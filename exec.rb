$: << File.expand_path("",File.dirname(__FILE__))
require 'big_sorter'

if ["--help", "-h", "help", "h"].include?(ARGV[0])
  puts "Available options: "
  puts "--no-cleanup :  Does not clean the files in temp/* after the execution"
  puts "[--help|-h|help|h] : displays options"
else
  BigSorter.ext_sort
  `rm temp/*` unless ARGV[0] == '--no-cleanup'
end