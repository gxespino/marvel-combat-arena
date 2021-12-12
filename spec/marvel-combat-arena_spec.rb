require 'spec_helper'

describe MarvelCombatArena do
  subject(:marvel_combat_arena) { MarvelCombatArena }

  describe '#version' do
    it 'has a version' do
      expect(subject::VERSION).not_to be_nil
    end
  end
end
