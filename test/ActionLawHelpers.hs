module ActionLawHelpers
  ( eqOn
  ) where

eqOn :: Eq b => [a] -> (a -> b) -> (a -> b) -> Bool
eqOn xs f g = all (\x -> f x == g x) xs
