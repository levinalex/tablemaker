require "tabletree/version"

class Tabletree

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

    def rows; 1 end
    def columns; 1 end

    def inspect
      @data
    end
  end

  class Node < Frame
    attr_reader :items

    def initialize(p=nil, idx = nil)
      super
      @items = []
      yield self
    end

    def cell(*args)
      Cell.new(self, @items.length, *args).tap { |c| @items << c }
    end

    def cells
      @items.flat_map do |i|
        i.is_a?(Cell) ? i : i.cells
      end
    end

    #   @items.inject([ax,ay]) do |(x,y),i|
    #     dx = x-i.width
    #     dy = y-i.height
    #     if dx < 0 && dy < 0
    #       if i.is_a?(Cell)
    #         return i
    #       else
    #         puts
    #         p [[i.width, i.height], i.items.inspect]
    #         return i.cell_at(x,y)
    #       end
    #     end
    #     x -= i.width if self.is_a?(Column)
    #     y -= i.height if self.is_a?(Row)

    #     [x,y]
    #   end
    #   nil
    # end

    def inspect
      "#{self.class.name.split("::").last[0]}#{@items.inspect}"
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

  end


  def self.column(&blk)
    Column.new(&blk)
  end

  def self.row(&blk)
    Row.new(&blk)
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
