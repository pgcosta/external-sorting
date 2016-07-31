module Merger
  extend self

  LINES_PER_READ = 10 #how many lines to read from each tempfile
  OUTPUT_FILE = "out"

  # merges the partitioned files
  def merge
    partitions = load_hash_of_files
    out = File.open(OUTPUT_FILE,"w")
    puts "merging files..."

    while !partitions.keys.empty? do
      # find the smallest elem and wite it to the output file
      out.write get_smallest_elem(partitions)
    end
    out.close
  end

  # given a hash {File => [String]}
  #  returns the 'smallest' string of the first elems of all the arrays
  #  IE: get_smallest_elem({file1 => ['c'], file2 => ['b'], file => ['a']}) returns 'a'
  def get_smallest_elem hash
    # set a smallest string. smallest = [value, key]
    smallest = hash.first[1].first, hash.first[0]

    # compare all the strings in the first position of the arrays
    hash.each do |key, values|
      # save the key of the smalest string, as well as the value
      smallest = values.first, key if values.first < smallest.first
    end

    # remove the smallest elem of the array. remember, smallest.last = key of the smallest element
    hash.fetch(smallest.last).shift

    # check if this array is empty, meaning we read all the buffered lines
    if hash[smallest.last].empty?
      # read more lines from the fragment file
      lines = read_n_lines(smallest.last, LINES_PER_READ)
      # delete this array if the EOF was reached
      if lines.empty?
        hash.delete(smallest.last)
      else
        # else assign the lines to this key
        hash[smallest.last] = lines
      end
    end
    # return the smallest value
    smallest.first
  end

  # loads all the temp files to a hash
  #  hash hash File instances as keys and arrays with some lines as values
  #  {File => [String]}
  # returns the hash
  def load_hash_of_files
    keys = get_temp_files
    hash = {}

    keys.each do |k|
      hash[k] = read_n_lines(k, LINES_PER_READ)
    end
    hash
  end

  # reads all the temp files present in temp/
  # returns an array with all the instances
  def get_temp_files
    files = []
    i = 1

    while File.exist?(file_name(i)) do
      files << File.open(file_name(i), "r")
      i+=1
    end
    files
  end

  private

  # return the filename of the n-th partition file
  def file_name(n)
    "temp/#{n}.temp"
  end

  # returns [] if EOF reached,
  def read_n_lines file, n
    array_of_lines = []
    n.times do
      break if file.eof?
      array_of_lines << file.gets
    end
    array_of_lines
  end

end