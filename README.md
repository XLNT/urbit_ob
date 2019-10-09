# urbit-ob, but in Dart

This is [urbit-ob](https://github.com/urbit/urbit-ob) but in dart, and only implementing the functions I care about:

- ob.patp(int)
- ob.patp2dec

TODO:

- ob.patq(Buffer)
- ob.patq2buffer

## Considerations

Since I'm using the built-in `int` type, this will break with:
1) large inputs
2) browser targets

The solution is probably to use the dart [BigInt](https://api.dartlang.org/stable/2.5.2/dart-core/BigInt-class.html) library. Welcoming PRs.
