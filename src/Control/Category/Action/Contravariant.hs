{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Control.Category.Action.Contravariant () where

import Data.Functor.Contravariant (Contravariant(..))
import Control.Category.Action.Core

instance Contravariant f => Action Op f where
  act = contramap . getOp
