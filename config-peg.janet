################################################################################
### Definition for DotGen2 config.

# Each definition (def) entry must be a struct with at least one entry
# called :type.  :type can be one of :tuple or :struct.  If the :type
# test fails, no other tests in the containing struct will be run.
# This is always the first test to be run.
#
# A tuple can have the following additional keys (everything else is ignored):
#   :min-length - minimum length for tuple.
#   :contents - a type or another definition entry.
#   :each-value - (optional) test to run over each entry
#
# A struct can the following additional keys (everything else is ignored):
#   :required - a map of key/type pairs (type can also be another definition entry).
#   :optional - a map of key/type pairs (type can also be another definition entry).
#   :min-length - sets minimum length, otherwise assumes 0.
#   :each-value - an (optional) test to run over each value.

(def- aliases
  {:type :struct
   :min-length 1
   :each-value :string})

(def- bash-entry
  {:type :struct
   :required [:name :string
              :description :string]
   :optional [:enabled :boolean
              :test :string
                :aliases aliases]})

(def- def-root
  {:type :tuple
   :min-length 1
   :contents bash-entry})



################################################################################
### Predicates

(defn- is-type? [type test]
  (= type (type test)))

(defn- is-true? [test msg]
  (if (not (eval test)) msg nil))



################################################################################
### Test runners / Pubic interface

(defn- test-min-length [def config name]
  (let [length-test (get :min-length def)]
    (cond (nil? length-test) nil
          (< 0 length-test)
          (string "Config is broken in " name " - cannot use negatives for :min-length.")
          (> (length config) length-test)
          (string name " needs a minimum length of " length-test))))

(def each-value-types
  [:string :number ])

(defn- test-each-value [def config name]
  (let [value-test
        (case (type value-test)
          :struct (test-def )
          )]
    (cond (nil? value-test) nil
          (map remove nils check length nil if zero) (value-test))))

(defn- test-tuple [def config name]
  (or (test-min-length def config name)
      (test-tuple-contents def config name)
      (test-each-value def config name)))

(defn- test-struct [def config name]
  (or (test-min-length def config name)
      (test-required def config name)
      (test-each-value def config name)
      (test-optional def config name)))

(defn test-def [def config name]
  (case (def :type)
    :tuple (test-tuple def config name)
    :struct (test-struct def config name)
    (string ":type must be either :tuple or :struct in " name)))



################################################################################
### Move to main program when working

(defn config-errors [config]
  (test-def def-root config "Root"))
