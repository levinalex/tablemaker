# Tablemaker

HTML table generator that allows arbitrary nested cell subdivisions
and applies colspan/rowspan as needed.

Including the gen in your Rails project will give you a new view helper `make_table`

## Usage

    = make_table(class: 'foo') do |t|
      - t.row do
        - t.th("A")
        - t.th("B")
        - t.th("C")
      - t.row do
        - t.column do
          - t.td("E")
          - t.td("F)
      - t.td(style: 'background: green') do
        %p cell content

this will generate this output:

<table class='foo'>
  <tr>
    <td>A</td>
    <td>B</td>
    <td>C</td>
  </tr>
  <tr>
    <td>E</td>
    <td style='background: green' rowspan='2' colspan='2'><p>cell centent</p></td>
  </tr>
  <tr>
    <td>F</td>
  </tr>
</table>


source:

    <table class='foo'>
      <tr>
        <td>A</td>
        <td>B</td>
        <td>C</td>
      </tr>
      <tr>
        <td>E</td>
        <td style='background: green' rowspan='2' colspan='2'>
          <p>cell centent</p>
        </td>
      </tr>
      <tr>
        <td>F</td>
      </tr>
    </table>


## Examples outside Rails

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


