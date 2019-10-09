import 'package:pointycastle/src/utils.dart';

/// generate these test cases via
/// JSON.stringify(_.range(n, n+100).map((i) => [i, ob.patp(i)]))
final patps = [
  [512, "~binzod"],
  [1024, "~samzod"],
  [9896704, "~poldec-tonteg"],
  [15663360, "~nidsut-tomdun"],
  [3108299008, "~morlyd-mogmev"],
  [479733505, "~fipfes-morlyd"],
  [0, "~zod"],
  [1, "~nec"],
  [2, "~bud"],
  [3, "~wes"],
  [4, "~sev"],
  [5, "~per"],
  [6, "~sut"],
  [7, "~let"],
  [8, "~ful"],
  [9, "~pen"],
  [10, "~syt"],
  [11, "~dur"],
  [12, "~wep"],
  [13, "~ser"],
  [14, "~wyl"],
  [15, "~sun"],
  [16, "~ryp"],
  [17, "~syx"],
  [18, "~dyr"],
  [19, "~nup"],
  [20, "~heb"],
  [21, "~peg"],
  [22, "~lup"],
  [23, "~dep"],
  [24, "~dys"],
  [25, "~put"],
  [26, "~lug"],
  [27, "~hec"],
  [28, "~ryt"],
  [29, "~tyv"],
  [30, "~syd"],
  [31, "~nex"],
  [32, "~lun"],
  [127, "~med"],
  [128, "~lyt"],
  [129, "~dus"],
  [255, "~fes"],
  [256, "~marzod"],
  [257, "~marnec"],
  [258, "~marbud"],
  [510, "~marnev"],
  [511, "~marfes"],
  [19268096, '~bosnyt-raddux'],
  [2342345, "~finfus-lartyr"],
  [2342346, "~barrym-lomlex"],
  [2342437, "~watnyl-motset"],
  [2342438, "~namnys-nimpen"],
  [2342439, "~tirrup-fanret"],
  [2342440, "~batmul-fosdel"],
  [2342441, "~finner-tacren"],
  [2342442, "~witheb-linlyt"],
  [2342443, "~tognub-davpeg"],
  [2342444, "~latpen-signep"],
  [2342345999, "~fipder-nopful"],
  [2342346000, "~litmun-wanpel"],
  [2342346095, "~hidlur-nalmyn"],
  [2342346096, "~richul-dignut"],
  [2342346097, "~moclur-pilber"],
  [2342346098, "~salmep-datden"]
];

final bigpatps = [
  [
    BigInt.parse("7468697320697320736f6d6520766572792068696768207175616c69747920656e74726f7079",
        radix: 16),
    "~divmes-davset-holdet--sallun-salpel-taswet-holtex--watmeb-tarlun-picdet-magmes--holter-dacruc-timdet-divtud--holwet-maldut-padpel-sivtud"
  ],
];

final patqs = [
  [_encodeInt(0), "~"],
  [
    [0],
    "~zod"
  ],
  [_encodeInt(512), "~binzod"],
  [_encodeInt(1024), "~samzod"],
  [_encodeInt(4016240379), "~poldec-tonteg"],
  [_encodeInt(1208402137), "~nidsut-tomdun"],
  [_encodeHex("01010101010101010102"), "~marnec-marnec-marnec-marnec-marbud"],
  [
    _encodeHex("6d7920617765736f6d65207572626974207469636b65742c206920616d20736f206c75636b79"),
    "~tastud-holruc-sidwet-salpel-taswet-holdeg-paddec-davdut-holdut-davwex-balwet-divwen-holdet-holruc-taslun-salpel-holtux-dacwex-baltud"
  ],
  [_encodeHex("0456a869eb"), "~dozsev-postuc-davlux"],
  // TODO: string encoding
  // [_encode("hello world"), "~dozsev-postuc-davlux"]
];

List<int> _encodeInt(int n) => encodeBigInt(BigInt.from(n));
List<int> _encodeHex(String hexString) => encodeBigInt(BigInt.parse(hexString, radix: 16));

// List<int> _encode(String word) {
//   print("${word} -> ${utf8.encode(word)}");
//   return utf8.encode(word);
// }

// int zfbs_32(int n, int s) => (n & 0xFFFFFFFF) >> s;

// int parseBase(String str, int start, int end, int mul) {
//   var r = 0;
//   var b = 0;
//   var len = math.min(str.length, end);
//   for (var i = start; i < len; i++) {
//     var c = str.codeUnitAt(i) - 48;

//     r *= mul;

//     // 'a'
//     if (c >= 49) {
//       b = c - 49 + 0xa;

//       // 'A'
//     } else if (c >= 17) {
//       b = c - 17 + 0xa;

//       // '0' - '9'
//     } else {
//       b = c;
//     }
//     print("c: ${c}, b: ${b}");
//     assert(c >= 0 && b < mul, 'Invalid character');
//     r += b;
//   }
//   return r;
// }

// // mimic BN's encoding of Strings
// // https://github.com/indutny/bn.js/blob/master/lib/bn.js#L143
// List<int> _encode(String number) {
//   final base = 10;
//   final start = 0;
//   // start as 0
//   final words = [0];
//   var length = 1;

//   void _iaddn(int word) {
//     words[0] += word;

//     // carry
//     var i;
//     for (i = 0; i < length && words[i] >= 0x4000000; i++) {
//       words[i] -= 0x4000000;
//       if (i == length - 1) {
//         words[i + 1] = 1;
//       } else {
//         words[i + 1]++;
//       }
//     }

//     length = math.max(length, i + 1);
//   }

//   void imuln(int n) {
//     assert(n < 0x4000000);

//     // Carry
//     var carry = 0;
//     var i;
//     for (i = 0; i < length; i++) {
//       var w = (words[i] | 0) * n;
//       var lo = (w & 0x3ffffff) + (carry & 0x3ffffff);
//       carry >>= 26;
//       carry += (w ~/ 0x4000000) | 0;
//       // NOTE: lo is 27bit maximum
//       carry += zfbs_32(lo, 26);
//       words[i] = lo & 0x3ffffff;
//     }

//     if (carry != 0) {
//       words[i] = carry;
//       length++;
//     }
//   }

//   // Find length of limb in base
//   var limbLen = 0;
//   var limbPow = 1;
//   for (limbPow = 1; limbPow <= 0x3ffffff; limbPow *= base) {
//     limbLen++;
//   }
//   limbLen--;
//   limbPow = (limbPow ~/ base) | 0;

//   var total = number.length - start;
//   var mod = total % limbLen;
//   var end = math.min(total, total - mod) + start;

//   var word = 0;
//   var i;
//   for (i = start; i < end; i += limbLen) {
//     word = parseBase(number, i, i + limbLen, base);

//     imuln(limbPow);
//     if (words[0] + word < 0x4000000) {
//       words[0] += word;
//     } else {
//       _iaddn(word);
//     }
//   }

//   if (mod != 0) {
//     var pow = 1;
//     word = parseBase(number, i, number.length, base);

//     for (i = 0; i < mod; i++) {
//       pow *= base;
//     }

//     imuln(pow);
//     if (words[0] + word < 0x4000000) {
//       words[0] += word;
//     } else {
//       _iaddn(word);
//     }
//   }

//   return words;

//   // return encodeBigInt(BigInt.parse(number, radix: 36));
// }
