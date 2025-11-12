(defn is-valid-map? [element value-type]
  "True if element is a map (struct), where each key is a :keyword and each
value is of type 'value-type'."
  (and (struct? element)
       (all (fn (x) (keyword? x))
            (keys element))
       (all (fn (x) (= value-type (type x)))
            (values element))))


(defn has-optional-map? [element map-name value-type]
  "True if 'map-name' is nill or a valid map (struct)."
  (or (nil? (element map-name))
      (is-valid-map? (element map-name) value-type)))


(defn has-key? [element key-name value-type]
  "True if element contains the key 'key-name' and the value is of type
'value-type'."
  (and (not (nil? (element key-name)))
       (= value-type (type (element key-name)))))


(defn has-optional-key? [element key-name value-type]
  "True if key either doesn't exist, or is of the correct type."
  (or (nil? (element key-name))
      (has-key? element key-name value-type)))


(defn enabled? [element]
  "True if there is no :enabled key, or it exists and is true."
  (or (nil? (element :enabled))
      (= true (element :enabled))))

(defn- run-test [test error-message]
  {:passed (eval test)
   :message error-message})


(defn- test-element [element]
  "Returns a tuple of structs with two keys, :passed and message."
  (let [is-struct (run-test (struct? element)
                            "Each element must be a struct.")]

    (if (false? (get is-struct :passed))
      (tuple is-struct)

      (tuple
        (run-test (has-key? element :name :string)
                 "Each element must have a name")

        (run-test (has-optional-key? element :description :string)
                 (string "Entry " (element :name) " does not have a valid ':description' entry."))

        (run-test (has-optional-key? element :enabled :boolean)
                  (string (element :name) " does not have a valid ':enabled' entry."))

        (run-test (has-optional-key? element :test :string)
                  (string "Entry " (element :name) " does not have a valid ':test' entry."))

        (run-test (has-optional-map? element :aliases :string)
                  (string "Entry " (element :name) " does not have a valid ':aliases' entry."))

        (run-test (has-optional-map? element :paths :string)
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
