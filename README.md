# Mohannad Movie — Public Domain Edition

A Flutter app for streaming **public domain films, series episodes, and classic footage**
with zero licensing risk and zero user accounts.

## Why Internet Archive instead of TMDB?

TMDB only provides *metadata* (titles, posters, descriptions) — it has no legal video
files, so the original plan required plugging in a separately-licensed video source.

This edition solves both problems at once by using **archive.org (Internet Archive)**:

- Its `advancedsearch.php` endpoint is a free, keyless JSON API for searching by
  collection, year, mediatype, etc.
- Every item's `metadata` endpoint returns direct, legally streamable file URLs
  (`.mp4`, `.ogv`) for content confirmed public domain or openly licensed
  (`licenseurl` field is exposed per item).
- No sign-up, no API key, no rate-limit auth — fits the "no registration" requirement
  perfectly.

> **Still verify licensing per title.** Archive.org hosts a mix of public domain,
> Creative Commons, and rights-reserved uploads. The app filters by collection
> (e.g. `collection:publicdomainmovies`, `collection:feature_films` +
> `licenseurl:*publicdomain*`) and you should keep that filter authoritative —
> don't assume every upload is clear just because it's on the Archive.

## Data flow

```
ArchiveOrgRemoteDataSource
  → advancedsearch.php?q=collection:(publicdomainmovies)&fl[]=identifier,title,year,...
  → for each identifier: metadata endpoint → resolves playable file URL + thumbnail
  → mapped to Movie entity → cached in Hive → rendered in BLoC-driven UI
```

## Running

```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter run
```

No `.env` / API key setup needed — that's the point.
