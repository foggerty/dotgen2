################################################################################
### Data definitions for DotGen2
#

(def- aliases
  {:type :definition
   :min-length -1
   :each-value :string})

(def- config-entry
  {:type :definition
   :required {:name        :string
              :description :string}
   :optional {:enabled     :boolean
              :test        :string
              :aliases     aliases}})

(def- config-root
  {:type :collection
   :min-length 1
   :each-value config-entry})
