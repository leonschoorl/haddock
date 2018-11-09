{-# LANGUAGE LambdaCase      #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TupleSections   #-}

{-# OPTIONS_HADDOCK show-extensions #-}

-- | a dummy plugin with some tracing
module DummyPlugin
  ( plugin )
where


-- GHC API
import Plugins    (Plugin (..), defaultPlugin)
import Plugins    (purePlugin)
import Debug.Trace
import TcRnTypes  (Ct, TcPlugin (..), TcPluginResult(..), ctEvidence, ctEvPred,
                   isWanted, mkNonCanonical)
import TcPluginM  (TcPluginM, tcPluginTrace)
import Outputable

showPprUnsafe = showSDocUnsafe . ppr

plugin :: Plugin
plugin
  = shout "dummy top level" $ defaultPlugin
  { tcPlugin = shout "dummy tcPlugin" $ const $ Just dummy
  , pluginRecompile = shout "dummy recompile type" purePlugin
  , installCoreToDos = \_ coretodos -> shout "installing dummy coretodos" $ return coretodos
  }

dummy :: TcPlugin
dummy = shout "DummyTcPluging"
  TcPlugin { tcPluginInit  =  shout "DummyPlugin init" $ return ()
           , tcPluginSolve =  shout "dummy tcPluginSolve" const (dummyTc)
           , tcPluginStop  =  shout "DummyPlugin stop" const (return ())
           }

shout msg = trace (unlines [line,msg,line])
  where
    line = replicate 40 '='

dummyTc
  :: [Ct]
  -> [Ct]
  -> [Ct]
  -> TcPluginM TcPluginResult
dummyTc given derived wanted      = shout (unlines ["dummyTc called on: ", "given:", showPprUnsafe given, "derived:", showPprUnsafe derived, "wanted:", showPprUnsafe wanted]) $ return (TcPluginOk [] [])
