################################################################################
### Datum definitions for DotGen2 config files.
### Ignoring this for now until the app is actually working, then will
### get back to implementing this.
##
#

(def- aliases
  {:type :definition
   :min-length 1
   :each-value :string})

(def- paths
  {:type :collection
   :min-length 1
   :each-value {:type :definition
                :optional {:order :number}
                :required {:path  :string}}})

(def- config-entry
  {:type :definition
   :required {:name        :string
              :description :string}
   :optional {:enabled     :boolean
              :test        :string
              :aliases     aliases
              :paths       paths}})

(def- config-root
  {:type :collection
   :min-length 1
   :each-value config-entry})
