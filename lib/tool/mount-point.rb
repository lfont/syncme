require_relative '../command/mount'

module SyncMe::Tool
    class MountPoint
        attr_accessor :dry_run
        attr_reader :location, :path

        def initialize(location)
            @location = location
            @path = nil
            @dry_run = false
            mount_type!
            mount_path!
            @mount = SyncMe::Command::Mount.new
        end

        def mount_type!
            @mount_type = nil
        end

        def mount_path!
            @mount_path = nil
        end

        def mounted?
            @path != nil
        end

        def mount
            puts "mounting #{@location}"
            if @mount_type
                # create @mount_path
                @mount.src = location
                @mount.dest = @mount_path
                @mount.t(@mount_type)
                @mount.exec unless @dry_run
            else
                @path = @location
            end
        end

        def unmount
            puts "unmounting #{@location}"
            if @mount_type
                # TODO umount
                # delete @mount_path
            end
            @path = nil
        end

        private :mount_type!, :mount_path!
    end
end
