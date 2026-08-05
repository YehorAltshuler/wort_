#!/usr/bin/env python3
"""Generate learnable LiD vocabulary from the bundled question snapshot.

The generator intentionally uses only repository-owned data. It recognizes
inflected surface forms with conservative German morphology rules, removes
function words and vocabulary already taught by the bundled coursebooks, and
uses the local lexicon for lemmas and translations.
"""

from __future__ import annotations

import json
import re
import sqlite3
from collections import Counter, defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
QUESTIONS = ROOT / "assets/citizenship_test/questions.json"
LEXICON = ROOT / "assets/native/lexicon.db"
GENDERS = ROOT / "assets/lexicon/genders.json"
OUTPUT = ROOT / "assets/coursebooks/leben-in-deutschland"

WORD_RE = re.compile(r"[A-Za-zÄÖÜäöüß]+(?:-[A-Za-zÄÖÜäöüß]+)*")

# Grammar words and broadly useful A1 vocabulary do not belong in a focused
# citizenship-test deck. Content words already present in a coursebook are
# removed separately below.
STOPWORDS = {
    "aber", "alle", "allein", "aller", "alles", "als", "also", "am", "an",
    "andere", "anderen", "anderer", "anderes", "auch", "auf", "aus", "bei",
    "beide", "beiden", "beim", "bereits", "bis", "da", "dabei", "dadurch",
    "dafür", "dagegen", "damals", "damit", "danach", "dann", "darauf",
    "darf", "das", "dass", "davon", "dazu", "dem", "den", "denen", "denn",
    "der", "deren", "des", "deshalb", "die", "dies", "diese", "diesem",
    "diesen", "dieser", "dieses", "dort", "durch", "dürfen", "ein", "eine",
    "einem", "einen", "einer", "eines", "einige", "er", "erst", "es", "etwa",
    "etwas", "für", "gegen", "gehören", "gehört", "gibt", "haben", "hat",
    "hier", "ihm", "ihn", "ihnen", "ihr", "ihre", "ihrem", "ihren", "ihrer",
    "ihres", "im", "in", "indem", "ins", "ist", "jede", "jedem", "jeden",
    "jeder", "jedes", "kein", "keine", "keinem", "keinen", "keiner", "kann",
    "können", "man", "mehr", "mit", "muss", "müssen", "nach", "nicht", "noch",
    "nur", "ob", "oder", "ohne", "schon", "sein", "seine", "seinem", "seinen",
    "seiner", "seines", "seit", "sich", "sie", "sind", "so", "soll", "sollen",
    "sondern", "sonst", "über", "um", "und", "uns", "unter", "vom", "von",
    "vor", "wann", "war", "waren", "warum", "was", "weil", "welche", "welchem",
    "welchen", "welcher", "welches", "wenn", "wer", "werden", "wie", "wieder",
    "wird", "wo", "wodurch", "wofür", "womit", "zu", "zum", "zur", "zwischen",
    "eins", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun",
    "zehn", "elf", "zwölf", "dritt", "zweit", "ehemalig", "erstmals", "folgend",
    "früher", "gesamt", "heutig", "hierfür", "hinzu", "jetzig", "letzt", "paar",
    "selber", "solch", "unser", "voneinander", "woran", "zuvor", "zurück",
    "januar", "mai", "juni", "juli", "oktober", "november",
    "freien", "letzen", "rechen",
}

MODULES = (
    ("module0.json", "Modul 1: Grundrechte und Demokratie", 1, 64),
    ("module1.json", "Modul 2: Staat und politische Beteiligung", 65, 129),
    ("module2.json", "Modul 3: Nationalsozialismus und Nachkriegszeit", 130, 180),
    ("module3.json", "Modul 4: DDR und Wiedervereinigung", 181, 220),
    ("module4.json", "Modul 5: Gesellschaft und Zusammenleben", 221, 300),
    ("module5.json", "Modul 6: Bundesländer", 301, 460),
)


def normalized(value: str) -> str:
    return value.casefold().strip()


def generated_forms(lemma: str, part: str) -> set[str]:
    value = normalized(lemma)
    forms = {value}
    if " " in value:
        return forms
    if part == "verb" and value.endswith("en"):
        stem = value[:-2]
        forms.update(stem + ending for ending in ("e", "st", "t", "en", "te", "test", "ten", "tet"))
        forms.update(("ge" + stem + "t", "ge" + stem + "et", "ge" + stem + "en"))
        if value.startswith(("be", "emp", "ent", "er", "ge", "miss", "ver", "zer")):
            forms.update((stem + "t", stem + "et"))
    elif part == "verb" and value.endswith("n"):
        stem = value[:-1]
        forms.update(stem + ending for ending in ("e", "st", "t", "n", "te", "ten"))
    elif part == "noun":
        forms.update(value + ending for ending in ("e", "en", "er", "n", "s"))
        for source, target in (("a", "ä"), ("o", "ö"), ("u", "ü")):
            if source in value:
                umlaut = value.replace(source, target, 1)
                forms.update(umlaut + ending for ending in ("", "e", "en", "er", "n"))
    else:
        forms.update(value + ending for ending in ("e", "en", "er", "es", "em"))
    return forms


