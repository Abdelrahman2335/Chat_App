# chat_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


After moving the Android SDK from the default C:\ drive to D:\, Gradle and Flutter builds began failing due to outdated paths pointing to the old SDK location.

🛠️ Issue Summary
The build system was still trying to access:

D:\Android\Sdk\cmake\3.22.1\bin\ninja.exe
This caused build failures and missing dependencies during debug mode in:


D:\Repository\Chat_App\android\app\.cxx\Debug
✅ Solution Steps
Update All SDK Paths

Locate and update all references to the old SDK path in:

local.properties

Any .gradle or .cxx cache/config

System environment variables (ANDROID_HOME, PATH, etc.)

Important Commands Used

flutter run --verbose
Showed detailed logs and helped pinpoint the exact path and tool causing the issue.

.\gradlew.bat clean
Cleaned old Gradle build files and rebuilt everything from scratch.

.\gradlew --stop
Stopped any running Gradle daemon that might have cached the old SDK path.

✅ Final Notes
Always verify and update paths in:

local.properties

Environment variables (JAVA_HOME, ANDROID_SDK_ROOT)

If things break again, use:

flutter run --verbose

flutter doctor -v

These are your best tools to track and resolve Android build issues quickly.