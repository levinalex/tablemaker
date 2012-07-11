# Tabletree

HTML table generator that allows arbitrary nested cell subdivisions
and applies colspan/rowspan as needed.

A very basic table:

    +---+---+
    | A | B |
    +---+---+
    | C | D |
    +---+---+

    Tabletree.row do |r|
      t.column do |r1|
        r1.cell("A")
        r1.cell("B")
      end
      r.column do |r2|
        r2.cell("C")
        r2.cell("D")
      end
    end

    # but you can also start with columns and construct the table left-to-right. this produces the exact same result:

    Tabletree.column do |c|
      t.row do |c1|
        c1.cell("A")
        c2.cell("C")
      end
      t.row do |c2|
        c2.cell("B")
        c2.cell("D")
      end
    end


A more advanced example:

    +---+---+---+
    |   |   | D |
    +   + B +---+
    |   |   | E |
    + A +---+---+
    |   |   | F |
    +   + C +---+
    |   |   | G |
    +---+---+---+


    table = Tabletree.column do |t|
      t.cell("A")
      t.row do |r|
        r.column do |c|
          c.cell("B")
          c.row do |rr|
            rr.cell("D")
            rr.cell("E")
          end
        end
        r.column do |c|
          c.cell("C")
          c.row do |rr|
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


Tabletree keeps track of all the rowspan/colspan attributes required to generate a valid HTML table

## Installation

Add this line to your application's Gemfile:

    gem 'tabletree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tabletree

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
