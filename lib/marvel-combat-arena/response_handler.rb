module MarvelCombatArena
  module ResponseHandler
    def self.characters(response_hash)
      response_hash['data']['results'].map do |character|
        {
          :name => character['name'],
          :id => character['id'],
          :description => character['description']
        }
      end
    end
  end
end
