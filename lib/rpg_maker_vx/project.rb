require_relative 'database'
require_relative 'resources/script_set'

module RPGMakerVX

  # Contains methods for accessing all information in an RPG Maker VX project.
  class Project

    # Sub-directory containing the database.
    DATABASE_SUBDIR = 'Data'.freeze

    # Name of the scripts file.
    SCRIPTS_FILE_NAME = ('Scripts' + Database::DATA_FILE_EXTENSION).freeze

    # Provides access to all of the data-driven objects.
    # Practically everything is located here except for the maps and resource files.
    # @return [Database]
    attr_reader :database

    # Provides access to the scripts.
    # @return [Resources::ScriptSet]
    attr_reader :scripts

    # Creates a new, empty RPG Maker VX project.
    # @param name [String] Name of the project.
    # @param database [Database] Existing database to use for resources.
    # @param scripts [Resources::ScriptSet] Existing set of scripts to use.
    # @note The project will not be created on disk until +#save+ is called.
    def initialize(name, database = nil, scripts = nil)
      @database = database || Database.new
      @scripts  = scripts  || Resources::ScriptSet.new
    end

    # Saves the entire project to a directory.
    # @param path [String] Path to the directory to save the project files to.
    # @return [void]
    def save(path)
      fail NotImplementedError
    end

    # Loads an RPG Maker VX project from disk.
    # @param path [String] Path to the directory containing the project files.
    # @return [Project]
    def self.load(path)
      # Load the database.
      data_path = File.join(path, DATABASE_SUBDIR)
      database  = Database.load(data_path)

      # Load the scripts
      script_path = File.join(data_path, SCRIPTS_FILE_NAME)
      scripts     = Resources::ScriptSet.load(script_path)

      Project.new('TODO', database, scripts)
    end

  end

end
