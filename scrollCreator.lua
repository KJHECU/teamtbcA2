user = require("user")

function getScroll(scrollType)
  scroll = widget.newScrollView(
  {
      id = scrollType,
      top = 100,
      left = 0,
      width = display.contentWidth,
      height = 350,
      scrollWidth = display.contentWidth,
      scrollHeight = 1600,
      hideBackground = true,
      horizontalScrollDisabled = true
    }
  )
  table.insert(currentButtons, scroll)
  return scroll
end

-- scroll pane for useful contacts
function addContactsToScroll(scroll, contactType, contactNum, num)
  if contactType == "Emergency" then
  	backgroundFile = "emergency.png"
  elseif contactType == "Embassy" then
  	backgroundFile = "embassy.png"
  else
  	backgroundFile = "noKinPhone.png"
  end
  button = widget.newButton(
    {
      label = contactNum .. "\n" .. contactType,
      cornerRadius = 0,
      fillColor = white,
      strokeWidth = 0,
      height = display.contentHeight/9,
      width = 300,
      x = display.contentWidth/2,
      y = (num * 80) + 30,
	  fontSize = 14,
	  defaultFile = backgroundFile
    }
  )
  scroll:insert(button)
  table.insert(currentButtons, button)
end

function populateScroll( scroll, search )
  order = false
  if scroll == lawyerScroll then
    if search == nil then
      query = [[SELECT * FROM lawyer WHERE countryid=]] .. currentCountryId
    else
      query = [[SELECT * FROM lawyer WHERE UPPER(name) LIKE "%]] .. search:upper() .. [[%" AND countryid=]] .. currentCountryId
    end
    query = query .. [[ ORDER BY name ASC]]
  elseif scroll == countryScroll then
    if search == nil then
      query = [[SELECT * FROM country]]
    else
      query = [[SELECT * FROM country WHERE UPPER(name) LIKE "%]] .. search:upper() .. [[%"]]
    end
    query = query .. [[ ORDER BY name ASC]]
  end
  i = 0
  for row in db:nrows(query) do
    addButtonToScroll(scroll, row, i)
    i = i + 1
  end
end

function populateContacts ( scroll )
  contactType = nil
  query = [[SELECT * FROM country WHERE id=]] .. currentCountryId
  for row in db:nrows(query) do
  	contactType = "Emergency"
    addContactsToScroll(scroll, contactType, row.emergency, 0)
  end
  contactType = "Embassy"
  query = [[SELECT * FROM country WHERE id=]] .. currentCountryId
  for row in db:nrows(query) do
    addContactsToScroll(scroll, contactType, row.embassy, 1)
  end
  contactType = "Next of Kin"
  query = [[SELECT * FROM user WHERE userid=]] .. currentUserId
  for row in db:nrows(query) do
    addContactsToScroll(scroll, contactType, row.nokname, 2)
  end
end