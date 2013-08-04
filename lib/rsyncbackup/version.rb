class Rsyncbackup
  VERSION = "1.0.2"
  DEFAULT_EXCLUSIONS = File.expand_path('.rsyncbackup.exclusions', ENV['HOME'])
  DEFAULT_INCOMPLETE_DIR_NAME = '.incomplete'
  DEFAULT_LAST_FULL_DIR_NAME  = '.lastfull'
end
