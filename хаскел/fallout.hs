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

game words secret = do
    printWords words
    putStr "YOUR ANSWER >> "

    idxStr <- getLine
    let maybeIdx = readMaybe idxStr :: Maybe Int

    case maybeIdx of
        Nothing -> game words secret
        Just idx -> do
            if idx < 0 || idx >= (length words) then
                game words secret
            else do
                let selection = words !! ((length words) - idx - 1)

                if selection == secret then
                    won
                else do
                    report secret selection
                    game words secret

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
