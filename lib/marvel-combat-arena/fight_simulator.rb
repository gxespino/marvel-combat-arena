module MarvelCombatArena
  module FightSimulator
    def self.fight(fighters:, location_seed:)
      fighters.inject({}) do |memo, fighter|
        word = fighter[:description].split(" ")[location_seed - 1].to_s

        larger = lambda do |word|
          return true if memo.empty?
          current_word = memo.first[:description].split(" ")[location_seed - 1].to_s
          word.length > current_word.length
        end

        equal = lambda do |word|
          return false if memo.empty?
          current_word = memo.first[:description].split(" ")[location_seed - 1].to_s
          word.length == current_word.length
        end

        memo = case word.downcase
               when larger        then [fighter]
               when 'gamma'       then [fighter]
               when 'radioactive' then [fighter]
               when equal         then fighters
               else memo
               end

        memo
      end
    end
  end
end
