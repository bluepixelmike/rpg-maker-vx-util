require_relative 'actor_collection'

module RPGMakerVX

  # Collects all of the data-driven objects into a single interface.
  class Database

    # File extension for all data types.
    DATA_FILE_EXTENSION = '.rvdata2'

    # Name of the actors file.
    ACTORS_FILE = 'Actors' + DATA_FILE_EXTENSION

    # Provides access to actor information.
    # @return [ActorCollection]
    attr_reader :actors

    attr_reader :classes

    attr_reader :skills

    attr_reader :items

    attr_reader :weapons

    attr_reader :armors

    attr_reader :enemies

    attr_reader :troops

    attr_reader :states

    attr_reader :animations

    attr_reader :tilesets

    attr_reader :events

    attr_reader :system

    attr_reader :terms

    # Creates an database with pre-populated resources.
    # @param resources [Hash<Symbol => Object>]
    def initialize(resources)
      @actors = resources[:actors] || ActorCollection.new
    end

    # Loads the database components of a project.
    # @param path [String] Path to the 'Data' directory in the project.
    # @return [Database]
    def self.load(path)
      # Generate filepaths for each resource.
      resource_paths = {
          :actors => File.join(path, ACTORS_FILE)
      }

      # Load each resource.
      resources = {
          :actors => ActorCollection.load(resource_paths[:actors])
      }

      Database.new(resources)
    end

    # Saves all contents of the database to a project.
    # @param path [String] Path to the 'Data' directory in the project.
    # @return [void]
    def save(path)
      {
          File.join(path, ACTORS_FILE) => @actors
      }.each do |filepath, resource|
        resource.save(filepath)
      end
    end

  end

end
