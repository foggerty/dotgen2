(defn- is-valid-map? [element value-type]
  "True if element is a map (struct), where each key is a :keyword and each
value is of type ':value-type'."
  (and (struct? element)
       (all (fn (x) (keyword? x))
            (keys element))
       (all (fn (x) (= value-type (type x)))
            (values element))))


(defn- has-optional-map? [element map-name value-type]
  "True if 'map-name' is nill or a valid map (struct)."
  (or (nil? (element map-name))
      (is-valid-map? (element map-name) value-type)))


(defn- has-key? [element key-name value-type]
  "True if element contains the key 'key-name' and the value is of type
'value-type'."
  (and (not (nil? (element key-name)))
       (= value-type (type (element key-name)))))


(defn- has-optional-key? [element key-name value-type]
  "True if element has nil for key-name, or non-nil and of type value-type."
  (or (nil? (element key-name))
      (has-key? element key-name value-type)))


(defn- has-valid-paths? [element]
  "True if :paths is not present or is a map of :keyword/strings."
  (has-optional-map? element :paths :string))


(defn- has-valid-aliases? [element]
  "True if :aliases is not present or is a map of :keyword/strings."
  (has-optional-map? element :aliases :string))


(defn- has-valid-test? [element]
  "True if :test is a string or not present."
  (has-optional-key? element :test :string))


(defn- has-valid-enabled? [element]
  "True if :enabled is a boolean or not present."
  (has-optional-key? element :enabled :boolean))


(defn- has-valid-description? [element]
  "True if :description is set and is a string.  Also true if
:description is not present."
  (has-optional-key? element :description :string))


(defn- has-valid-name? [element]
  "True if :name has been set."
  (has-key? element :name :string))


(defn- run-test [test error-message]
  {:passed (eval test)
   :message error-message})


(defn- test-element [element]
  "Returns a tuple of struct with two keys, :passed and message."
  (let [is-struct (run-test (struct? element)
                            "Each element must be a struct.")]

    (if (false? (get is-struct :passed))
      (tuple is-struct)
      
      (tuple 
       (run-test (has-valid-name? element)
                 "Each element must have a name")

       (run-test (has-valid-description? element)
                 (string "Entry " (element :name) " does not have a valid ':description' entry."))

       (run-test (has-valid-enabled? element)
                 (string (element :name) " does not have a valid ':enabled' entry."))

       (run-test (has-valid-test? element)
                 (string "Entry " (element :name) " does not have a valid ':test' entry."))

       (run-test (has-valid-aliases? element)
                 (string "Entry " (element :name) " does not have a valid ':aliases' entry."))

       (run-test (has-valid-paths? element)
                 (string "Entry " (element :name) " does not have a valid ':paths' entry."))))))


###############################################################################
## Public interface.
#

(defn validate-config [config]
  "Returns an array of error messages if there are any errors in config.
Otherwise an empty tuple."

  (let [results (->> (map test-element config)
                     flatten
                     (filter (fn [e] (false? (get e :passed)))))]

    (map (fn [r] (get r :message))
         results)))
