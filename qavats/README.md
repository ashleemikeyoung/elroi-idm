# Qavats customizations for Keycloak 26.8.1

Branding and deployment files for the Keycloak server at `https://id.qavatsit.com`.
This directory is the source of truth; it mirrors what is deployed on the server.

| Path in repo | Deployed to | Purpose |
|---|---|---|
| `themes/qavats/` | `/opt/keycloak/keycloak-26.8.1/themes/qavats/` | Login, account, admin and email theme |
| `caddy/Caddyfile` | `/etc/caddy/Caddyfile` | Reverse proxy; serves root favicons |
| `www/` | `/var/www/id-qavatsit/` | `/favicon.ico`, `/favicon.svg`, `/apple-touch-icon.png` |

## Theme overview

- **login** (parent `keycloak.v2`), all realms: the ElRoi wordmark over the product name "Id Manager".
  `loginTitleHtml` (messages_en) holds the markup; the wordmark is the parent's `--keycloak-logo-*`
  CSS variables, light-background file normally and dark-background file in dark mode. Keycloak's
  grey background artwork is removed. `styles` must keep `css/styles.css` or the parent layout is lost.
- **account** (parent `keycloak.v3`) and **admin** (parent `keycloak.v2`): the masthead is always
  dark, so CSS swaps in the dark-background logo there. Qavats favicons.
- **admin messages**: `welcomeText` (master realm welcome) and `introduction` (other realms'
  welcome) say "ElRoi Id Manager" instead of "Keycloak". English only.
- **admin welcome page (non-master realms)**: the theme `logo` must start with `/` because that page
  builds the URL as `resourceUrl + logo`. CSS replaces the image with the ElRoi wordmark (dark-background
  file in dark mode). The heading under "Welcome" is the realm's display name.
- **email**: Qavats subject lines.
- **welcome** (parent `keycloak`): exists only because `KC_SPI_THEME__DEFAULT=qavats` makes `/`
  look for a qavats welcome theme. Without it `/` answers 400 "The theme is null" (no page, so no
  favicon). The parent redirects `/` to the admin console once an admin exists.

## Realm settings (stored in the database, not in this repo)

Applied directly in Postgres, followed by a Keycloak restart:

```sql
-- master realm: header "Qavats" (displayNameHtml); tab "Sign in to ElRoi Id Manager" (display_name)
update realm set display_name = 'ElRoi Id Manager' where name = 'master';
update realm_attribute set value = '<div class="kc-logo-text"><span>Qavats</span></div>'
 where name = 'displayNameHtml' and value ilike '%keycloak%';
-- name shown in passkey prompts (all realms)
update realm_attribute set value = 'Qavats'
 where name in ('webAuthnPolicyRpEntityName', 'webAuthnPolicyRpEntityNamePasswordless')
   and value = 'keycloak';
-- every realm uses the qavats themes
update realm set login_theme = 'qavats', account_theme = 'qavats',
                 admin_theme = 'qavats', email_theme = 'qavats';
```

## Deploying theme changes

```bash
rsync -a --delete qavats/themes/qavats/ ash@id.qavatsit.com:/opt/keycloak/keycloak-26.8.1/themes/qavats/
ssh ash@id.qavatsit.com '
  rm -rf /opt/keycloak/keycloak-26.8.1/data/tmp/kc-gzip-cache/*/{login,admin,account}/qavats
  sudo systemctl restart keycloak'
```

Gotchas:

- **Restart is required.** Production mode caches themes.
- **Clear the gzip cache.** `data/tmp/kc-gzip-cache` survives restarts and keeps serving the old
  compressed CSS to browsers.
- **Rename changed CSS and images** (e.g. bump `-v4` to `-v5` and update the reference). Theme
  resources are served with a 30-day browser cache under a URL that only changes with the Keycloak
  version.
- Files must be readable by the `ash` user that runs Keycloak.

## Deploying Caddy and root favicons

```bash
scp qavats/www/* ash@id.qavatsit.com:/tmp/
scp qavats/caddy/Caddyfile ash@id.qavatsit.com:/tmp/Caddyfile
ssh ash@id.qavatsit.com '
  sudo install -m 644 /tmp/favicon.ico /tmp/favicon.svg /tmp/apple-touch-icon.png /var/www/id-qavatsit/
  sudo install -m 644 /tmp/Caddyfile /etc/caddy/Caddyfile
  sudo caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile && sudo systemctl reload caddy'
```

## Source artwork

From the Qavats Artwork folder: `qavats-horizontal-dark-600x160 v2.png` (for dark backgrounds),
`qavats-horizontal-light-600x160 v2.png` (for light backgrounds) and `icon.png` (favicons); `elroi-logo-light-text.svg` (dark ink, for light backgrounds) and
`elroi-logo-dark-text.svg` (pale ink, for dark backgrounds) for the login page and the admin welcome page.
