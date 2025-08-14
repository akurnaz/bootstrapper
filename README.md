# Bootstrapper

[![Pub Version](https://img.shields.io/pub/v/bootstrapper)](https://pub.dev/packages/bootstrapper)
[![License](https://img.shields.io/github/license/akurnaz/bootstrapper)](LICENSE)

Bootstrapper is a Dart package that enables you to initialize multiple configuration processes concurrently by organizing them into prioritized groups. Suitable for application startup sequences, dependency initialization, and scenarios where you need controlled concurrent execution.

## Usage

```dart
import 'package:bootstrapper/bootstrapper.dart';

class DatabaseConfig implements Bootstrappable<String> {
  DatabaseConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('DatabaseConfig($groupId) started with $property environment');

    await Future.delayed(const Duration(seconds: 1));

    print('DatabaseConfig($groupId) completed');
  }
}

class CacheConfig implements Bootstrappable<String> {
  CacheConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('CacheConfig($groupId) started with $property environment');

    await Future.delayed(const Duration(seconds: 2));

    print('CacheConfig($groupId) completed');
  }
}

class ApiConfig implements Bootstrappable<String> {
  ApiConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('ApiConfig($groupId) started with $property environment');

    await Future.delayed(const Duration(seconds: 3));

    print('ApiConfig($groupId) completed');
  }
}

Future<void> main() async {
  final bootstrapper = Bootstrapper<String>(
    property: 'development',
    bootstrappables: [
      // Group 0: High priority - Database and Cache run concurrently
      DatabaseConfig(0),
      CacheConfig(0),
      // Group 1: Lower priority - API runs after Group 0 completes
      ApiConfig(1),
    ],
  );

  print('Starting application initialization...');

  await bootstrapper.initialize();

  print('Application ready!');
}
```

### Expected Output

```
Starting application initialization...
DatabaseConfig(0) started with development environment
CacheConfig(0) started with development environment
DatabaseConfig(0) completed
CacheConfig(0) completed
ApiConfig(1) started with development environment
ApiConfig(1) completed
Application ready!
```

## Issues & Support

If you encounter any issues or have any questions, you can file an issue on the official GitHub repository. Contributions are also welcome via pull requests.