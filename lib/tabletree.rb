require "tabletree/version"

class Tabletree

  class Node
    def initialize
      @items = []
      yield self
      self
    end

    def cell(*args)
      @items << Cell.new(*args)
    end
  end

  class Cell
    def initialize(content)
      @data = content
    end

    def height
      1
    end

    def width
      1
    end

    def inspect
      @data
    end
  end

  class Row < Node
    def row(&blk)
      @items << Column.new(&blk)
    end

    def height
      @items.map { |i| i.height }.max
    end
    def width
      @items.map { |i| i.width }.inject(&:+)
    end
  end

  class Column < Node
    def height
      @items.map { |i| i.height }.inject(&:+)
    end
    def width
      @items.map { |i| i.width }.max
    end

    def column(&blk)
      @items << Row.new(&blk)
    end
  end


  def self.column(&blk)
    Row.new(&blk)
  end

end
