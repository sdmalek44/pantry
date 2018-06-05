require 'pry'

class Pantry
  attr_reader :stock, :shopping_list

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
  end

  def restock(item, amount)
    @stock[item] += amount
  end

  def stock_check(item)
    @stock[item]
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
end
