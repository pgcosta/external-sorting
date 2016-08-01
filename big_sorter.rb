$: << File.expand_path("",File.dirname(__FILE__))
require 'quicksort_worker'
require 'merger'

module BigSorter
  extend self

  NR_OF_PROCESSES = 10 #how many quicksorts concurrently
  TEXT_BLOCK_SIZE = 90000 #how many lines will be sorted each time

  def ext_sort
    partition_file
    Merger.merge
  end

  # read file, split it in batches, sort the batches concurrently, save them to temp files
  def partition_file
    file_number = 0
    file=File.open("file.txt", 'r')

    # read chunk of the file
    lines = read_n_lines(file, TEXT_BLOCK_SIZE)

    # loop to read the file
    loop do
      # create processes to sort chunks
      NR_OF_PROCESSES.times do |process_number|
        file_number += 1
        break if lines.empty?
        # filename to save a sorted chunk
        filename = "temp/" + file_number.to_s + ".temp"

        Process.fork do
          puts "Saving batch... Filename: #{filename}"
          File.open(filename, "w") do |fragment_file|
            # sort lines, and write each one to the fragment file
            QuickSortWorker.sort(lines).map{|line| fragment_file.write line}
          end
        end
        # wait for the processes to finish
        Process.waitall
        lines = read_n_lines(file, TEXT_BLOCK_SIZE)
      end
      # exit when the file is read
      break if lines.empty?
    end
    file.close
  end

  # returns an array up to n lines. [] if the file reached the end
  def read_n_lines(file, n)
    array_of_lines = []
    file.seek(0,IO::SEEK_CUR)

    n.times do
      break if file.eof?
      array_of_lines << file.gets
    end
    array_of_lines
  end
end
