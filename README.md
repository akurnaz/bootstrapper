# Bootstrapper

Bootstrapper is a Dart package that allows you to initialize multiple config processes in parallel by grouping them.

## Features

- Bootstrapper enables you to group a list of objects that need to be initialized.
- Objects that implement the `Bootstrappable` abstract class can be grouped together and initialized in parallel.
- Bootstrapper ensures that objects belonging to the same group are initialized before objects belonging to a different group.

## Getting started

To use Bootstrapper in your project, you should include it in your dependencies in your pubspec.yaml file as follows:

```yaml
dependencies:
  bootstrapper: ^0.1.0
```

## Usage

```dart
import 'package:bootstrapper/bootstrapper.dart';

class DatabaseConfig implements Bootstrappable<String> {
  DatabaseConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('DatabaseConfig($groupId) is started with $property property');

    await Future.delayed(const Duration(seconds: 1));

    print('DatabaseConfig($groupId) is finished with $property property');
  }
}

class CacheConfig implements Bootstrappable<String> {
  CacheConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('CacheConfig($groupId) is started with $property property');

    await Future.delayed(const Duration(seconds: 2));

    print('CacheConfig($groupId) is finished with $property property');
  }
}

class ApiConfig implements Bootstrappable<String> {
  ApiConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('ApiConfig($groupId) is started with $property property');

    await Future.delayed(const Duration(seconds: 3));

    print('ApiConfig($groupId) is finished with $property property');
  }
}

Future<void> main() async {
  Bootstrapper bootstrapper = Bootstrapper<String>(
    property: 'development',
    bootstrappables: [DatabaseConfig(0), CacheConfig(0), ApiConfig(1)],
  );

  await bootstrapper.initialize();
}
```

## Additional information

If you encounter any issues or have any questions, you can file an issue on the official GitHub repository. Contributions are also welcome via pull requests.