(import ./config/config :as cfg)
(import ./element-tests :as tests)

(defn show-help []
  (print "DotGen V2\n"))

(defn test-config [cfg]
  (tests/valid-config? cfg))

(defn generate-output [cfg])

(defn main [& args]
  # Show help if no arguments present.
  (if (= 1 (length args))
    (do (show-help)
        (os/exit 0)))

  # Sanity check the config.
  (test-config cfg/config)

  # Guess.....
  (generate-output cfg/config))
