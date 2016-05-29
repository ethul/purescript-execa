module Node.Execa
  ( EXECA
  , Execa
  , execa
  , cwd
  , env
  , stdioString
  , detached
  , uid
  , gid
  , shellBoolean
  , shellString
  , maxBuffer
  , stripEof
  , encoding
  , reject
  ) where

import Prelude (Unit, show)

import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)

import Data.Foreign (Foreign)
import Data.Function (Fn5, runFn5)
import Data.Functor.Contravariant (cmap)
import Data.Options (Option, Options, options, opt)
import Data.Posix (Gid, Uid, runGid, runUid)
import Data.StrMap (StrMap)

import Node.Encoding (Encoding)

type ExecaResult = { stdout :: String, stderr :: String }

execa :: forall eff. String -> Array String -> Options Execa -> Aff (execa :: EXECA | eff) ExecaResult
execa file args opts = makeAff (runFn5 execaFn file args (options opts))

foreign import data Execa :: *

cwd :: Option Execa String
cwd = opt "cwd"

env :: Option Execa (StrMap String)
env = opt "env"

stdioString :: Option Execa String
stdioString = opt "stdio"

detached :: Option Execa Boolean
detached = opt "detached"

uid :: Option Execa Uid
uid = cmap runUid (opt "uid")

gid :: Option Execa Gid
gid = cmap runGid (opt "gid")

shellBoolean :: Option Execa Boolean
shellBoolean = opt "shell"

shellString :: Option Execa String
shellString = opt "shell"

maxBuffer :: Option Execa Number
maxBuffer = opt "maxBuffer"

stripEof :: Option Execa Boolean
stripEof = opt "stripEof"

preferLocal :: Option Execa Boolean
preferLocal = opt "preferLocal"

encoding :: Option Execa Encoding
encoding = cmap show (opt "encoding")

reject :: Option Execa Boolean
reject = opt "reject"

foreign import data EXECA :: !

foreign import execaFn
  :: forall eff. Fn5 String
                     (Array String)
                     Foreign
                     (Error -> Eff (execa :: EXECA | eff) Unit)
                     (ExecaResult -> Eff (execa :: EXECA | eff) Unit)
                     (Eff (execa :: EXECA | eff) Unit)
