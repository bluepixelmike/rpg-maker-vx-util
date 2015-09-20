# encoding: UTF-8

class String
  def snake_case
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        tr(' ', '_').
        downcase
  end
end

module RPGMakerVXUtil

  # Converts scripts between RPG Maker VX format and structured plain-text files.
  module ScriptConverter
    class << self

      # Export scripts from RPG Maker VX to file(s).
      # @param project [::RPGMakerVX::Project] Project to extract scripts from.
      # @param dest [String] Path to the file or directory to write the scripts to.
      # @param options [Hash] Additional export options.
      # @option options [Symbol] :layout How the scripts are stored in their exported format.
      #   The options are:
      #   - +:dirs+ - Create a directory for each group of scripts and a single file for each script. A group is marked by having script name start with ▼ (\u25BC).
      #   - +:flat+ - Dump all scripts to a single directory. +dest+ represents the path to the directory.
      #   - +:file+ - Dump all scripts to a single file. +dest+ represents the path to the file.
      # @option options [Symbol] :line_endings Type of line ending to use.
      #   Can be either: +:crlf+ or +:lf+.
      # @option options [Boolean] :labels Flag indicating whether labels containing the script's name should be placed before each script in the file.
      #   This option only applies if +:layout+ is +:file+.
      # @return [void]
      def export(project, dest, options = { :layout => :dirs, :line_endings => :crlf, :labels => false })
        case(options[:layout])
          when :flat
            export_to_flat_files(project, dest, options)
          when :file
            export_to_single_file(project, dest, options)
          else # :dirs
            export_to_structured_files(project, dest, options)
        end
      end

      def import(project, src)
        fail NotImplementedError
      end

      private

      # Export from RPG Maker VX to files.
      # Creates a file structure containing plain-text scripts from a project.
      # @param project [::RPGMakerVX::Project] Project to extract scripts from.
      # @param dest [String] Destination directory to place the scripts in.
      #   A 'scripts' directory will be created in this directory.
      # @param options [Hash] Additional export options.
      # @option options [Symbol] :line_endings Type of line ending to use.
      #   Can be either: +:crlf+ or +:lf+.
      # @return [void]
      # @note Empty scripts will be omitted.
      def export_to_structured_files(project, dest, options = { :line_endings => :crlf })
        # Make destination directory if it doesn't already exist.
        Dir.mkdir(dest) unless Dir.exist?(dest)

        group        = ''
        group_path   = ''
        script_paths = []

        line_ending = case(options[:line_endings])
                        when :lf
                          "\n"
                        else # :crlf
                          "\r\n"
                      end

        # Skip the no-name and empty scripts.
        project.scripts.scripts.reject do |script|
          script.name.empty? && script.contents.empty?
        end.each do |script|
          if m = script.name.match(/^\u25BC\s*(.*)/)
            # This marks the beginning of a new group.
            group      = m[1].snake_case
            group_path = File.join(dest, group)
            Dir.mkdir(group_path) unless Dir.exist?(group_path)
          else
            # This is just a script.
            # Construct file name.
            name = script.name.snake_case
            file = name + '.rb'
            path = File.join(group_path, file)

            # Convert to the desired line-ending.
            contents = script.contents
            case(options[:line_endings])
              when :lf
                contents.gsub!("\r\n", "\n")
              else # :crlf
                contents.gsub!(/\r?\n/, "\r\n")
            end

            # Write the contents of the script to the file.
            File.open(path, 'wb') do |f|
              # Mark file as UTF-8.
              f.write '# encoding: UTF-8'
              f.write line_ending

              # Dump the script to the file.
              f.write contents
            end

            script_paths << "#{group}/#{name}"
          end
        end

        # Create the "include-all" script.
        top_name = File.basename(dest)
        top_file = dest + '.rb'
        File.open(top_file, 'wb') do |f|
          # Mark file as UTF-8.
          f.write '# encoding: UTF-8'
          f.write line_ending

          script_paths.each do |path|
            rel_path = File.join(top_name, path)
            f.write "require_relative '#{rel_path}'"
            f.write line_ending
          end
        end
      end

      # Export from RPG Maker VX to files.
      # Creates a file for each script from a project.
      # @param project [::RPGMakerVX::Project] Project to extract scripts from.
      # @param dest [String] Destination directory to place the scripts in.
      # @param options [Hash] Additional export options.
      # @option options [Symbol] :line_endings Type of line ending to use.
      #   Can be either: +:crlf+ or +:lf+.
      # @return [void]
      # @note Empty scripts will be omitted.
      def export_to_flat_files(project, dest, options = { :line_endings => :crlf })
        # Make destination directory if it doesn't already exist.
        Dir.mkdir(dest) unless Dir.exist?(dest)

        # Skip the empty scripts.
        script_names = project.scripts.scripts.reject do |script|
          script.contents.empty?
        end.map do |script|
          # Construct file name.
          name = script.name.snake_case
          file = name + '.rb'
          path = File.join(dest, file)

          # Convert to the desired line-ending.
          contents = script.contents
          case(options[:line_endings])
            when :lf
              contents.gsub!("\r\n", "\n")
            else # :crlf
              contents.gsub!(/\r?\n/, "\r\n")
          end

          # Write the contents of the script to the file.
          File.open(path, 'wb') do |f|
            # Mark file as UTF-8.
            f.write '# encoding: UTF-8'
            f.write line_ending

            # Dump the script to the file.
            f.write contents
          end

          name
        end

        line_ending = case(options[:line_endings])
                        when :lf
                          "\n"
                        else # :crlf
                          "\r\n"
                      end

        # Create the "include-all" script.
        top_name = File.basename(dest)
        top_file = dest + '.rb'
        File.open(top_file, 'wb') do |f|
          # Mark file as UTF-8.
          f.write '# encoding: UTF-8'
          f.write line_ending

          script_names.each do |name|
            f.write "require_relative '#{top_name}/#{name}'"
            f.write line_ending
          end
        end
      end

      # Export from RPG Maker VX to file.
      # Dumps all of the scripts from a project to a single file.
      # @param project [::RPGMakerVX::Project] Project to extract scripts from.
      # @param filename [String] Path to the file to write the scripts to.
      # @param options [Hash] Additional export options.
      # @option options [Boolean] :labels Flag indicating whether labels containing the script's name should be placed before each script in the file.
      # @option options [Symbol] :line_endings Type of line ending to use.
      #   Can be either: +:crlf+ or +:lf+.
      # @return [void]
      def export_to_single_file(project, filename, options = { :line_endings => :crlf, :labels => false })
        line_ending = case(options[:line_endings])
                        when :lf
                          "\n"
                        else # :crlf
                          "\r\n"
                      end

        File.open(filename, 'wb') do |f|
          # Mark file as UTF-8.
          f.write '# encoding: UTF-8'
          f.write line_ending

          # Write each script to the file.
          project.scripts.scripts.each do |script|
            # Prefix each script with its name.
            if options[:labels]
              f.write line_ending
              f.write "#---> #{script.name} <---"
              f.write line_ending
              f.write line_ending
            end

            # Convert to the desired line-ending.
            contents = script.contents
            case(options[:line_endings])
              when :lf
                contents.gsub!("\r\n", "\n")
              else # :crlf
                contents.gsub!(/\r?\n/, "\r\n")
            end

            # Write the script's contents.
            f.write contents
            f.write line_ending # Put a blank line between scripts.
          end
        end
      end

    end

  end

end
