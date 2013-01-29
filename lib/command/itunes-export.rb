require_relative 'shell-command'

module SyncMe::Command
    class ITunesExport < SyncMe::Command::ShellCommand
        def initialize(java_path = '', itunesexport_path = '')
            itunesexport = 'itunesexport.jar'
            itunesexport = File.join(itunesexport_path, itunesexport) unless itunesexport_path.empty?
            super("java -jar #{itunesexport}", java_path, '-')
        end
    end
end
