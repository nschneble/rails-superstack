class FunFacts
  FACTS = [
    "Octopuses have three hearts, and two stop beating when they swim",
    "Bananas are berries, but strawberries aren't",
    "There are more trees on Earth than stars in the Milky Way",
    "Honey never spoils",
    "Space smells like seared steak",
    "Sloths can hold their breath longer than dolphins",
    "Cheese is the most stolen food in the world",
    "Plants can hear caterpillars chewing"
  ].freeze

  def self.random
    FACTS.sample
  end
end
