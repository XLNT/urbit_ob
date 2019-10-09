import 'dart:core';

import 'package:quiver/iterables.dart';
import 'package:logging/logging.dart';

import 'package:urbit_ob/src/helpers.dart';

final Logger _log = Logger('Ob');

final zero = BigInt.zero;
final one = BigInt.one;
final two = BigInt.two;
final three = BigInt.from(3);
final four = BigInt.from(4);

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
