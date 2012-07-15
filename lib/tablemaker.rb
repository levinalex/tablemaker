require "tablemaker/version"
require 'fiber'

class Tablemaker

  class Frame
    attr_reader :parent
    def initialize(parent, idx)
      @parent = parent
      @index = idx
    end
    def last?
      return nil unless @parent
      @index == @parent.items.length-1
    end
    def dimensions
      [columns, rows]
    end
    def real_rows
      return rows unless @parent
      if @parent.is_a?(Column)
        return rows unless last?
        return rows + @parent.real_rows - @parent.rows
      else
        @parent.real_rows
      end
    end
    def real_cols
      return columns unless @parent
      if @parent.is_a?(Column)
        @parent.real_cols
      else
        return columns unless last?
        return columns + @parent.real_cols - @parent.columns
      end
    end
    def real_dimensions
      [real_cols, real_rows]
    end
  end

  class Cell < Frame
    def initialize(parent, idx, data)
      super(parent, idx)
      @data = data
    end
    def data
      @data
    end

    def cell_iterator
      yield self
      nil
    end

    def rows; 1 end
    def columns; 1 end
  end

  class Node < Frame
    attr_reader :items
    include Enumerable

    def initialize(p=nil, idx = nil)
      super
      @items = []
      yield self
    end

    def cell(*args)
      Cell.new(self, @items.length, *args).tap { |c| @items << c }
    end

    def cells
      f = Fiber.new do
        cell_iterator do |i|
          yield i
        end
        nil
      end
      f = f.resume while f && f.alive?
    end

    def each_row
      items = []
      f = Fiber.new do
        cell_iterator do |i|
          items << i
        end
        nil
      end

      while f && f.alive?
        f = f.resume
        yield items unless items.empty?
        items = []
      end
    end
  end

  class Column < Node
    def row(&blk)
      Row.new(self, @items.length, &blk).tap { |r| @items << r }
    end
    def columns
      @items.map(&:columns).max
    end
    def rows
      @items.map(&:rows).inject(&:+)
    end

    def cell_iterator(&blk)
      @items.each do |i|
        i.cell_iterator(&blk)
        Fiber.yield(Fiber.current)
      end
      nil
    end
  end

  class Row < Node
    def column(&blk)
      Column.new(self, @items.length, &blk).tap { |c| @items << c }
    end
    def columns
      @items.map(&:columns).inject(&:+)
    end
    def rows
      @items.map(&:rows).max
    end

    def cell_iterator(&blk)
      fibers = @items.map do |i|
        Fiber.new do
          i.cell_iterator(&blk)
        end
      end

      while !fibers.empty?
        fibers = fibers.map { |f| f.resume }.compact
        Fiber.yield(Fiber.current)
      end
    end
  end


  def self.column(&blk)
    Column.new(&blk)
  end
  def self.row(&blk)
    Row.new(&blk)
  end

end
