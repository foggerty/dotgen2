(def config
  [{:name "Common aliases"
    :enabled true
    :description "Avoid common foot-bullets in the shell."
    :aliases {:rm   "rm -i"
              :cp   "cp -i"
              :mv   "mv -i"
              :ls   "ls -h"}}

   {:name "Git"
    :enabled false
    :description "Useful aliases for Git."
    :test "which git"
    :aliases {:gts     "git status"
              :gtl     "git log"}}

   {:name "Home bin folder."
    :description "Add home bin folder to path."
    :test "[ -d \"$HOME/bin\" ]"
    :paths {:path "$HOME/bin"}}])