def definitions(localizations: dict, language: str) -> list[str]:
    result: list[str] = []
    for sense in localizations.get(language, {}).get("senses", []):
        value = sense.get("definitions", {}).get(language)
        if value and value not in result:
            result.append(value)
        if len(result) == 3:
            break
    return result


def looks_like_person_name(localizations: dict) -> bool:
    text = " ".join(definitions(localizations, "ru") + definitions(localizations, "en")).casefold()
    markers = (
        "given name", "male name", "female name", "surname", "family name",
        "имя", "фамилия", "личное мужское", "личное женское",
    )
    return any(marker in text for marker in markers)


def existing_course_vocabulary() -> set[str]:
    result: set[str] = set()
    for path in (ROOT / "assets/coursebooks").glob("*/module*.json"):
        if path.parent == OUTPUT:
            continue
        for record in json.loads(path.read_text()):
            for key in ("dictionaryId", "word", "infinitive"):
                if record.get(key):
                    result.add(normalized(record[key]))
    return result


def module_for(number: int) -> str:
    for filename, _, start, end in MODULES:
        if start <= number <= end:
            return filename
    raise ValueError(number)


def main() -> None:
    questions = json.loads(QUESTIONS.read_text())["questions"]
    genders = json.loads(GENDERS.read_text())
    existing = existing_course_vocabulary()

    occurrences: dict[str, Counter[str]] = defaultdict(Counter)
    casing: Counter[tuple[str, str]] = Counter()
    for question in questions:
        text = " ".join([question["question"], *question["answers"].values()])
        filename = module_for(question["officialNumber"] if question["scope"] == "general" else 301)
        for surface in WORD_RE.findall(text):
            token = normalized(surface)
            occurrences[token][filename] += 1
            casing[(token, surface)] += 1

    connection = sqlite3.connect(LEXICON)
    rows = connection.execute(
        "SELECT id, lemma, part_of_speech, localizations, frequency_rank FROM lexemes"
    ).fetchall()
    connection.close()

    form_index: dict[str, list[tuple]] = defaultdict(list)
    for row in rows:
        lexeme_id, lemma, part, raw_localizations, rank = row
        localizations = json.loads(raw_localizations or "{}")
        if not definitions(localizations, "ru") and not definitions(localizations, "en"):
            continue
        enriched = (lexeme_id, lemma, part or "other", localizations, rank)
        for form in generated_forms(lemma, part or "other"):
            form_index[form].append(enriched)

    selected: dict[str, tuple[tuple, Counter[str]]] = {}
    for token, module_counts in occurrences.items():
        if token in STOPWORDS or len(token) < 3:
            continue
        choices = form_index.get(token, [])
        if not choices:
            continue
        # Exact lemma beats generated morphology; then prefer a content POS and
        # the more frequent dictionary entry.
        choices.sort(key=lambda row: (
            (
                0 if normalized(row[1]) == token and row[2] != "other"
                else 1 if row[2] != "other"
                else 2 if normalized(row[1]) == token
                else 3
            ),
            row[4],
        ))
        row = choices[0]
        lexeme_id, lemma, part, localizations, _ = row
        if normalized(lemma) in STOPWORDS:
            continue
        # The LiD deck teaches vocabulary, not people, cities, countries or
        # other proper names. Most proper names in the lexicon are classified
        # as `other`; personal names occasionally arrive as nouns.
        if (part == "other" and lemma[:1].isupper()) or looks_like_person_name(localizations):
            continue
        if normalized(lexeme_id) in existing or normalized(lemma) in existing:
            continue
        key = normalized(lexeme_id)
        if key in selected:
            selected[key][1].update(module_counts)
        else:
            selected[key] = (row, module_counts.copy())

    by_module: dict[str, list[dict]] = defaultdict(list)
    for row, module_counts in selected.values():
        lexeme_id, lemma, part, localizations, _ = row
        filename = module_counts.most_common(1)[0][0]
        translations = {
            language: values
            for language in ("ru", "en")
            if (values := definitions(localizations, language))
        }
        record: dict = {
            "dictionaryId": lexeme_id,
            "type": part if part in ("noun", "verb") else "other",
        }
        if part == "verb":
            record["infinitive"] = lemma
        else:
            record["word"] = lemma
        if part == "noun":
            articles = genders.get(normalized(lemma), [])
            if articles:
                record["article"] = articles
        record["translation"] = translations
        by_module[filename].append(record)

    OUTPUT.mkdir(parents=True, exist_ok=True)
    module_metadata = []
    for index, (filename, title, _, _) in enumerate(MODULES, start=1):
        records = sorted(by_module[filename], key=lambda item: normalized(item.get("word", item.get("infinitive", ""))))
        (OUTPUT / filename).write_text(
            json.dumps(records, ensure_ascii=False, indent=2) + "\n"
        )
        module_metadata.append({"id": index, "title": title, "file": filename})

    book = {
        "id": "leben-in-deutschland",
        "title": "Leben in Deutschland",
        "level": "LiD",
        "modules": module_metadata,
    }
    (OUTPUT / "book.json").write_text(json.dumps(book, ensure_ascii=False, indent=2) + "\n")
    print(f"Generated {sum(map(len, by_module.values()))} unique LiD words")
    for filename, title, _, _ in MODULES:
        print(f"  {title}: {len(by_module[filename])}")


if __name__ == "__main__":
    main()
