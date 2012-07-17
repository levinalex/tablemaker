require 'helper'


def assert_table_structure(structure, table)
  structure = structure

  t = []
  table.each_row do |row|
    r = []
    row.each do |cell|
      r << cell
    end
    t << r
  end
  assert_equal structure, t
end

describe "an example table" do
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
    @table = Tablemaker.row do |t|
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
    assert_kind_of Tablemaker::Node, @table
  end

  it "should return a Row for #row" do
    assert_kind_of Tablemaker::Row, @row
    assert_equal 2, @row.rows
  end

  it "should return a Column for #column" do
    assert_kind_of Tablemaker::Column, @col
    assert_equal 1, @col.columns
    assert_equal 2, @col.rows
  end

  it "items should have correct dimensions" do
    assert_equal 4, @table.rows
    assert_equal 3, @table.columns
  end

  it "should have real dimensions for cells" do
    assert_equal [1,4], @a.real_dimensions
  end

  it "should yield cells in the correct order" do
    assert_equal [@a, @b, @c, @d, @e, @f, @g], @table.to_enum(:cells).to_a
  end

  it "should allow iteration over rows/cols" do
    assert_table_structure [[@a, @b, @c], [@d], [@e, @f], [@g]], @table
  end
end

describe "a simple column" do
  before do
    @col = Tablemaker.column do |c|
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
    @col = Tablemaker.column do |c|
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
    @table = Tablemaker.column do |t|
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
    @table = Tablemaker.column do |t|
      @r1 = t.row do |r1|
        @a = r1.cell("A")
        @b = r1.cell("B")
        @c = r1.cell("C")
      end
      @r2 = t.row do |r2|
        @c1 = @c1 = r2.column do |c1|
          @d = c1.cell("D")
          @e = c1.cell("E")
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
    assert_equal [2,2], @f.real_dimensions
  end

  it "should iterate correctly over subitems" do
    assert_equal [@a, @b, @c], @r1.to_enum(:cells).to_a
    assert_equal [@d, @f, @e], @r2.to_enum(:cells).to_a
    assert_equal [@a, @b, @c, @d, @f, @e], @table.to_enum(:cells).to_a
  end


  it "should allow iteration over rows/cols" do
    assert_table_structure [[@a, @b, @c], [@d, @f], [@e]], @table
  end
end

describe "starting with rows or columns does not matter" do

  before do
    @table1 = Tablemaker.row do |r|
      r.column do |c|
        @a1 = c.cell("A")
        @c1 = c.cell("C")
      end
      r.column do |c|
        @b1 = c.cell("B")
        @d1 = c.cell("D")
      end
    end

    @table2 = Tablemaker.column do |c|
      c.row do |r|
        @a2 = r.cell("A")
        @b2 = r.cell("B")
      end
      c.row do |r|
        @c2 = r.cell("C")
        @d2 = r.cell("D")
      end
    end
  end

  it "should have correct structure" do
    assert_table_structure [[@a1, @b1], [@c1, @d1]], @table1
    assert_table_structure [[@a2, @b2], [@c2, @d2]], @table2
  end
end

