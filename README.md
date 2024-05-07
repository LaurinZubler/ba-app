# upsi - mobile app
This repository contains the mobile app for the bachelor thesis "upsi - A decentralized STI tracing approach"

OST - Eastern Switzerland University of Applied Sciences  
Author: Laurin Zubler [laurin.zubler@ost.ch](mailto:laurin.zubler@ost.ch)  
Advisor: Dr. Thomas Bocek [thomas.bocek@ost.ch](mailto:thomas.bocek@ost.ch)

## project dashboard
The documentation as well as other useful links are published on the project dashboard:  
https://laurinzubler.github.io/ba-documentation/

## architecture
The architecture is inspired by: https://github.com/Uuttssaavv/flutter-clean-architecture-riverpod/tree/master

- `main.dart` file has services initialization code and wraps the root MyApp with a ProviderScope
- `main/app.dart` has the root MaterialApp and initializes AppRouter to handle the route throughout the application.
- `services` abstract app-level services with their implementations.
- The `shared` folder contains code shared across features
  - `theme` contains general styles (colors, themes & text styles)
  - `model` contains all the Data models needed in the application.
  - `http` is implemented with Dio.
  - `storage` is implemented with SharedPreferences.
  - Service locator pattern and Riverpod are used to abstract services when used in other layers.


## local setup
### install dependencies (once)
```console
flutter pub get
```

### code generation (each time)
To use Riverpod and Freezed, build_runner is required for automated code generation.
```console
dart run build_runner watch -d
```
More information: https://riverpod.dev/de/docs/concepts/about_code_generation

### run app (each time)
```console
flutter run lib/main.dart
```

## frameworks and packages
### riverpod
Riverpod is used as reactive caching and data-binding framework. https://riverpod.dev/

### freezed
Freezed is used a code generator for data-classes, unions, pattern-matching and cloning. https://github.com/rrousselGit/freezed
