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

    def min_height
      @items.map(&:min_height).max
    end
    def min_width
      @items.map(&:min_width).max
    end
    def max_height
      @parent ?  @parent.max_height : min_height
    end
    def max_width
      @parent ?  @parent.max_width : min_width
    end

    def height
      min_height
    end
    def width
      min_width
    end

    def cell_at(ax,ay)
      @items.inject([ax,ay]) do |(x,y),i|
        dx = x-i.width
        dy = y-i.height
        if dx < 0 && dy < 0
          if i.is_a?(Cell)
            return i
          else
            puts
            p [[i.width, i.height], i.items.inspect]
            return i.cell_at(x,y)
          end
        end
        x -= i.width if self.is_a?(Column)
        y -= i.height if self.is_a?(Row)

        [x,y]
      end
      nil
    end

    def inspect
      "#{self.class.name.split("::").last[0]}#{@items.inspect}"
    end
  end

  class Cell
    def initialize(parent, idx, content)
      @parent = parent
      @data = content
    end

    def min_height
      1
    end
    def min_width
      1
    end
    def max_height
      @parent.max_height
    end
    def max_width
      @parent.max_width
    end
    def height
      @parent.min_height
    end
    def width
      @parent.min_width
    end
    def dimensions
      [width, height]
    end

    def data
      @data
    end

    def inspect
      @data
    end
  end

  class Column < Node
    def min_height
      @items.map { |i| i.min_height }.max
    end
    def min_width
      @items.map { |i| i.min_width }.inject(&:+)
    end
    def row(&blk)
      @items << Row.new(self, @items.length, &blk)
    end
  end

  class Row < Node
    def min_height
      @items.map { |i| i.min_height }.inject(&:+)
    end
    def min_width
      @items.map { |i| i.min_width }.max
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
