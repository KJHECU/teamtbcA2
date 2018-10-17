-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- background image properties

local background = display.newImage("Background.jpg")
background.anchorX = 0
background.anchorY = 0
background:scale(0.45, 0.72)

local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )
local path = system.pathForFile( "data.db", system.ResourceDirectory )
local db = sqlite3.open( path )  

-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then             
        db:close()
    end
end

-- Configure tab buttons
local tabButtons = {
    {
        width = 40, 
        height = 50,
        defaultFile = "baseline_menu_white_18dp.png",
        overFile = "baseline_menu_white_18dp.png",
        id = "tab1",
        labelXOffset = -20,
        onPress = handleInput
    },
    {
        width = 180,
        height = 70,
        --label = "App Name",
        defaultFile = "app_name_28.png",
        overFile = "app_name_28.png",
        id = "tab2",
        onPress = handleInput
    } 
}
 
-- Create the widget
local tabBar = widget.newTabBar(
    {
        backgroundFile = "tab_bar_background.png",
        tabSelectedLeftFile = "transparent_image.png", 
        tabSelectedRightFile = "transparent_image.png",  
        tabSelectedMiddleFile = "transparent_image.png",
        tabSelectedFrameWidth = 1,
        tabSelectedFrameHeight = 1,
        top = -53,
        top = display.screenOriginY - 10,
        height = 52,
        width = display.contentWidth,
        --label = "App Name",
        buttons = tabButtons
    }
)

-- end top menu section

-- array of Widgets to show the buttons
local buttons
local buttonFillColor = { default={0, 0.8, 0.8, 1 }, over={0, 0.8, 0.8, 1} }
local buttonStrokeFillColor = { default={0,0.8,0.8}, over={0.8,0.8,1,1} }

-- handle button press
local function handleInput( event )
  id = event.target.id
  print("button push " .. id)
  if id == 2 then
    hideButtons(currentButtons)
    showButtons(mainMenuButtons)
    showButtons(menuBarButtons)
  elseif id == 4 then
    hideButtons(currentButtons)
    populateLawyerList()
    showButtons(localLawyerButtons)
    showButtons(menuBarButtons)
  elseif id == 5 then
    hideButtons(mainMenuButtons)
    showButtons(phraseButtons)
    showButtons(menuBarButtons)
  elseif id == 10 then
    if loginAccepted() then
      hideButtons(loginButtons)
      showButtons(mainMenuButtons)
      showButtons(menuBarButtons)
	 end
  elseif id == 11 then
	  hideButtons(loginButtons)
	  showButtons(registrationButtons)
	 end
end

-- handle scrolling
local function scrollListener( event )
  local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end
 
    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        end
    end
 
    return true
end

-- handle searching
local function searchListener( event )
  if ( event.phase == "ended" or event.phase == "submitted" ) then
    lawyerScroll:removeSelf()
    lawyerScroll = getLawyerScroll()
    table.insert(currentButtons, lawyerScroll)
    populateLawyerList(lawyerSearch.text)
  end
end

function loginAccepted()
  query = [[SELECT * FROM user WHERE username="]] .. txtUsername.text .. [["]]
  for row in db:nrows(query) do
    return row.password == txtPassword.text
  end
end

-- utility to make buttons
local function addButton( ID, x, y, width, height, isIcon, isPanic, label )
  if isIcon then
    button = widget.newButton(
        {
          id = ID,
          default = label,
          onRelease = handleInput,
          emboss = false,
          width = width,
          height = height,
          x = x,
          y = y
        }
      ) 
	  
  elseif isPanic then
    button = widget.newButton(
        {
          id = ID,
          label = label,
          shape = "roundedRect",
          cornerRadius = 8,
          fillColor = { default = { 255, 0, 0,}, over = { 255, 0, 0.5,} },
          strokeColor = { default = { 255, 0, 0 }, over = { 255, 0, 0} },
		  labelColor = { default = { 255, 255, 0 }, over = { 255, 255, 0} },
          strokeWidth = 1,
          onRelease = handleInput,
          emboss = false,
          width = 130,
          height = 38,
          x = x,
          y = y
        		
		}
	
        )  
  else
    button = widget.newButton(
        {
          id = ID,
          label = label,
          shape = "roundedRect",
          cornerRadius = 10,
          fillColor = buttonFillColor,
          strokeColor = buttonStrokeFillColor,
		  labelColor = { default = { 163, 25, 12 }, over = { 163, 25, 12} },
          strokeWidth = 2,
          onRelease = handleInput,
          emboss = false,
          width = width,
          height = height,
          x = x,
          y = y
        		
		}
	
        )    
  end
	return button
end


homeButton = display.newImage("home_white_192x192.png")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10

panicSettingsButton = display.newImage("User-Profile.png")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10


  
  -- login feature which is enabled by default --

