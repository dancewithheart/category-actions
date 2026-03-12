{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE InstanceSigs #-}

module Control.Category.Action.Cokleisli
  ( Extend(..)
  , Extract(..)
  ) where

import Prelude hiding (id, (.))
import qualified Prelude
import Control.Category (Category(..))
import Control.Category.Action.Core

class Functor w => Extend w where
  extend :: (w a -> b) -> w a -> w b

class Extend w => Extract w where
  extract :: w a -> a

instance Extract w => Category (Cokleisli w) where
  id :: Cokleisli w a a
  id = Cokleisli extract

  (.) :: Cokleisli w b c -> Cokleisli w a b -> Cokleisli w a c
  Cokleisli g . Cokleisli f = Cokleisli (g Prelude.. extend f)

instance Extract w => Action (Cokleisli w) w where
  act :: Cokleisli w a b -> w a -> w b
  act (Cokleisli f) = extend f

