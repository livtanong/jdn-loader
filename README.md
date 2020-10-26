# jdn-loader
A utility for loading JDNs using janet's import mechanism. This tool is still in its early stages, and the API could still have breaking changes. Use at your own risk.

## Why?
Because sometimes you want to load runtime configuration during compile-time, because you want a standalone executable. Also, I was curious and because Janet allows me to. :D

## Installation
Either add `jdn-loader.janet` to your project
or
`jpm install https://github.com/levitanong/jdn-loader` in a project with a `project.janet`
or
Manually add `https://github.com/levitanong/jdn-loader` to your `project.janet`

## Usage
There are two ways to use `jdn-loader`, loading individual jdns, or loading an entire directory of jdns.

### Individual
Say you have a directory `sample-jdns` and inside you have a file `foo.jdn`.

``` clojure
(import sample-jdns/foo :as single-foo)

single-foo/value
```

### Directory
Individually loading jdns is going to be quite a chore if you have an entire directory full of jdn files, so jdn-loader allows you to load all the jdns in a directory.

To load a directory, there are two options. You can load the entire directory as a struct (with the filenames as the keys), or you can bind each jdn file in the directory to the environment.
To switch between these two modes, add the import argument `:jdn-loader/binding-type`, with either `:struct` or `:env` as the value.

Both methods require you to prefix your directory with `jdn::`. This is because there's no other way for us to infer that a directory, which has no extensions, should be loaded using `jdn-loader`.

#### struct
This mode is useful for when you expect the data to grow over time in your repo, such as in a linter where you expect users to contribute PEGs. In other words, this is useful for an open set.
``` clojure
(import jdn::sample-data/jdn-samples :as sample-jdns :jdn-loader/binding-type :struct)

sample-jdns/jdns # {:file1 {:field1 0 :field2 [0 1]} :file2 [{:otherfield1 "hi"}]}
```

#### env
This mode is useful if you have a closed set. This is closer in spirit to the individual loading method.
``` clojure
(import jdn::sample-data/jdn-samples :as sample-jdns-env :jdn-loader/binding-type :env)

sample-jdns/file1 # {:field1 0 :field2 [0 1]}
sample-jdns/file2 # [{:otherfield1 "hi"}]
```

## License
jdn-loader is licensed under the MIT License
