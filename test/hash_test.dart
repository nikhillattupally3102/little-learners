import 'package:flutter_test/flutter_test.dart';
import 'package:little_learners/generators/gen.dart';

void main() {
  // Known FNV-1a (32-bit) values. The same numbers must come out on the web
  // build, so seen-question memory syncs between iPad and browser.
  test('stable hash matches FNV-1a', () {
    expect(Gen.stableHash('a'), 3826002220);
    expect(Gen.stableHash('hello world'), 3582672807);
    expect(Gen.stableHash('20261120_addition'), 2424432624);
  });
}
