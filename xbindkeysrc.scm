;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; bind audio control keys
(xbindkey '("XF86AudioMute") "amixer sset Master toggle")
(xbindkey '("XF86AudioLowerVolume") "amixer sset Master 5%-")
(xbindkey '("XF86AudioRaiseVolume") "amixer sset Master 5%+")
(xbindkey '("XF86AudioMicMute") "amixer sset Mic toggle")

;; bind monitor switching to F11
(xbindkey '("F11") "autorandr --change")
;; bind monitor switching to F11 on laptop keyboard
(xbindkey '("XF86LaunchA") "autorandr --change")

;; take a screenshot
(xbindkey '("XF86MyComputer") "/home/jschwab/scripts/screenshot")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
