import Html.App exposing (program)
import Html exposing (..)
import Html.Events exposing (..)
import Task
import Hash

type alias Model = List (String, Status)

init : (Model, Cmd Msg)
init = ([], Task.perform (\_ -> NoOp) identity (Task.succeed Run)) 

runTests : Cmd Msg
runTests = Cmd.batch tests

tests : List (Cmd Msg)
tests =
  [ succeedWith "Should Hash UTF-8 SHA-256 to Hex"
    (Hash.hash Hash.Utf8 Hash.Sha256 Hash.Hex "message")
    "ab530a13e45914982b79f9b7e3fba994cfd1f3fb22f71cea1afbf02b460c6d1d"
  , succeedWith "Should hash UTF-8 SHA-256 to Base64"
    (Hash.hash Hash.Utf8 Hash.Sha256 Hash.Base64 "message")
    "q1MKE+RZFJgrefm34/uplM/R8/si9xzqGvvwK0YMbR0="
  , succeedWith "Should Hash UTF-8 SHA-256 to Bin"
    (Hash.hash Hash.Utf8 Hash.Sha256 Hash.Bin "message")
    "1010101101010011000010100001001111100100010110010001010010011000001010110111100111111001101101111110001111111011101010011001010011001111110100011111001111111011001000101111011100011100111010100001101011111011111100000010101101000110000011000110110100011101"
  , succeedWith "Should Hash UTF-8 SHA-1 to Hex"
    (Hash.hash Hash.Utf8 Hash.Sha1 Hash.Hex "message")
    "6f9b9af3cd6e8b8a73c2cdced37fe9f59226e27d"
  , succeedWith "Should hash UTF-8 SHA-1 to Base64"
    (Hash.hash Hash.Utf8 Hash.Sha1 Hash.Base64 "message")
    "b5ua881ui4pzws3O03/p9ZIm4n0="
  , succeedWith "Should Hash UTF-8 SHA-1 to Bin"
    (Hash.hash Hash.Utf8 Hash.Sha1 Hash.Bin "message")
    "0110111110011011100110101111001111001101011011101000101110001010011100111100001011001101110011101101001101111111111010011111010110010010001001101110001001111101"
  , succeedWith "Should Hash UTF-8 SHA-384 to Hex"
    (Hash.hash Hash.Utf8 Hash.Sha384 Hash.Hex "message")
    "353eb7516a27ef92e96d1a319712d84b902eaa828819e53a8b09af7028103a9978ba8feb6161e33c3619c5da4c4666a5"
  , succeedWith "Should hash UTF-8 SHA-384 to Base64"
    (Hash.hash Hash.Utf8 Hash.Sha384 Hash.Base64 "message")
    "NT63UWon75LpbRoxlxLYS5AuqoKIGeU6iwmvcCgQOpl4uo/rYWHjPDYZxdpMRmal"
  , succeedWith "Should Hash UTF-8 SHA-384 to Bin"
    (Hash.hash Hash.Utf8 Hash.Sha384 Hash.Bin "message")
    "001101010011111010110111010100010110101000100111111011111001001011101001011011010001101000110001100101110001001011011000010010111001000000101110101010101000001010001000000110011110010100111010100010110000100110101111011100000010100000010000001110101001100101111000101110101000111111101011011000010110000111100011001111000011011000011001110001011101101001001100010001100110011010100101"
  , succeedWith "Should Hash UTF-8 SHA-512 to Hex"
    (Hash.hash Hash.Utf8 Hash.Sha512 Hash.Hex "message")
    "f8daf57a3347cc4d6b9d575b31fe6077e2cb487f60a96233c08cb479dbf31538cc915ec6d48bdbaa96ddc1a16db4f4f96f37276cfcb3510b8246241770d5952c"
  , succeedWith "Should hash UTF-8 SHA-512 to Base64"
    (Hash.hash Hash.Utf8 Hash.Sha512 Hash.Base64 "message")
    "+Nr1ejNHzE1rnVdbMf5gd+LLSH9gqWIzwIy0edvzFTjMkV7G1IvbqpbdwaFttPT5bzcnbPyzUQuCRiQXcNWVLA=="
  , succeedWith "Should Hash UTF-8 SHA-512 to Bin"
    (Hash.hash Hash.Utf8 Hash.Sha512 Hash.Bin "message")
    "11111000110110101111010101111010001100110100011111001100010011010110101110011101010101110101101100110001111111100110000001110111111000101100101101001000011111110110000010101001011000100011001111000000100011001011010001111001110110111111001100010101001110001100110010010001010111101100011011010100100010111101101110101010100101101101110111000001101000010110110110110100111101001111100101101111001101110010011101101100111111001011001101010001000010111000001001000110001001000001011101110000110101011001010100101100"
  ]

type Status
  = Running
  | Passed
  | Failed

type Msg
  = NoOp
  | Run
  | Pass String
  | Fail String

succeedWith : String -> Task.Task x a -> a -> Cmd Msg
succeedWith name task with = Task.perform
  (\_ -> Fail name)
  (\a -> if a == with then (Pass name) else (Fail name))
  task

failWith : String -> Task.Task a x -> a -> Cmd Msg
failWith name task with = Task.perform
  (\a -> if a == with then (Pass name) else (Fail name))
  (\_ -> Fail name)
  task

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)
    Run -> (model, runTests)
    Pass id -> ((id, Passed) :: model, Cmd.none)
    Fail id -> ((id, Failed) :: model , Cmd.none)

view : Model -> Html Msg
view model = div []
  <| List.map (\b -> pre [] [text <| 
    (case (snd b) of
      Running -> "Running"
      Passed -> "PASS"
      Failed -> "FAIL"
    ) ++ " " ++ (fst b)]) model

main = program
  { init = init
  , update = update
  , view = view
  , subscriptions = \_ -> Sub.none
  }
