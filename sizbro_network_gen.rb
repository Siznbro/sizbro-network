require 'optparse'
require 'victor'
require 'json'
require 'erb'

options = {format: 'text'}

OptionParser.new do |parser|
  parser.on('-o', '--output out', 'output file name.') do |p|
    options[:output] = p
  end
  parser.on('-f', '--format format', 'format of the output') do |p|
    options[:format] = p
  end
end.parse!

def member_list
  source = File.read('list.json')
  JSON.parse(source)
end

def count_member(list)
  list.inject(0) { |sum, year| sum += year["members"].length }
end

def generate_text(filename)
  f = File.open(filename, 'w')
  list = member_list
  output = "Sizbro Members #{Time.now.year} (#{count_member(list)} people)\n\n"
  list.each do |scholar_year|
    output << "#{scholar_year["year"]}X Generation:\n"
    scholar_year["members"].each do |member|
      output << "\t- #{member["name"]}(#{member["nickname"]}), #{member["occupation"]}\n"
    end
  end
  f.write(output)
  f.close
end

def generate_html(filename)
  f = File.open(filename, 'w')
  template = File.read('template.html.erb')
  records = member_list
  count = count_member(records)
  output = ERB.new(template).result(binding)
  f.write(output)
  f.close
end


send("generate_#{options[:format]}", options[:output])


