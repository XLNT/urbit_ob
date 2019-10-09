# urbit-ob, but in Dart

This is [urbit-ob](https://github.com/urbit/urbit-ob) but in dart, and only implementing the functions I care about:

- ob.patp(int)
- ob.patp2dec

TODO:

- remove wrapping class since these are pure functions
- ob.patq(Buffer)
- ob.patq2buffer

## Considerations

Since I'm using the built-in `int` type, this will break with:
1) large inputs
2) browser targets

The solution is probably to use the dart [BigInt](https://api.dartlang.org/stable/2.5.2/dart-core/BigInt-class.html) library. Welcoming PRs.

## Example

```dart
import 'package:urbit_ob/urbit_ob.dart'

final ob = Ob();

assert(ob.patp(19268096) == "~bosnyt-raddux");
assert(ob.patp2dec("~bosnyt-raddux") == 19268096);
```
