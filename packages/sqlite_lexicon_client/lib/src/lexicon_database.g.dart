// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lexicon_database.dart';

// ignore_for_file: type=lint
class $LexemesTable extends Lexemes with TableInfo<$LexemesTable, Lexeme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LexemesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pronunciationMeta = const VerificationMeta(
    'pronunciation',
  );
  @override
  late final GeneratedColumn<String> pronunciation = GeneratedColumn<String>(
    'pronunciation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sensesMeta = const VerificationMeta('senses');
  @override
  late final GeneratedColumn<String> senses = GeneratedColumn<String>(
    'senses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etymologyMeta = const VerificationMeta(
    'etymology',
  );
  @override
  late final GeneratedColumn<String> etymology = GeneratedColumn<String>(
    'etymology',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localizationsMeta = const VerificationMeta(
    'localizations',
  );
  @override
  late final GeneratedColumn<String> localizations = GeneratedColumn<String>(
    'localizations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formsMeta = const VerificationMeta('forms');
  @override
  late final GeneratedColumn<String> forms = GeneratedColumn<String>(
    'forms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyRankMeta = const VerificationMeta(
    'frequencyRank',
  );
  @override
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
    'frequency_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lemma,
    partOfSpeech,
    pronunciation,
    senses,
    etymology,
    localizations,
    forms,
    frequencyRank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lexemes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lexeme> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    }
    if (data.containsKey('pronunciation')) {
      context.handle(
        _pronunciationMeta,
        pronunciation.isAcceptableOrUnknown(
          data['pronunciation']!,
          _pronunciationMeta,
        ),
      );
    }
    if (data.containsKey('senses')) {
      context.handle(
        _sensesMeta,
        senses.isAcceptableOrUnknown(data['senses']!, _sensesMeta),
      );
    }
    if (data.containsKey('etymology')) {
      context.handle(
        _etymologyMeta,
        etymology.isAcceptableOrUnknown(data['etymology']!, _etymologyMeta),
      );
    }
    if (data.containsKey('localizations')) {
      context.handle(
        _localizationsMeta,
        localizations.isAcceptableOrUnknown(
          data['localizations']!,
          _localizationsMeta,
        ),
      );
    }
    if (data.containsKey('forms')) {
      context.handle(
        _formsMeta,
        forms.isAcceptableOrUnknown(data['forms']!, _formsMeta),
      );
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
        _frequencyRankMeta,
        frequencyRank.isAcceptableOrUnknown(
          data['frequency_rank']!,
          _frequencyRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyRankMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lexeme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lexeme(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      )!,
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      ),
      pronunciation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronunciation'],
      ),
      senses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}senses'],
      ),
      etymology: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etymology'],
      ),
      localizations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}localizations'],
      ),
      forms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forms'],
      ),
      frequencyRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_rank'],
      )!,
    );
  }

  @override
  $LexemesTable createAlias(String alias) {
    return $LexemesTable(attachedDatabase, alias);
  }
}

class Lexeme extends DataClass implements Insertable<Lexeme> {
  final String id;
  final String lemma;
  final String? partOfSpeech;
  final String? pronunciation;
  final String? senses;
  final String? etymology;
  final String? localizations;
  final String? forms;
  final int frequencyRank;
  const Lexeme({
    required this.id,
    required this.lemma,
    this.partOfSpeech,
    this.pronunciation,
    this.senses,
    this.etymology,
    this.localizations,
    this.forms,
    required this.frequencyRank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lemma'] = Variable<String>(lemma);
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(partOfSpeech);
    }
    if (!nullToAbsent || pronunciation != null) {
      map['pronunciation'] = Variable<String>(pronunciation);
    }
    if (!nullToAbsent || senses != null) {
      map['senses'] = Variable<String>(senses);
    }
    if (!nullToAbsent || etymology != null) {
      map['etymology'] = Variable<String>(etymology);
    }
    if (!nullToAbsent || localizations != null) {
      map['localizations'] = Variable<String>(localizations);
    }
    if (!nullToAbsent || forms != null) {
      map['forms'] = Variable<String>(forms);
    }
    map['frequency_rank'] = Variable<int>(frequencyRank);
    return map;
  }

