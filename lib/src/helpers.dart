import 'package:urbit_ob/src/muk.dart';

const ux_1_0000 = 0x10000;
const ux_ffff_ffff = 0xffffffff;
const ux_1_0000_0000 = 0x100000000;
const ux_ffff_ffff_ffff_ffff = 0xffffffffffffffff;
const ux_ffff_ffff_0000_0000 = 0xffffffff00000000;

const u_65535 = 65535;
const u_65536 = 65536;

int fen(int r, int a, int b, int Function(int, int) f, int m) {
  int loop(int j, int ell, int arr) {
    if (j < 1) {
      return a * arr + ell;
    } else {
      final eff = f(j - 1, ell);

      // NB (jtobin):
      //
      // Slight deviation from B&R (2002) here to prevent negative values.  We
      // add 'a' or 'b' to arr as appropriate and reduce 'eff' modulo the same
      // number before performing subtraction.
      //
      final tmp = j % 2 != 0 ? (arr + a - (eff % a)) % a : (arr + b - (eff % b)) % b;

      return loop(j - 1, tmp, ell);
    }
  }

  ;

  final ahh = r % 2 != 0 ? m ~/ a : m % a;
  final ale = r % 2 != 0 ? m % a : m ~/ a;
  final L = ale == a ? ahh : ale;
  final R = ale == a ? ale : ahh;

  return loop(r, L, R);
}

int Fen(int r, int a, int b, int k, int Function(int, int) f, int m) {
  final c = fen(r, a, b, f, m);
  return c < k ? c : fen(r, a, b, f, c);
}

int tail(int n) => Fen(4, u_65535, u_65536, ux_ffff_ffff, F, n);

int F(int j, int n) {
  const raku = [
    0xb76d5eed,
    0xee281300,
    0x85bcae01,
    0x4b387af7,
  ];

  return muk(raku[j], 2, n);
}

int fe(int r, int a, int b, int Function(int, int) f, int m) {
  int loop(int j, int ell, int arr) {
    if (j > r) {
      return r % 2 != 0 ? (a * arr + ell) : arr == a ? (a * arr + ell) : (a * ell + arr);
    } else {
      final eff = f(j - 1, arr);

      final tmp = j % 2 != 0 ? (ell + eff) % a : (ell + eff) % b;

      return loop(j + 1, arr, tmp);
    }
  }

  final L = m % a;
  final R = m ~/ a;

  return loop(1, L, R);
}

int Fe(int r, int a, int b, int k, int Function(int, int) f, int m) {
  final c = fe(r, a, b, f, m);
  return c < k ? c : fe(r, a, b, f, c);
}

int feis(int n) => Fe(4, u_65535, u_65536, ux_ffff_ffff, F, n);

int fein(int n) {
  int loop(int pyn) {
    final lo = n & ux_ffff_ffff;
    final hi = n & ux_ffff_ffff_0000_0000;

    return pyn >= ux_1_0000 && pyn <= ux_ffff_ffff
        ? ux_1_0000 + feis(pyn - ux_1_0000)
        : pyn >= ux_1_0000_0000 && pyn <= ux_ffff_ffff_ffff_ffff ? (hi | loop(lo)) : pyn;
  }

  ;

  return loop(n);
}

int fynd(int n) {
  int loop(int cry) {
    final lo = cry & ux_ffff_ffff;
    final hi = cry & ux_ffff_ffff_0000_0000;

    return cry >= ux_1_0000 && cry <= ux_ffff_ffff
        ? (ux_1_0000 + tail(cry - ux_1_0000))
        : cry >= ux_1_0000_0000 && cry <= ux_ffff_ffff_ffff_ffff ? (hi | loop(lo)) : cry;
  }

  return loop(n);
}
