(def config
  [{:name "Common aliases"
    :description "Avoid common foot-bullets in the shell."
    :aliases {:rm   "rm -i"
              :cp   "cp -i"
              :mv   "mv -i"
              :ls   "ls -h #{os_opt(@ls_color)}"
              :grep "grep --color=auto"}}

   {:name "Git"
    :description "Useful aliases for Git."
    :test "which git"
    :enabled false}

   {:name "Home bin folder."
    :description "Add home bin folder to path."
    :test "[ -d \"$HOME/bin\" ]"
    :paths {:path "$HOME/bin"}}

   {:name "Local bin folder."
    :description "Add ~/.local/bin to path, after ~/bin."
    :test "[ -d \"$HOME/.local/bin\" ]"
    :paths {:path "$HOME/.local/bin"}   }])
