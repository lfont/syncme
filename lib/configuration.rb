require 'json'

module SyncMe
    class Configuration < Hash
        def initialize(config_file)
            super
            File.open(config_file) do |file|
                json = file.read
                data = JSON.parse(json)
                replace(data)
            end
        end
    end
end
