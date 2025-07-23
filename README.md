# token_interceptor

A lightweight, customizable [Dio](https://pub.dev/packages/dio) interceptor for Flutter that automatically attaches JWT tokens and refreshes them when expired (HTTP 401). Built with `flutter_secure_storage` to keep tokens secure.

## ✨ Features

- ✅ Automatically adds `Authorization: Bearer <token>` to requests
- 🔁 Refreshes token on 401 error
- 🔐 Stores refresh token securely using `flutter_secure_storage`
- 📦 Cleanly packaged for reuse across multiple apps

## 🚀 Installation

In your `pubspec.yaml`:

```yaml
dependencies:
  token_interceptor:
    git:
      url: https://github.com/narzu11ayevnodirbek/token_interceptor.git
