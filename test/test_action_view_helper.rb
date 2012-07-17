require 'helper'

class TestTableMaker < ActionView::TestCase
  include Tablemaker::ViewHelpers::ActionView

  setup do
    ActionView::Base.send(:include, Tablemaker::ViewHelpers::ActionView)
  end

  test "should integrate with ActiveRecord::Base" do
    assert_respond_to ActionView::Base.new, :make_table
  end

  test "should output simple table correctly" do
    table = make_table do |t|
            t.row do
              t.td("A")
              t.td("B")
            end
          end

    expected = "<table><tr><td>A</td><td>B</td></tr></table>"
    assert_dom_equal expected, table
  end

  test "should output simple table starting with columns correctly" do
    table = make_table do |t|
            t.column do
              t.td("A")
              t.td("B")
            end
          end

    expected = "<table><tr><td>A</td></tr><tr><td>B</td></tr></table>"
    assert_dom_equal expected, table
  end

  test "should output complex table correctly" do
    table = make_table do |t|
      t.row do
        t.td("A")
        t.td("B")
        t.td("C")
      end
      t.row do
        t.column do
          t.td("E")
          t.td("F")
        end
        t.td("G")
      end
    end

    expected = "<table>" +
                 "<tr><td>A</td><td>B</td><td>C</td></tr>" +
                 "<tr><td>E</td><td rowspan=2 colspan=2>G</td></tr>" +
                 "<tr><td>F</td></tr>" +
               "</table>"

    assert_dom_equal expected, table
  end
end
