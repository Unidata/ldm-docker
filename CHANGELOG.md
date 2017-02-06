# Change Log
All notable changes to this project will be documented in this file. This change log follows the conventions of [keepachangelog.com](http://keepachangelog.com/).

## 6.13.6 - 2017-02-06

### Changed

- In Dockerfile libpng-dev -> libpng-devel for CentOS

## 6.13.5 - 2016-11-01

### Added

- `gnuplot` to the container

### Changed

- suggested better default queue size
- setting `/home/ldm` for `pqact` and `pqsurf` per Tom Y.
- moving queue outside the container
- dockerhub automated builds
- ulimit set in `docker-compose.yml`
- cleaning up `tar.gz` file (does not need to end up in container).

## 6.13.4 - 2016-08-17

### Added

- `CHANGELOG.md`

### Changed

- `README` improvements and typo corrections
- correctly invoking `configure` and `make root-actions` do deal with port 388 (e.g., for LDM relay node scenario)
- version update to `6.13.4` for `Dockerfile` and `README`
- removed bogus `crontab` mount
- Miscellaneous `Dockerfile` clean up
- Miscellaneous `.travis.yml` clean up

## 6.13.3 - 2016-07-22

### Added
- `README` additions
- `docker-compose.yml` `ldm` container name reference

[Unreleased]: https://github.com/Unidata/ldm-docker/compare/v6.13.6...HEAD
[6.13.6]: https://github.com/Unidata/ldm-docker/compare/v6.13.5...v6.13.6
[6.13.5]: https://github.com/Unidata/ldm-docker/compare/v6.13.4...v6.13.5
[6.13.4]: https://github.com/Unidata/ldm-docker/compare/v6.13.3...v6.13.4
[6.13.3]: https://github.com/Unidata/ldm-docker/compare/v6.13.2...v6.13.3
