require 'pry'

class Pantry
  attr_reader :stock, :shopping_list

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
    @cookbook = []
  end

  def restock(item, amount)
    @stock[item] += amount
  end

  def stock_check(item)
    @stock[item]
  end

  def add_to_cookbook(recipe)
    @cookbook << recipe
  end

  def add_to_shopping_list(recipe)
    @shopping_list = recipe.ingredients.inject(@shopping_list) do |hash, ingredients|
    hash[ingredients[0]] += ingredients[1]
    hash
    end
  end

  def print_shopping_list
    shopping_list = @shopping_list.inject("") do |message, list|
      message += "* #{list[0]}: #{list[1]}\n"
    end
    shopping_list.chomp
  end

  def what_can_i_make
    @cookbook.inject([]) do |array, recipe|
      array << recipe.name if can_i_make_this?(recipe)
      array
    end
  end

  def can_i_make_this?(recipe)
    recipe.ingredients.all? {|ingred, num| @stock[ingred] >= num }
  end

  def how_many_of_this?(recipe)
    recipe.ingredients.inject(0) do |sum, ingred_num|
      num_in_stock = @stock[ingred_num[0]]
      num_we_have = ingred_num[1]
      if num_we_have < num_in_stock
        num_in_stock = num_in_stock / num_we_have
        sum += 1
      end
  end
end
