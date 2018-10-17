-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- background image properties

local background = display.newImage("Background.jpg")
background.anchorX = 0
background.anchorY = 0
background:scale(0.45, 0.58)

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

txtUsername = native.newTextField(0,0,200,30)
labelUsername = display.newText( "Username", 265, 85, 0, 0, native.systemFont, 18 )
labelUsername:setFillColor ( black )
txtUsername.anchorX = 0
txtUsername.anchorY = 0
txtUsername.x = 10
txtUsername.y = 70
txtUsername:setTextColor(0,0,0)
--set input type
txtUsername.inputType = "default"
--define the placeholder
txtUsername.placeholder = "-- insert username --"
--set font
txtUsername.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(txtUsername)

-- password capture
txtPassword = native.newTextField(0,0,200,30)
labelPassword = display.newText( "Password", 265, 135, 0, 0, native.systemFont, 18 )
labelPassword:setFillColor ( black )
txtPassword.anchorX = 0
txtPassword.anchorY = 0
txtPassword.x = 10
txtPassword.y = 120
txtPassword:setTextColor(0,0,0)
txtPassword.isSecure = true
--set input type
txtPassword.inputType = "default"
--define the placeholder
txtPassword.placeholder = "-- insert password --"
--set font
txtPassword.font = native.newFont(native.systemFont, 12)

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
<<<<<<< HEAD
		addButton( 4, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Local Lawyers'),
		addButton( 5, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Phrase Translation'), 
		addButton( 6, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, false, false, 'Useful Contacts'), 
=======
		addButton( 4, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Local Lawyers'),
		addButton( 5, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Phrase Translation'), 
		addButton( 6, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Useful Contacts')
>>>>>>> 5e3a5d2d7575ce032121831a0d4c181169673d43
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
    txtPassword,
    txtUsername,
    labelPassword,
    labelUsername
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
hideButtons(loginButtons)
showButtons(mainMenuButtons)