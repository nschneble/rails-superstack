# Collection of fun trivia facts used in most emails

class FunFacts
  def self.random
    facts.sample
  end

  def self.facts
    @facts ||= JSON.parse(File.read(Rails.root.join("lib/data/fun_facts.json")))
  end
end
