import 'package:test/test.dart';
import 'package:logging/logging.dart';

import 'package:urbit_ob/urbit_ob.dart' as ob;
import 'cases.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  group('ob', () {
    test('should have 256 prefixes', () {
      expect(ob.prefixes.length, equals(256));
    });

    test('should have 256 suffixes', () {
      expect(ob.suffixes.length, equals(256));
    });

    test('should syl names correctly', () {
      expect(ob.patp2syls('~bosnyt-raddux'), orderedEquals(["bos", "nyt", "rad", "dux"]));
    });

    group('.patp', () {
      patps.forEach((pair) {
        test("should convert ${pair[0]} to ${pair[1]}", () {
          expect(ob.patp(BigInt.from(pair[0])), equals(pair[1]));
        });
      });
    });

    group('.patp (big)', () {
      bigpatps.forEach((pair) {
        test("should convert ${pair[0]} to ${pair[1]}", () {
          expect(ob.patp(pair[0]), equals(pair[1]));
        });
      });
    });

    group('.patp2dec', () {
      patps.forEach((pair) {
        test("should convert ${pair[1]} to ${pair[0]}", () {
          expect(ob.patp2dec(pair[1]), equals(BigInt.from(pair[0])));
        });
      });
    });
  });

  group('.patq', () {
    patqs.forEach((pair) {
      test("should convert ${pair[0]} to ${pair[1]}", () {
        expect(ob.patq(pair[0]), equals(pair[1]));
      });
    });
  });

  group('.patq2buf', () {
    patqs.forEach((pair) {
      test("should convert ${pair[1]} to ${pair[0]}", () {
        expect(ob.patq2buf(pair[1]), orderedEquals(pair[0]));
      });
    });
  });
}
