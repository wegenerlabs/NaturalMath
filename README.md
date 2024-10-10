# Natural Math

A simple but well-tested Swift package to solve math problems.

## How to use

Add this package dependency to your Xcode project: `https://github.com/wegenerlabs/NaturalMath.git`

Call the package like this:
```
import Natural Math

let result = NaturalMath("1+2").result
// returns a Result<Double, Error>, in this case .success(3)
```

## Supported operators and constants

```
+ - * / ^ sqrt abs sin cos tan arcsin arccos arctan pi ln log lb e
()
```

See [NaturalMathIntegrationsTests](https://github.com/wegenerlabs/NaturalMath/blob/main/Tests/NaturalMathTests/NaturalMathIntegrationsTests.swift) for example usage.

Trig functions use radians. log uses base 10. lb uses base 2.

Synonyms can be used for many operators (e.g. `:` for division). See [NaturalMathToken](https://github.com/wegenerlabs/NaturalMath/blob/main/Sources/NaturalMath/NaturalMathToken.swift).

## Ambiguous problems

`2^3^2 = 2^(3^2)`, not `(2^3)^2`
`6/3(2+1) = (6/3)(2+1)`, not `6/(3*(2+1))`
