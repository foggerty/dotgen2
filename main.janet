(import /config)
(import /tests)
(import /generation)

(defn show-help []
  (print "DotGen V2\n"))

(defn show-errors [results]
  )

(defn write-output [cfg])

(defn print-output [cfg])

(defn display? [args]
  return false)

(defn main [& args]
  # Show help if no arguments present.
  (if (= 1 (length args))
    (do (show-help)
        (os/exit 1)))

  # Sanity check the config.
  (let [results (tests/valid-config? cfg/config)]
    (if (>0 (length results))
      (do (show-errors results)
          (os/exit/1))))

  (if (display? args)
    (print-output cfg/config)
    (write-output cfg/config)))
