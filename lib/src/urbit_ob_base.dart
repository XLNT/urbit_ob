import 'package:quiver/iterables.dart';
import 'package:logging/logging.dart';
import 'dart:math' as math;

import 'package:urbit_ob/src/helpers.dart';

final Logger _log = Logger('Ob');

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
int bex(int n) => math.pow(2, n);

/// divides c / 2^(2^a * b)
int rsh(int a, int b, int c) => c ~/ (bex(bex(a) * b));

/// no clue
int met(int a, int b, [int c = 0]) => b == 0 ? c : met(a, rsh(a, 1, b), c + 1);

/// ¯\\_(ツ)_/¯
int end(int a, int b, int c) => c % bex(bex(a) * b);

// API

/// encode an integer as patp
String patp(int n) {
  final sxz = fein(n);
  final dyy = met(4, sxz);
  final dyx = met(3, sxz);

  String loop(int tsxz, int timp, String trep) {
    final log = end(4, 1, tsxz);
    final pre = prefixes[rsh(3, 1, log)];
    final suf = suffixes[end(3, 1, log)];
    final etc = timp % 4 == 0 ? timp == 0 ? '' : '--' : '-';

    final res = pre + suf + etc + trep;

    return timp == dyy ? trep : loop(rsh(4, 1, tsxz), timp + 1, res);
  }

  return '~' + (dyx <= 1 ? suffixes[sxz] : loop(sxz, 0, ''));
}

/// decode a patp string to dec representation
int patp2dec(String name) {
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

  return fynd(int.parse(addr, radix: 2));
}
