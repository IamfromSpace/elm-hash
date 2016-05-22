#elm-hash

Enable Cryptographic hashing in elm.

##Example

```elm
import Hash exposing (..)
import Task exposing (..)

hashPassword : String -> String -> Task () String
hashPassword salt password = (salt ++ password)
  |> hash Utf8 Sha256 Hex
```
