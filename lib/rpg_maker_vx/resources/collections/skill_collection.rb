require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of skill information.
      class SkillCollection < Collection

        # Creates an empty collection of skills.
        def initialize
          super(::RPG::Skill)
        end

        # Loads a set of skills from a file.
        # @param filename [String] Path to the skills file.
        # @return [SkillCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Skill)
          collection = SkillCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
