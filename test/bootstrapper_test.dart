import 'package:bootstrapper/bootstrapper.dart';
import 'package:test/test.dart';

void main() {
  group('Bootstrapper', () {
    test('should initialize Bootstrappable objects in groups', () async {
      // arrange
      final property = 'property';
      final bootstrappables = [
        _TestBootstrappable(groupId: 1),
        _TestBootstrappable(groupId: 2),
        _TestBootstrappable(groupId: 1),
      ];
      final bootstrapper = Bootstrapper(property: property, bootstrappables: bootstrappables);

      // act
      await bootstrapper.initialize();

      // assert
      expect(bootstrappables[0].initialized, isTrue);
      expect(bootstrappables[1].initialized, isTrue);
      expect(bootstrappables[2].initialized, isTrue);
      expect(bootstrappables[0].isInitializedBefore(bootstrappables[1]), isTrue);
      expect(bootstrappables[2].isInitializedBefore(bootstrappables[1]), isTrue);
    });
  });
}

class _TestBootstrappable extends Bootstrappable<String> {
  _TestBootstrappable({required this.groupId});

  @override
  final int groupId;
  DateTime? initializationTime;

  @override
  Future<void> initialize(String property) async {
    await Future.delayed(Duration(milliseconds: 100));

    initializationTime = DateTime.now();
  }

  bool get initialized => initializationTime != null;

  bool isInitializedBefore(_TestBootstrappable other) {
    if (!initialized || !other.initialized) {
      throw Exception('Both objects must be initialized before calling isInitializedBefore method');
    }

    return initializationTime!.isBefore(other.initializationTime!);
  }
}
