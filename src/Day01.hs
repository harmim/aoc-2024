module Day01 (parse, partOne, partTwo) where

import Control.Arrow (right)
import Data.List (sort)
import Text.Parsec (ParseError, newline, sepEndBy1, string)
import Text.Parsec qualified (parse)
import Text.Parsec.String (Parser)
import Text.ParserCombinators.Parsec.Number (int)

type Input' = [(Int, Int)]

type Input = ([Int], [Int])

parser :: Parser Input'
parser = sepEndBy1 ((,) <$> int <* string "   " <*> int) newline

transformInput :: Input' -> Input
transformInput input = (map fst input, map snd input)

parse :: String -> Either ParseError Input
parse = right transformInput . Text.Parsec.parse parser ""

partOne :: Input -> String
partOne (l, r) =
  show $ sum $ map (\(a, b) -> abs (a - b)) $ zip (sort l) (sort r)

partTwo :: Input -> String
partTwo (l, r) = show $ sum $ map (\x -> x * (length $ filter (== x) r)) l
