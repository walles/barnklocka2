import 'package:barnklocka2/gamestate.dart';
import 'package:test/test.dart';

void main() {
  test('_isValidRendering vs four-digit time', () {
    expect(isValidRendering('1234', DateTime(1, 1, 1, 12, 34)), isTrue);
    expect(isValidRendering('123', DateTime(1, 1, 1, 12, 34)), isFalse);
    expect(isValidRendering('0234', DateTime(1, 1, 1, 2, 34)), isTrue);
    expect(isValidRendering('0034', DateTime(1, 1, 1, 12, 34)), isFalse);

    // Single-digit minutes should require rendering with a leading zero
    expect(isValidRendering('1203', DateTime(1, 1, 1, 12, 3)), isTrue);
  });

  test('_isValidRendering vs three-digit time', () {
    expect(isValidRendering('234', DateTime(1, 1, 1, 2, 34)), isTrue);
    expect(isValidRendering('345', DateTime(1, 1, 1, 2, 34)), isFalse);

    // Single-digit minutes should require rendering with a leading zero
    expect(isValidRendering('123', DateTime(1, 1, 1, 12, 3)), isFalse);
  });

  test('_isValidRendering vs colon separated time', () {
    expect(isValidRendering('12:34', DateTime(1, 1, 1, 12, 34)), isTrue);
    expect(isValidRendering('12:03', DateTime(1, 1, 1, 12, 3)), isTrue);
    expect(isValidRendering('2:34', DateTime(1, 1, 1, 2, 34)), isTrue);
  });
}
