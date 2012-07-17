require 'action_view'

module Tablemaker
  module ViewHelpers
    module ActionView
      class TableHelper
        def initialize(&block)
          @stack = []
          @root = Tablemaker.column do |r|
            with_context(r) do
              yield self
            end
          end
        end

        def row
          current.row do |r|
            with_context(r) do
              yield
            end
          end
        end

        def column(&blk)
          if @stack.size == 1
            row do
              column(&blk)
            end
          else
            current.column do |c|
              with_context(c, &blk)
            end
          end
        end

        def td(*args)
          current.cell(*args)
        end

        def to_html(context, attrs = {})
          context.content_tag("table") do
            @root.each_row do |r|
              s = context.content_tag("tr") do
                r.each do |c|
                  attrs = {}
                  attrs[:rowspan] = c.real_rows if c.real_rows > 1
                  attrs[:colspan] = c.real_cols if c.real_cols > 1
                  s2 = context.content_tag("td", attrs) do
                    c.data
                  end

                  context.concat(s2)
                end
              end
              context.concat(s)
            end
          end
        end


        private

        def with_context(frame)
          @stack.push(frame)
          yield
          @stack.pop
        end

        def current
          @stack.last
        end

      end


      def make_table(opts = {}, &block)
        table = TableHelper.new(&block).to_html(self)
      end
    end
  end
end
