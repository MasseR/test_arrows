import Auto
import Control.Arrow
import Prelude hiding ((.))
import Control.Category ((.))

stream :: Auto a Int
stream = go 1
  where
    go :: Int -> Auto a Int
    go n = ACons $ \_ -> (n, go (n+1))

resettingStream :: Auto Int Int
resettingStream = arr (\x -> if x > 2 then 0 else x)

-- Almost like functor, but it's using the a `Auto` b
toAuto :: (a -> b) -> Auto a b
toAuto f = ACons $ \x -> (f x, toAuto f)

doubleA :: Num a => Auto a a
doubleA = toAuto (*2)

succA :: Enum a => Auto a a
succA = toAuto succ

summer :: Num a => Auto a a
summer = go 0
  where
    go acc = ACons $ \n -> let x = acc + n in (x, go x)

main :: IO ()
main = do
  print $ fst $ simulate stream [1..5 :: Int]
  print $ fst $ simulate (stream >>> resettingStream) [0,0,0,0,0 :: Int]
  print $ fst $ simulate doubleA [1..5 :: Int]
  print $ fst $ simulate succA [1..5 :: Int]
  print $ fst $ simulate (succA . doubleA) [1..5 :: Int]
  print $ fst $ simulate summer [1..5 :: Int]
  print $ fst $ simulate (succA . summer) [1..5 :: Int]
