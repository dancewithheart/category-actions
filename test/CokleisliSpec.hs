{-# LANGUAGE FlexibleInstances #-}

module CokleisliSpec (tests) where

import Prelude hiding (id, (.))
import Control.Category
import Test.QuickCheck

import Control.Category.Action.Core
import Control.Category.Action.Cokleisli
import Control.Category.Action.Laws

data Env e a = Env e a
  deriving (Eq, Show)

instance Functor (Env e) where
  fmap f (Env e a) = Env e (f a)

instance Extend (Env e) where
  extend f w@(Env e _) = Env e (f w)

instance Extract (Env e) where
  extract (Env _ a) = a

instance Arbitrary a => Arbitrary (Env String a) where
  arbitrary = Env <$> elements ["x", "y", "z"] <*> arbitrary

data EnvArrow
  = GetValue
  | AddEnvLength
  | NegateValue
  deriving (Eq, Show)

instance Arbitrary EnvArrow where
  arbitrary = elements [GetValue, AddEnvLength, NegateValue]

interpretEnvArrow :: EnvArrow -> Env String Int -> Int
interpretEnvArrow GetValue           (Env _ a) = a
interpretEnvArrow AddEnvLength       (Env e a) = a + length e
interpretEnvArrow NegateValue        (Env _ a) = negate a

tests :: IO ()
tests = do
  quickCheck prop_env_identity
  quickCheck prop_env_composition

envLaws :: Laws (Cokleisli (Env String))
envLaws = Laws
  { lawId = Cokleisli extract
  , lawCompose = \f g -> g . f
  }

prop_env_identity :: Env String Int -> Bool
prop_env_identity =
  actionIdentity envLaws

prop_env_composition
  :: Env String Int
  -> EnvArrow
  -> EnvArrow
  -> Bool
prop_env_composition fa f g =
  actionComposition
    envLaws
    (Cokleisli (interpretEnvArrow f))
    (Cokleisli (interpretEnvArrow g))
    fa