-- username capture

backloadEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.65, display.contentWidth, display.contentHeight/15)
backloadEmail:setFillColor (0, 0.8, 0.8)
inputloadEmail = native.newTextField(0,0,200,30)
txtloadEmail = display.newText( "Email",display.contentWidth/0.8, display.contentHeight/6.15, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputloadEmail.x = display.contentWidth/2.9
inputloadEmail.y = display.contentHeight/6.6
inputloadEmail:setTextColor(0,0,0)
--set input type
inputloadEmail.inputType = "default"
--define the placeholder
inputloadEmail.placeholder = "-- insert email--"
--set font
inputloadEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputloadEmail)

-- password capture
backloadPassword = display.newRect(display.contentWidth/2, display.contentHeight/4.2, display.contentWidth, display.contentHeight/15)
backloadPassword:setFillColor (0, 0.8, 0.8)
inputloadPassword = native.newTextField(0,0,200,30)
txtloadPassword = display.newText( "Password", display.contentWidth/0.83, display.contentHeight/4, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputloadPassword.x = display.contentWidth/2.9
inputloadPassword.y = display.contentHeight/4.2
inputloadPassword:setTextColor(0,0,0) 
--set input type
inputloadPassword.inputType = "default"
--define the placeholder
inputloadPassword.placeholder = "-- insert password --"
--set font
inputloadPassword.font = native.newFont(native.systemFont, 12)

------- registration fields
-- registration label
backRegistration = display.newRect(display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15)
backRegistration:setFillColor (0, 0.8, 0.8)
txtRegistration = display.newText("Registration", display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15, native.systemFont, 18)
txtRegistration:setFillColor (1,1,1 )
txtRegistration.x = display.contentWidth/1.20
txtRegistration.y = display.contentHeight/13

-- email field
backregEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.7, display.contentWidth, display.contentHeight/15)
backregEmail:setFillColor (0, 0.8, 0.8)
inputregEmail = native.newTextField(0,0,200,30)
txtregEmail = display.newText( "Email",display.contentWidth/0.8, display.contentHeight/6.2, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputregEmail.x = display.contentWidth/2.9
inputregEmail.y = display.contentHeight/6.6
inputregEmail:setTextColor(0,0,0)
--set input type
inputregEmail.inputType = "default"
--define the placeholder
inputregEmail.placeholder = "-- insert email--"
--set font
inputregEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputEmail)

