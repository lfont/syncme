require_relative '../command/rsync'
require_relative '../tool/mount-point'

module SyncMe::Synchronizer
    class FileSync
        attr_accessor :dry_run
        attr_reader :config, :src, :dest

        def initialize(config, src, dest)
            @config = config
            @src = SyncMe::Tool::MountPoint.new(src)
            @dest = SyncMe::Tool::MountPoint.new(dest)
            @dry_run = false
            @rsync = SyncMe::Command::RSync.new

            before_sync do 
                @src.mount unless @src.mounted?
                @dest.mount unless @dest.mounted?
                @src.dry_run = @dry_run
                @dest.dry_run = @dry_run
            end

            after_sync do
                @src.unmount if @src.mounted?
                @dest.unmount if @dest.mounted?
            end
        end

        def before_sync(&proc)
            (@before_sync ||= []) << proc
        end

        def after_sync(&proc)
            (@after_sync ||= []) << proc
        end

        def self.trigger(events)
            if events
                events.each { |e| e.call }
            end
        end

        def sync
            FileSync.trigger(@before_sync)

            @rsync.init
            @rsync.src = @src.path
            @rsync.dest = @dest.path
            puts @rsync.opt_archive
                       .opt_verbose
                       .opt_modify_window(1)
            @rsync.exec unless @dry_run

            FileSync.trigger(@after_sync)
        end

        private :before_sync, :after_sync
    end
end
