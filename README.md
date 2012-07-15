# Tablemaker

HTML table generator that allows arbitrary nested cell subdivisions
and applies colspan/rowspan as needed.

## Examples

A very basic table:

    # +---+---+
    # | A | B |
    # +---+---+
    # | C | D |
    # +---+---+
    #
    @table2 = Tablemaker.column do |c|
      c.row do |r|
        r.cell("A")
        r.cell("B")
      end
      c.row do |r|
        @c2 = r.cell("C")
        @d2 = r.cell("D")
      end
    end

    # but you can also start with columns and construct the table left-to-right. this produces the exact same result:
    #
    Tablemaker.row do |r|
      r.column do |c|
        c.cell("A")
        c.cell("C")
      end
      r.column do |c|
        c.cell("B")
        c.cell("D")
      end
    end

A more advanced example:

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
      t.cell("A")
      t.column do |r|
        r.row do |c|
          c.column do |rr|
            rr.cell("B")
            rr.cell("D")
          end
          c.cell("C")
        end
        r.row do |c|
          c.cell("E")
          c.column do |rr|
            rr.cell("F")
            rr.cell("G")
          end
        end
      end
    end


this will generate the following output:

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


Tablemaker keeps track of all the rowspan/colspan attributes required to generate a valid HTML table

## Installation

Add this line to your application's Gemfile:

    gem 'tablemaker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tablemaker


