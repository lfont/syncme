require_relative 'shell-command'

module Command
    class ITunesExport < Command::ShellCommand
        def initialize(path = '')
            super('java -jar itunesexport.jar', path, '-')
        end
    end
end
