require 'pry'
class Museum
  attr_reader :name, :exhibits, :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    recommendation = []
    @exhibits.each do |exhibit|
      if patron.interests.any?(exhibit.name)
        recommendation << exhibit
      end
    end
    recommendation
  end

  def lowest_cost
    costs = @exhibits.map do |exhibit|
      exhibit.cost
    end
    sorted = costs.sort
    sorted.shift
  end

  def admit(patron)
    if patron.spending_money >= lowest_cost
      @patrons << patron
    end
  end

  def patrons_by_exhibit_interest
    @exhibits.reduce({}) do |acc, exhibit|
      acc[exhibit] = patrons.select do |patron|
        patron.interests.include?(exhibit.name)
      end
      acc
    end
  end

  def ticket_lottery_contestants(exhibit)
    @patrons.select do |patron|
      patron.spending_money < exhibit.cost
    end
  end

  def draw_lottery_winner(exhibit)
    ticket_lottery_contestants(exhibit).sample
  end
end
