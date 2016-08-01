# Readme

# Implementation of a common external sort Algorithm

## Overview
* Split the huge file in chunks
* QuickSort each of the chunks concurrently (note: i consider 'A'>'a')
* Merge the sorted chunks into the final file

# Requirements

Tested with the following:

* ruby 2.2.3
* rspec 3.4.4

# How to execute?

1. generate the file ```ruby -e 'a=STDIN.readlines;5000000.times do;b=[];16.times do; b << a[rand(a.size)].chomp end; puts b.join(" "); end' < /usr/share/dict/words > file.txt```
 
2. run ```ruby exec.rb```

3. a file named 'out' will be created with the sorted data

You can tweak settings by altering the values of static variables in **big_sorter.rb** and **merger.rb**, and check options running ```ruby exec -h```

# How to run the tests?

1. run ```rspec --init``` in the directory
2. then simply ```rspec```

# Analysis of the solution

## Algorithm

Sorting a huge file provides unique challenges.

Traditional sorting algorithms run on system memory (RAM). For huge files, that is just not feasile, as it quickly bottlenecks the system (ie: sorting a 3 GB file in a machine with 2 GB ram)

So my approach was to use a traditional external sort. Here are the steps:

1. Read a chunk of lines from file.txt
2. For each chunk, run concurrently N processes that quicksort each of the chunks, and outputs the sorted results to temporary files
3. GOTO step 1 until all the file.txt is read and sorted
4. Merge all the temporary files into a final output file
4.1 Read 10 lines from each temp file
4.2 append to the output file the smallest line of all the lines read
4.3 keep reading lines from the temp files, until all the lines are read
4.4 the final file will be finally ready

## Complexity analysis

### Partition

For the partition phase, each chunk gets quicksorted and outputed to a temp file.

The number of chunks depend on the **TEXT_BLOCK_SIZE** defined in big_sorter.rb. Let K be the number of chunks.

So the average case for quicksort is O(n log n), which for this scenario, taking into account the randomness of the data in file.txt, is pretty accurate.

So the average case for partition is K * O(n log n)


### Merging

The way the algorithm works, is it builds a list of K lists, each one being already sorted.

The solution is found by looping over the K lists to pick off the minimum element each time, and repeat this loop until all lists are empty.

In the worst case, this algorithm performs O((K−1)(n−K/2)), which is how the algorithm works everytime.


## Performance comments

The partionning and sorting of the file is done concurently. By default only 10 processes will execute at each time, each quicksorting 90k lines.

More in depth benchmarking should be done to detect the most appropriate number of concurrent processes.

Disk memory-wise, on the worst case the algorithm occupies ~3 times the size of the original file. This is because at the very end of the merging phase we have the original file + the temp files + the output file.

In the end the temp files are deleted. One possible optimization is to destroy the original file after all the temp files have been created.

In terms of physical memory, more benchmarks should be done to determine a good size for the chunks.

Both for partitioning and merging, the files are only read in chunks. These chunks are easily configurable (**TEXT_BLOCK_SIZE** and **LINES_PER_READ**).

