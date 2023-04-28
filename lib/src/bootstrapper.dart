import 'package:meta/meta.dart';

/// An abstract class representing an object that can be bootstrapped.
abstract class Bootstrapable<P> {
  /// Defines to which group the [Bootstrapable] object belongs.
  int get groupId;

  /// Represents the operations that will be executed for the [Bootstrapable] object.
  Future<void> initialize(P property);
}

class Bootstrapper<P> {
  Bootstrapper({
    required this.property,
    required this.bootstrapables,
  });

  /// The value that will be passed to the initialize method of each [Bootstrapable] object.
  final P property;

  /// The list of [Bootstrapable] objects that needs to be executed.
  final List<Bootstrapable<P>> bootstrapables;

  /// Groups all [Bootstrapable] objects by their groupIds and initializes the objects in each group in parallel by calling their initialize methods.
  Future<void> initialize() async {
    final Map<int, List<Bootstrapable>> groupedMap = groupByGroupId(bootstrapables);

    final Map<int, List<Bootstrapable>> sortedGroupedMap =
        Map.fromEntries(groupedMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    for (var list in sortedGroupedMap.values) {
      await Future.wait(list.map((b) => b.initialize(property)));
    }
  }

  @visibleForTesting
  Map<int, List<Bootstrapable>> groupByGroupId(List<Bootstrapable> values) {
    var map = <int, List<Bootstrapable>>{};
    for (var element in values) {
      (map[element.groupId] ??= []).add(element);
    }
    return map;
  }
}
