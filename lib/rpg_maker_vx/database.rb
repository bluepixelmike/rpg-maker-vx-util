require_relative 'database'

module RPGMakerVX

  # Collects all of the data-driven objects into a single interface.
  class Database

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

  end

end
