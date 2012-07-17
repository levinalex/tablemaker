require 'action_view'
require 'tablemaker/table_helper'

module Tablemaker
  module ViewHelpers
    module ActionView

      def make_table(opts = {}, &block)
        table = TableHelper.new(self, &block).to_html(opts)
      end
    end
  end
end
