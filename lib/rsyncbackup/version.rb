class Rsyncbackup
  VERSION = "1.0.1"
  DEFAULT_EXCLUSIONS = File.expand_path('.rsyncbackup.exclusions', ENV['HOME'])
end
