# Configuration root.

(def config
  [{:name "Common aliases"
    :description "Avoid common foot-bullets in the shell."
    :aliases {:rm   "rm -i"
              :cp   "cp -i"
              :mv   "mv -i"
              :ls   "ls -h #{os_opt(@ls_color)}"
              :grep "grep --color=auto"}}

   {:name "Git"
    :test "which git"
    :description "Useful aliases fot Git."
    :enabled false
    :aliases {:gts  "git status -s -b --column"
              :gtc  "git checkout"
              :gtl  "git log --graph --decorate=full"
              :gtlt "git log --graph --format=\"%Cgreen %h %p %Cred%d %Cblue%cn - %ar %Creset%s\""
              :gtb  "git branch -vva"
              :gtp  "git pull --rebase"}}])
