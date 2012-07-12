require "tabletree/version"

class Tabletree

  class Node
    attr_reader :items
    attr_reader :parent

    def initialize(p=nil, idx = nil)
      @parent = p
      @index = idx
      @items = []
      yield self
      self
    end

    def cell(*args)
      @items << Cell.new(self, @items.length, *args)
    end

    def cells
      @items.flat_map do |i|
        i.is_a?(Cell) ? i : i.cells
      end
    end

    def cell_at(ax,ay)
      @items.inject([ax,ay]) do |(x,y),i|
        dx = x-i.width
        dy = y-i.height
        if dx < 0 && dy < 0
          if i.is_a?(Cell)
            return i
          else
            return i.cell_at(x,y)
          end
        end
        x -= i.width if self.is_a?(Column)
        y -= i.height if self.is_a?(Row)

        [x,y]
      end
      nil
    end
  end

  class Cell
    def initialize(parent, idx, content)
      @parent = parent
      @data = content
    end

    def height
      1
    end
    def width
      1
    end

    def data
      @data
    end

    def inspect
      @data
    end
  end

  class Column < Node
    def height
      @items.map { |i| i.height }.max
    end
    def width
      @items.map { |i| i.width }.inject(&:+)
    end
    def row(&blk)
      @items << Row.new(self, @items.length, &blk)
    end
  end

  class Row < Node
    def height
      @items.map { |i| i.height }.inject(&:+)
    end
    def width
      @items.map { |i| i.width }.max
    end
    def column(&blk)
      @items << Column.new(self, @items.length, &blk)
    end
  end


  def self.column(&blk)
    Column.new(&blk)
  end

  def self.example
    Tabletree.column do |t|
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

end
