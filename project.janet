(declare-project
  :name "jdn-loader"
  :description "A utility for loading JDNs using janet's import mechanism."
  :url "https://github.com/levitanong/jdn-loader"
  :dependencies ["https://github.com/joy-framework/tester"
                 "https://github.com/andrewchambers/janet-jdn"])

(declare-source
  :source ["src/jdn-loader.janet"])
