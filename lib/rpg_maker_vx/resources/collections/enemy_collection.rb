require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of enemy information.
      class EnemyCollection < Collection

        # Creates an empty collection of enemies.
        def initialize
          super(::RPG::Enemy)
        end

        # Loads a set of enemies from a file.
        # @param filename [String] Path to the enemies file.
        # @return [EnemyCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Enemy)
          collection = EnemyCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
