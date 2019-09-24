require 'optparse'

options = {}

OptionParser.new do |parser|
  parser.on("--output", "output file name.") do |p|
    options[:output] = p
  end
end.parse!

puts "options = #{options}"