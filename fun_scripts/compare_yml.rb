def compare_keys first_file_info, second_file_info, results_location = 'results/'
  first_file = Hash.new
  second_file = Hash.new
  deltas_file = Hash.new
  File.open( first_file_info ) { |yf| first_file =  YAML.load( yf ) }
  File.open( second_file_info) { |yf| second_file =  YAML.load( yf ) }
  first_file.each_pair do |k,v|
    test_read = second_file[k]
    puts test_read
    if test_read.nil?
      deltas_file[k] = v
    end
  end
  unless File.exist?(results_location + "result")
    File.open( results_location + "result", 'w' ) { |f| f.write( deltas_file.to_yaml )}
  else
    File.delete(results_location + "result")
    File.open( results_location + "result", 'w' ) { |f| f.write( deltas_file.to_yaml )}
  end
  puts first_file == second_file
end

compare_keys(ARGV[0],ARGV[1])
