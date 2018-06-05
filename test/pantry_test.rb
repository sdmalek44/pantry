require './lib/pantry'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/recipe'

class PantryTest < Minitest::Test
  def setup
    @pantry = Pantry.new
    @r
  end

  def test_it_has_attributes
    expected = {}
    assert_equal expected, @pantry.stock

    assert_equal 0, @pantry.stock_check("Cheese")

    @pantry.restock("Cheese", 10)
    assert_equal 10, @pantry.stock_check("Cheese")

    @pantry.restock("Cheese", 20)
    assert_equal 30, @pantry.stock_check("Cheese")
  end
  def test_it_adds_recipee_to_shopping_list
    @pantry = Pantry.new
    @r = Recipe.new("Cheese Pizza")

    @r.add_ingredient("Cheese", 20)
    @r.add_ingredient("Flour", 20)

    expected = {"Cheese" => 20, "Flour" => 20}
    assert_equal expected, @r.ingredients

    @pantry.add_to_shopping_list(@r)

    assert_equal expected, @pantry.shopping_list
  end
end
