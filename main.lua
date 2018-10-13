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

