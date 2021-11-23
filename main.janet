(import ./config :as cfg)
(import ./config-peg)

(defn show-help []
  (print "Help!"))

(defn test-config [cfg]
  )

(defn generate-output [cfg])

(defn main [& args]
  # Show help if no arguments present.
  (if (= 1 (length args))
    (show-help))

  # Sanity check the config.
  (test-config cfg/config)

  # Guess.....
  (generate-output cfg/config))
