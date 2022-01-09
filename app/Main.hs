-- The module can choose functions/types to export by placing them and their constructors in the module statement.
module Main (main) where

-- We also choose what to import with lists in parentheses.
import Move
import Calc
import Data.List.Split (splitOn)
-- import System.Environment   -- for getArgs
-- import Debug.Trace

-- read and show are for String -> a and a -> String
-- so for case statements haskell considers indentation of _, so don't space it out of line with the other cases.
parseMove :: String -> Move
parseMove m = 
    let (mc : num) = m
     in case mc of
          'a' -> Add (read num) 
          's' -> Sub (read num) 
          'm' -> Mul (read num) 
          'd' -> Div (read num) 
          'e' -> Exp (read num) 
          'f' -> Flip
          '+' -> Sum
          'r' -> Rev
          'b' -> Back
          '|' -> Mirror
          'c' -> Concat num
          'h' -> case (head num) of
                   'l' -> Shift L
                   'r' -> Shift R
                   _   -> undefined
          't' -> let args = splitOn ">" num 
                  in Trans (head args) (head $ tail args)
          _   -> undefined

parseMoves :: String -> [Move]
parseMoves mstr = map parseMove $ splitOn "," mstr

readInt :: IO Int
readInt = readLn

-- = vs. <-: https://stackoverflow.com/a/28625714/13553596
-- also, use trace to print debug statements (not print)
-- also, use putStrLn to print Strings, or you'll get double quotes (from show)
-- also, use getLine and getChar to read Strings and Chars, so you don't need quotes.
main :: IO ()
main = do
    putStrLn "Enter starting number:"
    start <- readInt
    putStrLn "Enter goal number:"
    goal <- readInt
    putStrLn "Enter number of moves:"
    depth <- readInt
    putStrLn "Enter movelist.  See Main.hs for move list specification."
    moves <- getLine
    let problem = Calc {start = start, goal = goal, depth = depth, moves = parseMoves moves}
     in print (solve problem)
    putStrLn "Do you want to continue? (y/n)"
    continue <- getChar
    if continue == 'y' || continue == '\n'
       then main
       else pure ()     -- 'pure' is a Monad function that wraps its argument in the proper monad. aka 'return'.

-- debugging: https://www.reddit.com/r/haskell/comments/oqb1g/using_print_statements_in_code_for_debugging/

{- NOTES 
So, we know that the order that the moves are given in matters slightly.  We also know that we need a heuristic for choosing the order of moves in doMoves.
How do we solve these two problems?  That is, how can we evaluate how useful a move is?
Perhaps in move simplicity?  For example, the entropy of flipping the sign of a number is just 1 bit.  You flip it once, and flipping it twice is useless.
Backspace has a little more entropy, but less than concat because it can't occur twice.
Frankly looks like a hard problem, but who knows, maybe some emergent behavior will arise.  Machine learning application??

-Honestly seems like a heuristic for this is as hard as solving the Collatz conjecture.

-Actually, there may yet be a heuristic.  For example, fail-fast is possible - moves such as Mirror are bound to fail-fast, and Trans is sometimes impossible.

-}
