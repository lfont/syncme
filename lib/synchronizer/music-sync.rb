require 'socket'
require_relative 'file-sync'
require_relative 'file-helpers'
require_relative '../command/itunes-export'

module SyncMe::Synchronizer
	class MusicSync < SyncMe::Synchronizer::FileSync
		include SyncMe::Synchronizer::FileHelpers

		def initialize(config, src, dest, share)
			super(config, src, dest)
			@share = share
			@itunesExport = SyncMe::Command::ITunesExport.new(config['java_path'],
			                                                  config['itunesexport_path'])
		end

		def sync
			each_files(File.join(@src, '**', '*.m3u'),
					   File.join(@src, '**', '*.pls')) do |file|
				delete_file(file)
			end

			puts @itunesExport.init
							  .opt_outputDir(@src)
							  .opt_musicPath(@share)
							  .opt_includeBuiltInPlaylists
							  .opt_fileTypes('MP3M4A')
			@itunesExport.exec unless @dry_run

			each_files(File.join(@src, '*.m3u')) do |file|
				convert_file(file, 'UTF8-MAC', 'UTF8')
				appendto_filename(file, "_#{Socket.gethostname}")
			end

			each_files(File.join(@dest, '**', '*.m3u'),
					   File.join(@dest, '**', '*.pls')) do |file|
				delete_file(file)
			end

			super
		end
	end
end
