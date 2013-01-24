require_relative 'shell-command'

module SyncMe::Command
    class RSync < SyncMe::Command::ShellCommand
        attr_accessor :src, :dest

        @@pattern = '%{src} %{dest}'

        def initialize(path = '')
            @src = ''
            @dest = ''
            super('rsync', path)
        end

        def init
            @src.clear
            @dest.clear
            super
        end

        def to_s
            src = ''
            dest = ''
            src.replace("\"#{@src}\"") unless @src.empty?
            dest.replace("\"#{@dest}\"") unless @dest.empty?
            (super + @@pattern) % { :src => src, :dest => dest }
        end
    end
end
