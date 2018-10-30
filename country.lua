----------------------------------------------------------------------------------------
--
-- country.lua
--
-----------------------------------------------------------------------------------------

-- Create and populate country select display group
countryGroup = display.newGroup()

globe = display.newImage("globe.png" ,display.contentWidth/5, display.contentHeight/10)
globe:scale(.125,.125)
countryGroup:insert(globe)

fingerPress = display.newImage ("fingerpress.png",display.contentWidth/1.15, display.contentHeight/10)
fingerPress:scale(.4, .4)
countryGroup:insert(fingerPress)

countrySelectButton = addButton( 99, display.contentWidth/1.9, display.contentHeight/10, display.contentWidth, display.contentHeight/10, "countrySelect", 'Current Country: Australia')
countryGroup:insert(countrySelectButton)
countrySelectButton:toBack()

countryScroll = getScroll( "country" )
countrySearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,26)
countrySearch.placeholder = "Search Country"
countrySearch.id = "countryId"

-- Listener for when text is entered into country search bar
function searchListenerCountry( event )
  if ( event.phase == "ended" or event.phase == "submitted" ) then
    countryScroll:removeSelf()
    countryScroll = getScroll("country")
    table.insert(currentButtons, countryScroll)
    populateScroll(countryScroll, countrySearch.text)
  end
end
countrySearch:addEventListener("userInput", searchListenerCountry)