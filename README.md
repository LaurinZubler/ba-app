# upsi - mobile app
This repository contains the mobile app for the bachelor thesis "upsi - A decentralized STI tracing approach"

OST - Eastern Switzerland University of Applied Sciences  
Author: Laurin Zubler [laurin.zubler@ost.ch](mailto:laurin.zubler@ost.ch)  
Advisor: Dr. Thomas Bocek [thomas.bocek@ost.ch](mailto:thomas.bocek@ost.ch)

## Project Dashboard
The documentation as well as other useful links are published on the project dashboard:  
https://laurinzubler.github.io/ba-documentation/

## Local Setup
### Install Dependencies (once)
```console
flutter pub get
```

### Code Generation
To use Riverpod and Freezed, build_runner is required for automated code generation.
```console
dart run build_runner watch -d
```
More information: https://riverpod.dev/de/docs/concepts/about_code_generation

### Run app
```console
flutter run lib/main.dart
```

### l10n (optional)
Manually generate l10n files
```console
flutter gen-l10n
```

## Frameworks and Packages
### Riverpod
Riverpod is used as reactive caching and data-binding framework. https://riverpod.dev/

### Freezed
Freezed is used a code generator for data-classes, unions, pattern-matching and cloning. https://github.com/rrousselGit/freezed
