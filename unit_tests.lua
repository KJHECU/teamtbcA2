----------------------------------------------------------------------------------------
--
-- unit_tests.lua
--
-- Using - https://github.com/JesterXL/lunatest
--
-----------------------------------------------------------------------------------------
-- required for unit tests
module(..., package.seeall)

-- test background image is loaded
function test_background()
  local background = display.newImage("background.jpg")
  assert_not_nil(background, "Background image cannot be found.")
end
-- end test

-- test opening db file
function test_open_db()
  local sqlite3 = require( "sqlite3" )
  local path = system.pathForFile( "data.db", system.ResourceDirectory )
  assert_match(path, "data.db", "wrong filename for db file.")
  local db = sqlite3.open( path )
end
-- end test

-- test image loaded for home button
function test_home_button()
  local homeButton = display.newImage("home_white_192x192.png")
  assert_not_nil(homeButton, "home button image cannot be found.")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10
end

-- test image loaded for panic settings button
function test_panic_button()
  local panicSettingsButton = display.newImage("User-Profile.png")
  assert_not_nil(panicSettingsButton, "panic settings button image cannot be found.")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10
end

