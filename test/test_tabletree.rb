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
    @table = Tabletree.columns do |t|
      t.cell("A")
      t.rows do |r|
        r.columns do |c|
          c.cell("B")
          c.rows do |rr|
            rr.cell("D")
            rr.cell("E")
          end
        end
        r.columns do |c|
          c.cell("C")
          c.rows do |rr|
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

end
