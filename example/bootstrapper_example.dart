import 'package:bootstrapper/bootstrapper.dart';

class FooConfig implements Bootstrapable<String> {
  FooConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('FooConfig($groupId) is started with $property property');

    await Future.delayed(const Duration(seconds: 1));

    print('FooConfig($groupId) is finished with $property property');
  }
}

class BarConfig implements Bootstrapable<String> {
  BarConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('BarConfig($groupId) is started with $property property');

    await Future.delayed(const Duration(seconds: 2));

    print('BarConfig($groupId) is finished with $property property');
  }
}

class BazConfig implements Bootstrapable<String> {
  BazConfig(this.groupId);

  @override
  final int groupId;

  @override
  Future<void> initialize(String property) async {
    print('BazConfig($groupId) is started with $property property');

    await Future.delayed(const Duration(seconds: 3));

    print('BazConfig($groupId) is finished with $property property');
  }
}

Future<void> main() async {
  Bootstrapper bootstrapper = Bootstrapper<String>(
    property: 'development',
    bootstrapables: [
      FooConfig(0),
      BarConfig(0),
      BarConfig(1),
    ],
  );

  await bootstrapper.initialize();
}
