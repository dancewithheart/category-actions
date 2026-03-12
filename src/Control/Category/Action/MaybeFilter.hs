{-# LANGUAGE InstanceSigs #-}

module Control.Category.Action.MaybeFilter
  ( MaybeKleisli(..)
  ) where

import Prelude hiding (id, (.))
import Control.Category (Category(..))

newtype MaybeKleisli a b = MaybeKleisli
  { runMaybeKleisli :: a -> Maybe b
  }

instance Category MaybeKleisli where
  id :: MaybeKleisli a a
  id = MaybeKleisli Just

  (.) :: MaybeKleisli b c -> MaybeKleisli a b -> MaybeKleisli a c
  MaybeKleisli g . MaybeKleisli f =
    MaybeKleisli (\a -> f a >>= g)
