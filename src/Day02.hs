module Day02 (parse, partOne, partTwo) where

import Text.Parsec (ParseError, newline, sepBy1, sepEndBy1, string)
import Text.Parsec qualified (parse)
import Text.Parsec.String (Parser)
import Text.ParserCombinators.Parsec.Number (int)

type Input = [[Int]]

parser :: Parser Input
parser = sepEndBy1 (sepBy1 int (string " ")) newline

parse :: String -> Either ParseError Input
parse = Text.Parsec.parse parser ""

isIncreasing :: [Int] -> Bool
isIncreasing =
  snd
    . foldr
      ( \next (prev, ok) ->
          if ok && isOk next prev then (next, True) else (prev, False)
      )
      (minBound, True)
  where
    isOk next prev = next > prev && (prev == minBound || isGoodDiff next prev)
    isGoodDiff a b = d >= 1 && d <= 3
      where
        d = abs $ a - b

removeEach :: [a] -> [[a]]
removeEach x = [take i x ++ drop (i + 1) x | i <- [0 .. (length x) - 1]]

partOne :: Input -> String
partOne =
  show
    . length
    . filter (\report -> isIncreasing report || isIncreasing (reverse report))

partTwo :: Input -> String
partTwo =
  show
    . length
    . filter
      ( \report ->
          any
            ( \report' ->
                isIncreasing report' || isIncreasing (reverse report')
            )
            $ removeEach report
      )
