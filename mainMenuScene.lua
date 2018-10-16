-----------------------------------------------------------------------------------------
--
-- questionScene.lua
--
-- This is the scene in which questions are asked and answers checked
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local widget = require( "widget" )

-- array of Widgets to show the buttons
local buttons
local buttonFillColor = { default={1,1,1,1}, over={1,0.1,0.7,0.4} }
local buttonStrokeFillColor = { default={1,0,0,1}, over={0.8,0.8,1,1} }

-- handle button press
local function handleInput( event )
  display.newText('Button pressed ID:' .. event.target.id, 40, 40)
  event.target.isVisible = false
end

-- utility to make buttons
local function addButton( ID, x, y, width, height, isIcon, label )
  if not isIcon then
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
  else
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
  end
	return button
end

local menuBarButtons = {
    addButton( 4, display.contentWidth/2, display.contentHeight, display.contentWidth/3, display.contentHeight/12, false, 'Panic Button'), 
    addButton( 5, buttonImage1.x, buttonImage1.y, buttonImage1.width*0.22, buttonImage1.height*0.22, true, buttonImage1 ),
    addButton( 6, buttonImage2.x, buttonImage2.y, buttonImage2.width*0.12, buttonImage2.height*0.12, true, buttonImage2 )
  }

local buttonImage1 = display.newImage("home_white_192x192.png")
  buttonImage1:scale(0.22, 0.22)
  buttonImage1.y = display.contentHeight
  buttonImage1.x = 9.3*display.contentWidth/10

local buttonImage2 = display.newImage("User-Profile.png")
  buttonImage2:scale(0.12, 0.12)
  buttonImage2.y = display.contentHeight
  buttonImage2.x = 7.75*display.contentWidth/10
  
local mainMenuButtons = {
		addButton( 1, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Local Lawyers'),
		addButton( 2, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Phrase Translation'), 
		addButton( 3, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/10, false, 'Useful Contacts'), 
  }

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    -- insert them into the scene group
    for _, button in pairs(mainMenuButtons) do
    	sceneGroup:insert(button)
    end
    
    for _, button in pairs(menuBarButtons) do
      sceneGroup:insert(button)
    end

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene