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
