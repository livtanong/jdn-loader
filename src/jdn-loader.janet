(import jdn)

(defn load-jdn
  [path args]
  @{'value @{:value (jdn/decode (slurp path))}})

(defn remove-extension
  "Takes a filename, strips the extension.
  Or more accurately, removes any substring after the last `.`"
  [filepath]
  (let [path-segments (string/split "/" filepath)
        segments (string/split "." (last path-segments))
        # pop is destructive, and returns the element.
        _ (if (> (length segments) 1) (array/pop segments) segments)
        no-extension (string/join segments ".")]
    no-extension))

(defn process-jdn-filepath
  "Creates a tuple of [key jdn-data] where the key is simply
  the filename with the extension removed"
  [key-fn val-fn filepath]
  [(key-fn (remove-extension filepath))
   (val-fn
     (jdn/decode (slurp filepath)))])

(defn load-jdns
  "given a path to a directory, find all jdn files and create bindings.
  The binding type is dependent on the `:jdn-loader/binding-type` key in the args"
  [path args]
  (let [{:jdn-loader/binding-type binding-type} (struct (splice args))
        binding-type (or binding-type :struct)
        dir-filenames (os/dir path)
        jdn-filenames (->> dir-filenames
                        (filter (partial string/has-suffix? ".jdn"))
                        (map (fn [filename] (string path "/" filename))))
        make-table (fn [key-fn val-fn filepaths]
                     (splice (mapcat (partial process-jdn-filepath key-fn val-fn) filepaths)))]
    (case binding-type
      :struct @{'jdns @{:value (struct (splice (make-table keyword identity jdn-filenames)))}}
      :env (table (splice (make-table symbol (fn [val] @{:value val}) jdn-filenames)))
      @{})))

(defn check-jdn-dir
  "Function to check if path is prefixed with `jdn::`.
  This is necessary because there's nothing to distinguish a simple directory,
  unlike an actual jdn file which we'd guess from the file extension."
  [template path]
  (if (string/has-prefix? "jdn::" path)
    (let [cleaned-path (string/replace "jdn::" "" path)
          full-path (module/expand-path cleaned-path template)]
      (string full-path))))

# For single JDN files
## (module/add-paths ".jdn" :jdn)
(array/push module/paths [":cur:/:all:.jdn" :jdn |(if string/has-prefix? "." $)])
(put module/loaders :jdn load-jdn)

# For a directory of JDN files
(array/push module/paths [(partial check-jdn-dir ":cur:/:all:") :jdns])
(array/push module/paths [(partial check-jdn-dir ":all:") :jdns])
(put module/loaders :jdns load-jdns)
