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
    ingredients = recipe.ingredients
    @shopping_list = ingredients.inject(@shopping_list) do |hash, ingredient|
    hash[ingredient[0]] += ingredient[1]
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
    @stock.inject([]) do |array, ingred_num|
      unless recipe.ingredients[ingred_num[0]].nil?
        array << (ingred_num[1] / recipe.amount_required(ingred_num[0]))
      end
      array
    end.min
  end

  def how_many_can_i_make
    @cookbook.inject(Hash.new(0)) do |hash, recipe|
      hash[recipe.name] += how_many_of_this?(recipe)
      hash
    end.delete_if {|ingred, num| num == 0}
  end

end
