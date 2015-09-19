require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of state information.
      class StateCollection < Collection

        # Creates an empty collection of states.
        def initialize
          super(::RPG::State)
        end

        # Loads a set of states from a file.
        # @param filename [String] Path to the states file.
        # @return [StateCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::State)
          collection = StateCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
