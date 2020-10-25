(import tester :prefix "" :exit true)
(import ../src/jdn-loader)

(import jdn::sample-jdns :jdn-loader/binding-type :struct)
# need to make this fresh because sample-jdns was already imported.
(import jdn::sample-jdns :as sample-jdns-env :jdn-loader/binding-type :env :fresh true)
(import ./sample-jdns/foo :as single-foo)

(deftest

  (test "bind specific jdn file to value"
    (is (= {:field-1 "hi" :field-2 "hello"} single-foo/value)))

  (test "bind sample-jdns to a struct"
    (is (= :struct (type jdn::sample-jdns/jdns))))

  (test "bind sample-jdns to the env: foo"
    (is (= {:field-1 "hi" :field-2 "hello"} sample-jdns-env/foo)))

  (test "bind sample-jdns to the env: bar"
    (is (= [{:yes "no"} {:no "yes"}] sample-jdns-env/bar)))

  )
