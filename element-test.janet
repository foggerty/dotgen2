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
# With both :collection and :definition the following keys
# can be used:
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
#     Same as :optional, except that each entry is expected to be
#     present.
#
# Any other keys will be ignored.


################################################################################
### Definition predicates
#

(defn- basic-type? [x]
  "True if x is one of :string, :number or :boolean, either the keywords
or the type itself matches on of those ust read the code this was
harder to explain than I initially thought it would be.."
  (let [t (if (= :keyword (type x))
            x
            (type x))]
    (or (= :string t)
        (= :number t)
        (= :boolean t))))

(defn- element? [x]
  "True if x is a struct, has a key called :type, and if :type is either
:collection or :definition."
  (and (= :struct (type x))
       (x :type)
       (or (= :collection (x :type))
           (= :definition (x :type)))))

(defn- min-length-valid? [x]
  "True is x has a key called :min-length with a value of type :number.
The value must be a whole number and > 0.

If :min-length is not present, will return true."
  (let [min-length (x :min-length)]
    (or (not min-length)
        (and (= :number (type min-length))
             (<= min-length (math/trunc min-length))
             (> min-length 0)))))

(defn- each-value-valid? [x]
  "True if x has a key called :each-value, with a value that is either
:string, :number, :boolean or another element.

If :each-value is not present, will return true."
  (let [each-value (x :each-value)]
    (or (not each-value)
        (or (basic-type? x)
            (element? x)))))

(defn- is-valid-definition? [x]
  "True if x is nil or a janet struct, where:
 - Each key in the collection is a :keyword.
 - Each value of the collection must be one of :string, :number, :boolean
or another element definition."
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

(defn- valid-element? [x]
  (and (element? x)
       (min-length-valid? x)
       (each-value-valid? x)
       (required-valid? x)
       (optional-valid? x)))

################################################################################
## Public interface.
