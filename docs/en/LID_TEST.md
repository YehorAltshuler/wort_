# Leben in Deutschland

[Deutsch](../de/LID_TEST.md) · [Русский](../ru/LID_TEST.md)

## Architecture

The UI reads questions only from the local Drift database. Remote JSON and
images are used exclusively by `CitizenshipTestRepository` during sync.

```text
UI → Riverpod → CitizenshipTestRepository
                    ├─ DriftCitizenshipTestClient
                    ├─ HttpCitizenshipTestClient
                    └─ CitizenshipTestMediaStore
```

The sole remote source is the published
[`bamf-lid-dataset`](https://github.com/YehorAltshuler/bamf-lid-dataset).
The app does not scrape BAMF pages or parse PDFs.

## Local data and sessions

Drift stores catalog generations, questions, media/sync metadata, progress,
favorites, exam sessions, and answers. Native images live in versioned
Application Support directories; Web images use persistent browser cache.

The bundled snapshot contains 460 questions and 100 images and initializes only
an empty database. LiD exam and all-question sessions persist their question
queue and current position. Exam sessions also persist selected answers, so they
can be resumed after closing and reopening the app. Starting explicitly with
`startNew` replaces the previous active session.

## Synchronization

- automatic checks run on launch/foreground no more than once every 15 days;
- failures apply cooldowns of 1 hour, 6 hours, then 24 hours;
- manual checks ignore interval and cooldown;
- manifest validators (`ETag`/`Last-Modified`) and SHA-256 protect downloads;
- validated data activates in one Drift transaction;
- individual image failures create a partial update and persistent retry;
- each image is limited to 4 MiB;
- cleanup removes only obsolete generations, keeping active and previous data.

Sync metadata records last check and last successful update. Older databases
with duplicate metadata rows are repaired deterministically when read.

## Exam rules

`LebenInDeutschlandExamRules` defines 30 general questions plus 3 for the
selected state, 33 total, and a 60-minute limit. The LiD pass threshold is 15;
the citizenship certificate threshold is 17 correct answers.

## Drift on Web

`web/sqlite3.wasm` and `web/drift_worker.js` must match the Drift version.
Hosting must serve WASM as `application/wasm`, allow Web Workers, and use HTTPS
for OPFS. Verify with a Web release build and the Chrome media-store test.
