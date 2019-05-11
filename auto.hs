import Data.Functor.Identity

-- This is based on the series from https://blog.jle.im/entry/intro-to-machines-arrows-part-1-stream-and.html

-- Streams

newtype Stream b = SCons (b, Stream b)

myStream :: Stream Integer
myStream = go 1
  where
    go n = SCons (n, go (n+1))

-- Isomorphic to cofree
data Cofree f a = a :< f (Cofree f a)
type CoStream b = Cofree Identity b

myCoStream :: CoStream Int
myCoStream = go 1
  where
    go n = n :< Identity (go (n+1))


main :: IO ()
main = undefined
