require 'action_view'

module Tablemaker
  module ViewHelpers
    module ActionView
      class TableHelper
        def initialize(context, &block)
          @context = context
          @stack = []
          @root = Tablemaker.column do |r|
            stack(r) do
              yield self
            end
          end
        end

        def row
          current.row do |r|
            stack(r) do
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
              stack(c, &blk)
            end
          end
        end

        def td(*args, &block)
          text = if block_given?
                   @context.capture(&block)
                 else
                   args.shift
                 end
          current.cell(text, *args)
        end

        def to_html(attrs = {})
          context.content_tag("table", attrs) do
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

        def stack(frame)
          @stack.push(frame)
          yield
          @stack.pop
        end

        def context
          @context
        end

        def current
          @stack.last
        end

      end


      def make_table(opts = {}, &block)
        table = TableHelper.new(self, &block).to_html(opts)
      end
    end
  end
end
