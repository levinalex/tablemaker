require "tablemaker/version"
require "tablemaker/frame"
require 'fiber'

module Tablemaker
  def self.column(&blk)
    Column.new(&blk)
  end
  def self.row(&blk)
    Row.new(&blk)
  end

end

require 'tablemaker/railtie' if defined?(Rails)
