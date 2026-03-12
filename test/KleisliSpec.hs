module KleisliSpec (tests) where

import Prelude hiding (id, (.))
import Control.Category

import Test.QuickCheck
import Control.Category.Action.Core
import Control.Category.Action.Kleisli ()
import Control.Category.Action.Laws

tests :: IO ()
tests = do
  quickCheck prop_maybe_kleisli_identity
  quickCheck prop_maybe_kleisli_composition

kleisliMaybeLaws :: Laws (Kleisli Maybe)
kleisliMaybeLaws = Laws
  { lawId = Kleisli Just
  , lawCompose = \f g -> g Control.Category.. f
  }

prop_maybe_kleisli_identity :: Maybe Int -> Bool
prop_maybe_kleisli_identity =
  actionIdentity kleisliMaybeLaws

prop_maybe_kleisli_composition
  :: Maybe Int
  -> Fun Int (Maybe Int)
  -> Fun Int (Maybe Int)
  -> Bool
prop_maybe_kleisli_composition fa (Fun _ f) (Fun _ g) =
  actionComposition kleisliMaybeLaws (Kleisli f) (Kleisli g) fa
