import 'package:logging/logging.dart';
import 'package:test/test.dart';

import 'package:urbit_ob/src/muk.dart' as muk;

// https://stackoverflow.com/a/31929528
final cases = [
  ['', 0, 0],
  ['', 1, 0x514E28B7],
  ['', 0xffffffff, 0x81F16F39],
  [
    String.fromCharCodes([0xFF, 0xFF, 0xFF, 0xFF]),
    0,
    0x76293B50
  ],
  // [
  //   String.fromCharCodes([21, 43, 65, 87]),
  //   0,
  //   0xF55B516B
  // ],
  // [
  //   String.fromCharCodes([21, 43, 65, 87]),
  //   0x5082EDEE,
  //   0x2362F9DE
  // ],
  // [
  //   String.fromCharCodes([21, 43, 65]),
  //   0,
  //   0x7E4A8634
  // ],
  // [
  //   String.fromCharCodes([21, 43]),
  //   0,
  //   0xA0F7B07A
  // ],
  // [
  //   String.fromCharCodes([21]),
  //   0,
  //   0x72661CF4
  // ],
  [
    String.fromCharCodes([0, 0, 0, 0]),
    0,
    0x2362F9DE
  ],
  [
    String.fromCharCodes([0, 0, 0]),
    0,
    0x85F0B427
  ],
  [
    String.fromCharCodes([0, 0]),
    0,
    0x30F4C306
  ],
  [
    String.fromCharCodes([0]),
    0,
    0x514E28B7
  ],
  ["aaaa", 0x9747b28c, 0x5A97808A],
  ["aaa", 0x9747b28c, 0x283E0130],
  ["aa", 0x9747b28c, 0x5D211726],
  ["a", 0x9747b28c, 0x7FA09EA6],
  ["abcd", 0x9747b28c, 0xF0478627],
  ["abc", 0x9747b28c, 0xC84A62DD],
  ["ab", 0x9747b28c, 0x74875592],
  ["a", 0x9747b28c, 0x7FA09EA6],
  ["Hello, world!", 0x9747b28c, 0x24884CBA],
  // ["ππππππππ", 0x9747b28c, 0xD58063C1],
  [String.fromCharCodes(List.filled(256, 97)), 0x9747b28c, 0x37405BDC]
];

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  group('murmur', () {
    for (var i = 0; i < cases.length; i++) {
      final String key = cases[i][0];
      final int seed = cases[i][1];
      final int res = cases[i][2];

      test("(${key}, ${seed}) = ${res}", () {
        expect(muk.murmurhash3_32_gc(key, seed), equals(res));
      });
    }
  });

  group('urbit muk cases', () {
    test('case 1', () {
      expect(muk.muk(0, 2, BigInt.from(0x101)), 0x42081a9b);
    });

    test('case 2', () {
      expect(muk.muk(0, 2, BigInt.from(0x201)), 0x64c7667e);
    });

    test('case 3', () {
      expect(muk.muk(0, 2, BigInt.from(0x4812)), 0xa30782dc);
    });
  });
}
