import 'package:collection/collection.dart';

/// An abstract class representing an object that can be bootstrapped.
abstract class Bootstrappable<P> {
  /// Defines to which group the [Bootstrappable] object belongs.
  int get groupId;

  /// Represents the operations that will be executed for the [Bootstrappable] object.
  Future<void> initialize(P property);
}

class Bootstrapper<P> {
  const Bootstrapper({required P property, required List<Bootstrappable<P>> bootstrappables})
    : _bootstrappables = bootstrappables,
      _property = property;

  /// The value that will be passed to the initialize method of each [Bootstrappable] object.
  final P _property;

  /// The list of [Bootstrappable] objects that needs to be executed.
  final List<Bootstrappable<P>> _bootstrappables;

  /// Groups all [Bootstrappable] objects by their groupIds and initializes the objects in each group
  /// concurrently by calling their initialize methods.
  Future<void> initialize() async {
    final groupedLists = _bootstrappables.groupListsBy((b) => b.groupId);

    final sortedGroupIds = groupedLists.keys.sorted((a, b) => a.compareTo(b));

    for (final groupId in sortedGroupIds) {
      final list = groupedLists[groupId]!;

      await Future.wait(list.map((b) => b.initialize(_property)));
    }
  }
}
