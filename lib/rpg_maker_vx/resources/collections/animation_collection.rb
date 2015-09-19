require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of animation information.
      class AnimationCollection < Collection

        # Creates an empty collection of animations.
        def initialize
          super(::RPG::Animation)
        end

        # Loads a set of animations from a file.
        # @param filename [String] Path to the animations file.
        # @return [AnimationCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Animation)
          collection = AnimationCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
