{-# LANGUAGE LambdaCase #-}
import Data.Functor.Identity

-- This is based on the series from https://blog.jle.im/entry/intro-to-machines-arrows-part-1-stream-and.html

-- Streams

newtype Stream b = SCons (b, Stream b)

myStream :: Stream Integer
myStream = go 1
  where
    go :: Integer -> Stream Integer
    go n = SCons (n, go (n+1))

-- Isomorphic to cofree
data Cofree f a = a :< f (Cofree f a)
type CoStream b = Cofree Identity b

myCoStream :: CoStream Int
myCoStream = go 1
  where
    go n = n :< Identity (go (n+1))

-- See also
-- http://hackage.haskell.org/package/streams

data Moore a b = Moore b (a -> Moore a b)

myStreamMoore :: Moore a Int
myStreamMoore = go 1
  where
    go :: Int -> Moore a Int
    go n = Moore n (\_ -> go (n+1))

data Auto a b = ACons { runAuto :: (a -> (b, Auto a b)) }

-- Note the difference between those types

myStreamAuto :: Auto a Int
myStreamAuto = go 1
  where
    go :: Int -> Auto a Int
    go n = ACons (\x -> (n, go (n+1)))

-- Everything until now was trivial, just [1..] streams


-- But there is the other type parameter as well, let's use it
settableAuto :: Auto (Maybe Int) Int
settableAuto = go 1
  where
    go :: Int -> Auto (Maybe Int) Int
    go n = ACons $ \case
      Nothing -> (n, go (n+1))
      Just x -> (x, go (x+1))

-- This is where the difference lies.
-- See how the external state can affect the *current* state on the Auto version, but only the *next* version with the actual Moore type.
settableMoore :: Moore (Maybe Int) Int
settableMoore = go 1
  where
    go :: Int -> Moore (Maybe Int) Int
    go n = Moore n $ \case
      Nothing -> go (n+1)
      Just x -> go (x+1)

testAuto :: Auto a b -> [a] -> ([b], Auto a b)
testAuto auto [] = ([], auto)
testAuto auto (x:xs) = (y:ys, final)
  where
       (y, next) = runAuto auto x
       (ys, final) = testAuto next xs

main :: IO ()
main = undefined
