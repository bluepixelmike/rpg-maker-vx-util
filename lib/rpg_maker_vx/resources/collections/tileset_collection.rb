require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of tileset information.
      class TilesetCollection < Collection

        # Creates an empty collection of tilesets.
        def initialize
          super(::RPG::Tileset)
        end

        # Loads a set of tilesets from a file.
        # @param filename [String] Path to the tilesets file.
        # @return [TilesetCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Tileset)
          collection = TilesetCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
