=begin rdoc

= UTILITIES_SPEC.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-02-10
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
=end

require 'spec_helper.rb'
require 'tempfile'
require 'tmpdir'

describe Rsyncbackup do

  let(:source){Dir.mktmpdir("source")}
  let(:target){Dir.mktmpdir("target")}
  before(:each) do
    Dir.chdir(source) do |pwd|
      %w{one two three four five}.each do |d|
        FileUtils.mkdir(File.join(pwd,d))
      end
    end
  end

  context "utilities" do
    let(:syncer) { Rsyncbackup.new(source, target, :dry_run => true) }    

    context "#build_command" do

      it { syncer.should respond_to(:build_command) }

      it "should build a valid command" do
        cmd = syncer.build_command
        cmd.should =~ /--archive/
        cmd.should =~ /--one-file-system/
        cmd.should =~ /--hard-links/
        cmd.should =~ /--human-readable/
        cmd.should =~ /--inplace/
        cmd.should =~ /--numeric-ids/
        cmd.should =~ /--delete/
        cmd.should =~ /#{source}/
        cmd.should =~ /#{File.join(target,Rsyncbackup::DEFAULT_INCOMPLETE_DIR_NAME)}/
      end
    end
    
    context "#last_full_backup" do
      it { syncer.should respond_to(:last_full_backup) }

      it "should be nil if no last full backup" do
        syncer.last_full_backup.should be_nil
      end

      context "with a last full backup directory" do
        let(:last_full_directory) {Time.new(2013,01,01,03,10,00).strftime("%FT%H-%M-%S")}
        let(:last_full_file) {File.join(target, Rsyncbackup::DEFAULT_LAST_FULL_DIR_NAME)}
        
        before do
          FileUtils.mkdir(File.join(target,last_full_directory))
          File.write(last_full_file, last_full_directory)
        end
        
        it "should be the directory name if there was a last full backup marker" do
          syncer.last_full_backup.should == last_full_directory
          # File.unlink last_full_file # should not need this using tmpdir
        end
      end

    end

    context "#backup_dir_name" do
      it { syncer.should respond_to(:backup_dir_name) }
      it "should give a valid backup directory name: YYYY-MM-DDTHH-MM-SS" do
        syncer.backup_dir_name.should match /(\d){4}-(\d){2}-(\d){2}T(\d){2}-(\d){2}-(\d){2}/
      end
    end

    context "#strip_trailing_separator_if_any" do
      it "should respond to #strip_trailing_separator_if_any" do
        syncer.should respond_to(:strip_trailing_separator_if_any)
      end

      context "with trailing separators" do
      
        it "should remove trailing slash from source" do
          syncer.strip_trailing_separator_if_any('source/').should == 'source'
        end
      
        it "should remove trailing slash from source when keep_if_symlink is true" do
          syncer.strip_trailing_separator_if_any('source/',true).should == 'source'
        end
      
        context "when a symlink" do
          let(:source_link) do
            tmpfile = Tempfile.new("sourcelink")
            path = tmpfile.path
            tmpfile.close
            tmpfile.unlink
            path
          end

          let(:source_link_slash) {source_link + File::SEPARATOR}

          
          before do
            File.symlink(source,source_link)
          end

          after do
            File.unlink(source_link)
          end

          it "should not remove trailing slash from source if source is a symlink" do
            syncer.strip_trailing_separator_if_any(source_link_slash,true).should == source_link_slash
          end

          
        end


        it "should remove trailing slash from target" do
          syncer.strip_trailing_separator_if_any('target/').should == 'target'
        end

      end
      
      context "withOUT trailing separators" do
      
        it "should remove trailing slash from source" do
          syncer.strip_trailing_separator_if_any('source').should == 'source'
        end
      
        it "should remove trailing slash from target" do
          syncer.strip_trailing_separator_if_any('target').should == 'target'
        end
        
      end

    end

  end
  
end
 
