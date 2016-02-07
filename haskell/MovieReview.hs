import Control.Monad (liftM, ap)

data MovieReview = MovieReview {
      revTitle :: String
    , revUser :: String
    , revReview :: String
    }

review alist =
    MovieReview `liftM` lookup1 "title" alist
                   `ap` lookup1 "user" alist
                   `ap` lookup1 "review" alist

lookup1 key alist = case lookup key alist of
                        Just (Just s@(_:_)) -> Just s
                        _ -> Nothing
