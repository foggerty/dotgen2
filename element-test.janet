################################################################################
#
# A definition consists of a series of nested elements.  Each element
# is a Janet struct.
#
# Each element MUST have at least one key called :type.
#
# :type can be either :collection or :definition.
#
#   :collection
#
#     Represents a Janet tuple '[]'.
#
#   :definition
#
#     Represents a Janet struct '{}'.
#
# With both :collection and :definition the following keys can be
# used:
#
#   :min-length
#
#     A number specifying minimum length.
#
#   :each-value
#
#     Either a simple type (:string, :number or :boolean) or another
#     definition element.  Each value will either have its type
#     checked, or compared to the definition in the element.
#
# When :type is set to :definition, the following keys can also be used:
#
#   :optional
#
#     A collection where all keys must be of type :keyword, and each
#     value must follow the same rules as for :each-value.
#
#  :required
#
#     Same as :optional, but required :-)
#
# Any other keys will be ignored.


################################################################################
### Definition predicates
#

(defn- basic-type? [x]
  "True if x is one of :string, :number or :boolean."
  (or (= :string x)
      (= :number x)
      (= :boolean x)))

(defn- element? [x]
  "True if x is a struct, has a key called :type, and if :type is either
:collection or :definition."
  (and (= :struct (type x))
       (x :type)
       (or (= :collection (x :type))
           (= :definition (x :type)))))

(defn- test-value [x key test]
  "True if x doesn't contain a key called key, otherwise the result of
applying test to x."
  (let [value (x key)]
    (or (nil? value)
        (test value))))

(defn- min-length-valid? [x]
  "True is x has a key called :min-length with a value of type :number.
The value must be a whole number and > 0.  If :min-length is not
present, will return true."
  (test-value x :min-length
     (fn [a]
       (and (= :number (type a))
            (<= a (math/trunc a))
            (> 0 a)))))

(defn- each-value-valid? [x]
  "True if x has a key called :each-value, with a value that is either
:string, :number, :boolean or another element.  If :each-value is not
present, will return true."
  (test-value x :each-value
     (fn [a]
       (or (basic-type? a)
           (element? a)))))

(defn- is-valid-definition? [x]
  "True if x is nil or a janet struct where each key in the collection
is a :keyword, and each value is one of :string, :number, :boolean or
another element definition."
  (or (nil? x)
      (and
        (= :struct (type x))
        (all (fn [t] (= :keyword (type t)))
             (keys x))
        (all (fn [v] (or (basic-type? v)
                         (element? v)))
             (values x)))))

(defn- optional-valid? [x]
  "If present, test :optional collection.  If not, return true."
  (is-valid-definition? (x :optional)))

(defn- required-valid? [x]
  "If present, test :required collection.  If not, return true."
  (is-valid-definition? (x :required)))


################################################################################
## Test functions.

(defn- validate-definition [definition x]
  "Uses definition ")

(defn- valid-element? [x]
  (and (element? x)
       (min-length-valid? x)
       (each-value-valid? x)
       (required-valid? x)
       (optional-valid? x)))


################################################################################
## Public interface.
