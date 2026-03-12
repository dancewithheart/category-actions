{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE InstanceSigs #-}

module Control.Category.Action.Kleisli () where

import Prelude hiding (id, (.))
import qualified Prelude
import Control.Category (Category(..))
import Control.Category.Action.Core

instance Monad f => Category (Kleisli f) where
  id :: Kleisli f a a
  id = Kleisli Prelude.return

  (.) :: Kleisli f b c -> Kleisli f a b -> Kleisli f a c
  Kleisli g . Kleisli f = Kleisli (\a -> f a >>= g)

instance Monad f => Action (Kleisli f) f where
  act :: Kleisli f a b -> f a -> f b
  act (Kleisli f) fa = fa >>= f
