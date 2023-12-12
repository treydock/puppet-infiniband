# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v4.1.0](https://github.com/treydock/puppet-infiniband/tree/v4.1.0) (2022-08-22)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/v4.0.0...v4.1.0)

### Added

- Replace CentOS 8 support with Rocky/AlmaLinux 8 [\#34](https://github.com/treydock/puppet-infiniband/pull/34) ([treydock](https://github.com/treydock))
- Mirror puppet-module-mofed nm\_controlled behavior [\#33](https://github.com/treydock/puppet-infiniband/pull/33) ([pedmon](https://github.com/pedmon))

## [v4.0.0](https://github.com/treydock/puppet-infiniband/tree/v4.0.0) (2021-09-14)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/v3.1.0...v4.0.0)

### Changed

- BREAKING: Major updates: drop EL6, drop Puppet 5, add Puppet 7 [\#29](https://github.com/treydock/puppet-infiniband/pull/29) ([treydock](https://github.com/treydock))

### Added

- Bump supported yum and stdlib module dependencies [\#31](https://github.com/treydock/puppet-infiniband/pull/31) ([treydock](https://github.com/treydock))
- Support EL8 [\#30](https://github.com/treydock/puppet-infiniband/pull/30) ([treydock](https://github.com/treydock))
- Bump dep augeasproviders shellvar [\#28](https://github.com/treydock/puppet-infiniband/pull/28) ([mrolli](https://github.com/mrolli))

## [v3.1.0](https://github.com/treydock/puppet-infiniband/tree/v3.1.0) (2019-05-23)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/3.0.0...v3.1.0)

### Added

- Bump supported version of yum module [\#27](https://github.com/treydock/puppet-infiniband/pull/27) ([treydock](https://github.com/treydock))
- Add convenient support for bonding IB interfaces [\#26](https://github.com/treydock/puppet-infiniband/pull/26) ([mrolli](https://github.com/mrolli))
- Add tests for new facts and rubocop fixes [\#24](https://github.com/treydock/puppet-infiniband/pull/24) ([treydock](https://github.com/treydock))
- Convert to PDK [\#23](https://github.com/treydock/puppet-infiniband/pull/23) ([treydock](https://github.com/treydock))
- Use Ruby function for calc\_log\_num\_mtt [\#22](https://github.com/treydock/puppet-infiniband/pull/22) ([treydock](https://github.com/treydock))
- Add initial support for multiple infiniband ports and a new fact for mapping network device names and related IB device information [\#21](https://github.com/treydock/puppet-infiniband/pull/21) ([clevelas](https://github.com/clevelas))
- Use puppet strings [\#20](https://github.com/treydock/puppet-infiniband/pull/20) ([treydock](https://github.com/treydock))

## [3.0.0](https://github.com/treydock/puppet-infiniband/tree/3.0.0) (2019-04-26)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/2.0.0...3.0.0)

### Changed

- BREAKING: Use example42/network module for infiniband interfaces [\#19](https://github.com/treydock/puppet-infiniband/pull/19) ([treydock](https://github.com/treydock))
- BREAKING: Install packages via yum package group [\#17](https://github.com/treydock/puppet-infiniband/pull/17) ([treydock](https://github.com/treydock))

### Added

- Support only Puppet 5 and 6 and update module dependency ranges [\#18](https://github.com/treydock/puppet-infiniband/pull/18) ([treydock](https://github.com/treydock))
- Add HCA facts [\#15](https://github.com/treydock/puppet-infiniband/pull/15) ([treydock](https://github.com/treydock))

## [2.0.0](https://github.com/treydock/puppet-infiniband/tree/2.0.0) (2017-11-11)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/1.3.0...2.0.0)

### Changed

- BREAKING: Use Puppet data types for parameters - drop puppet 3 support [\#14](https://github.com/treydock/puppet-infiniband/pull/14) ([treydock](https://github.com/treydock))

## [1.3.0](https://github.com/treydock/puppet-infiniband/tree/1.3.0) (2017-11-09)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/1.2.0...1.3.0)

### Added

- Adds possibility to omit network service restarts. [\#12](https://github.com/treydock/puppet-infiniband/pull/12) ([mrolli](https://github.com/mrolli))

### Fixed

- Test for "true" and true [\#13](https://github.com/treydock/puppet-infiniband/pull/13) ([mrolli](https://github.com/mrolli))

## [1.2.0](https://github.com/treydock/puppet-infiniband/tree/1.2.0) (2017-10-10)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/1.1.1...1.2.0)

### Added

- Adds support for EL-7.4. [\#11](https://github.com/treydock/puppet-infiniband/pull/11) ([mrolli](https://github.com/mrolli))

## [1.1.1](https://github.com/treydock/puppet-infiniband/tree/1.1.1) (2017-09-04)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/1.1.0...1.1.1)

### Added

- infiniband.rb: Workaround for missing Facter::Util::FileRead. [\#7](https://github.com/treydock/puppet-infiniband/pull/7) ([olifre](https://github.com/olifre))
- Addiitonal parameter MTU for ifcfg scripts. [\#4](https://github.com/treydock/puppet-infiniband/pull/4) ([mrolli](https://github.com/mrolli))

## [1.1.0](https://github.com/treydock/puppet-infiniband/tree/1.1.0) (2014-11-05)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/1.0.0...1.1.0)

## [1.0.0](https://github.com/treydock/puppet-infiniband/tree/1.0.0) (2014-10-16)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/0.1.1...1.0.0)

## [0.1.1](https://github.com/treydock/puppet-infiniband/tree/0.1.1) (2014-06-19)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/0.1.0...0.1.1)

## [0.1.0](https://github.com/treydock/puppet-infiniband/tree/0.1.0) (2014-05-22)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/0.0.4...0.1.0)

## [0.0.4](https://github.com/treydock/puppet-infiniband/tree/0.0.4) (2014-05-10)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/0.0.3...0.0.4)

## [0.0.3](https://github.com/treydock/puppet-infiniband/tree/0.0.3) (2014-05-09)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/0.0.1...0.0.3)

## [0.0.1](https://github.com/treydock/puppet-infiniband/tree/0.0.1) (2014-03-28)

[Full Changelog](https://github.com/treydock/puppet-infiniband/compare/811c4f4fb3e795285896bd67adc63ceb3c23b152...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
