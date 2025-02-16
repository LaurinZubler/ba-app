# upsi - mobile app
This repository contains the mobile app for the bachelor thesis "upsi - A decentralized STI tracing approach"

OST - Eastern Switzerland University of Applied Sciences  
Author: Laurin Zubler [laurin.zubler@ost.ch](mailto:laurin.zubler@ost.ch)  
Advisor: Dr. Thomas Bocek [thomas.bocek@ost.ch](mailto:thomas.bocek@ost.ch)

## Local Setup
### Install Dependencies (once)
```shell
flutter pub get
```

### Code Generation
To use Riverpod and Freezed, build_runner is required for automated code generation.
```shell
dart run build_runner build
dart run build_runner watch -d
```
More information: https://riverpod.dev/de/docs/concepts/about_code_generation

### Android
adjust `/upsi/android/app/build.gradle` 
```
minSdkVersion 21 
```

### Environment Variables
Create File /upsi/.env with content:
```
INFURA_API_KEY=<Infura API Key>
```

### l10n
Manually generate l10n files
```shell
flutter gen-l10n
```

### Generate App Icons
```shell
dart run flutter_launcher_icons
```

## Run app
```shell
flutter run lib/main.dart
```
