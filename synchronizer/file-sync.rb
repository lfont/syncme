require_relative '../command/rsync'

module Synchronizer
    class FileSync
        attr_accessor :dry_run
        attr_reader :src, :dest

        def initialize(src, dest)
            @src = src
            @dest = dest
            @dry_run = false
            @rsync = Command::RSync.new
        end

        def sync
            @rsync.init
            @rsync.src = @src
            @rsync.dest = @dest
            puts @rsync.opt_archive
                       .opt_verbose
                       .opt_modify_window(1)
            @rsync.exec unless @dry_run
        end
    end
end