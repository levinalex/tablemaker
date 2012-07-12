require 'helper'


describe "tabletree" do
  it "should work" do

  end


  HTML = <<-EOF
    <table>
      <tr>
        <td rowspan=4>A</td>
        <td rowspan=2>B</td>
        <td>D</td>
      </tr>
      <tr>
        <td>E</td>
      </tr>
      <tr>
        <td rowspan=2>C</td>
        <td>F</td>
      </tr>
      <tr>
        <td>G</td>
      </tr>
    </table>
  EOF
end


describe "the example" do
  before do

    @table = Tabletree.column do |t|
      t.cell("A")
      t.row do |r|
        r.column do |c|
          c.row do |rr|
            rr.cell("B")
            rr.cell("D")
          end
          c.cell("C")
        end
        r.column do |c|
          c.cell("E")
          c.row do |rr|
            rr.cell("F")
            rr.cell("G")
          end
        end
      end
    end
  end

  it "should compile without errors" do
    assert @table
    assert_kind_of Tabletree::Node, @table
  end

  it "should have dimensions of 3/4" do
    assert_equal 4, @table.height
    assert_equal 3, @table.width
  end

  it "should have correct dimensions for subitems" do
    assert_equal [1, 4], @table.items.map(&:height)
    assert_equal [2, 2], @table.items.last.items.map(&:height)
  end

  it "should return all the cells" do
    assert_equal 7, @table.cells.length
  end

  it "should have cell_at" do
    assert_equal "A", @table.cell_at(0,0).data
    assert_equal "B", @table.cell_at(1,0).data
    assert_equal "C", @table.cell_at(2,0).data
    assert_equal "D", @table.cell_at(1,1).data
    assert_equal "E", @table.cell_at(1,2).data
    assert_equal "F", @table.cell_at(2,2).data
    assert_equal "G", @table.cell_at(2,3).data
  end

end
