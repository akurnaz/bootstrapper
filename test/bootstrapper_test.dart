import 'package:bootstrapper/bootstrapper.dart';
import 'package:test/test.dart';

void main() {
  group('Bootstrapper', () {
    test('should group Bootstrapable objects by groupId', () async {
      // arrange
      final property = 'property';
      final bootstrapables = [
        MyBootstrapable(groupId: 1),
        MyBootstrapable(groupId: 2),
        MyBootstrapable(groupId: 1),
      ];
      final bootstrapper = Bootstrapper(property: property, bootstrapables: bootstrapables);

      // act
      final groupedMap = bootstrapper.groupByGroupId(bootstrapables);

      // assert
      expect(groupedMap.length, equals(2));
      expect(groupedMap[1], hasLength(2));
      expect(groupedMap[2], hasLength(1));
    });

    test('should initialize Bootstrapable objects in groups', () async {
      // arrange
      final property = 'property';
      final bootstrapables = [
        MyBootstrapable(groupId: 1),
        MyBootstrapable(groupId: 2),
        MyBootstrapable(groupId: 1),
      ];
      final bootstrapper = Bootstrapper(property: property, bootstrapables: bootstrapables);

      // act
      await bootstrapper.initialize();

      // assert
      expect(bootstrapables[0].isInitialized, isTrue);
      expect(bootstrapables[1].isInitialized, isTrue);
      expect(bootstrapables[2].isInitialized, isTrue);
      expect(bootstrapables[0].initializedBefore(bootstrapables[1]), isTrue);
      expect(bootstrapables[2].initializedBefore(bootstrapables[1]), isTrue);
    });
  });
}

class MyBootstrapable extends Bootstrapable<String> {
  MyBootstrapable({required this.groupId});

  @override
  final int groupId;
  bool isInitialized = false;
  DateTime? initializationTime;

  @override
  Future<void> initialize(String property) async {
    initializationTime = DateTime.now();
    await Future.delayed(Duration(milliseconds: 100));
    isInitialized = true;
  }

  bool initializedBefore(MyBootstrapable other) {
    if (initializationTime == null || other.initializationTime == null) {
      throw Exception('Both objects must be initialized before calling initializedBefore method');
    }
    return initializationTime!.isBefore(other.initializationTime!);
  }
}
