import 'package:collection/collection.dart';

/// An abstract class representing an object that can be bootstrapped.
abstract class Bootstrapable<P> {
  /// Defines to which group the [Bootstrapable] object belongs.
  int get groupId;

  /// Represents the operations that will be executed for the [Bootstrapable] object.
  Future<void> initialize(P property);
}

class Bootstrapper<P> {
  const Bootstrapper({required P property, required List<Bootstrapable<P>> bootstrapables})
    : _bootstrapables = bootstrapables,
      _property = property;

  /// The value that will be passed to the initialize method of each [Bootstrapable] object.
  final P _property;

  /// The list of [Bootstrapable] objects that needs to be executed.
  final List<Bootstrapable<P>> _bootstrapables;

  /// Groups all [Bootstrapable] objects by their groupIds and initializes the objects in each group
  /// in parallel by calling their initialize methods.
  Future<void> initialize() async {
    final groupedLists = _bootstrapables.groupListsBy((b) => b.groupId);

    final sortedGroupIds = groupedLists.keys.sorted((a, b) => a.compareTo(b));

    for (final groupId in sortedGroupIds) {
      final list = groupedLists[groupId]!;

      await Future.wait(list.map((b) => b.initialize(_property)));
    }
  }
}
