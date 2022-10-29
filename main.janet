(import ./config/config :as cfg)
(import ./datum-definition :as datum)

(defn show-help []
  (print "DotGen V2"))

(defn test-config [cfg]
  (cond (= nil cfg) (error "No config defined!")
        # send both datum-definition and cfg to a function
        # that walks one using the other as a guide, and collects
        # error messages.
        # if it returns not empty (or nil?  What's more idomatic for Janet?) then
        # concatinate the errors and dumps to stderr, and returns false.
        # Otherwise returns true.
        ) )

(defn generate-output [cfg])

(defn main [& args]
  # Show help if no arguments present.
  (if (= 1 (length args))
    (show-help)
    (os/exit 0))

  # Sanity check the config.
  (test-config cfg/config)

  # Guess.....
  (generate-output cfg/config))
