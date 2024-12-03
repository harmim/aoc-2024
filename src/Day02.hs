module Day02 (parse, partOne, partTwo) where

import Text.Parsec (ParseError, anyChar, many1, newline, sepEndBy1)
import Text.Parsec qualified (parse)
import Text.Parsec.String (Parser)

type Input = [String]

parser :: Parser Input
parser = sepEndBy1 (many1 anyChar) newline

parse :: String -> Either ParseError Input
parse = Text.Parsec.parse parser ""

partOne :: Input -> String
partOne _ = ""

partTwo :: Input -> String
partTwo _ = ""
