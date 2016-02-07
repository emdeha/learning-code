fun :: Int -> String
fun n = (`runCont` id) $ do
        str <- callCC $ \exit1 -> do
            when (n < 10) (exit1 (show n))
            let ns = map digitToInt (show (n `div` 2))
            n' <- callCC $ \exit2 -> do
                when ((length ns) < 3) (exit2 (length ns))
                when ((length ns) < 5) (exit2 n)
                when ((length ns) < 7) $ do let ns' = map intToDigit (reverse ns)
                                            exit1 (dropWhile (=='0') ns')
                return $ sum ns
            return $ "(ns = " ++ (show ns) ++ ") " ++ (show n')
        return $ "Answer: " ++ str
