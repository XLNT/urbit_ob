# urbit-ob, but in Dart

This is [urbit-ob](https://github.com/urbit/urbit-ob) but in dart, and only implementing the functions I care about:

- ob.patp(int)
- ob.patp2dec

TODO:

- ob.patq(Buffer)
- ob.patq2buffer

## Example

```dart
import 'package:urbit_ob/urbit_ob.dart' as ob;

final point = BigInt.from(19268096);
final name = "~bosnyt-raddux";

assert(ob.patp(point) == name);
assert(ob.patp2dec(name) == point);
```

## Tests

```bash
pub run test
```
