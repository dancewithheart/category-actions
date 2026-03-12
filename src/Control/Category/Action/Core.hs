{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE InstanceSigs #-}

module Control.Category.Action.Core
  ( Action(..)
  , Op(..)
  , Kleisli(..)
  , Cokleisli(..)
  ) where

import Prelude hiding (id, (.))
import qualified Prelude
import Control.Category (Category(..))

class Category hom => Action hom f | f -> hom where
  act :: hom a b -> f a -> f b

newtype Op a b = Op { getOp :: b -> a }

instance Category Op where
  id :: Op a a
  id = Op Prelude.id

  (.) :: Op b c -> Op a b -> Op a c
  Op g . Op f = Op (f Prelude.. g)

newtype Kleisli f a b = Kleisli
  { runKleisli :: a -> f b
  }

newtype Cokleisli f a b = Cokleisli
  { runCokleisli :: f a -> b
  }
