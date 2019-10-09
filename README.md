# urbit-ob, but in Dart

This is [urbit-ob](https://github.com/urbit/urbit-ob) but in dart, and only implementing the functions I care about:

- ob.patp(int)
- ob.patp2dec

TODO:

- ob.patq(Buffer)
- ob.patq2buffer

## Example

```dart
import 'package:urbit_ob/urbit_ob.dart'

final ob = Ob();

assert(ob.patp(BigInt.from(19268096)) == "~bosnyt-raddux");
assert(ob.patp2dec("~bosnyt-raddux") == BigInt.from(19268096));
```
