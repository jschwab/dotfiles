--
-- xmonad config file on monolith
--

import Numeric

import XMonad
import Data.Char (toLower)
import Data.List (isInfixOf, isPrefixOf)
import Data.Monoid
import System.Exit

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops

import XMonad.Actions.CycleWS
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.NoBorders
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.UpdatePointer

import XMonad.Util.Run
import XMonad.Util.Scratchpad

import XMonad.Prompt
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell

import XMonad.Layout.ResizableTile

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "xterm"

-- Whether focus follows the mouse pointer
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["1:todo","2:mail","3:web"] ++ map show ([4..9] ++ [0])

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

-- Things for interacting with pass
--
-- convert string to lower case
downCase :: String -> String
downCase = map toLower

-- match on substring
isCaseInsensitiveInfixOf :: String -> String -> Bool
isCaseInsensitiveInfixOf s l = (downCase s) `isInfixOf` (downCase l)

-- exclude things from Private
hasPrivatePrefix :: String -> String -> Bool
hasPrivatePrefix s l = "Private" `isPrefixOf` l

-- pass search predicate
passSearchPredicate :: String -> String -> Bool
passSearchPredicate s l = (not (hasPrivatePrefix s l)) && (isCaseInsensitiveInfixOf s l)

-- spawning duplicate terminal
-- https://marcinchmiel.com/articles/2017-09/launching-terminal-emulator-in-current-working-directory-in-xmonad/

mkTerm = withWindowSet launchTerminal

launchTerminal ws = case W.peek ws of
       Nothing -> runInTerm "" "$SHELL"
       Just xid -> terminalInCwd xid

terminalInCwd xid = let
  hex = showHex xid " "
  shInCwd = "'cd $(readlink /proc/$(ps --ppid $(xprop -id 0x" ++ hex
    ++ "_NET_WM_PID | cut -d\" \" -f3) -o pid= | tr -d \" \")/cwd) && $SHELL'"
  in runInTerm "" $ "sh -c " ++ shInCwd


myXPConfig = def { position = Top
                 , promptBorderWidth = 0
                 , bgColor = "Black"
                 , fgColor = "White"
                 , defaultText = []
                 , alwaysHighlight = True
                 , promptKeymap = emacsLikeXPKeymap
                 , font = "xft:Hack-11"
                 , height = 44
                 , searchPredicate = passSearchPredicate
                 }

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a new terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- duplicate an existing terminal
    , ((modm .|. shiftMask .|. controlMask, xK_Return), mkTerm)

    -- launch an emacs client
    , ((modm .|. controlMask, xK_Return), spawn "emacsclient -n -c")

    -- make a scratchpad terminal
    , ((modm                    ,xK_d), scratchpadSpawnActionTerminal myTerminal)

    -- show a calendar
    , ((modm                    ,xK_c), spawn "gsimplecal")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    , ((modm .|. controlMask,    xK_h), sendMessage MirrorShrink)
    , ((modm .|. controlMask,    xK_l), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
--    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Toggle the border
    , ((modm .|. shiftMask, xK_b     ), withFocused toggleBorder)

    -- Lock screen
    , ((modm .|. shiftMask, xK_l     ), spawn "xscreensaver-command -lock")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9,0], Switch to workspace N
    -- mod-shift-[1..9,0], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- find and empty worksspace and or move a window there
    [
      ((modm,                xK_m    ), viewEmptyWorkspace)
    , ((modm .|. shiftMask,  xK_m    ), tagToEmptyWorkspace)
    ]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    -- screen/window movement commands from an old config
    [
      ((modm              , xK_a)     , onPrevNeighbour def W.view)
    , ((modm              , xK_o)     , onNextNeighbour def W.view)
    , ((modm .|. shiftMask, xK_a)     , onPrevNeighbour def W.shift)
    , ((modm .|. shiftMask, xK_o)     , onNextNeighbour def W.shift)
    , ((modm              , xK_Right) , nextWS)
    , ((modm              , xK_Left)  , prevWS)
    , ((modm,               xK_z)     , toggleWS)
    ]
    ++

    -- comands related to time-tracking/productivity
    --
    [
    -- start/reset a pomodoro
      ((modm              , xK_Home  ), spawn "touch ~/.pomodoro_session")

    -- kill a pomodoro
    , ((modm              , xK_End   ), spawn "rm ~/.pomodoro_session")
    ]
    ++

    -- interact with prompts
    [ ((modm,                                xK_p), shellPrompt myXPConfig)
    , ((modm .|. shiftMask,                  xK_p), passPrompt myXPConfig)
    , ((modm .|. controlMask,                xK_p), passGeneratePrompt myXPConfig)
    , ((modm .|. controlMask  .|. shiftMask, xK_p), passRemovePrompt myXPConfig)
    ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)

    -- bind button6 and button7 (scroll wheel tilt) to move between workspaces
    , ((0, 6), (\w -> prevWS))
    , ((0, 7), (\w -> nextWS))

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
myLayout = tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = ResizableTall nmaster delta ratio []

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

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
myManageHook = composeAll
    [ className =? "MPlayer" --> doFloat
    , fmap ("PGPLOT Window" `isInfixOf`) title --> doFloat ]
    <+>
    scratchpadManageHook (W.RationalRect 0.25 0.25 0.5 0.5)

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = ewmhDesktopsEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

-- Move the mouse to the lower right corner when I change to a window
myLogHook = updatePointer (0.95, 0.95) (0.0, 0.0)

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "green" "black" . wrap "" ""
                , ppVisible = xmobarColor "yellow" "black" . wrap "" ""
                , ppHidden = xmobarColor "white" "black" . wrap "" ""
                , ppHiddenNoWindows = xmobarColor "red" "black" . wrap "" ""
                , ppOrder = \(ws:l:t:_)   -> [ws]
                , ppSort = fmap (.scratchpadFilterOutWorkspace) $ ppSort xmobarPP
                }

-- Key binding to toggle the gap for the bar.
mytoggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Define my xmobar
myxmobar = statusBar "xmobar" myPP mytoggleStrutsKey


------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad =<< myxmobar (ewmh defaults)

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
