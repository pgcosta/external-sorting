describe QuickSortWorker do
  it "should sort and array of 10 Strings" do
    lines = []
    lines << "My dogs are beautiful"
    lines << "42 is the answer to everything"
    lines << "lorem ipsum"
    lines << "emmit remmus"
    lines << "I'm with you"
    lines << "The getaway"
    lines << "Around the world"
    lines << "Breaking the girl"
    lines << "Can't stop"
    lines << "Under the bridge"

    sorted_lines = QuickSortWorker.sort(lines)

    expect(sorted_lines.size).to eq(lines.size)
    expect(sorted_lines).to eq(lines.sort)
  end

  describe "special cases" do
    it "should sort capital letters first than lowercase" do
      lines = []
      lines << "amelie"
      lines << "Amelie"

      sorted_lines = QuickSortWorker.sort(lines)
      expect(sorted_lines).to eq(lines.sort)
      expect(sorted_lines[0]).to eq("Amelie")
    end
  end
end