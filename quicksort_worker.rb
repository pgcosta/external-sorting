module QuickSortWorker
  extend self

  def sort lines
    quicksort(lines,0,lines.size-1)
    lines
  end

  private
  # quicksorts array of strings
  def quicksort arr, lo, hi
    if lo < hi
      p = partition(arr, lo, hi);
      quicksort(arr, lo, p);
      quicksort(arr, p+1, hi);
    end
  end

  def partition arr, lo, hi
    pivot = arr[lo]
    i = lo - 1
    j = hi + 1
    loop do
      i+=1
      while arr[i] < pivot do
        i+=1
      end
      j-=1
      while arr[j] > pivot do
        j-=1
      end

      if i >= j
        return j
      end
    
      arr[i],arr[j] = arr[j],arr[i]
    end
  end
end