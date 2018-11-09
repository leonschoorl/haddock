{-# OPTIONS_GHC -fplugin GHC.TypeLits.KnownNat.Solver #-}
{-# LANGUAGE TypeOperators #-}

module UsingPlugins where

import GHC.TypeLits (Nat, KnownNat, type (+))

resize :: (KnownNat a, KnownNat b) => f a -> f b
resize = undefined

extend :: (KnownNat a, KnownNat b) => f a -> f (b + a)
extend = resize
