################################################################################
### Functions to turn config into bash files.
###
##
#

(import /tests)


(def- .profile)


(def- .bash_profile
  "source ~/.profile
source ~/.bashrc")


(def- bashrc-headers
  "# Load aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Set Bash defaults
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize")


(def- .bashrc)


(defn gen-alias [element]
  (let [result @[]
        aliases (element :aliases)]
    (if aliases
      (do
        (array/push result (string "# " (element :name)))
        (eachp [alias value] aliases
          (array/push result
                      (string (string/ascii-upper alias) "=" value)))
        (array/push result "")))
    result))


(defn gen-aliases [elements]
  "Genreate an array representing the .aliases file."
  (let [result @[]]
    (loop [element :in elements]
      (array/push result (gen-alias element)))
    (flatten result)))


(defn enabled-elements [elements]
  (filter enabled? elements))


(defn test [elements]
  (loop [line :in
         (gen-aliases (enabled-elements elements))]
    (print line)))
