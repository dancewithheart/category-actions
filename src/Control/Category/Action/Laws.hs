{-# LANGUAGE RankNTypes #-}

module Control.Category.Action.Laws
  ( Laws(..)
  , actionIdentity
  , actionComposition
  ) where

import Control.Category.Action.Core

data Laws hom = Laws
  { lawId      :: forall a. hom a a
  , lawCompose :: forall a b c. hom a b -> hom b c -> hom a c
  }

actionIdentity
  :: (Action hom f, Eq (f a))
  => Laws hom
  -> f a
  -> Bool
actionIdentity laws fa =
  act (lawId laws) fa == fa

actionComposition
  :: (Action hom f, Eq (f c))
  => Laws hom
  -> hom a b
  -> hom b c
  -> f a
  -> Bool
actionComposition laws f g fa =
  act g (act f fa) == act (lawCompose laws f g) fa
