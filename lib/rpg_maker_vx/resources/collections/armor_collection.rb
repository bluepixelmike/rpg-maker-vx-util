require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of armor information.
      class ArmorCollection < Collection

        # Creates an empty collection of armors.
        def initialize
          super(::RPG::Armor)
        end

        # Loads a set of armors from a file.
        # @param filename [String] Path to the armors file.
        # @return [ArmorCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Armor)
          collection = ArmorCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
