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

The server distribution is written to `quarkus/dist/target/`. See
[docs/building.md](docs/building.md) for more options.

## Running

```bash
tar -xzf quarkus/dist/target/keycloak-*.tar.gz
cd keycloak-*/
bin/kc.sh start-dev
```

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
