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
    valid_ingredients = @stock.inject([]) do |array, ingred_num|
      array << (ingred_num[1] / recipe.amount_required(ingred_num[0])) unless recipe.ingredients[ingred_num[0]].nil?
      array
    end
    valid_ingredients.min
  end

  def how_many_can_i_make
    how_many_of_each = @cookbook.map {|recipe| how_many_of_this?(recipe)}
    how_many = Hash.new(0)
    @cookbook.each_with_index do |recipe,index|
      how_many[recipe.name] += how_many_of_each[index]
    end
    how_many.delete_if {|ingred, num| num == 0}
  end
end
