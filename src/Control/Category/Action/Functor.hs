{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Control.Category.Action.Functor () where

import Control.Category.Action.Core

instance Functor f => Action (->) f where
  act = fmap
