----------------------------------------------------------------------------------------
--
-- unit_tests.lua
--
-----------------------------------------------------------------------------------------
-- required for unit tests
require "lunit"
module("unit_tests", lunit.testcase, package.seeall)

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
  homeButton = display.newImage("home_white_192x192.png")
  assert_not_nil(homeButton, "home button image cannot be found.")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10
end

-- test image loaded for panic settings button
function test_panic_button()
  panicSettingsButton = display.newImage("User-Profile.png")
  assert_not_nil(panicSettingsButton, "panic settings button image cannot be found.")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10
end

-- test lawyer scroll is a table
function test_lawyer_scroll()
  lawyerScroll = getScroll( "lawyer" )
  assert_pass(is_table(lawyerScroll), "lawyerScroll is not a table.")
  lawyerSearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,50)
  lawyerSearch.placeholder = "Search Lawyer"
  lawyerSearch.id = "lawyerId"
  lawyerSearch:addEventListener("userInput", searchListenerLaw)
end

-- test country scroll is a table
function test_country_scroll()
  countryScroll = getScroll( "country" )
  assert_pass(is_table(countryScroll), "countryScroll is not a table.")
  countrySearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,50)
  countrySearch.placeholder = "Search Country"
  countrySearch.id = "countryId"
  countrySearch:addEventListener("userInput", searchListenerCountry)
end

-- test phrase scroll is a table
function test_phrase_scroll()
  phraseScroll = getScroll( "phrase" )
  assert_pass(is_table(phraseScrollScroll), "phraseScroll is not a table.")
  phraseRectangle = display.newRect(display.contentCenterX, 80, display.contentWidth, 35)
  phraseRectangle.strokeWidth = 3
  phraseRectangle:setFillColor(0, 0.8, 0.8, 1 )
  phraseRectangle:setStrokeColor(0, 0.8, 0.8, 1 )
  phraseText = display.newText(
  {
    text = " phrases",     
    x = display.contentWidth / 2,
    y = 80,
    width = display.contentWidth / 2,  
    fontSize = 20,
    align = "center"
  }
 ) 
 phraseText:setFillColor( 1, 1, 1 )
end