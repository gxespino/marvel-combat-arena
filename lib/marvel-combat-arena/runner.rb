require 'tty-prompt'
require 'tty-progressbar'
require_relative 'client'
require_relative 'response_handler'
require_relative 'fight_simulator'

module MarvelCombatArena
  class Runner
    def initialize
      @client = MarvelCombatArena::Client.new
      @handler = MarvelCombatArena::ResponseHandler
      @simulator = MarvelCombatArena::FightSimulator
      @prompt = TTY::Prompt.new
      @pastel = Pastel.new
    end

    attr_reader :client, :handler, :simulator, :prompt, :pastel

    def run
      puts pastel.magenta title
      puts pastel.cyan "Let's first see if you have access to the arena...\n"

      public_key  = prompt.ask("What is your public_key?")
      private_key = prompt.ask("What is your private_key?")

      loading msg: "Connecting to the arena..."

      client.set_keys!(
        public_key: public_key,
        private_key: private_key
      )

      response = client.characters(random_subset: true)

      if response.is_a? MarvelCombatArena::Response::Error
        puts pastel.red("Looks like something went wrong trying to access the Marvel Combat Arena.")
        puts pastel.red("Make sure your public_key and private_key are correct and try again later...")
      else
        puts pastel.bright_green("Connected!")
        loading msg: "Retrieving today's fighters..."
        puts pastel.bright_green("Found 20 fighters!\n")

        characters = handler.characters(response)

        char1 = prompt.select("Choose the first fighter:") do |menu|
          characters.each do |character|
            menu.choice character[:name], character[:id]
          end
        end

        # Remove already selected character
        updated_characters = characters.reject do |char|
          char[:id] == char1
        end

        char2 = prompt.select("Choose the second fighter:") do |menu|
          updated_characters.each do |character|
            menu.choice character[:name], character[:id]
          end
        end

        # Seed functionality based on fight location
        location = prompt.select("Where shall they fight?") do |menu|
          menu.choice "Suzuki Castle", 1
          menu.choice "Air Force Base", 2
          menu.choice "Ayutthaya Ruins", 3
          menu.choice "Lair of the Four Kings", 4
          menu.choice "Metro City Bay Area", 5
          menu.choice "English Manor", 6
          menu.choice "Apprentice Alley", 7
          menu.choice "Crumbling Laboratory", 8
          menu.choice "Random Stage", 9
        end

        fighters = characters.select do |char|
          [char1, char2].include? char[:id]
        end

        fight_result = simulator.fight(
          fighters: fighters,
          location_seed: location
        )

        loading msg: "#{fighters[0][:name]} and #{fighters[1][:name]} are FIGHTING!"

        if fight_result.length == 1
          puts pastel.bright_green("The winner is #{fight_result.first[:name]}!\n\n")
        else
          puts pastel.bright_green("The fight was a TIE! Neither fighter had anything to say...\n")
          puts pastel.yellow("Fight Details: \n#{fight_result[0]}\n#{fight_result[1]}")
        end
      end
    end

    private

    def title
      <<-TITLE

█▀▄▀█ ▄▀█ █▀█ █░█ █▀▀ █░░
█░▀░█ █▀█ █▀▄ ▀▄▀ ██▄ █▄▄

█▀▀ █▀█ █▀▄▀█ █▄▄ ▄▀█ ▀█▀
█▄▄ █▄█ █░▀░█ █▄█ █▀█ ░█░

▄▀█ █▀█ █▀▀ █▄░█ ▄▀█
█▀█ █▀▄ ██▄ █░▀█ █▀█

      TITLE
    end

    def loading(msg:)
      puts "\n"
      bar = TTY::ProgressBar.new("#{pastel.cyan(msg)} [:bar]", head: ">", total: 15, hide_cursor: true)
      15.times do
        sleep([0.1, 0.2].sample)
        bar.advance(2)
      end
    end
  end
end
