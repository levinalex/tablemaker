require 'tablemaker/view_helpers'

module Tablemaker
  class Railtie < Rails::Railtie
    initializer "tablemaker.configure" do |app|
      ActiveSupport.on_load :action_view do
        require 'tablemaker/view_helpers'
        include Tablemaker::ViewHelpers::ActionView
      end
    end
  end
end


