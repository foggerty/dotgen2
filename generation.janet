################################################################################
### Functions to turn config into bash files.
###
##
#

(import ./element-tests :as test)

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

(defn write-element [element]
  "Outputs config defined in element to the correct Bash files.")

(defn write-elements [config]
  "Outputs each config element to the correct Bash files."
  (each write-element config))

(defn enabled-elements [elements]
  (filter (fn [element] (test/has-optional-key? element)
            elements)))
