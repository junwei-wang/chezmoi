import           System.IO
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet               as W

import qualified Data.Map                      as M
import           Data.Maybe                     ( fromJust )

import           XMonad.Util.EZConfig           ( additionalKeysP )
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Run                ( spawnPipe )
import           XMonad.Util.SpawnOnce

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "$HOME/.cargo/bin/alacritty"

myBorderWidth :: Dimension
myBorderWidth = 3           -- Sets border width for windows

myNormColor :: String
myNormColor = "#9d91bb"   -- Border color of normal windows

myFocusColor :: String
myFocusColor = "#46d9ff"   -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount =
  gets
    $ Just
    . show
    . length
    . W.integrate'
    . W.stack
    . W.workspace
    . W.current
    . windowset

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "volumeicon &"
  spawnOnce "nm-applet &"
  spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc"
  spawnOnce
    "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 30 &"



-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces =
  [ " 1-ORG "
  , " 2-dev "
  , " 3-www "
  , " 4-mail "
  , " 5-chat "
  , " 6-conf "
  , " 7-music "
  , " 8 "
  , " 9 "
  ]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

clickable ws =
  "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where i = fromJust $ M.lookup ws myWorkspaceIndices

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
  [ ("M-C-r"       , spawn "xmonad --recompile")  -- Recompiles xmonad
  , ("M-S-r"       , spawn "xmonad --restart")    -- Restarts xmonad

    -- Run Prompt
  , ("M-S-<Return>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu
  , ("M-p"         , spawn "rofi -show drun")    -- Dmenu
  , ("M-<Return>"  , spawn (myTerminal)) -- Dmenu
  ]

main :: IO ()
main = do
  xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"
  xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1"
  xmonad
    $                 docks defaultConfig
                        { modMask            = myModMask -- Use Super instead of Alt
                        , manageHook = manageDocks <+> manageHook defaultConfig
                        , layoutHook = avoidStruts $ layoutHook defaultConfig
     -- this must be in this order, docksEventHook must be last
                        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
                        , startupHook        = myStartupHook
                        , terminal           = myTerminal
                        , workspaces         = myWorkspaces
                        , borderWidth        = myBorderWidth
                        , normalBorderColor  = myNormColor
                        , focusedBorderColor = myFocusColor
                        , logHook            =
                          dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
                            { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
                                                                   >> hPutStrLn xmproc1 x                          -- xmobar on monitor 2
                              -- >> hPutStrLn xmproc2 x                          -- xmobar on monitor 3
                            , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
                            , ppVisible = xmobarColor "#98be65" "" . clickable              -- Visible but not current workspace
                            , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable -- Hidden workspaces
                            , ppHiddenNoWindows = xmobarColor "#c792ea" "" . clickable     -- Hidden workspaces (no windows)
                            , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
                            , ppSep = "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
                            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
                            , ppExtras = [windowCount]                                     -- # of windows current workspace
                            , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]                    -- order of things in xmobar
                            }
                        }
    `additionalKeysP` myKeys
