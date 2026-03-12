module Main where

import qualified FunctorSpec
import qualified ContravariantSpec
import qualified KleisliSpec
import qualified CokleisliSpec

main :: IO ()
main = do
  putStrLn "\nFunctor"
  FunctorSpec.tests

  putStrLn "\nContravariant"
  ContravariantSpec.tests

  putStrLn "\nKleisli / FlatMap"
  KleisliSpec.tests

  putStrLn "\nCokleisli / CoFlatMap"
  CokleisliSpec.tests
