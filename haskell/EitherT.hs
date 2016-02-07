import Control.Monad.Trans
import Control.Monad

newtype EitherT left m right = EitherT {
      runEitherT :: m (Either left right)
    }

prv `bindET` nxt =
    EitherT $ runEitherT prv >>= \e -> f e nxt
  where f (Right r) nxt = runEitherT (nxt r)
        f (Left err) _ = return (Left err)

returnET :: (Monad m) => right -> EitherT left m right
returnET = EitherT . return . Right

instance (Monad m) => Monad (EitherT left m) where
    return = returnET
    (>>=) = bindET

instance MonadTrans (EitherT left) where
    lift m = EitherT (Right `liftM` m)
