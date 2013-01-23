require 'optparse'
require_relative 'synchronizer/file-sync'
require_relative 'synchronizer/music-sync'

options = {}
OptionParser.new do |opt|
    opt.banner = 'Usage: syncme [options] --sync TYPE --src SRC --dest DEST [--sync-opts OPT1,OPT2,...]'

    opt.on_tail('-h', '--help', 'Help') do
        puts opt
        exit
    end

    opt.on_tail('-v', '--version', 'Version') do
        puts '0.0.1'
        exit
    end

    opt.on('-d', '--dry-run', 'Dry run') do
        options[:dry_run] = true
    end

    opt.on('--sync TYPE', 'Sync') do |type|
        options[:sync] = type
    end

    opt.on('--src SRC', 'Source') do |src|
        options[:src] = src
    end

    opt.on('--dest DEST', 'Destination') do |dest|
        options[:dest] = dest
    end

    opt.on('--sync-opts OPT1,OPT2,...', Array, 'Sync Options') do |opts|
        options[:sync_opts] = opts
    end
end.parse!

if not options.key?(:dry_run)
    options[:dry_run] = false
end

synchronizer = eval("Synchronizer::#{options[:sync].capitalize}Sync").new(options[:src],
                                                                          options[:dest],
                                                                          *options[:sync_opts])
synchronizer.dry_run = options[:dry_run]
synchronizer.sync
