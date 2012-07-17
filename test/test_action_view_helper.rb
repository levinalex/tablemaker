require 'helper'

describe "parsing haml example file" do
  it "should integrate with ActiveRecord::Base" do
    ActionView::Base.send(:include, Tablemaker::ViewHelpers::ActionView)
    assert_respond_to ActionView::Base.new, :make_table
  end

end
