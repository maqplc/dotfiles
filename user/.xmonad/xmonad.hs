--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
 
import XMonad
import System.Exit
import System.IO (hPutStrLn) 

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

import XMonad.Layout.NoBorders

import XMonad.Util.Dzen 
import XMonad.Util.Run

import XMonad.Actions.CycleWS

import XMonad.Layout.Accordion
import XMonad.Layout.MagicFocus
import XMonad.Layout.PerWorkspace


import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Window

import XMonad.Layout.Tabbed

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvtc"
 
-- Width of the window border in pixels.
--
myBorderWidth   = 1
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["web","code","media"]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#eeeeee"
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch firefox
    , ((modMask,		xK_f), spawn $ "firefox")
 
 
    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modMask              , xK_p ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_m), sendMessage (IncMasterN (-1)))
 
    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modMask              , xK_q     ),
          broadcastMessage ReleaseResources >> restart "xmonad" True)
 
    -- Switch to workspace
    , ((modMask              , xK_a	), windows $ W.greedyView "web")

    , ((modMask              , xK_z	), windows $ W.greedyView "code")

    , ((modMask              , xK_e ), windows $ W.greedyView "media")


    , ((modMask , xK_r), runOrRaisePrompt defaultXPConfig)


    , ((modMask  .|. shiftMask, xK_s     ), windowPromptBring  defaultXPConfig)
    , ((modMask  , xK_s     ), windowPromptGoto  defaultXPConfig)

   , ((modMask .|. shiftMask,               xK_l),  nextWS)
   , ((modMask .|. shiftMask,               xK_h),    prevWS)


    ]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $ smartBorders  $
	onWorkspace "media" (Full ||| Mirror tiled)$
	onWorkspace "web"  (Accordion ||| simpleTabbed ||| Mirror tiled) $
	onWorkspace "code" (simpleTabbed ||| Accordion ||| Mirror tiled)$
	Mirror tiled 
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 3/4
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
 
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
------------------------------------------------------------------------
-- Status bars and logging
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
firstDzenCommand  = "dzen2 -bg '#060000' -fg '#777777' -h 16 -w 1440 -sa c -e '' -ta l"
secondDzenCommand = "while true ; do date +'%A %d %B %Y - %H:%M' ; sleep 5 ; done | dzen2 -bg '#060000' -fg '#777777' -h 16 -y 884 -sa r -e '' -ta r"

myLogHook h = dynamicLogWithPP $ defaultPP {
                ppCurrent  = dzenColor "black" "white" . pad
              , ppVisible  = dzenColor "white" "#333333" . pad
              , ppHidden   = dzenColor "white"  "#333333" . pad
              , ppHiddenNoWindows = dzenColor "#777777"  "#333333" . pad
              , ppUrgent   = dzenColor "red" "yellow"
              , ppWsSep    = "|"
              , ppSep      = " - "
              , ppLayout   = id
              , ppTitle    = ("^fg(white) " ++) . dzenEscape
              , ppOutput   = hPutStrLn h
              }

 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do din <- spawnPipe firstDzenCommand
	  spawnPipe secondDzenCommand
          xmonad $ defaultConfig {
                     terminal           = myTerminal,
                     focusFollowsMouse  = myFocusFollowsMouse,
                     borderWidth        = myBorderWidth,
                     modMask            = myModMask,
                     numlockMask        = myNumlockMask,
                     workspaces         = myWorkspaces,
                     normalBorderColor  = myNormalBorderColor,
                     focusedBorderColor = myFocusedBorderColor,
                     keys               = myKeys,
                     mouseBindings      = myMouseBindings,
                     layoutHook         = myLayout,
                     manageHook         = myManageHook,
                     logHook            = myLogHook din
                   }
