Feature: help lists all options and arguments
  In order to ensure user knows what to do
  I want to display a useful help
  So I know how to run the rsync backup

  Scenario: App just runs
    When I get help for "rsyncbackup"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--[no-]dry-run|
      |--exclusions|
      |--help|
      |--log-level|
      |--version|
    And the banner should document that this app's arguments are:
      |source|
      |target|
