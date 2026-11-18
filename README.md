[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/donetick-2?utm_medium=integration&utm_source=button&utm_campaign=donetick)

# Donetick on Railway

One-click [Donetick](https://github.com/donetick/donetick) for [Railway](https://railway.com): an open-source app for tasks and household chores, shared with family or friends.

This repo is what the Railway template builds. It deploys:

- **Donetick v0.1.86**, from the official image `donetick/donetick:v0.1.86`, pinned by digest `sha256:66253a32a8e8ed8c49c49418b43abe1181db23e07defe97748d2cb7508c487cd`.
- One service with a public domain, a health check on `/api/v1/health` and a volume at `/data`.

## What's on the volume

| Path | What |
| --- | --- |
| `/data/donetick.db` | SQLite database (users, circles, tasks, history) |
| `/data/config/selfhosted.yaml` | Donetick's config file, written on first start. Edit it to change settings, then restart |
| `/data/uploads/` | Task photos and profile pictures (local storage, not S3) |

Everything survives redeploys, restarts and updates.

## Variables

| Variable | Default | Why |
| --- | --- | --- |
| `PORT` | `2021` | Port Donetick listens on; the public domain points at it |
| `DT_JWT_SECRET` | `${{secret(64)}}` | Signs login tokens. Generated per deploy; changing it logs everyone out |
| `DT_SERVER_PUBLIC_HOST` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL, used for calendar feed links and email links |

The deploy asks for nothing. Any other setting in `selfhosted.yaml` can be overridden with a `DT_` variable (dots become underscores), for example:

- `DT_IS_USER_CREATION_DISABLED=true`: close sign-ups once your accounts exist.
- `DT_EMAIL_HOST`, `DT_EMAIL_PORT`, `DT_EMAIL_EMAIL`, `DT_EMAIL_KEY`: SMTP for password-reset emails.
- `DT_TELEGRAM_TOKEN`, `DT_PUSHOVER_TOKEN`: notification channels.
- `DT_OAUTH2_*`: single sign-on with an OIDC provider.

## After deploying

Open the public URL, choose **Sign up** and create your account. Anyone who can reach the URL can sign up and gets a separate circle; invite family members to your circle from **Settings**, then set `DT_IS_USER_CREATION_DISABLED=true` if you don't want other sign-ups.

## Updates

When this repo's `main` changes (a new Donetick version), Railway shows an **update available** notice on your project. Read [CHANGELOG.md](CHANGELOG.md) first, then apply it. Your volume and variables stay as they are.

## Local run

```sh
docker build -t donetick-railway .
docker run -p 2021:2021 -e DT_JWT_SECRET=$(openssl rand -hex 32) -v donetick-data:/data donetick-railway
```

Donetick is licensed AGPL-3.0 by its authors. This wrapper only adds a start script.
