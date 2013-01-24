require_relative 'shell-command'

module SyncMe::Command
    class Iconv < SyncMe::Command::ShellCommand
        attr_accessor :src, :dest

        @@pattern = '%{src} %{redirection} %{dest}'

        def initialize(path = '')
            @src = ''
            @dest = ''
            super('iconv', path)
        end

        def init
            @src.clear
            @dest.clear
            super
        end

        def to_s
            src = ''
            redirection = ''
            dest = ''
            src.replace("\"#{@src}\"") unless @src.empty?
            dest.replace("\"#{@dest}\"") unless @dest.empty?
            if not dest.empty?
                redirection.replace('>')
            end
            (super + @@pattern) % { :src => src,
                                    :redirection => redirection,
                                    :dest => dest }
        end
    end
end