-- First Name
backFname = display.newRect(display.contentWidth/2, display.contentHeight/4.2, display.contentWidth, display.contentHeight/15)
backFname:setFillColor (0, 0.8, 0.8)
inputFname = native.newTextField(0,0,200,30)
txtFname = display.newText( "First Name", display.contentWidth/0.85, display.contentHeight/4, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputFname.x = display.contentWidth/2.9
inputFname.y = display.contentHeight/4.2
inputFname:setTextColor(0,0,0) 
--set input type
inputFname.inputType = "default"
--define the placeholder
inputFname.placeholder = "-- insert first name --"
--set font
inputFname.font = native.newFont(native.systemFont, 12)

-- Surname
backSname = display.newRect(display.contentWidth/2, display.contentHeight/3.1, display.contentWidth, display.contentHeight/15)
backSname:setFillColor (0, 0.8, 0.8)
inputSname = native.newTextField(0,0,200,30)
txtSname = display.newText( "Surname", display.contentWidth/0.83, display.contentHeight/3, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputSname.x = display.contentWidth/2.9
inputSname.y = display.contentHeight/3.1
inputSname:setTextColor(0,0,0) 
--set input type
inputSname.inputType = "default"
--define the placeholder
inputSname.placeholder = "-- insert first name --"
--set font
inputSname.font = native.newFont(native.systemFont, 12)

-- Mobile No
backMobile = display.newRect(display.contentWidth/2, display.contentHeight/2.5, display.contentWidth, display.contentHeight/15)
backMobile:setFillColor (0, 0.8, 0.8)
inputMobile = native.newTextField(0,0,200,30)
txtMobile = display.newText( "Mobile no", display.contentWidth/0.84, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputMobile.x = display.contentWidth/2.9
inputMobile.y = display.contentHeight/2.5
inputMobile:setTextColor(0,0,0) 
--set input type
inputMobile.inputType = "default"
--define the placeholder
inputMobile.placeholder = "-- insert first name --"
--set font
inputMobile.font = native.newFont(native.systemFont, 12)

-- Password
backregPassword = display.newRect(display.contentWidth/2, display.contentHeight/2.1, display.contentWidth, display.contentHeight/15)
backregPassword:setFillColor (0, 0.8, 0.8)
inputregPassword = native.newTextField(0,0,200,30)
txtregPassword = display.newText( "Password", display.contentWidth/0.84, display.contentHeight/2.05, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )
inputregPassword.x = display.contentWidth/2.9
inputregPassword.y = display.contentHeight/2.1
inputregPassword:setTextColor(0,0,0) 
--set input type
inputregPassword.inputType = "default"
--define the placeholder
inputregPassword.placeholder = "-- insert password --"
--set font
inputregPassword.font = native.newFont(native.systemFont, 12)


-- Next of Kin label
backKin = display.newRect(display.contentWidth/2, display.contentHeight/1.8, display.contentWidth/2, display.contentHeight/15)
backKin:setFillColor (0, 0.8, 0.8)
txtKin = display.newText( "Next of Kin info", display.contentWidth/1.25, display.contentHeight/1.775, display.contentWidth, display.contentHeight/15, native.systemFont, 18 )

-- scroll pane for local lawyer list

function getLawyerScroll()
  scroll = widget.newScrollView(
  {
      id = "lawyer",
      top = 100,
      left = 0,
      width = display.contentWidth,
      height = 350,
      scrollWidth = display.contentWidth,
      scrollHeight = 1600,
      hideBackground = true,
      horizontalScrollDisabled = true,
      listener = scrollListener
    }
  )
  return scroll
end

lawyerScroll = getLawyerScroll()
lawyerSearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,50)
lawyerSearch.placeholder = "Search Lawyers"
lawyerSearch.id = "lawyer"
lawyerSearch:addEventListener("userInput", searchListener)

function addButtonToScroll(scroll, row, num)
  button = widget.newButton(
    {
      id = scroll.id .. row.id,
      label = row.name,
      shape = "roundedRect",
      cornerRadius = 0,
      fillColor = buttonFillColor,
      strokeColor = buttonStrokeFillColor,
      strokeWidth = 0,
      height = display.contentHeight/9,
      width = 300,
      x = display.contentWidth/2,
      y = (num * 75) + 30,
      onRelease = handleInput
    }
  )
  scroll:insert(button)
end

function populateLawyerList( search )
  if search == nil then
    query = [[SELECT * FROM lawyer]]
  else
    query = [[SELECT * FROM lawyer WHERE UPPER(name) LIKE "%]] .. search:upper() .. [[%"]]
    print("Searched on " .. search .. " query " .. query)
  end
  i = 0
  for row in db:nrows(query) do
    addButtonToScroll(lawyerScroll, row, i)
    i = i + 1
  end
end
  
currentButtons = {}

countrySelectButton = addButton( 99, display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15, false, false, 'Current Country: Australia')

menuBarButtons = {
    addButton( 1, display.contentWidth/2, display.contentHeight + 10, display.contentWidth/3, display.contentHeight/12, false, true, 'Panic Button'), 
    addButton( 2, homeButton.x, homeButton.y, homeButton.width*0.22, homeButton.height*0.22, true, false, homeButton ),
    addButton( 3, panicSettingsButton.x, panicSettingsButton.y, panicSettingsButton.width*0.12, panicSettingsButton.height*0.12, true, false, panicSettingsButton ),
    homeButton,
    panicSettingsButton
  }
  
mainMenuButtons = {
    countrySelectButton,
		addButton( 4, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Local Lawyers'),
		addButton( 5, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Phrase Translation'), 
		addButton( 6, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Useful Contacts'), 
  }
  
phraseButtons = {
    countrySelectButton,
		addButton( 7, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Useful Phrases'),
		addButton( 8, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Legal Phrases'), 
		addButton( 9, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Set Favourite Phrases'), 
  }
  
loginButtons = {
		addButton( 10, display.contentWidth/2, 6*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Login'),
		addButton( 11, display.contentWidth/2, 7*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false,  'Register'),
    backloadEmail,
	txtloadEmail,
	inputloadEmail,
	backloadPassword,
	txtloadPassword,
	inputloadPassword,

}

registrationButtons = {
	backRegistration,
	txtRegistration,
	backregEmail,
	inputregEmail,
	txtregEmail,
	backFname,
	inputFname,
	txtFname,
	backSname,
	inputSname,
	txtSname,
	backMobile,
	inputMobile,
	txtMobile,
	backregPassword,
	inputregPassword,
	txtregPassword,
	backKin,
	txtKin

	
}

localLawyerButtons = {
  lawyerScroll,
  lawyerSearch
}
  
function showButtons(buttons)
    for _, button in pairs(buttons) do
      button.isVisible = true
      table.insert(currentButtons, button)
    end
end

function hideButtons(buttons)
    for _, button in pairs(buttons) do
      button.isVisible = false
    end
    currentButtons = {}
end

populateLawyerList()
hideButtons(phraseButtons)
hideButtons(menuBarButtons)
hideButtons(localLawyerButtons)
showButtons(loginButtons)
hideButtons(mainMenuButtons)
hideButtons(registrationButtons)