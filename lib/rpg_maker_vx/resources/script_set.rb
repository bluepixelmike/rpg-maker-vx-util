require 'zlib'
require_relative 'script'

module RPGMakerVX
  module Resources

    # Collection of scripts.
    class ScriptSet

      # Individual scripts.
      # @return [Array<Script>]
      attr_reader :scripts

      # Creates a collection of scripts.
      # @param scripts [Array<Script>] Scripts to populate the collection with.
      def initialize(scripts = [])
        @scripts = scripts
      end

      # Loads a collection of scripts from a file.
      # @param filename [String] Path to the file containing scripts.
      # @return [ScriptSet]
      def self.load(filename)
        # Load the collection object.
        obj = File.open(filename, 'rb') do |f|
          Marshal.load(f)
        end

        # Validate contents.
        fail TypeError unless obj.is_a?(Array)
        obj.each do |item|
          fail TypeError unless item.is_a?(Array)
          fail TypeError if item.length != 3
          fail TypeError unless item[0].is_a?(Fixnum)
          fail TypeError unless item[1].is_a?(String)
          fail TypeError unless item[2].is_a?(String)
        end

        # Convert the contents.
        scripts = obj.map do |item|
          _, name, compressed = item
          contents = Zlib.inflate(compressed)
          Script.new(name, contents)
        end

        ScriptSet.new(scripts)
      end

      # Saves the collection of scripts to a file.
      # @param filename [String] Path to the file to save to.
      # @return [void]
      def save(filename)
        # Convert each script to a three item array.
        obj = @scripts.map do |script|
          # I honestly have no idea what this first value is.
          # It's not any checksum or hash that I know of,
          # and changing it doesn't seem to impact anything.
          magic      = script.contents.hash # Just give it a hash value.
          name       = script.name
          compressed = Zlib.deflate(script.contents)
          [magic, name, compressed]
        end

        # Dump the object to the file.
        File.open(filename, 'wb') do |f|
          f.write Marshal.dump(obj)
        end

        nil
      end

    end

  end
end
