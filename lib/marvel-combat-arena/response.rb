require 'json'

module MarvelCombatArena
  module Response
    def self.create(response_string)
      response_hash = JSON.parse(response_string)
      response_hash
    end
  end
end
