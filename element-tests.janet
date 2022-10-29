################################################################################
### Datum Tests
###
### Each elament must:
###  Be a Janet Struct - {}
###
### Each element must contain at minimum:
###  :type - one of :definition or :collection.
###
### :definition indicates a collection of key/value pairs.
### :collection indicates a collection of values.
###
### For :definition, the following key/value pairs are allowed:
###  :required - a struct where each key must be a keyword, and the value is
###  one of :string, :number, :boolean or another element.
###  :optional - same as :required.
###  :min-length - sets a minimum number of items in this element.
###  :each-value - one of :string, :number, :boolean or another element.
###  Each item in the definition must match with :each-value.
###
### For :collection the following key/value pairs are allowed:
###  :min-length - same rules apply as described for :definition.
###  :each-value - same rules apply as described for :definition.
###
### Note that additional key/value pairs not specified above will
### be ignored.
##
#

(defn- has-valid-name [element]
  "True if :name has been set."
  (string? (element :name)))

(defn- has-valid-description [element]
  "True if :description is set and is a string.  Also true if
:description is not present."
  (or (nil? (element :descrition))
      (string? (element :description))))

(defn- has-valid-test [element]
  "True if :test is a string or not present.  That's about all we can
test at this point!"
  (or (nil? (element :test))
      (string? (element :test))))

(defn- has-valid-aliases [element]
  "True if :aliases is not present, or is a struct of :keyword/strings."
  (let [test (element :aliases)]
    (or (nil? test)
        (and (struct? test)
             (all keyword? (keys test))
             (all string? (values test))))))

(defn- has-valid-paths [element]
  "True if :paths is not present, or is a struct of :keyword/strings."
  (let [test (element :paths)]
    (or (nil? test)
        (and (struct? test)
             (all keyword? (keys test) )
             (all string? (values test))))))

(defn- has-valid-enabled [element]
  "True if :enabled is a boolean or not present."
  (or (= nil (element :enabled))
      (boolean? (element :enabled))))

(defn- valid-element [element]
  "True if the element is a struct and all (recognised) contained keys
are valid."
  (and (struct? element)
       (has-valid-name element)
       (has-valid-description element)
       (has-valid-enabled element)
       (has-valid-aliases element)
       (has-valid-test element)))

(defn valid-config [config]
  "True if config is a tuple of valid elements."
  (and (tuple? config)
       (all valid-element config)))
