class Pantry
  attr_reader :stock

  def initialize
    @stock = Hash.new(0)
  end

  def restock(item, amount)
    @stock[item] += amount
  end

  def stock_check(item)
    @stock[item]
  end
end
