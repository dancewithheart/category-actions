module FunctorSpec (tests) where

import Prelude hiding (id, (.))
import Control.Category
import Test.QuickCheck

import Control.Category.Action.Core
import Control.Category.Action.Functor ()
import Control.Category.Action.Laws

tests :: IO ()
tests = do
  quickCheck prop_maybe_identity
  quickCheck prop_maybe_composition

functorLaws :: Laws (->)
functorLaws = Laws
  { lawId = id
  , lawCompose = \f g -> g . f
  }

prop_maybe_identity :: Maybe Int -> Bool
prop_maybe_identity =
  actionIdentity functorLaws

prop_maybe_composition :: Fun Int Int -> Fun Int Int -> Maybe Int -> Bool
prop_maybe_composition (Fun _ f) (Fun _ g) fa =
  actionComposition functorLaws f g fa
