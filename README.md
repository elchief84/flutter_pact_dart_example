# pact_example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Use ngrok to expone api
npx ngrok http 3000

#### pact_dart after installation
command `flutter pub run pact_dart:install` /usr/local/lib/libpact_ffi.dylib will be created.
Download and replace this file with
https://github.com/pact-foundation/pact-reference/releases/download/libpact_ffi-v0.4.6/libpact_ffi-osx-aarch64-apple-darwin.dylib.gz
to run test on M1/M2/M3

set environment variable PACT_DART_LIB_DOWNLOAD_PATH=/usr/local/lib/libpact_ffi.dylib