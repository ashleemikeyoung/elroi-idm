# ElRoi IdM

Open source identity and access management.

Add authentication to applications and secure services with minimum effort. No need to deal with
storing users or authenticating users. ElRoi IdM provides user federation, strong authentication,
user management, fine-grained authorization, and more.

ElRoi IdM is derived from [Keycloak](https://www.keycloak.org) 26.8.1. It stays compatible with
Keycloak clients, adapters, and extensions. Internal package names (`org.keycloak.*`), Maven
coordinates, the `kc.sh` launcher, and `KC_*` configuration options are unchanged, so Keycloak's
documentation for those still applies.

## Building

Requires JDK 21.

```bash
./mvnw clean install -DskipTests
```

The server distribution is written to `quarkus/dist/target/` as `keycloak-<version>.tar.gz`
and `.zip`. The test harnesses find the archive by that name, so it stays the default. For a
release, name the archive and its top-level directory after ElRoi IdM:

```bash
./mvnw clean install -DskipTests -Ddist.archive.file.prefix=elroi-idm
```

This writes `elroi-idm-<version>.tar.gz`, which unpacks to `elroi-idm-<version>/`. The launcher
inside is still `bin/kc.sh`. See [docs/building.md](docs/building.md) for more options.

## Running

```bash
tar -xzf quarkus/dist/target/elroi-idm-*.tar.gz
cd elroi-idm-*/
bin/kc.sh start-dev
```

## Documentation

The guides in `docs/` name the product through the `{project_name}` attribute, set to ElRoi IdM in
`docs/guides/attributes.adoc` and `docs/documentation/topics/templates/document-attributes.adoc`.
Text that still says Keycloak is left as upstream wrote it on purpose: resource kinds such as
`kind: Keycloak`, code, the Keycloak Operator, past Keycloak release and upgrade notes, and links
to keycloak.org. Rewriting it would make those passages wrong and conflict with every upstream
rebase.

## Deployment

The `qavats/` directory has the branding theme, reverse-proxy configuration, and deployment notes
for the Qavats server at `https://id.qavatsit.com`.

## Reporting security vulnerabilities

See [SECURITY.md](SECURITY.md).

## License

ElRoi IdM is licensed under the [GNU Affero General Public License v3](LICENSE.txt).

It includes code from Keycloak, which is licensed under the
[Apache License 2.0](LICENSE-APACHE-2.0.txt). Files from Keycloak keep their original copyright
and license notices. See [NOTICE](NOTICE) for details.

"Keycloak" is a trademark of its respective owners. ElRoi IdM is not affiliated with or endorsed
by the Keycloak project or Red Hat.
