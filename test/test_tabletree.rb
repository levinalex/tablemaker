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

    # +---+---+---+
    # |   | B |   |
    # |   +---+ C |
    # |   | D |   |
    # | A +---+---+
    # |   |   | F |
    # |   | E +---+
    # |   |   | G |
    # +---+---+---+
    #
    @table = Tabletree.row do |t|
      @a = t.cell("A")
      t.column do |r|
        @row = r.row do |c|
          @col = c.column do |rr|
            @b = rr.cell("B")
            @d = rr.cell("D")
          end
          @c = c.cell("C")
        end
        r.row do |c|
          @e = c.cell("E")
          c.column do |rr|
            @f = rr.cell("F")
            @g = rr.cell("G")
          end
        end
      end
    end
  end

  it "should compile without errors" do
    assert @table
    assert_kind_of Tabletree::Node, @table
  end

  it "should return a Row for #row" do
    assert_kind_of Tabletree::Row, @row
    assert_equal 2, @row.rows
  end

  it "should return a Column for #column" do
    assert_kind_of Tabletree::Column, @col
    assert_equal 1, @col.columns
    assert_equal 2, @col.rows
  end

  it "items should have correct dimensions" do
    assert_equal 4, @table.rows
    assert_equal 3, @table.columns
  end
end


describe "a simple column" do
  before do
    @col = Tabletree.column do |c|
      c.cell("A")
      c.cell("B")
    end
  end

  it "should have 2 rows, 1 column" do
    assert_equal 2, @col.rows
    assert_equal 1, @col.columns
  end
end

describe "nested columns" do
  before do
    @col = Tabletree.column do |c|
      c.cell("A")
      @row = c.row do |r|
        r.column do |c2|
          c2.cell("B")
          c2.cell("C")
        end
      end
    end
  end

  it "should have 3 rows, 1 column" do
    assert_equal 3, @col.rows
    assert_equal 1, @col.columns
  end
end

describe "simple 3/2" do
  before do

    # +---+---+---+
    # | A | B | C |
    # +---+---+---+
    # | D |   E   |
    # +---+-------+
    #
    @table = Tabletree.column do |t|
      @r1 = t.row do |r1|
        @a = r1.cell("A")
        @b = r1.cell("B")
        @c = r1.cell("C")
      end
      @r2 = t.row do |r2|
        @d = r2.cell("D")
        @e = r2.cell("E")
      end
    end
  end
end

describe "spanning cols/rows at the same time" do
  before do

    # +---+---+---+
    # | A | B | C |
    # +---+---+---+
    # | D |       |
    # +---+   F   |
    # | E |       |
    # +---+-------+
    #
    @table = Tabletree.column do |t|
      @r1 = t.row do |r1|
        @a = r1.cell("A")
        @b = r1.cell("B")
        @c = r1.cell("C")
      end
      @r2 = t.row do |r2|
        @c1 = @c1 = r2.column do |c1|
          @d = c1.cell("D")
          c1.cell("E")
        end
        @c2 = r2.column do |c2|
          @f = c2.cell("F")
        end
      end
    end
  end

  it "should correctly identify last cols" do
    assert !@r1.last?, "r1 is not last col"
    assert @r2.last?, "r2 is last col"
  end

  it "should have correct dimensions on items" do
    assert_equal [3,3], @table.dimensions
    assert_equal [3,1], @r1.dimensions
    assert_equal [1,1], @a.dimensions
    assert_equal [3,2], @r2.real_dimensions
    assert_equal [1,2], @c1.real_dimensions
    assert_equal [2,2], @c2.real_dimensions
  end

end

  # it "should have correct dimensions for subitems" do
  #   # assert_equal [1, 4], @table.items.map(&:height)
  #   # assert_equal [2, 2], @table.items.last.items.map(&:height)
  # end

  # it "should return all the cells" do
  #   assert_equal 7, @table.cells.length
  # end

  # it "should have cell_at" do
  #   assert_equal "A", @table.cell_at(0,0).data
  #   assert_equal "B", @table.cell_at(1,0).data
  #   assert_equal "C", @table.cell_at(2,0).data
  #   assert_equal "D", @table.cell_at(1,1).data
  #   assert_equal "E", @table.cell_at(1,2).data
  #   assert_equal "F", @table.cell_at(2,2).data
  #   assert_equal "G", @table.cell_at(2,3).data
  # end

  # it "should have correct cell dimensions" do
  #   # assert_equal [1,4], @table.cell_at(0,0).dimensions

  # end

