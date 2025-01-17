[![CI](https://github.com/Wadeewee/survey-flutter-ic-pooh/actions/workflows/test.yml/badge.svg)](https://github.com/Wadeewee/survey-flutter-ic-pooh/actions/workflows/test.yml)
[![codecov](https://codecov.io/github/Wadeewee/survey-flutter-ic-pooh/branch/main/graph/badge.svg?token=XHHBI111RO)](https://codecov.io/github/Wadeewee/survey-flutter-ic-pooh)

# Survey Flutter

Survey application built with Flutter

## Usage

Clone the repository

`git clone git@github.com:Wadeewee/survey-flutter-ic-pooh.git`

## Prerequisite

- Flutter 3.3.10
- Flutter version manager (recommend): [fvm](https://fvm.app/)

## Getting Started

### Setup

- Create these `.env` files in the root directory according to the flavors and add the required
  environment variables into them. The example environment variable is in `.env.sample`.

  - Staging: `.env.staging`

  - Production: `.env`

- Run code generator

  - `$ fvm flutter packages pub run build_runner build --delete-conflicting-outputs`

### Run

- Run the app with the desire app flavor:

  - Staging: `$ fvm flutter run --flavor staging`

  - Production: `$ fvm flutter run --flavor production`

### Test

- Run unit testing:

  - `$ fvm flutter test`

- Run integration testing:

  - `$ fvm flutter drive --driver=test_driver/integration_test.dart --target=integration_test/{test_file}.dart --flavor staging`

  - For example:

    `$ fvm flutter drive --driver=test_driver/integration_test.dart --target=integration_test/home_screen_test.dart --flavor staging`

- Code coverage integration:

  - CodeCov: for the private repository, we need to set up a [TeamBot](https://docs.codecov.com/docs/team-bot) in `codecov.yml`.

## License

This project is Copyright (c) 2014 and onwards. It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![Nimble](https://assets.nimblehq.co/logo/dark/logo-dark-text-160.png)

This project is maintained and funded by Nimble.

We love open source and do our part in sharing our work with the community!
See [our other projects][community] or [hire our team][hire] to help build your product.

[community]: https://github.com/nimblehq
[hire]: https://nimblehq.co/
