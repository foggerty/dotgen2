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
### Config test functions

(defn- is-type? [obj t]
  (= t (type obj)))

(defn- is-true? [tst & msgs]
  (if (not tst) (string ;msgs) nil))

(defn- test-min-length [test config name]
  (let [min (test :min-length)]
    (if (nil? min)
      nil
      (is-true? (>= (length config) min)
                "Property " name " has a minimum length of " min))))

(defn- seqi [lst func]
  (do
    (var i 0)
    (seq [l :in lst]
         (++ i)
         (func l i))))

(defn- test-content [test name]
  (fn [cfg i]
    (apply-config-test test cfg (string name ":" i " "))))

(defn- test-tuple-content [test config name]
  (let [content-test (test :contents)]
    (if (nil? content-test)
      nil
      (seqi config (test-content content-test name)))))


################################################################################
### Test runners / Pubic interface

(defn- test-tuple [test config name]
  (or (is-true? (is-type? config :tuple) "Expected tuple for " name)
      (test-min-length test config name)
      (test-tuple-content test config name)))

(defn- test-struct [test config name]
  (or (is-true? (is-type? config :struct) "Expected struct for " name)
      (test-min-length test config name)
      (test-each-value test config name)
      (test-required test config name)
      (test-optional test config name)))

(defn- apply-test [test config name]
  (case (test :type)
    :tuple (test-tuple test config name)
    :struct (test-struct test config name)))



################################################################################
### Rest is application specific...

(defn config-errors [config]
  (apply-test config root config "Root"))
