require 'json'

module SyncMe
    class Configuration
        def initialize(config_file)
            File.open(config_file) do |file|
                json = file.read
                @data = JSON.parse(json)
            end
        end

        def [](key)
            @data[key]
        end
    end
end
