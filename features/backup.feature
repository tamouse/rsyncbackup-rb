Feature: Perform Backups
  In order to ensure files are correctly backed up
  I will need to run the backup script
  
  Scenario: Run a backup from source to target
    Given a directory named "source"
    Given a file named "source/one" with:
      """
      xxxx
      """
    Given a file named "source/two" with:
      """
      xxxx
      """
    Given a directory named "target"
    When I successfully run `rsyncbackup --log-level debug source target`
    Then a file named "target/.lastfull" should exist
    And a directory named "target/.incomplete" should not exist
    


    
    

