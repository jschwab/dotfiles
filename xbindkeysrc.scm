;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; bind audio control keys
(xbindkey '("XF86AudioMute") "amixer sset Master toggle")
(xbindkey '("XF86AudioLowerVolume") "amixer sset Master 5%-")
(xbindkey '("XF86AudioRaiseVolume") "amixer sset Master 5%+")
(xbindkey '("XF86AudioMicMute") "amixer sset Mic toggle")

;; bind brightness control keys
(xbindkey '("XF86MonBrightnessDown") "xbacklight -dec 5")
(xbindkey '("XF86MonBrightnessUp") "xbacklight -inc 5")

;; bind monitor switching hotkeys
;;
;; on laptop keyboard
;;   [][][] key -> XF86LaunchA
;;   Fn + [][][] -> F11
;;
;; on USB keyboard (Logitech Wave)
;;   F11 -> F11

;; so bind F11 to autoswitch on both
(xbindkey '("F11") "autorandr --change")

;; and bind [][][] to special "all monitor" target
(xbindkey '("XF86LaunchA") "autorandr --load horizontal")

(xbindkey '("Print") "import /tmp/$(date +\"screenshot-on-%F-at-%T.png\")")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
