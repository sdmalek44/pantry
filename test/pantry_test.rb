require_relative 'test_helper'
require './lib/pantry'
require './lib/recipe'

class PantryTest < Minitest::Test
  def setup
    @pantry = Pantry.new
    
    @r1 = Recipe.new("Cheese Pizza")
    @r1.add_ingredient("Cheese", 20)
    @r1.add_ingredient("Flour", 20)

    @r2 = Recipe.new("Pickles")
    @r2.add_ingredient("Brine", 10)
    @r2.add_ingredient("Cucumbers", 30)

    @r3 = Recipe.new("Peanuts")
    @r3.add_ingredient("Raw nuts", 10)
    @r3.add_ingredient("Salt", 10)
  end

  def test_it_exists
    assert_instance_of Pantry, @pantry
  end

  def test_it_has_attributes
    expected = {}
    assert_equal expected, @pantry.stock

    assert_equal 0, @pantry.stock_check("Cheese")

    assert_equal 10, @pantry.restock("Cheese", 10)
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

    @r_2 = Recipe.new("Spaghetti")
    @r_2.add_ingredient("Spaghetti Noodles", 10)
    @r_2.add_ingredient("Marinara Sauce", 10)
    @r_2.add_ingredient("Cheese", 5)

    @pantry.add_to_shopping_list(@r_2)
    expected = {"Cheese" => 25, "Flour" => 20, "Spaghetti Noodles" => 10, "Marinara Sauce" => 10}
    assert_equal expected, @pantry.shopping_list

    printed = "* Cheese: 25\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
    assert_equal printed, @pantry.print_shopping_list
  end

  def test_what_i_can_make_and_how_many
    @pantry = Pantry.new

    assert_equal [@r1], @pantry.add_to_cookbook(@r1)
    @pantry.add_to_cookbook(@r2)
    @pantry.add_to_cookbook(@r3)

    @pantry.restock("Cheese", 10)
    @pantry.restock("Flour", 20)
    @pantry.restock("Brine", 40)
    @pantry.restock("Cucumbers", 120)
    @pantry.restock("Raw nuts", 20)
    @pantry.restock("Salt", 20)

    expected = ["Pickles", "Peanuts"]
    assert_equal expected, @pantry.what_can_i_make

    refute @pantry.can_i_make_this?(@r1)
    assert @pantry.can_i_make_this?(@r2)

    assert_equal 0, @pantry.how_many_of_this?(@r1)
    assert_equal 4, @pantry.how_many_of_this?(@r2)

    expected = {"Pickles" => 4, "Peanuts" => 2}
    assert_equal expected, @pantry.how_many_can_i_make
  end
end
