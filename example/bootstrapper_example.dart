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
