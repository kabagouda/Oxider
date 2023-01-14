# Oxider Binaries SDK

This package is the entry point for oxider commands.
It will be activated globally and then added to the dart SDK.

## Important

To build the final oxider-sdk, it will be necessary to compile the bin/oxider.dart file for different platforms (exe, etc...) and add it to the different dart-sdk depending on the platform.

Example: `dart compile exe bin/oxider.dart -o oxider.exe`
