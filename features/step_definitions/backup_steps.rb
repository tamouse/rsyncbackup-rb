=begin rdoc

= BACKUP_STEPS.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-02-10
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
=end

Then /^"(.*?)" should have a new backup$/ do |arg1|
  last_dir = File.read("#{arg1}/.lastfull")
  File.directory?("#{arg1}/last_dir")
end
