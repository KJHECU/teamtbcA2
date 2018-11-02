----------------------------------------------------------------------------------------
--
-- buttonCreator.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")

buttonFillColor = { default={0, 0.8, 0.8, 1 }, over={0, 0.8, 0.8, 1} }
buttonStrokeFillColor = { default={0,0.8,0.8}, over={0.8,0.8,1,1} }

-- Utility to make buttons
function addButton( ID, x, y, width, height, btnType, label )
  if btnType == "icon" then
    button = widget.newButton(
        {
          default = label,
          onRelease = handleInput,
          width = width,
          height = height
        }
      )
  elseif btnType == "panic" then
    button = widget.newButton(
        {
          label = label,
          shape = "roundedRect",
          cornerRadius = 8,
          fillColor = { default = { 255, 0, 0,}, over = { 255, 0, 0.5,} },
          strokeColor = { default = { 255, 0, 0 }, over = { 255, 0, 0} },
          labelColor = { default = { 255, 255, 0 }, over = { 255, 255, 0} },
          strokeWidth = 1,
          onRelease = handleInput,
          width = width,
          height = height
        }
      )
  elseif btnType == "countrySelect" then
    button = widget.newButton(
        {
          label = label,
          shape = "roundedRect",
          cornerRadius = 10,
          fillColor = { default = { 1, 1, 1,}, over = { 0.8, 0.8, 0.8,} },
          strokeColor = { default = { 1, 1, 1,}, over = { 0.8, 0.8, 0.8,} },
          labelColor = { default = { 0, 0, 0 }, over = { 0, 0, 0} },
          strokeWidth = 2,
          onRelease = handleInput,
          width = width/.6,
          height = height/1.5,
		  fontSize = 13
        }
      )
  elseif btnType == "lawyerAdd" then
    button = widget.newButton(
        {
          default = label,
          onRelease = handleInput,
          width = width,
          height = height,
		}
  )
  elseif btnType == "phraseAdd" then
    button = widget.newButton(
        {
          default = label,
          onRelease = handleInput,
          width = width,
          height = height,
		}
  )
 else
    button = widget.newButton(
        {
          label = label,
          shape = "roundedRect",
          cornerRadius = 10,
          fillColor = buttonFillColor,
          strokeColor = buttonStrokeFillColor,
          labelColor = { default = { 163, 25, 12 }, over = { 163, 25, 12} },
          strokeWidth = 2,
          onRelease = handleInput,
          width = width,
          height = height
        }
      )
  end
  button.id = ID
  button.x = x
  button.y = y
	return button
end

-- Utility to add buttons to a scroll pane
function addButtonToScroll(scroll, row, num)
  button = widget.newButton(
    {
      id = scroll.id .. row.id,
      label = row.name,
      shape = "roundedRect",
      cornerRadius = 0,
      fillColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
      labelColor = { default = { 0, 0, 0 }, over = { 0, 0, 0} },
      strokeWidth = 0,
      height = display.contentHeight/9,
      width = 350,
      x = display.contentWidth/2,
      y = (num * 75) + 30,
      fontSize = 14,
      onRelease = handleInput
    }
  )
  if scroll == lawyerScroll then
    scroll:insert(button)
    table.insert(currentButtons, button)
    if userType == 1 then
      binLawyerIcon = display.newImage("recycle-bin.png", button.x + 120, button.y )
      binLawyerIcon:scale (0.75, 0.75)
      binLawyer = addButton( "binLawyer".. row.id , button.x + 120, button.y , 25, 25, "icon", binLawyerIcon ) --( ID, x, y, width, height, btnType, label )
      scroll:insert(binLawyerIcon)
      scroll:insert(binLawyer)
      table.insert(currentButtons, binLawyerIcon)
      table.insert(currentButtons, binLawyer)
    end
  else
	  scroll:insert(button)
	  table.insert(currentButtons, button)
  end
end