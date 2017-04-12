require 'rubygems'
require 'json'

def calculate_test_code_metrics(total_metrics, production_code_metrics)
  test_code_metrics = {}
  test_code_metrics["LOC"] = total_metrics["LOC"] - production_code_metrics["LOC"]
  test_code_metrics["CLOC"] = total_metrics["CLOC"] - production_code_metrics["CLOC"]
  test_code_metrics["NCLOC"] = total_metrics["NCLOC"] - production_code_metrics["NCLOC"]
  test_code_metrics
end

def calculate_prod_code_metrics(production_code_metrics)
  new_hash = {}
  new_hash["LOC"] = production_code_metrics["LOC"]
  new_hash["CLOC"] = production_code_metrics["CLOC"]
  new_hash["NCLOC"] = production_code_metrics["NCLOC"]
  new_hash["method_count"] = production_code_metrics["Method"] + production_code_metrics["Function"]
  new_hash
end

target_directory = ARGV[0]
Dir.chdir target_directory
`git reset origin/master && git reset --hard`
`git pull`
return unless `rm -rf vendor`
total_file_count = `find .//. -name '*.go' -print | grep -c //`
total_metrics = JSON.parse( `golocc -o json --no-vendor ./...`)
`find . -type f -name '*_test.go' -delete`
prod_file_count = `find .//. -name '*.go' -print | grep -c //`
production_code_metrics = JSON.parse( `golocc -o json --no-vendor ./...`)
test_code_metrics = calculate_test_code_metrics(total_metrics, production_code_metrics)
prod_code_metrics = calculate_prod_code_metrics(production_code_metrics)
puts "PROJECT: #{target_directory}"
puts("Amount of Prodfiles #{ prod_file_count}")
puts("PROD METRICS: #{prod_code_metrics}")
puts("Amount of Testfiles #{total_file_count.to_i - prod_file_count.to_i}")
puts("TEST METRICS: #{test_code_metrics}")
puts("Cyclic Complexity average:#{`gocyclo -avg .`.lines.last}")
`git reset origin/master && git reset --hard`
