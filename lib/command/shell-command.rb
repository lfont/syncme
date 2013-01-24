module SyncMe::Command
    class ShellCommand
        def initialize(name, path = '', opt_prefix = '--')
            @name = name
            @path = path
            @opt_prefix = opt_prefix
            @cmd = ''
            self.init
        end

        def init
            @cmd.replace("#{@name} %{opt}")
            self
        end

        def exec
            cmd = self.to_s
            cmd = File.join(@path, cmd) unless @path.empty?
            `#{cmd}`
            $?.exitstatus
        end

        def method_missing(meth, *args, &block)
            method = meth.to_s
            if not method =~ /^opt_/
                super
            else
                opt = method.sub(/^opt_/, '')
                            .gsub(/_/, '-')
                val = ''
                if not args.empty?
                    val.replace("=\"#{args.join(',')}\"")
                end
                @cmd = @cmd % { :opt => "#{@opt_prefix + opt + val} %{opt}" }
                self
            end
        end

        def to_s
            # fill the last %{opt}
            @cmd % { :opt => '' }
        end
    end
end
