import 'package:barnklocka2/gamestats.dart';
import 'package:barnklocka2/toplist.dart';
import 'package:test/test.dart';

void main() {
  final faster = GameStats(const Duration(seconds: 10), 10);
  final slower = GameStats(const Duration(seconds: 20), 10);
  final worst = GameStats(const Duration(seconds: 10), 9);

  test('Fastest first', () {
    TopList testMe = TopList(2);
    testMe.add(faster);
    testMe.add(slower);

    expect(testMe.list, equals([faster, slower]));
    expect(testMe.mostRecentEntry, equals(1));
  });

  test('Fastest first (additions in other order)', () {
    TopList testMe = TopList(2);
    testMe.add(slower);
    testMe.add(faster);

    expect(testMe.list, equals([faster, slower]));
    expect(testMe.mostRecentEntry, equals(0));
  });

  test('Evicting saves the most recent entry even if it is the worst one', () {
    TopList testMe = TopList(2);
    testMe.add(faster);
    testMe.add(slower);
    testMe.add(worst);

    // Evict slower, because we always retain the most recent entry
    expect(testMe.list, equals([faster, worst]));
    expect(testMe.mostRecentEntry, 1);
  });

  test('Evicting the worst entry', () {
    TopList testMe = TopList(2);
    testMe.add(worst);
    testMe.add(slower);
    testMe.add(faster);

    expect(testMe.list, equals([faster, slower]));
    expect(testMe.mostRecentEntry, 0);
  });

  test('Serialize empty', () {
    const size = 2;
    TopList original = TopList(size);
    String serialized = original.serialize();
    TopList deserialized = TopList.deserialize(serialized);

    expect(deserialized.size, equals(size));
    expect(deserialized.list, equals(original.list));
    expect(deserialized.mostRecentEntry, equals(-1));
  });

  test('Serialize non-empty', () {
    const size = 2;
    TopList original = TopList(size);
    original.add(faster);
    original.add(slower);

    String serialized = original.serialize();
    TopList deserialized = TopList.deserialize(serialized);

    expect(deserialized.size, equals(size));
    expect(deserialized.list, equals(original.list));
    expect(deserialized.mostRecentEntry, equals(-1));
  });
}
