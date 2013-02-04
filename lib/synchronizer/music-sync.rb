require 'socket'
require_relative 'file-sync'
require_relative '../tool/file-management'
require_relative '../command/itunes-export'

module SyncMe::Synchronizer
	class MusicSync < SyncMe::Synchronizer::FileSync
		include SyncMe::Tool::FileManagement

		def initialize(config, src, dest, share)
			super(config, src, dest)
			@share = share
			@itunesExport = SyncMe::Command::ITunesExport.new(config['java_path'],
			                                                  config['itunesexport_path'])
			before_sync do
				clean_playlists
				export_playlists
				convert_playlists
			end
		end

		def clean_playlists
			each_files(File.join(@src.path, '**', '*.m3u'),
					   File.join(@src.path, '**', '*.pls')) do |file|
				delete_file(file)
			end
		end

		def export_playlists
			puts @itunesExport.init
							  .opt_outputDir(@src.path)
							  .opt_musicPath(@share)
							  .opt_includeBuiltInPlaylists
							  .opt_fileTypes('MP3M4A')
			@itunesExport.exec unless @dry_run
		end

		def convert_playlists
			each_files(File.join(@src.path, '*.m3u')) do |file|
				convert_file(file, 'UTF8-MAC', 'UTF8')
				appendto_filename(file, "_#{Socket.gethostname}")
			end
		end

		private :clean_playlists, :export_playlists, :convert_playlists
	end
end
