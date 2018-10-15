-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )

-- top menu section - yane

local function handleTabBarEvent( event )
    print( event.target.id ) 
end
 
-- Configure tab buttons
local tabButtons = {
    {
        width = 40, 
        height = 50,
        defaultFile = "baseline_menu_white_18dp.png",
        overFile = "baseline_menu_white_18dp.png",
        id = "tab1",
        labelXOffset = -20,-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- background image properties

local background = display.newImage("Background.jpg")
background.anchorX = 0
background.anchorY = 0
background:scale(0.5, 0.55)

local widget = require( "widget" )

-- top menu section - yane

local function handleTabBarEvent( event )
    print( event.target.id ) 
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
        onPress = handleTabBarEvent
    },
    {
        width = 180,
        height = 70,
        --label = "App Name",
        defaultFile = "app_name_28.png",
        overFile = "app_name_28.png",
        id = "tab2",
        onPress = handleTabBarEvent
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
        top = display.screenOriginY + 50;
        height = 52,
        width = display.contentWidth,
        --label = "App Name",
        buttons = tabButtons
    }
)

-- end top menu section

-- array of Widgets to show the buttons
local buttons
local buttonFillColor = { default={1,1,1,1}, over={1,0.1,0.7,0.4} }
local buttonStrokeFillColor = { default={1,0,0,1}, over={0.8,0.8,1,1} }

-- handle button press
local function handleInput( event )
  id = event.target.id
  if id == 2 then
    hideButtons(currentButtons)
    showButtons(mainMenuButtons)
  elseif id == 5 then
    hideButtons(mainMenuButtons)
    showButtons(phraseButtons)
  elseif id == 10 then
	labelUsername.isVisible = false
	txtUsername.isVisible = false
	labelPassword.isVisible = false
	txtPassword.isVisible = false
	hideButtons(loginButtons)
	showButtons(mainMenuButtons)
	showButtons(phraseButtons)
	showButtons(menuBarButtons) 
	
  end
end

-- utility to make buttons
local function addButton( ID, x, y, width, height, isIcon, label )
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
  else
    button = widget.newButton(
        {
          id = ID,
          label = label,
          shape = "roundedRect",
          cornerRadius = 10,
          fillColor = buttonFillColor,
          strokeColor = buttonStrokeFillColor,
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
  homeButton.isVisible = false

panicSettingsButton = display.newImage("User-Profile.png")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10
  panicSettingsButton.isVisible = false
  
currentButtons = {}

countrySelectButton = addButton( 99, display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15, false, 'Current Country: Australia')

menuBarButtons = {
    addButton( 1, display.contentWidth/2, display.contentHeight + 10, display.contentWidth/3, display.contentHeight/12, false, 'Panic Button'), 
    addButton( 2, homeButton.x, homeButton.y, homeButton.width*0.22, homeButton.height*0.22, true, homeButton ),
    addButton( 3, panicSettingsButton.x, panicSettingsButton.y, panicSettingsButton.width*0.12, panicSettingsButton.height*0.12, true, panicSettingsButton )
  }
  
mainMenuButtons = {
    countrySelectButton,
		addButton( 4, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Local Lawyers'),
		addButton( 5, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Phrase Translation'), 
		addButton( 6, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Useful Contacts'), 
  }
  
phraseButtons = {
    countrySelectButton,
		addButton( 7, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Useful Phrases'),
		addButton( 8, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Legal Phrases'), 
		addButton( 9, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Set Favourite Phrases'), 
  }
  
loginButtons = {
		addButton( 10, display.contentWidth/2, 2*display.contentHeight/3.5, display.contentWidth, display.contentHeight/10, false, 'Login'),
		addButton( 11, display.contentWidth/2, 2*display.contentHeight/2.8, display.contentWidth, display.contentHeight/10, false, 'Register'),
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

-- disabled on default prior to login

hideButtons(phraseButtons)
hideButtons(mainMenuButtons)
hideButtons(menuBarButtons) 


-- login feature which is enabled by default --

-- username capture
txtUsername = native.newTextField(0,0,200,30)
labelUsername = display.newText( "Username", 265, 85, 0, 0, "Roboto-Medium.ttf", 18 )
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
txtUsername.font = native.newFont("Roboto-Medium.ttf", 12)
native.setKeyboardFocus(txtUsername)

-- password capture
txtPassword = native.newTextField(0,0,200,30)
labelPassword = display.newText( "Password", 265, 135, 0, 0, "Roboto-Medium.ttf", 18 )
labelPassword:setFillColor ( black )
txtPassword.anchorX = 0
txtPassword.anchorY = 0
txtPassword.x = 10
txtPassword.y = 120
txtPassword:setTextColor(0,0,0)
--set input type
txtPassword.inputType = "default"
--define the placeholder
txtPassword.placeholder = "-- insert password --"
--set font
txtPassword.font = native.newFont(native.systemFont, 12)


        onPress = handleTabBarEvent
    },
    {
        width = 180,
        height = 70,
        --label = "App Name",
        defaultFile = "app_name_28.png",
        overFile = "app_name_28.png",
        id = "tab2",
        onPress = handleTabBarEvent
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
        top = display.screenOriginY + 50;
        height = 52,
        width = display.contentWidth,
        --label = "App Name",
        buttons = tabButtons
    }
)

-- end top menu section

-- array of Widgets to show the buttons
local buttons
local buttonFillColor = { default={1,1,1,1}, over={1,0.1,0.7,0.4} }
local buttonStrokeFillColor = { default={1,0,0,1}, over={0.8,0.8,1,1} }

-- handle button press
local function handleInput( event )
  id = event.target.id
  if id == 2 then
    hideButtons(currentButtons)
    showButtons(mainMenuButtons)
  elseif id == 5 then
    hideButtons(mainMenuButtons)
    showButtons(phraseButtons)
  end
end

-- utility to make buttons
local function addButton( ID, x, y, width, height, isIcon, label )
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
  else
    button = widget.newButton(
        {
          id = ID,
          label = label,
          shape = "roundedRect",
          cornerRadius = 10,
          fillColor = buttonFillColor,
          strokeColor = buttonStrokeFillColor,
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

local homeButton = display.newImage("home_white_192x192.png")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10

local panicSettingsButton = display.newImage("User-Profile.png")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10
  
currentButtons = {}

countrySelectButton = addButton( 99, display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15, false, 'Current Country: Australia')

menuBarButtons = {
    addButton( 1, display.contentWidth/2, display.contentHeight + 10, display.contentWidth/3, display.contentHeight/12, false, 'Panic Button'), 
    addButton( 2, homeButton.x, homeButton.y, homeButton.width*0.22, homeButton.height*0.22, true, homeButton ),
    addButton( 3, panicSettingsButton.x, panicSettingsButton.y, panicSettingsButton.width*0.12, panicSettingsButton.height*0.12, true, panicSettingsButton )
  }
  
mainMenuButtons = {
    countrySelectButton,
		addButton( 4, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Local Lawyers'),
		addButton( 5, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Phrase Translation'), 
		addButton( 6, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Useful Contacts'), 
  }
  
phraseButtons = {
    countrySelectButton,
		addButton( 7, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Useful Phrases'),
		addButton( 8, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Legal Phrases'), 
		addButton( 9, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Set Favourite Phrases'), 
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

hideButtons(phraseButtons)
showButtons(mainMenuButtons)