  LexemesCompanion toCompanion(bool nullToAbsent) {
    return LexemesCompanion(
      id: Value(id),
      lemma: Value(lemma),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      pronunciation: pronunciation == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciation),
      senses: senses == null && nullToAbsent
          ? const Value.absent()
          : Value(senses),
      etymology: etymology == null && nullToAbsent
          ? const Value.absent()
          : Value(etymology),
      localizations: localizations == null && nullToAbsent
          ? const Value.absent()
          : Value(localizations),
      forms: forms == null && nullToAbsent
          ? const Value.absent()
          : Value(forms),
      frequencyRank: Value(frequencyRank),
    );
  }

  factory Lexeme.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lexeme(
      id: serializer.fromJson<String>(json['id']),
      lemma: serializer.fromJson<String>(json['lemma']),
      partOfSpeech: serializer.fromJson<String?>(json['partOfSpeech']),
      pronunciation: serializer.fromJson<String?>(json['pronunciation']),
      senses: serializer.fromJson<String?>(json['senses']),
      etymology: serializer.fromJson<String?>(json['etymology']),
      localizations: serializer.fromJson<String?>(json['localizations']),
      forms: serializer.fromJson<String?>(json['forms']),
      frequencyRank: serializer.fromJson<int>(json['frequencyRank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lemma': serializer.toJson<String>(lemma),
      'partOfSpeech': serializer.toJson<String?>(partOfSpeech),
      'pronunciation': serializer.toJson<String?>(pronunciation),
      'senses': serializer.toJson<String?>(senses),
      'etymology': serializer.toJson<String?>(etymology),
      'localizations': serializer.toJson<String?>(localizations),
      'forms': serializer.toJson<String?>(forms),
      'frequencyRank': serializer.toJson<int>(frequencyRank),
    };
  }

  Lexeme copyWith({
    String? id,
    String? lemma,
    Value<String?> partOfSpeech = const Value.absent(),
    Value<String?> pronunciation = const Value.absent(),
    Value<String?> senses = const Value.absent(),
    Value<String?> etymology = const Value.absent(),
    Value<String?> localizations = const Value.absent(),
    Value<String?> forms = const Value.absent(),
    int? frequencyRank,
  }) => Lexeme(
    id: id ?? this.id,
    lemma: lemma ?? this.lemma,
    partOfSpeech: partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
    pronunciation: pronunciation.present
        ? pronunciation.value
        : this.pronunciation,
    senses: senses.present ? senses.value : this.senses,
    etymology: etymology.present ? etymology.value : this.etymology,
    localizations: localizations.present
        ? localizations.value
        : this.localizations,
    forms: forms.present ? forms.value : this.forms,
    frequencyRank: frequencyRank ?? this.frequencyRank,
  );
  Lexeme copyWithCompanion(LexemesCompanion data) {
    return Lexeme(
      id: data.id.present ? data.id.value : this.id,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      pronunciation: data.pronunciation.present
          ? data.pronunciation.value
          : this.pronunciation,
      senses: data.senses.present ? data.senses.value : this.senses,
      etymology: data.etymology.present ? data.etymology.value : this.etymology,
      localizations: data.localizations.present
          ? data.localizations.value
          : this.localizations,
      forms: data.forms.present ? data.forms.value : this.forms,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lexeme(')
          ..write('id: $id, ')
          ..write('lemma: $lemma, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('senses: $senses, ')
          ..write('etymology: $etymology, ')
          ..write('localizations: $localizations, ')
          ..write('forms: $forms, ')
          ..write('frequencyRank: $frequencyRank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lemma,
    partOfSpeech,
    pronunciation,
    senses,
    etymology,
    localizations,
    forms,
    frequencyRank,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lexeme &&
          other.id == this.id &&
          other.lemma == this.lemma &&
          other.partOfSpeech == this.partOfSpeech &&
          other.pronunciation == this.pronunciation &&
          other.senses == this.senses &&
          other.etymology == this.etymology &&
          other.localizations == this.localizations &&
          other.forms == this.forms &&
          other.frequencyRank == this.frequencyRank);
}

class LexemesCompanion extends UpdateCompanion<Lexeme> {
  final Value<String> id;
  final Value<String> lemma;
  final Value<String?> partOfSpeech;
  final Value<String?> pronunciation;
  final Value<String?> senses;
  final Value<String?> etymology;
  final Value<String?> localizations;
  final Value<String?> forms;
  final Value<int> frequencyRank;
  final Value<int> rowid;
  const LexemesCompanion({
    this.id = const Value.absent(),
    this.lemma = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.senses = const Value.absent(),
    this.etymology = const Value.absent(),
    this.localizations = const Value.absent(),
    this.forms = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LexemesCompanion.insert({
    required String id,
    required String lemma,
    this.partOfSpeech = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.senses = const Value.absent(),
    this.etymology = const Value.absent(),
    this.localizations = const Value.absent(),
    this.forms = const Value.absent(),
    required int frequencyRank,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lemma = Value(lemma),
       frequencyRank = Value(frequencyRank);
  static Insertable<Lexeme> custom({
    Expression<String>? id,
    Expression<String>? lemma,
    Expression<String>? partOfSpeech,
    Expression<String>? pronunciation,
    Expression<String>? senses,
    Expression<String>? etymology,
    Expression<String>? localizations,
    Expression<String>? forms,
    Expression<int>? frequencyRank,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lemma != null) 'lemma': lemma,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (senses != null) 'senses': senses,
      if (etymology != null) 'etymology': etymology,
      if (localizations != null) 'localizations': localizations,
      if (forms != null) 'forms': forms,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LexemesCompanion copyWith({
    Value<String>? id,
    Value<String>? lemma,
    Value<String?>? partOfSpeech,
    Value<String?>? pronunciation,
    Value<String?>? senses,
    Value<String?>? etymology,
    Value<String?>? localizations,
    Value<String?>? forms,
    Value<int>? frequencyRank,
    Value<int>? rowid,
  }) {
    return LexemesCompanion(
      id: id ?? this.id,
      lemma: lemma ?? this.lemma,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      pronunciation: pronunciation ?? this.pronunciation,
      senses: senses ?? this.senses,
      etymology: etymology ?? this.etymology,
      localizations: localizations ?? this.localizations,
      forms: forms ?? this.forms,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (pronunciation.present) {
      map['pronunciation'] = Variable<String>(pronunciation.value);
    }
    if (senses.present) {
      map['senses'] = Variable<String>(senses.value);
    }
    if (etymology.present) {
      map['etymology'] = Variable<String>(etymology.value);
    }
    if (localizations.present) {
      map['localizations'] = Variable<String>(localizations.value);
    }
    if (forms.present) {
      map['forms'] = Variable<String>(forms.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LexemesCompanion(')
          ..write('id: $id, ')
          ..write('lemma: $lemma, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('senses: $senses, ')
          ..write('etymology: $etymology, ')
          ..write('localizations: $localizations, ')
          ..write('forms: $forms, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LexemeSearchTable extends LexemeSearch
    with TableInfo<$LexemeSearchTable, LexemeSearchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LexemeSearchTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyRankMeta = const VerificationMeta(
    'frequencyRank',
  );
  @override
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
    'frequency_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lemma,
    partOfSpeech,
    frequencyRank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lexeme_search';
  @override
  VerificationContext validateIntegrity(
    Insertable<LexemeSearchData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
        _frequencyRankMeta,
        frequencyRank.isAcceptableOrUnknown(
          data['frequency_rank']!,
          _frequencyRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyRankMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LexemeSearchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LexemeSearchData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      )!,
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      ),
      frequencyRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_rank'],
      )!,
    );
  }

  @override
  $LexemeSearchTable createAlias(String alias) {
    return $LexemeSearchTable(attachedDatabase, alias);
  }
}

class LexemeSearchData extends DataClass
    implements Insertable<LexemeSearchData> {
  final String id;
  final String lemma;
  final String? partOfSpeech;
  final int frequencyRank;
  const LexemeSearchData({
    required this.id,
    required this.lemma,
    this.partOfSpeech,
    required this.frequencyRank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lemma'] = Variable<String>(lemma);
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(partOfSpeech);
    }
    map['frequency_rank'] = Variable<int>(frequencyRank);
    return map;
  }

  LexemeSearchCompanion toCompanion(bool nullToAbsent) {
    return LexemeSearchCompanion(
      id: Value(id),
      lemma: Value(lemma),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      frequencyRank: Value(frequencyRank),
    );
  }

  factory LexemeSearchData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LexemeSearchData(
      id: serializer.fromJson<String>(json['id']),
      lemma: serializer.fromJson<String>(json['lemma']),
      partOfSpeech: serializer.fromJson<String?>(json['partOfSpeech']),
      frequencyRank: serializer.fromJson<int>(json['frequencyRank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lemma': serializer.toJson<String>(lemma),
      'partOfSpeech': serializer.toJson<String?>(partOfSpeech),
      'frequencyRank': serializer.toJson<int>(frequencyRank),
    };
  }

  LexemeSearchData copyWith({
    String? id,
    String? lemma,
    Value<String?> partOfSpeech = const Value.absent(),
    int? frequencyRank,
  }) => LexemeSearchData(
    id: id ?? this.id,
    lemma: lemma ?? this.lemma,
    partOfSpeech: partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
    frequencyRank: frequencyRank ?? this.frequencyRank,
  );
  LexemeSearchData copyWithCompanion(LexemeSearchCompanion data) {
    return LexemeSearchData(
      id: data.id.present ? data.id.value : this.id,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LexemeSearchData(')
          ..write('id: $id, ')
          ..write('lemma: $lemma, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('frequencyRank: $frequencyRank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lemma, partOfSpeech, frequencyRank);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LexemeSearchData &&
          other.id == this.id &&
          other.lemma == this.lemma &&
          other.partOfSpeech == this.partOfSpeech &&
          other.frequencyRank == this.frequencyRank);
}

class LexemeSearchCompanion extends UpdateCompanion<LexemeSearchData> {
  final Value<String> id;
  final Value<String> lemma;
  final Value<String?> partOfSpeech;
  final Value<int> frequencyRank;
  final Value<int> rowid;
  const LexemeSearchCompanion({
    this.id = const Value.absent(),
    this.lemma = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LexemeSearchCompanion.insert({
    required String id,
    required String lemma,
    this.partOfSpeech = const Value.absent(),
    required int frequencyRank,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lemma = Value(lemma),
       frequencyRank = Value(frequencyRank);
  static Insertable<LexemeSearchData> custom({
    Expression<String>? id,
    Expression<String>? lemma,
    Expression<String>? partOfSpeech,
    Expression<int>? frequencyRank,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lemma != null) 'lemma': lemma,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LexemeSearchCompanion copyWith({
    Value<String>? id,
    Value<String>? lemma,
    Value<String?>? partOfSpeech,
    Value<int>? frequencyRank,
    Value<int>? rowid,
  }) {
    return LexemeSearchCompanion(
      id: id ?? this.id,
      lemma: lemma ?? this.lemma,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LexemeSearchCompanion(')
          ..write('id: $id, ')
          ..write('lemma: $lemma, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LexiconDatabase extends GeneratedDatabase {
  _$LexiconDatabase(QueryExecutor e) : super(e);
  $LexiconDatabaseManager get managers => $LexiconDatabaseManager(this);
  late final $LexemesTable lexemes = $LexemesTable(this);
  late final $LexemeSearchTable lexemeSearch = $LexemeSearchTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [lexemes, lexemeSearch];
}

typedef $$LexemesTableCreateCompanionBuilder =
    LexemesCompanion Function({
      required String id,
      required String lemma,
      Value<String?> partOfSpeech,
      Value<String?> pronunciation,
      Value<String?> senses,
      Value<String?> etymology,
      Value<String?> localizations,
      Value<String?> forms,
      required int frequencyRank,
      Value<int> rowid,
    });
typedef $$LexemesTableUpdateCompanionBuilder =
    LexemesCompanion Function({
      Value<String> id,
      Value<String> lemma,
      Value<String?> partOfSpeech,
      Value<String?> pronunciation,
      Value<String?> senses,
      Value<String?> etymology,
      Value<String?> localizations,
      Value<String?> forms,
      Value<int> frequencyRank,
      Value<int> rowid,
    });

class $$LexemesTableFilterComposer
    extends Composer<_$LexiconDatabase, $LexemesTable> {
  $$LexemesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senses => $composableBuilder(
    column: $table.senses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etymology => $composableBuilder(
    column: $table.etymology,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localizations => $composableBuilder(
    column: $table.localizations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forms => $composableBuilder(
    column: $table.forms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LexemesTableOrderingComposer
    extends Composer<_$LexiconDatabase, $LexemesTable> {
  $$LexemesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senses => $composableBuilder(
    column: $table.senses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etymology => $composableBuilder(
    column: $table.etymology,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localizations => $composableBuilder(
    column: $table.localizations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forms => $composableBuilder(
    column: $table.forms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LexemesTableAnnotationComposer
    extends Composer<_$LexiconDatabase, $LexemesTable> {
  $$LexemesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senses =>
      $composableBuilder(column: $table.senses, builder: (column) => column);

  GeneratedColumn<String> get etymology =>
      $composableBuilder(column: $table.etymology, builder: (column) => column);

  GeneratedColumn<String> get localizations => $composableBuilder(
    column: $table.localizations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get forms =>
      $composableBuilder(column: $table.forms, builder: (column) => column);

  GeneratedColumn<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => column,
  );
}

class $$LexemesTableTableManager
    extends
        RootTableManager<
          _$LexiconDatabase,
          $LexemesTable,
          Lexeme,
          $$LexemesTableFilterComposer,
          $$LexemesTableOrderingComposer,
          $$LexemesTableAnnotationComposer,
          $$LexemesTableCreateCompanionBuilder,
          $$LexemesTableUpdateCompanionBuilder,
          (Lexeme, BaseReferences<_$LexiconDatabase, $LexemesTable, Lexeme>),
          Lexeme,
          PrefetchHooks Function()
        > {
  $$LexemesTableTableManager(_$LexiconDatabase db, $LexemesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LexemesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LexemesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LexemesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lemma = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                Value<String?> pronunciation = const Value.absent(),
                Value<String?> senses = const Value.absent(),
                Value<String?> etymology = const Value.absent(),
                Value<String?> localizations = const Value.absent(),
                Value<String?> forms = const Value.absent(),
                Value<int> frequencyRank = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LexemesCompanion(
                id: id,
                lemma: lemma,
                partOfSpeech: partOfSpeech,
                pronunciation: pronunciation,
                senses: senses,
                etymology: etymology,
                localizations: localizations,
                forms: forms,
                frequencyRank: frequencyRank,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lemma,
                Value<String?> partOfSpeech = const Value.absent(),
                Value<String?> pronunciation = const Value.absent(),
                Value<String?> senses = const Value.absent(),
                Value<String?> etymology = const Value.absent(),
                Value<String?> localizations = const Value.absent(),
                Value<String?> forms = const Value.absent(),
                required int frequencyRank,
                Value<int> rowid = const Value.absent(),
              }) => LexemesCompanion.insert(
                id: id,
                lemma: lemma,
                partOfSpeech: partOfSpeech,
                pronunciation: pronunciation,
                senses: senses,
                etymology: etymology,
                localizations: localizations,
                forms: forms,
                frequencyRank: frequencyRank,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LexemesTableProcessedTableManager =
    ProcessedTableManager<
      _$LexiconDatabase,
      $LexemesTable,
      Lexeme,
      $$LexemesTableFilterComposer,
      $$LexemesTableOrderingComposer,
      $$LexemesTableAnnotationComposer,
      $$LexemesTableCreateCompanionBuilder,
      $$LexemesTableUpdateCompanionBuilder,
      (Lexeme, BaseReferences<_$LexiconDatabase, $LexemesTable, Lexeme>),
      Lexeme,
      PrefetchHooks Function()
    >;
typedef $$LexemeSearchTableCreateCompanionBuilder =
    LexemeSearchCompanion Function({
      required String id,
      required String lemma,
      Value<String?> partOfSpeech,
      required int frequencyRank,
      Value<int> rowid,
    });
typedef $$LexemeSearchTableUpdateCompanionBuilder =
    LexemeSearchCompanion Function({
      Value<String> id,
      Value<String> lemma,
      Value<String?> partOfSpeech,
      Value<int> frequencyRank,
      Value<int> rowid,
    });

class $$LexemeSearchTableFilterComposer
    extends Composer<_$LexiconDatabase, $LexemeSearchTable> {
  $$LexemeSearchTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LexemeSearchTableOrderingComposer
    extends Composer<_$LexiconDatabase, $LexemeSearchTable> {
  $$LexemeSearchTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LexemeSearchTableAnnotationComposer
    extends Composer<_$LexiconDatabase, $LexemeSearchTable> {
  $$LexemeSearchTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => column,
  );
}

class $$LexemeSearchTableTableManager
    extends
        RootTableManager<
          _$LexiconDatabase,
          $LexemeSearchTable,
          LexemeSearchData,
          $$LexemeSearchTableFilterComposer,
          $$LexemeSearchTableOrderingComposer,
          $$LexemeSearchTableAnnotationComposer,
          $$LexemeSearchTableCreateCompanionBuilder,
          $$LexemeSearchTableUpdateCompanionBuilder,
          (
            LexemeSearchData,
            BaseReferences<
              _$LexiconDatabase,
              $LexemeSearchTable,
              LexemeSearchData
            >,
          ),
          LexemeSearchData,
          PrefetchHooks Function()
        > {
  $$LexemeSearchTableTableManager(
    _$LexiconDatabase db,
    $LexemeSearchTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LexemeSearchTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LexemeSearchTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LexemeSearchTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lemma = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                Value<int> frequencyRank = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LexemeSearchCompanion(
                id: id,
                lemma: lemma,
                partOfSpeech: partOfSpeech,
                frequencyRank: frequencyRank,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lemma,
                Value<String?> partOfSpeech = const Value.absent(),
                required int frequencyRank,
                Value<int> rowid = const Value.absent(),
              }) => LexemeSearchCompanion.insert(
                id: id,
                lemma: lemma,
                partOfSpeech: partOfSpeech,
                frequencyRank: frequencyRank,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LexemeSearchTableProcessedTableManager =
    ProcessedTableManager<
      _$LexiconDatabase,
      $LexemeSearchTable,
      LexemeSearchData,
      $$LexemeSearchTableFilterComposer,
      $$LexemeSearchTableOrderingComposer,
      $$LexemeSearchTableAnnotationComposer,
      $$LexemeSearchTableCreateCompanionBuilder,
      $$LexemeSearchTableUpdateCompanionBuilder,
      (
        LexemeSearchData,
        BaseReferences<_$LexiconDatabase, $LexemeSearchTable, LexemeSearchData>,
      ),
      LexemeSearchData,
      PrefetchHooks Function()
    >;

class $LexiconDatabaseManager {
  final _$LexiconDatabase _db;
  $LexiconDatabaseManager(this._db);
  $$LexemesTableTableManager get lexemes =>
      $$LexemesTableTableManager(_db, _db.lexemes);
  $$LexemeSearchTableTableManager get lexemeSearch =>
      $$LexemeSearchTableTableManager(_db, _db.lexemeSearch);
}
