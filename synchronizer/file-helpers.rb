require_relative '../command/iconv'

module Synchronizer::FileHelpers
    def delete_file(file)
        puts "deleting file: #{file}"
        File.delete(file) unless @dry_run
    end

    def move_file(old_file, new_file)
        puts "moving file: #{old_file} to: #{new_file}"
        File.rename(old_file, new_file) unless @dry_run
    end

    def convert_file(file, from_code, to_code)
        puts "converting file: #{file} from: #{from_code} to: #{to_code}"
        iconv = Command::Iconv.new
        iconv.src = file
        iconv.dest = "#{file}.tmp"
        puts iconv.opt_from_code(from_code)
                  .opt_to_code(to_code)
        iconv.exec unless @dry_run
        delete_file(iconv.src)
        move_file(iconv.dest, iconv.src)
    end

    def appendto_filename(file, part)
        extname = File.extname(file)
        prefix = file.sub(Regexp.new("#{extname}$"), '')
        new_name = prefix + part + extname
        move_file(file, new_name)
    end

    def each_files(*patterns)
        files = Dir[*patterns]
        if block_given?
            files.each do |file|
                yield file
            end
        end
        files.length
    end
end
