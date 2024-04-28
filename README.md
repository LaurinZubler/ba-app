# upsi - mobile app
This repository contains the mobile app for the bachelor thesis "upsi - A decentralized STI tracing approach"

OST - Eastern Switzerland University of Applied Sciences  
Author: Laurin Zubler [laurin.zubler@ost.ch](mailto:laurin.zubler@ost.ch)  
Advisor: Dr. Thomas Bocek [thomas.bocek@ost.ch](mailto:thomas.bocek@ost.ch)

## Project Dashboard
The documentation as well as other useful links are published on the project dashboard:  
https://laurinzubler.github.io/ba-documentation/

## Riverpod
This app is using Riverpod. A reactive caching and data-binding framework: https://riverpod.dev/

### Code generation
To use all benefits of Riverpod, an extra step is required to automatically generate code fragments.  

run:
```
dart run build_runner watch -d
```
More information: https://riverpod.dev/de/docs/concepts/about_code_generation