{-# LANGUAGE FlexibleInstances #-}

module ContravariantSpec (tests) where

import Data.Functor.Contravariant (Contravariant(..))
import Prelude hiding (id, (.))
import Control.Category
import Test.QuickCheck

import Control.Category.Action.Core
import Control.Category.Action.Contravariant ()
import Control.Category.Action.Laws
import ActionLawHelpers

newtype Predicate a = Predicate { runPredicate :: a -> Bool }

instance Contravariant Predicate where
  contramap f (Predicate p) = Predicate (p . f)

instance Show (Predicate a) where
  show _ = "<predicate>"

instance Arbitrary (Predicate Int) where
  arbitrary = do
    Fun _ f <- arbitrary
    pure (Predicate f)

tests :: IO ()
tests = do
  quickCheck prop_predicate_identity
  quickCheck prop_predicate_composition

contravariantLaws :: Laws Op
contravariantLaws = Laws
  { lawId = Op id
  , lawCompose = \f g -> g . f
  }

prop_predicate_identity :: Predicate Int -> Bool
prop_predicate_identity p =
  eqOn [-5..5]
    (runPredicate (act (lawId contravariantLaws) p))
    (runPredicate p)

prop_predicate_composition :: Predicate Int -> Fun Int Int -> Fun Int Int -> Bool
prop_predicate_composition p (Fun _ f) (Fun _ g) =
  eqOn [-5..5]
    (runPredicate (act (Op g) (act (Op f) p)))
    (runPredicate (act (lawCompose contravariantLaws (Op f) (Op g)) p))
