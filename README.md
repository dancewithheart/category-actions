# category-actions

Many familiar functional programming abstractions
can be seen as actions of computation categories on type constructors.

Core idea:

```text
        f : A -> B
   A ---------------> B
   |                  |
 F |                  | F
   v                  v
 F[A] --- act(f) --> F[B]
```

with laws:
```haskell
act id        = id
act (g . f)   = act g . act f
```

| Abstraction   | Computation morphisms    |
|---------------|--------------------------|
| Functor       | `A -> B`                 |
| Contravariant | `B -> A`   (`Op`)        |
| Monad         | `A -> F B` (`Kleisli`)   |
| Comonad       | `F A -> B` (`CoKleisli`) |
| Filter        | `A -> Maybe B`           |

This can be encoded in Haskell as:

```haskell
class Category hom => Action hom f | f -> hom where
  act :: hom a b -> f a -> f b
```

## Examples:

* Action (->) f corresponds to Functor f
```haskell
instance Functor f => Action (->) f where
  act = fmap
```
* Action Op f corresponds to Contravariant f
```haskell
instance Contravariant f => Action Op f where
  act = contramap . getOp
```
* Action (Kleisli f) f corresponds to monadic composition
```haskell
instance Monad f => Action (Kleisli f) f where
  act (Kleisli f) fa = fa >>= f
```
* Action (Cokleisli f) f corresponds to comonadic composition
```haskell
instance Extract w => Action (Cokleisli w) w where
  act (Cokleisli f) = extend f
```

## Why this is interesting

The same law shape appears in several familiar abstractions:

fmap
contramap
flatMap
extend
mapFilter

This suggests that they can be understood uniformly as actions of different computation categories.

## Scope

This package focuses on the action layer.
It does not yet cover the monoidal structure behind Applicative, Monad, or Arrow.
Those belong to a next layer of the story.

## Status

This is an exploratory library accompanying a broader project:
* Haskell library
* Agda formalization
* paper draft: Notions of Computation as Category Actions
