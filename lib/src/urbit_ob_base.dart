import 'dart:core';
import 'dart:math' as math;

import 'package:pointycastle/src/utils.dart';
import 'package:quiver/iterables.dart';
import 'package:logging/logging.dart';

import 'package:urbit_ob/src/helpers.dart';

final Logger _log = Logger('Ob');

final zero = BigInt.zero;
final one = BigInt.one;
final two = BigInt.two;
final three = BigInt.from(3);
final four = BigInt.from(4);
final eight = BigInt.from(8);

final pre = """
dozmarbinwansamlitsighidfidlissogdirwacsabwissib
rigsoldopmodfoglidhopdardorlorhodfolrintogsilmir
holpaslacrovlivdalsatlibtabhanticpidtorbolfosdot
losdilforpilramtirwintadbicdifrocwidbisdasmidlop
rilnardapmolsanlocnovsitnidtipsicropwitnatpanmin
ritpodmottamtolsavposnapnopsomfinfonbanmorworsip
ronnorbotwicsocwatdolmagpicdavbidbaltimtasmallig
sivtagpadsaldivdactansidfabtarmonranniswolmispal
lasdismaprabtobrollatlonnodnavfignomnibpagsopral
bilhaddocridmocpacravripfaltodtiltinhapmicfanpat
taclabmogsimsonpinlomrictapfirhasbosbatpochactid
havsaplindibhosdabbitbarracparloddosbortochilmac
tomdigfilfasmithobharmighinradmashalraglagfadtop
mophabnilnosmilfopfamdatnoldinhatnacrisfotribhoc
nimlarfitwalrapsarnalmoslandondanladdovrivbacpol
laptalpitnambonrostonfodponsovnocsorlavmatmipfip
"""
    .replaceAll("\n", "");

final suf = """
zodnecbudwessevpersutletfulpensytdurwepserwylsun
rypsyxdyrnuphebpeglupdepdysputlughecryttyvsydnex
lunmeplutseppesdelsulpedtemledtulmetwenbynhexfeb
pyldulhetmevruttylwydtepbesdexsefwycburderneppur
rysrebdennutsubpetrulsynregtydsupsemwynrecmegnet
secmulnymtevwebsummutnyxrextebfushepbenmuswyxsym
selrucdecwexsyrwetdylmynmesdetbetbeltuxtugmyrpel
syptermebsetdutdegtexsurfeltudnuxruxrenwytnubmed
lytdusnebrumtynseglyxpunresredfunrevrefmectedrus
bexlebduxrynnumpyxrygryxfeptyrtustyclegnemfermer
tenlusnussyltecmexpubrymtucfyllepdebbermughuttun
bylsudpemdevlurdefbusbeprunmelpexdytbyttyplevmyl
wedducfurfexnulluclennerlexrupnedlecrydlydfenwel
nydhusrelrudneshesfetdesretdunlernyrsebhulryllud
remlysfynwerrycsugnysnyllyndyndemluxfedsedbecmun
lyrtesmudnytbyrsenwegfyrmurtelreptegpecnelnevfes
"""
    .replaceAll("\n", "");

List<String> chunkString(String chars, int size) => partition(chars.codeUnits, size)
    .map((units) => units.map((u) => String.fromCharCode(u)).join(''))
    .toList();

final prefixes = chunkString(pre, 3);
final suffixes = chunkString(suf, 3);

// HELPERS

List<String> splitAt(int index, String str) => [
      str.substring(0, math.min(str.length, index)),
      str.length >= index ? str.substring(index) : ''
    ];

/// splits a patp string into chunks of 3
List<String> patp2syls(String name) => chunkString(name.replaceAll(RegExp(r'[\^~-]'), ''), 3);

/// raises 2^n
BigInt bex(BigInt n) => BigInt.two.pow(n.toInt());

/// divides c / 2^(2^a * b)
BigInt rsh(BigInt a, BigInt b, BigInt c) => c ~/ (bex(bex(a) * b));

/// no clue
BigInt met(BigInt a, BigInt b, BigInt c) =>
    b == BigInt.zero ? c : met(a, rsh(a, BigInt.one, b), c + BigInt.one);

/// ¯\\_(ツ)_/¯
BigInt end(BigInt a, BigInt b, BigInt c) => c % bex(bex(a) * b);

// API

enum Clan {
  Galaxy,
  Star,
  Planet,
  Moon,
  Comet,
}

Clan clan(BigInt point) {
  final wid = met(three, point, zero);
  return wid <= one
      ? Clan.Galaxy
      : wid == two ? Clan.Star : wid <= four ? Clan.Planet : wid <= eight ? Clan.Moon : Clan.Comet;
}

/// encode an integer as patp
String patp(BigInt n) {
  final sxz = fein(n);
  final dyy = met(four, sxz, BigInt.zero);
  final dyx = met(three, sxz, BigInt.zero);

  String loop(BigInt tsxz, BigInt timp, String trep) {
    final log = end(four, one, tsxz);
    final pre = prefixes[rsh(three, one, log).toInt()];
    final suf = suffixes[end(three, one, log).toInt()];
    final etc = timp % four == BigInt.zero ? timp == BigInt.zero ? '' : '--' : '-';

    final res = pre + suf + etc + trep;

    return timp == dyy ? trep : loop(rsh(four, one, tsxz), timp + one, res);
  }

  return '~' + (dyx <= one ? suffixes[sxz.toInt()] : loop(sxz, zero, ''));
}

/// decode a patp string to dec representation
BigInt patp2dec(String name) {
  // TODO: validity
  final syls = patp2syls(name);

  String syl2bin(int idx) => idx.toRadixString(2).padLeft(8, '0');

  var idx = 0;
  final addr = syls.fold(
    '',
    (acc, syl) => idx++ % 2 != 0 || syls.length == 1
        ? acc + syl2bin(suffixes.indexOf(syl))
        : acc + syl2bin(prefixes.indexOf(syl)),
  );

  return fynd(BigInt.parse(addr, radix: 2));
}

String patq(List<int> buf) {
  // NB(shrugs): if odd length, first chunk holds the extra syl
  final chunked = buf.length % 2 != 0 && buf.length > 1
      ? [
            [buf[0]]
          ] +
          partition(buf.sublist(1), 2).toList()
      : partition(buf, 2).toList();

  String prefixName(List<int> byts) =>
      byts.length == 1 ? prefixes[0] + suffixes[byts[0]] : prefixes[byts[0]] + suffixes[byts[1]];

  String name(List<int> byts) =>
      byts.length == 1 ? suffixes[byts[0]] : prefixes[byts[0]] + suffixes[byts[1]];

  String alg(List<int> pair) =>
      pair.length % 2 != 0 && chunked.length > 1 ? prefixName(pair) : name(pair);

  return chunked.fold('~', (acc, elem) => acc + (acc == '~' ? '' : '-') + alg(elem));
}

List<int> patq2buf(String name) {
  // NB(shrugs): dart-specific behavior
  if (name == '~') {
    return [];
  }

  final chunks = name.substring(1).split('-');

  String dec2hex(int dec) => dec.toRadixString(16).padLeft(2, '0');

  final splat = chunks.map((chunk) {
    final syls = splitAt(3, chunk);
    return syls[1] == ''
        ? dec2hex(suffixes.indexOf(syls[0]))
        : dec2hex(prefixes.indexOf(syls[0])) + dec2hex(suffixes.indexOf(syls[1]));
  });

  final hex = BigInt.parse(splat.join(''), radix: 16);

  // NB(shrugs): dart-specific behavior
  if (hex == BigInt.zero) {
    return [0];
  }

  return encodeBigInt(hex);
}
