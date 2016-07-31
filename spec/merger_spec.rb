require 'byebug'
describe Merger do

  (1..3).each do |n|
    let(:"file_#{n}") do
      file = File.open("temp/#{n}.temp","r")
      file
    end
  end

  describe "read_n_lines" do

    it "should return [] if file is empty" do
      f=file_1
      Merger.send(:read_n_lines,f, 200000)
      Merger.send(:read_n_lines,f, 200000)
      result = Merger.send(:read_n_lines,f, 200)
      f.close

      expect(result).to eq([])
    end

    it "should read n lines of a file" do
      f=file_1
      result = Merger.send(:read_n_lines,f, 200)
      f.close

      expect(result.count).to eq(200)
    end
  end

  describe "get_temp_files" do
    it "should get an array of files" do
      files = Merger.get_temp_files
      expect(files.count).to be > 2
    end
  end

  describe "load_hash_of_files" do
    it "read 10 first lines from each file" do
      hash = Merger.load_hash_of_files

      hash.values.each do |lines|
        expect(lines.count).to eq(10)
      end
    end

    it "in each array, the first elem is less than the last" do
      hash = Merger.load_hash_of_files

      hash.values.each do |lines|
        expect(lines.shift).to be < lines.last
      end
    end
  end

  describe "get_smallest_elem" do
    # care: all arrays must be already sorted
    let(:hash) do
      {
        file1: ["abbbbbbb", "Elohist hematodynamics", "xerodermic"],
        file2: ["aaaaaaaa", "Erodium syringitis", "vulturous"],
        file3: ["accccccc", "Europasian apteral abbas", "ytterbium"]
      }
    end

    it "should remove the smallest global elem of the arrays" do
      h = hash
      Merger.get_smallest_elem(h)

      expect(h[:file1].size).to be(3)
      expect(h[:file2].size).to be(2)
      expect(h[:file3].size).to be(3)
    end

    it "should return the smallest global elem of the arrays" do
      h = hash
      res = Merger.get_smallest_elem(h)

      expect(h[:file2].size).to be(2)
      expect(res).to eq("aaaaaaaa")
    end

    it "should work correctly after successive calls" do
      h = hash
      Merger.get_smallest_elem(h)
      Merger.get_smallest_elem(h)
      Merger.get_smallest_elem(h)

      # count all the elems in all the arrays
      global_arrays_elems_count = h.values.inject(0){|res,val| res+=val.count}
      
      expect(h.keys.count).to eq(3)
      expect(global_arrays_elems_count).to eq(6)
    end
  end

  describe "merge" do
    it "should merge the fragments 1, 2 and 3" do
      Merger.merge

      expect(File.exist?("out")).to be true

      lines = File.readlines("out")
      lines.each_cons(2) do |l|
        expect(l.first).to be < l.last
      end
    end

    it "should output an out file with a size as file1 + file2 + file3" do
      Merger.merge

      file_1_lines = File.readlines("temp/1.temp").count
      file_2_lines = File.readlines("temp/2.temp").count
      file_3_lines = File.readlines("temp/3.temp").count
      file_4_lines = File.readlines("temp/4.temp").count

      lines_sum = file_1_lines + file_2_lines + file_3_lines + file_4_lines
      out_lines = File.readlines("out").count

      expect(out_lines).to eq(lines_sum)
    end
  end
end