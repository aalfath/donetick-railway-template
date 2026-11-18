# Changelog

## v0.1.86 (2026-11-18)

First release of the template.

- Donetick v0.1.86 (`donetick/donetick:v0.1.86@sha256:66253a32a8e8ed8c49c49418b43abe1181db23e07defe97748d2cb7508c487cd`).
- SQLite database, generated config and uploaded photos all on the `/data` volume.
- Uploads use local storage on the volume (the app's default is an S3 bucket you would have to configure).
- `DT_JWT_SECRET` generated per deploy; `DT_SERVER_PUBLIC_HOST` set from the Railway domain.
- Health check on `/api/v1/health`.
