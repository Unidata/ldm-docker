# Change Log
All notable changes to this project will be documented in this file. This change log follows the conventions of [keepachangelog.com](http://keepachangelog.com/).

## [6.13.12] - 2020-11-03

### Added
- license

### Changed
- bumping version to 6.13.12

## [6.13.11] - 2019-05-15

### Changed
- bumping version to 6.13.11

## [6.13.10] - 2019-04-24

### Changed
- bumping version to 6.13.10 (6.13.8 and 6.13.9 were ephemeral and never captured).

## [6.13.7] - 2019-02-08

### Changed
- crontab improvements, [a47c842](https://github.com/Unidata/ldm-docker/commit/a47c842)
- `yum -y update yum`, [9557343](https://github.com/Unidata/ldm-docker/commit/9557343)
- chown changes, [dc703b6](https://github.com/Unidata/ldm-docker/commit/dc703b6)
- runtime improvements in how permissions are handled, [e8bf062](https://github.com/Unidata/ldm-docker/commit/e8bf062)
- modernized `docker-compose.yml`, [0f2e2af](https://github.com/Unidata/ldm-docker/commit/0f2e2af)
- information about support, [90347f4](https://github.com/Unidata/ldm-docker/commit/90347f4)
- `.profile` to include `~/bin` in `PATH`, [0f50b1e](https://github.com/Unidata/ldm-docker/commit/0f50b1e)
- update `gosu`, [79c94bd](https://github.com/Unidata/ldm-docker/commit/79c94bd)
- added `libstdc++-static` for `6.13.7`, [79c94bd](https://github.com/Unidata/ldm-docker/commit/79c94bd)

### Added
- scouring utilities, [226c3a5](https://github.com/Unidata/ldm-docker/commit/226c3a5)
- DOI citation, [9e0b79c](https://github.com/Unidata/ldm-docker/commit/9e0b79c)
- parameterizable UID, GID, [27b8201](https://github.com/Unidata/ldm-docker/commit/27b8201)
- working example, [0a1a731](https://github.com/Unidata/ldm-docker/commit/0a1a731)

## [6.13.6] - 2017-02-06

### Changed

- In Dockerfile libpng-dev -> libpng-devel for CentOS

## [6.13.5] - 2016-11-01

### Added

- `gnuplot` to the container

### Changed

- suggested better default queue size
- setting `/home/ldm` for `pqact` and `pqsurf` per Tom Y.
- moving queue outside the container
- dockerhub automated builds
- ulimit set in `docker-compose.yml`
- cleaning up `tar.gz` file (does not need to end up in container).

## [6.13.4] - 2016-08-17

### Added

- `CHANGELOG.md`

### Changed

- `README` improvements and typo corrections
- correctly invoking `configure` and `make root-actions` do deal with port 388 (e.g., for LDM relay node scenario)
- version update to `6.13.4` for `Dockerfile` and `README`
- removed bogus `crontab` mount
- Miscellaneous `Dockerfile` clean up
- Miscellaneous `.travis.yml` clean up

## [6.13.3] - 2016-07-22

### Added
- `README` additions
- `docker-compose.yml` `ldm` container name reference

[Unreleased]: https://github.com/Unidata/ldm-docker/compare/v6.13.12...HEAD
[6.13.12]: https://github.com/Unidata/ldm-docker/compare/v6.13.11...v6.13.12
[6.13.11]: https://github.com/Unidata/ldm-docker/compare/v6.13.10...v6.13.11
[6.13.10]: https://github.com/Unidata/ldm-docker/compare/v6.13.7...v6.13.10
[6.13.7]: https://github.com/Unidata/ldm-docker/compare/v6.13.6...v6.13.7
[6.13.6]: https://github.com/Unidata/ldm-docker/compare/v6.13.5...v6.13.6
[6.13.5]: https://github.com/Unidata/ldm-docker/compare/v6.13.4...v6.13.5
[6.13.4]: https://github.com/Unidata/ldm-docker/compare/v6.13.3...v6.13.4
[6.13.3]: https://github.com/Unidata/ldm-docker/compare/v6.13.2...v6.13.3
