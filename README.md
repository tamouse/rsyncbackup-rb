# Rsyncbackup

Yet another rsyncbackup script, this time in ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'rsyncbackup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rsyncbackup

## Usage

    rsyncbackup [options] SOURCE TARGET
	
`SOURCE` can be any valid rsync spec.

`TARGET` must be a valid file path on the local machine.

Consult the --help for details.

## Contributing

1. Fork it, clone it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
