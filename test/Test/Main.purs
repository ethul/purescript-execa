module Test.Main (main) where

import Prelude (Unit, (<<<), (<>))

import Control.Monad.Aff (runAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (message)
import Control.Monad.Eff.Console (CONSOLE, log)

import Data.Options (Options, (:=))
import Data.Monoid (mempty)

import Node.Execa

main :: forall eff. Eff (console :: CONSOLE, execa :: EXECA | eff) Unit
main = runAff (log <<< message) (\a -> log a.stdout) (execa "ls" [ "-1" ] opts)
  where
  opts :: Options Execa
  opts = cwd := "./src" <> env := mempty
