import 'package:urbit_ob/urbit_ob.dart';
import 'package:test/test.dart';
import 'package:logging/logging.dart';

import 'patps.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  group('ob', () {
    Ob ob;

    setUp(() {
      ob = Ob();
    });

    test('should have 256 prefixes', () {
      expect(ob.prefixes.length, equals(256));
    });

    test('should have 256 suffixes', () {
      expect(ob.suffixes.length, equals(256));
    });

    test('should chunk names correctly', () {
      expect(ob.chunk('~bosnyt-raddux'), orderedEquals(["bos", "nyt", "rad", "dux"]));
    });

    group('.patp', () {
      patps.forEach((pair) {
        test("should convert ${pair[0]} to ${pair[1]}", () {
          expect(ob.patp(pair[0]), equals(pair[1]));
        });
      });
    });

    group('.patp2dec', () {
      patps.forEach((pair) {
        test("should convert ${pair[1]} to ${pair[0]}", () {
          expect(ob.patp2dec(pair[1]), equals(pair[0]));
        });
      });
    });
  });
}
