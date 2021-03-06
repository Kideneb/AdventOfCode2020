module Part2 where

import Data.List.Split
import Data.Char

import System.IO ()  
import Control.Monad ()

data Instruction = Jump {val :: Int}
        | Acc {val :: Int}
        | Nop {val :: Int} deriving (Eq)

instance Show Instruction where
        show (Jump val) = "jmp " ++ show val
        show (Acc val) = "acc " ++ show val
        show (Nop val) = "nop" ++ show val
        

main :: IO ()
main = do  
        contents <- readFile "in.txt"
        print   
                . part2
                . map parseInstruction
                . splitOn "\n" 
                . filter (/= '\r') $ init contents

part2 :: [Instruction] -> Int
part2 xs = findDuplicate xs [] 0 0

findDuplicate :: [Instruction] -> [Int] -> Int -> Int -> Int
findDuplicate instr visited acc pos
        | elem pos visited = acc
        | isJump instruction = findDuplicate instr newVisited acc (pos + val instruction)
        | isAcc instruction = findDuplicate instr newVisited (acc + val instruction) (pos + 1)
        | isNop instruction = findDuplicate instr newVisited acc (pos + 1)
        where
                instruction = instr!!pos
                newVisited = pos : visited

isJump :: Instruction -> Bool
isJump (Jump _) = True
isJump _ = False

isAcc :: Instruction -> Bool
isAcc (Acc _) = True
isAcc _ = False

isNop :: Instruction -> Bool
isNop (Nop _) = True
isNop _ = False 

parseInstruction :: String -> Instruction
parseInstruction str
        | x == "acc" = Acc (read val)
        | x == "jmp" = Jump (read val)
        | x == "nop" = Nop (read val)
        where 
                [x,y] = splitOn " " str 
                val = filter (/= '+') y