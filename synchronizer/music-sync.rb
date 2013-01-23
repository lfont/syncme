require 'socket'
require_relative 'file-sync'
require_relative 'file-helpers'
require_relative '../command/itunes-export'

module Synchronizer
	class MusicSync < Synchronizer::FileSync
		include Synchronizer::FileHelpers

		def initialize(src, dest, share)
			super(src, dest)
			@share = share
			@itunesExport = Command::ITunesExport.new
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
