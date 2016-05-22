module Hash exposing (hash, sha256, Algorithm(..), TextEncoding(..), OutputType(..))
{-| This library provides access to SHA hashing functions.

# Configuration Types
@docs TextEncoding, Algorithm, OutputType

# Hashing Methods
@docs hash, sha256

-}

import Native.Hash

{-| How to decode the string representation into bytes.  See [UTF-8](https://en.wikipedia.org/wiki/UTF-8), and [UTF-16](https://en.wikipedia.org/wiki/UTF-16).  If you don't know which one you want, you want UTF-8.
-}
type TextEncoding
  = Utf8
  | Utf16le
  | Utf16be

{-| The algorithm used to perform the hash.  See [SHA](https://en.wikipedia.org/wiki/Secure_Hash_Algorithm).  Note that SHA-1 is no longer considered cryptographically secure.
-}
type Algorithm
  = Sha1
  | Sha256
  | Sha384
  | Sha512

{-| How the hash should be represented as a string after encoding.
    hash UTF-8 SHA-1 Bin "message" == "01101111100110111001101011110011110011010..."
    hash UTF-8 SHA-1 Hex "message" == "6f9b9af3cd6e8b8a73c2cdced37fe9f59226e27d"
    hash UTF-8 SHA-1 Base64 "message" == "b5ua881ui4pzws3O03/p9ZIm4n0="
-}
type OutputType
  = Hex
  | Base64
  | Bin

{-| Generic hashing.  Takes a TextEncoding type, an Algorithm type, an OutputType type, and the string to encode.  This creates a task that can fail with a CryptoError or a String.

    hash Utf8 Sha256 Base64 "message" == "q1MKE+RZFJgrefm34/uplM/R8/si9xzqGvvwK0YMbR0="
-}
hash : TextEncoding -> Algorithm -> OutputType -> String -> Platform.Task never String
hash = Native.Hash.hash

{-| Create a SHA-256 hash from a string using typical defaults.

    sha256 "message" == "ab530a13e45914982b79f9b7e3fba994cfd1f3fb22f71cea1afbf02b460c6d1d"
-}
sha256 : String -> Platform.Task never String
sha256 message = hash Utf8 Sha256 Hex message
