import 'package:flutter_test/flutter_test.dart';
import 'package:tialink/core/utils.dart';

void main() {
  test("Test randomInt", () {
    for (var i = 0; i < 100; i++) {
      expect(randomInt(8).toString(), hasLength(8));
    }
  });
}
