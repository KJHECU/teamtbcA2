----------------------------------------------------------------------------------------
--
-- profile.lua
--
-----------------------------------------------------------------------------------------

-- Adds profile information to profile display scroll
function addProfileToScroll(scroll, userDetailType, contact, num)
  if contact ~= nil then
    printLabel = userDetailType .. "\n" .. contact
  else
    printLabel = userDetailType .. "\nNot supplied" 
  end
  button = widget.newButton(
    {
      label = printLabel,
      labelAlign = "left",
      labelXOffset = 160,
      shape = "roundedRect",
      cornerRadius = 0,
      fillColor = white,
      strokeWidth = 0,
      height = display.contentHeight/9,
      width = display.contentWidth,
      x = display.contentWidth/2,
      y = (num * 53) + 30
    }
  )
  button:toFront()
  scroll:insert(button)
  table.insert(currentButtons, button)
end

-- Pulls profile data from db
function populateProfile ( profileType, profileId, scroll )
  if profileType == "user" then
    query = [[SELECT * FROM user WHERE userid=]] .. profileId
  else
    query = [[SELECT * FROM lawyer WHERE id=]] .. profileId
  end
  for row in db:nrows(query) do
    userImg = row.userpic
    if userImg ~= nil then 
      profileImg = display.newImage(userImg, display.contentWidth/2, display.contentHeight/4)
      scroll:insert(profileImg)
    else
      print(userImg)
    end
    addProfileToScroll(scroll, "Name", row.name, 2)
    addProfileToScroll(scroll, "Mobile", row.mobilenum, 4)
    addProfileToScroll(scroll, "Work", row.worknum, 5)
    addProfileToScroll(scroll, "E-mail", row.email, 6)
    scroll:insert(button)
  end
  table.insert(currentButtons, scroll)
end