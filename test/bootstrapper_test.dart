import 'package:bootstrapper/bootstrapper.dart';
import 'package:test/test.dart';

void main() {
  group('Bootstrapper', () {
    test('should initialize Bootstrapable objects in groups', () async {
      // arrange
      final property = 'property';
      final bootstrapables = [
        _TestBootstrapable(groupId: 1),
        _TestBootstrapable(groupId: 2),
        _TestBootstrapable(groupId: 1),
      ];
      final bootstrapper = Bootstrapper(property: property, bootstrapables: bootstrapables);

      // act
      await bootstrapper.initialize();

      // assert
      expect(bootstrapables[0].initialized, isTrue);
      expect(bootstrapables[1].initialized, isTrue);
      expect(bootstrapables[2].initialized, isTrue);
      expect(bootstrapables[0].isInitializedBefore(bootstrapables[1]), isTrue);
      expect(bootstrapables[2].isInitializedBefore(bootstrapables[1]), isTrue);
    });
  });
}

class _TestBootstrapable extends Bootstrapable<String> {
  _TestBootstrapable({required this.groupId});

  @override
  final int groupId;
  DateTime? initializationTime;

  @override
  Future<void> initialize(String property) async {
    await Future.delayed(Duration(milliseconds: 100));

    initializationTime = DateTime.now();
  }

  bool get initialized => initializationTime != null;

  bool isInitializedBefore(_TestBootstrapable other) {
    if (!initialized || !other.initialized) {
      throw Exception('Both objects must be initialized before calling isInitializedBefore method');
    }

    return initializationTime!.isBefore(other.initializationTime!);
  }
}
