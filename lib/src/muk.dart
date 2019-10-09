const ux_FF = 0xFF;
const ux_FF00 = 0xFF00;
const u_256 = 256;

int muk(int syd, int len, int key) {
  final lo = key & ux_FF;
  final hi = (key & ux_FF00) ~/ u_256;
  final kee = String.fromCharCode(lo) + String.fromCharCode(hi);

  return murmurhash3_32_gc(kee, syd);
}

int zfbs_32(int n, int s) => (n & 0xFFFFFFFF) >> s;

int murmurhash3_32_gc(String k, int seed) {
  final key = k.codeUnits;
  var h1b, k1;

  final remainder = key.length & 3; // key.length % 4
  final bytes = key.length - remainder;
  var h1 = seed;
  var c1 = 0xcc9e2d51;
  var c2 = 0x1b873593;
  var i = 0;

  while (i < bytes) {
    k1 = ((key[i] & 0xff)) |
        ((key[++i] & 0xff) << 8) |
        ((key[++i] & 0xff) << 16) |
        ((key[++i] & 0xff) << 24);
    ++i;

    k1 = ((((k1 & 0xffff) * c1) + ((((zfbs_32(k1, 16)) * c1) & 0xffff) << 16))) & 0xffffffff;
    k1 = (k1 << 15) | (zfbs_32(k1, 17));
    k1 = ((((k1 & 0xffff) * c2) + ((((zfbs_32(k1, 16)) * c2) & 0xffff) << 16))) & 0xffffffff;

    h1 ^= k1;
    h1 = (h1 << 13) | (zfbs_32(h1, 19));
    h1b = ((((h1 & 0xffff) * 5) + ((((zfbs_32(h1, 16)) * 5) & 0xffff) << 16))) & 0xffffffff;
    h1 = (((h1b & 0xffff) + 0x6b64) + ((((zfbs_32(h1b, 16)) + 0xe654) & 0xffff) << 16));
  }

  k1 = 0;

  if (remainder == 3) {
    k1 ^= (key[i + 2] & 0xff) << 16;
  }

  if (remainder == 3 || remainder == 2) {
    k1 ^= (key[i + 1] & 0xff) << 8;
  }

  if (remainder == 3 || remainder == 2 || remainder == 1) {
    k1 ^= (key[i] & 0xff);
  }

  k1 = (((k1 & 0xffff) * c1) + ((((zfbs_32(k1, 16)) * c1) & 0xffff) << 16)) & 0xffffffff;
  k1 = (k1 << 15) | (zfbs_32(k1, 17));
  k1 = (((k1 & 0xffff) * c2) + ((((zfbs_32(k1, 16)) * c2) & 0xffff) << 16)) & 0xffffffff;
  h1 ^= k1;

  h1 ^= key.length;

  h1 ^= zfbs_32(h1, 16);
  h1 = (((h1 & 0xffff) * 0x85ebca6b) + ((((zfbs_32(h1, 16)) * 0x85ebca6b) & 0xffff) << 16)) &
      0xffffffff;
  h1 ^= zfbs_32(h1, 13);
  h1 = ((((h1 & 0xffff) * 0xc2b2ae35) + ((((zfbs_32(h1, 16)) * 0xc2b2ae35) & 0xffff) << 16))) &
      0xffffffff;
  h1 ^= zfbs_32(h1, 16);

  return zfbs_32(h1, 0);
}
