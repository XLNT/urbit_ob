import 'package:test/test.dart';

import 'package:urbit_ob/urbit_ob.dart' as ob;

void main() {
  group('.clan', () {
    test('should itentify galaxy', () {
      expect(ob.clan(BigInt.from(0)), equals(ob.Clan.Galaxy));
    });

    test('should itentify star', () {
      expect(ob.clan(BigInt.two.pow(8)), equals(ob.Clan.Star));
    });

    test('should itentify planet', () {
      expect(ob.clan(BigInt.two.pow(16)), equals(ob.Clan.Planet));
    });

    test('should itentify moon', () {
      expect(ob.clan(BigInt.two.pow(32)), equals(ob.Clan.Moon));
    });

    test('should itentify comet', () {
      expect(ob.clan(BigInt.two.pow(64)), equals(ob.Clan.Comet));
    });
  });
}
