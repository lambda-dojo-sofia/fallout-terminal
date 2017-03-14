import System.Random
import Text.Read

dict :: IO [String]
dict = do
    text <- readFile "dictionary.txt"
    return $ words text

wordsByLength :: Int -> [[a]] -> [[a]]
wordsByLength l xs = filter (\x -> length x == l) xs

selectWords :: Int -> [String] -> IO [String]
selectWords n ws = do
    gen <- newStdGen
    return $ map (\i -> ws !! i) $ take n $ randomRs (0, (length ws) - 1) gen

printWords :: [String] -> IO ()
printWords [] = return ()
printWords (w:ws) = do
    putStrLn $ (show $ length ws) ++ " " ++ w
    printWords ws

startGame = do
    gen <- newStdGen

    let wordCount = 12
    let wordLength = 8

    lengthWords <- fmap (wordsByLength wordLength) dict
    words <- selectWords wordCount lengthWords
    [secret] <- selectWords 1 words

    game words secret

readIndex :: Int -> Int -> IO (Either String Int)
readIndex lowerLimit upperLimit = do
  putStr "YOUR ANSWER >> "
  maybeIdx <- fmap (readMaybe) getLine :: IO (Maybe Int)
  case maybeIdx of
    Nothing -> return $ Left "Invalid number"
    Just idx -> if isIndexWithinRange lowerLimit upperLimit idx then
        return $ Right idx
      else
        return $ Left ( "Number should be between " ++ (show lowerLimit) ++ " and " ++ (show upperLimit) )

isIndexWithinRange :: Int -> Int -> Int -> Bool
isIndexWithinRange lowerLimit upperLimit idx = idx >= lowerLimit && idx <= upperLimit

game words secret = do
    printWords words
    eitherIdx <- readIndex 0 ((length words) - 1)
    case eitherIdx of
      Left errorMessage -> print errorMessage >> game words secret
      Right idx -> do
        let selection = words !! (((length words) - idx) - 1)
        print selection
        if selection == secret then
          won
        else report secret selection >> game words secret

won = do
    putStrLn "Love u"

report secret selection = do
    let ms = matches secret selection
    putStrLn $ "Same letters: " ++ (show ms)
    putStrLn ""

matches as bs = matches' as bs 0

matches' [] _ count = count
matches' _ [] count = count
matches' (a:as) (b:bs) count =
    matches' as bs (count + add) where
        add = if a == b then 1 else 0
