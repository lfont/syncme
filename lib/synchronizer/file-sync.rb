require_relative '../command/rsync'

module SyncMe::Synchronizer
    class FileSync
        attr_accessor :dry_run
        attr_reader :config, :src, :dest

        def initialize(config, src, dest)
            @config = config
            @src = src
            @dest = dest
            @dry_run = false
            @rsync = SyncMe::Command::RSync.new
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