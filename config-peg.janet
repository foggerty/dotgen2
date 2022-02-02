################################################################################
### Config data definition

# Each config entry must be a struct with at least one entry called
# :type.  :type can be one of :tuple or :struct.  If the :type test
# fails, no other tests in the containing struct will be run.  This is
# always the first test to be run.
#
# A tuple can have:
#   :min-length - minimum length for tuple.
#   :each-value - ensures each item in tuple is of a matching (simple) type.
#   :contents - another config entry, to be run against every item.
#
# A struct can have:
#   :required -
#   :optional -
#   :min-length -
#   :each-value -

(def- aliases
  {:type :struct
   :min-length 1
   :each-value :string})

(def- config-entry
  {:type :struct
   :required [:name :string
              :description :string]
   :optional [:enabled :boolean
              :test :string
              :aliases aliases]})

(def- config-root
  {:type :tuple
   :min-length 1
   :contents config-entry})



################################################################################
### Predicates

(defn- is-true? [test msg]
  (if (not test) msg nil))

(defn- test-min-length [test config name]
  "If :min-length exists, apply if to config."
  (let [min (test :min-length)]
    (if min
      ())))

(defn- test-tuple-content [test config name]
  ; this is where I aggregate results
  )

(defn- test-each-value [test config name]
  ; ditto
  )

(defn- test-optional [test config name]
  )

################################################################################
### Test runners / Pubic interface

(defn- test-tuple [test config name]
  (or (is-true? (is-type? config :tuple) (str "Expected tuple for " name))
      (test-min-length test config name)
      (test-tuple-content test config name)))

(defn- test-struct [test config name]
  (or (is-true? (is-type? config :struct) (str "Expected struct for " name))
      (test-min-length test config name)
      (test-required test config name)
      (test-each-value test config name)
      (test-optional test config name)))

(defn apply-config-test [test config name]
  (case (test :type)
    :tuple (test-tuple test config name)
    :struct (test-struct test config name)
    (str "Type must be either :tuple or :struct in " name)))


################################################################################
### Move to main program when working

(defn config-errors [config]
  (apply-test config-root config "Root"))
