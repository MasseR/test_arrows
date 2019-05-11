{-# LANGUAGE DeriveFunctor #-}
module Auto where


-- This is continuation from the auto.hs file
-- Instead of doing the comparison between Auto and Moore,
-- I'll try to write the necessary instances here

import Prelude hiding ((.), id)
import Control.Category
import Control.Arrow

data Auto a b = ACons { runAuto :: (a -> (b, Auto a b)) } deriving (Functor)

instance Category Auto where
  id = ACons $ \x -> (x, id)
  (ACons g) . (ACons f) = ACons $ \a ->
    let (b, abAuto) = f a
        (c, bcAuto) = g b
    in (c, bcAuto . abAuto)

instance Arrow Auto where
  arr f = ACons $ \b -> (f b, arr f)
  first auto = ACons $ \(b,d) ->
    let (c, bcAuto) = runAuto auto b
    in ((c, d), first bcAuto)

simulate :: Auto a b -> [a] -> ([b], Auto a b)
simulate auto [] = ([], auto)
simulate auto (x:xs) = (y:ys, final)
  where
       (y, next) = runAuto auto x
       (ys, final) = simulate next xs
