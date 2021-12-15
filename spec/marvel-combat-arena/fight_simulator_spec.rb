require 'spec_helper'

describe MarvelCombatArena::FightSimulator do
  let(:simulator) { MarvelCombatArena::FightSimulator }

  describe '.fight' do
    it 'picks the character with the longest word based on location seed' do
      fighters = [
        {
          :name => 'Doctor Strange',
          :id => 1009282,
          :description => 'Doctor Stephen Vincent Strange M.D., Ph.D is the Sorcerer Supreme and a Master of the Mystic Arts'
        },
        {
          :name => 'Hulk',
          :id => 1011358,
          :description => 'Bruce Banner was a scientist who was working on a gamma bomb when he noticed teenager Rick Jones out on the test range.'
        }
      ]
      location_seed = 4

      expect(
        simulator.fight(fighters: fighters, location_seed: location_seed).first[:name]
      ).to eq 'Doctor Strange'
    end

    it 'picks any character with the magic word "gamma"' do
      fighters = [
        {
          :name => 'Doctor Strange',
          :id => 1009282,
          :description => 'Doctor Stephen Vincent Strange M.D., Ph.D is the Sorcerer Supreme and a Master of the Mystic Arts'
        },
        {
          :name => 'Hulk',
          :id => 1011358,
          :description => 'Bruce Banner was GAMMA scientist who was working on a gamma bomb when he noticed teenager Rick Jones out on the test range.'
        }
      ]
      location_seed = 4

      expect(
        simulator.fight(fighters: fighters, location_seed: location_seed).first[:name]
      ).to eq 'Hulk'
    end

    it 'picks any character with the magic word "radioactive"' do
      fighters = [
        {
          :name => 'Doctor Strange',
          :id => 1009282,
          :description => 'Doctor Stephen Vincent Radioactive M.D., Ph.D is the Sorcerer Supreme and a Master of the Mystic Arts'
        },
        {
          :name => 'Hulk',
          :id => 1011358,
          :description => 'Bruce Banner was scientistbutlongerthan who was working on a gamma bomb when he noticed teenager Rick Jones out on the test range.'
        }
      ]
      location_seed = 4

      expect(
        simulator.fight(fighters: fighters, location_seed: location_seed).first[:name]
      ).to eq 'Hulk'
    end

    it 'accounts for empty descriptions' do
      fighters = [
        {
          :name => 'Doctor Strange',
          :id => 1009282,
          :description => 'Doctor Stephen Vincent Strange M.D., Ph.D is the Sorcerer Supreme and a Master of the Mystic Arts'
        },
        {
          :name => 'Hulk',
          :id => 1011358,
          :description => ''
        }
      ]
      location_seed = 4

      expect(
        simulator.fight(fighters: fighters, location_seed: location_seed).first[:name]
      ).to eq 'Doctor Strange'
    end

    it 'accounts for ties by returning both fighters' do
      fighters = [
        {
          :name => 'Doctor Strange',
          :id => 1009282,
          :description => 'Doctor Stephen Vincent Strange M.D., Ph.D is the Sorcerer Supreme and a Master of the Mystic Arts'
        },
        {
          :name => 'Hulk',
          :id => 1011358,
          :description => 'Bruce Banner was Strange who was working on a gamma bomb when he noticed teenager Rick Jones out on the test range.'
        }
      ]
      location_seed = 4

      expect(
        simulator.fight(fighters: fighters, location_seed: location_seed).length
      ).to eq 2
    end
  end
end
