require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of troop information.
      class TroopCollection < Collection

        # Creates an empty collection of troops.
        def initialize
          super(::RPG::Troop)
        end

        # Loads a set of troops from a file.
        # @param filename [String] Path to the troops file.
        # @return [TroopCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Troop)
          collection = TroopCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
