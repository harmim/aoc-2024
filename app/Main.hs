{-# LANGUAGE RecordWildCards #-}

module Main (main) where

import Control.Monad.IO.Class qualified (liftIO)
import Control.Monad.Reader qualified (ReaderT, ask, runReaderT)
import Data.Time.Clock qualified (diffUTCTime, getCurrentTime)
import Day01 qualified
import Day02 qualified
import Day03 qualified
-- import Day04 qualified
-- import Day05 qualified
-- import Day06 qualified
-- import Day07 qualified
-- import Day08 qualified
-- import Day09 qualified
-- import Day10 qualified
-- import Day11 qualified
-- import Day12 qualified
-- import Day13 qualified
-- import Day14 qualified
-- import Day15 qualified
-- import Day16 qualified
-- import Day17 qualified
-- import Day18 qualified
-- import Day19 qualified
-- import Day20 qualified
-- import Day21 qualified
-- import Day22 qualified
-- import Day23 qualified
-- import Day24 qualified
-- import Day25 qualified
import System.Directory qualified (doesFileExist)
import System.Environment qualified (getArgs)
import System.Exit qualified (exitFailure)
import System.IO qualified (hPutStrLn, stderr)

data Config = Config
  { day :: Int,
    test :: Bool
  }

type App = Control.Monad.Reader.ReaderT Config IO

die :: String -> IO a
die msg = System.IO.hPutStrLn System.IO.stderr msg >> System.Exit.exitFailure

data Solver = forall a. Solver
  { parse :: String -> a,
    partOne :: a -> String,
    partTwo :: a -> String
  }

solverMap :: [(Int, Solver)]
solverMap =
  [ (1, Solver Day01.parse Day01.partOne Day01.partTwo),
    (2, Solver Day02.parse Day02.partOne Day02.partTwo),
    (3, Solver Day03.parse Day03.partOne Day03.partTwo)
    -- (4, Solver Day04.parse Day04.partOne Day04.partTwo)
    -- (5, Solver Day05.parse Day05.partOne Day05.partTwo)
    -- (6, Solver Day06.parse Day06.partOne Day06.partTwo)
    -- (7, Solver Day07.parse Day07.partOne Day07.partTwo)
    -- (8, Solver Day08.parse Day08.partOne Day08.partTwo)
    -- (9, Solver Day09.parse Day09.partOne Day09.partTwo)
    -- (10, Solver Day10.parse Day10.partOne Day10.partTwo)
    -- (11, Solver Day11.parse Day11.partOne Day11.partTwo)
    -- (12, Solver Day12.parse Day12.partOne Day12.partTwo)
    -- (13, Solver Day13.parse Day13.partOne Day13.partTwo)
    -- (14, Solver Day14.parse Day14.partOne Day14.partTwo)
    -- (15, Solver Day15.parse Day15.partOne Day15.partTwo)
    -- (16, Solver Day16.parse Day16.partOne Day16.partTwo)
    -- (17, Solver Day17.parse Day17.partOne Day17.partTwo)
    -- (18, Solver Day18.parse Day18.partOne Day18.partTwo)
    -- (19, Solver Day19.parse Day19.partOne Day19.partTwo)
    -- (20, Solver Day20.parse Day20.partOne Day20.partTwo)
    -- (21, Solver Day21.parse Day21.partOne Day21.partTwo)
    -- (22, Solver Day22.parse Day22.partOne Day22.partTwo)
    -- (23, Solver Day23.parse Day23.partOne Day23.partTwo)
    -- (24, Solver Day24.parse Day24.partOne Day24.partTwo)
    -- (25, Solver Day25.parse Day25.partOne Day25.partTwo)
  ]

getDaySolver :: Int -> Either String Solver
getDaySolver day = case lookup day solverMap of
  Just solver -> Right solver
  Nothing ->
    Left $
      "Day " ++ show day ++ " has not been solved yet, or it is invalid."

loadInput :: App (Either String String)
loadInput = do
  Config {day, test} <- Control.Monad.Reader.ask

  let dir = if test then "input-test/" else "input/"
  let file = dir ++ (if day < 10 then "0" else "") ++ show day ++ ".txt"

  Control.Monad.IO.Class.liftIO $ do
    fileExists <- System.Directory.doesFileExist file
    if fileExists
      then Right <$> readFile file
      else
        return $
          Left $
            "Failed to access input data for day " ++ show day ++ "."

printResults :: String -> Double -> String -> Double -> IO ()
printResults partOneRes partOneTime partTwoRes partTwoTime = do
  putStrLn $ "Part 1: " ++ partOneRes ++ " (" ++ show partOneTime ++ " seconds)"
  putStrLn $ "Part 2: " ++ partTwoRes ++ " (" ++ show partTwoTime ++ " seconds)"

measureTime :: a -> IO (a, Double)
measureTime part = do
  start <- Data.Time.Clock.getCurrentTime
  let result = part
  end <- Data.Time.Clock.getCurrentTime

  return (result, realToFrac $ Data.Time.Clock.diffUTCTime end start)

parseArgs :: [String] -> IO Config
parseArgs args = case args of
  [] -> die "Must provide a day to solve."
  (dayArg : testArg) -> case reads dayArg of
    [(day, "")] -> return $ Config day (testArg == ["test"])
    _ -> die $ "The provided day ('" ++ dayArg ++ "') is not a valid integer."

runApp :: App ()
runApp = do
  Config {day, test} <- Control.Monad.Reader.ask

  inputResult <- loadInput
  case inputResult of
    Left err -> Control.Monad.IO.Class.liftIO $ die err
    Right input -> case getDaySolver day of
      Left err -> Control.Monad.IO.Class.liftIO $ die err
      Right Solver {..} -> Control.Monad.IO.Class.liftIO $ do
        putStrLn $
          "Solving day "
            ++ show day
            ++ "..."
            ++ (if test then "\nUsing a test input file..." else "")

        let parsedInput = parse input
        (partOneRes, partOneTime) <- measureTime $ partOne parsedInput
        (partTwoRes, partTwoTime) <- measureTime $ partTwo parsedInput

        printResults partOneRes partOneTime partTwoRes partTwoTime

main :: IO ()
main =
  Control.Monad.Reader.runReaderT runApp
    =<< parseArgs
    =<< System.Environment.getArgs
