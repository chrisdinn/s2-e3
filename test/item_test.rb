require 'test_helper'

class ItemTest < Test::Unit::TestCase
  
  def test_name
    item = Adventure::Item.new "ladder"
    assert_equal "ladder", item.name
  end
  
  def test_description
    description = "An old ladder. Can't support much weight"
    item = Adventure::Item.new "ladder", :description => description
    assert_equal description, item.description
  end
  
end