# jdn-loader
A utility for loading JDNs using janet's import mechanism.

## Usage
There are two ways to use `jdn-loader`, loading individual jdns, or loading an entire directory of jdns.

### Individual

``` clojure
(import ./sample-jdns/foo :as single-foo)

single-foo/value
```

### Directory
To load a directory, there are two options. You can load the entire directory as a struct, or you can bind each jdn file in the directory to the environment.
To switch between these two modes, add the import argument `:jdn-loader/binding-type`, with either `:struct` or `:env` as the value.

#### struct
This mode is useful for when you expect the data to grow over time in your repo
``` clojure
(import jdn::sample-data :as sample-jdns :jdn-loader/binding-type :struct)

sample-jdns/jdns # {:file1 {:field1 0 :field2 [0 1]} :file2 [{:otherfield1 "hi"}]}
```

#### env
``` clojure
(import jdn::sample-data :as sample-jdns-env :jdn-loader/binding-type :env)

sample-jdns/file1 # {:field1 0 :field2 [0 1]}
sample-jdns/file2 # [{:otherfield1 "hi"}]
```

