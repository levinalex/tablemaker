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
    table = make_table(class: "table") do |t|
            t.row do
              t.th("A", style: "color: red")
              t.td("B")
            end
          end

    expected = "<table class='table'><tr><th style='color: red'>A</th><td>B</td></tr></table>"
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

  test "should have generic 'line' method that alternates between rows and columns" do
    table = make_table do |t|
      t.line do
        t.line do
          t.line do
            t.td("A")
            t.td("B")
          end
        end
        t.line do
          t.td("C")
          t.td("D")
        end
      end
      t.line do
        t.td("E")
        t.td("F")
      end
    end

    expected = "<table>" +
                 "<tr><td rowspan=2>A</td><td rowspan=2>B</td><td>C</td></tr>" +
                 "<tr><td>D</td></tr>" +
                 "<tr><td>E</td><td colspan=2>F</td></tr>" +
               "</table>"

    assert_dom_equal expected, table
  end
end
