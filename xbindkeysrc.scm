;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; bind audio control keys
(xbindkey '("XF86AudioMute") "amixer sset Master toggle")
(xbindkey '("XF86AudioLowerVolume") "amixer sset Master playback 5dB-")
(xbindkey '("XF86AudioRaiseVolume") "amixer sset Master playback 5dB+")
(xbindkey '("XF86AudioMicMute") "amixer sset Mic toggle")

;; bind monitor switching to F11
(xbindkey '("F11") "autorandr --change")
;; bind monitor switching to F11 on laptop keyboard
(xbindkey '("c:248") "autorandr --change")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of xbindkeys guile configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
