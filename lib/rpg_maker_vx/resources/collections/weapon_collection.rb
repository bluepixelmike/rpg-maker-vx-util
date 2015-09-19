require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of weapon information.
      class WeaponCollection < Collection

        # Creates an empty collection of weapons.
        def initialize
          super(::RPG::Weapon)
        end

        # Loads a set of weapons from a file.
        # @param filename [String] Path to the weapons file.
        # @return [WeaponCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Weapon)
          collection = WeaponCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
