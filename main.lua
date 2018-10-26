----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- required for unit tests
require "lunit"

-- background image properties

local background = display.newImage("background.jpg")
background.anchorX = 0
background.anchorY = 0
background:scale(0.45, 0.72)

local widget = require( "widget" )
local sqlite3 = require( "sqlite3" )
local path = system.pathForFile( "data.db", system.ResourceDirectory )
local db = sqlite3.open( path )  

local currentCountryId = 1
local userType = 0

-- List for placing currently active buttons for easier hiding
currentButtons = {}

-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then             
        db:close()
    end
end

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
    hideButtons(phraseButtons)
    showButtons(mainMenuButtons)
    showButtons(menuBarButtons)
  elseif id == 4 then
    hideButtons(currentButtons)
    populateScroll(lawyerScroll, nil)
    lawyerScroll.isVisible = true
    showButtons(localLawyerButtons)
    showButtons(menuBarButtons)
  elseif id == 5 then
    hideButtons(mainMenuButtons)
    showButtons(phraseMenuButtons)
    showButtons(menuBarButtons)
  elseif id == 7 then
    hideButtons(phraseMenuButtons)
    phraseText.text = "Useful Phrases"
    populatePhrases(phraseScroll, nil, 0)
    phraseScroll.isVisible = true
    showButtons(phraseButtons)
    showButtons(menuBarButtons)
  elseif id == 8 then
    hideButtons(phraseMenuButtons)
    phraseText.text = "Legal Phrases"
    populatePhrases(phraseScroll, nil, 1)
    phraseScroll.isVisible = true
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
  elseif id == 12 then
    submitRegistration()
  elseif id == 13 then
	  hideButtons(registrationButtons)
	  showButtons(loginButtons)
  elseif id == 99 then
    hideButtons(currentButtons)
    populateScroll(countryScroll, nil)
    countryScroll.isVisible = true
    showButtons(countryButtons)
    showButtons(menuBarButtons)
  elseif string.starts(id,"country") then
    currentCountryId = id:sub(8)
    for row in db:nrows([[SELECT name FROM country WHERE id=]] .. currentCountryId) do
      countrySelectButton:setLabel("Current Country: " .. row.name)
    end
    hideButtons(currentButtons)
    showButtons(mainMenuButtons)
    showButtons(menuBarButtons)
  end
end

-- handle searching for lawyer
local function searchListenerLaw( event )
  if ( event.phase == "ended" or event.phase == "submitted" ) then
    lawyerScroll:removeSelf()
    lawyerScroll = getScroll("lawyer")
    table.insert(currentButtons, lawyerScroll)
    populateScroll(lawyerScroll, lawyerSearch.text)
  end
end

-- handle searching for country
local function searchListenerCountry( event )
  if ( event.phase == "ended" or event.phase == "submitted" ) then
    countryScroll:removeSelf()
    countryScroll = getScroll("country")
    table.insert(currentButtons, countryScroll)
    populateScroll(countryScroll, countrySearch.text)
  end
end

function submitRegistration()
  query = [[INSERT INTO user (email, password, name, mobilenum, nokemail, nokname, nokmobile) VALUES ("]] 
    .. inputRegEmail.text .. [[", "]] .. inputRegPassword.text .. [[", "]] .. inputFname.text .. " " .. inputSname.text 
    .. [[", "]] .. inputMobile.text .. [[", "]] .. inputKinEmail.text .. [[", "]] .. inputKinFname.text .. " " .. inputKinSname.text
    .. [[", "]] .. inputKinMobile.text .. [[");]]
  db:exec(query)
end

function loginAccepted()
  query = [[SELECT * FROM user WHERE email="]] .. inputLoadEmail.text .. [["]]
  for row in db:nrows(query) do
    if row.password == inputLoadPassword.text then
      userType = row.usertype
      print("User type = " .. userType)
      return true
    end
    return false
  end
end

-- utility to make buttons
local function addButton( ID, x, y, width, height, btnType, label )
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

backLoadEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.65, display.contentWidth, display.contentHeight/15)
backLoadEmail:setFillColor (0, 0.8, 0.8)
inputLoadEmail = native.newTextField(0,0,200,30)
txtLoadEmail = display.newText( "Email",display.contentWidth/0.8, display.contentHeight/6.15, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputLoadEmail.x = display.contentWidth/2.9
inputLoadEmail.y = display.contentHeight/6.6
inputLoadEmail:setTextColor(0,0,0)
--set input type
inputLoadEmail.inputType = "default"
--define the placeholder
inputLoadEmail.placeholder = "-- insert email--"
--set font
inputLoadEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputLoadEmail)

-- password capture
backLoadPassword = display.newRect(display.contentWidth/2, display.contentHeight/4.2, display.contentWidth, display.contentHeight/15)
backLoadPassword:setFillColor (0, 0.8, 0.8)
inputLoadPassword = native.newTextField(0,0,200,30)
txtLoadPassword = display.newText( "Password", display.contentWidth/0.83, display.contentHeight/4, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputLoadPassword.x = display.contentWidth/2.9
inputLoadPassword.y = display.contentHeight/4.2
inputLoadPassword:setTextColor(0,0,0) 
--set input type
inputLoadPassword.inputType = "default"
inputLoadPassword.isSecure = true
--define the placeholder
inputLoadPassword.placeholder = "-- insert password --"
--set font
inputLoadPassword.font = native.newFont(native.systemFont, 12)

------- registration fields
-- registration label
backRegistration = display.newRect(display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15)
backRegistration:setFillColor (0, 0.8, 0.8)
txtRegistration = display.newText("REGISTRATION", display.contentWidth/2.5, display.contentHeight/13.5, display.contentWidth, display.contentHeight/15, native.systemFont, 16)
txtRegistration:setFillColor (1,1,1 )
txtRegistration.x = display.contentWidth/1.25
txtRegistration.y = display.contentHeight/12.5

-- email field
backRegEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.1, display.contentWidth, display.contentHeight/15)
backRegEmail:setFillColor (0, 0.8, 0.8)
inputRegEmail = native.newTextField(0,0,200,30)
txtRegEmail = display.newText( "Email",display.contentWidth/0.84, display.contentHeight/5.6, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputRegEmail.x = display.contentWidth/2.9
inputRegEmail.y = display.contentHeight/6.2
inputRegEmail:setTextColor(0,0,0)
--set input type
inputRegEmail.inputType = "default"
--define the placeholder
inputRegEmail.placeholder = "-- insert email--"
--set font
inputRegEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputEmail)

-- First Name
backFname = display.newRect(display.contentWidth/2, display.contentHeight/4.1, display.contentWidth, display.contentHeight/15)
backFname:setFillColor (0, 0.8, 0.8)
inputFname = native.newTextField(0,0,200,30)
txtFname = display.newText( "First Name", display.contentWidth/0.84, display.contentHeight/3.9, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
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
txtSname = display.newText( "Surname", display.contentWidth/0.84, display.contentHeight/3, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
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
txtMobile = display.newText( "Mobile no", display.contentWidth/0.84, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
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
backRegPassword = display.newRect(display.contentWidth/2, display.contentHeight/2.1, display.contentWidth, display.contentHeight/15)
backRegPassword:setFillColor (0, 0.8, 0.8)
inputRegPassword = native.newTextField(0,0,200,30)
txtRegPassword = display.newText( "Password", display.contentWidth/0.84, display.contentHeight/2.0275, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputRegPassword.x = display.contentWidth/2.9
inputRegPassword.y = display.contentHeight/2.1
inputRegPassword:setTextColor(0,0,0) 
--set input type
inputRegPassword.inputType = "default"
inputRegPassword.isSecure = true
--define the placeholder
inputRegPassword.placeholder = "-- insert password --"
--set font
inputRegPassword.font = native.newFont(native.systemFont, 12)


-- Next of Kin label
backKin = display.newRect(display.contentWidth/2, display.contentHeight/1.775, display.contentWidth/1, display.contentHeight/15)
backKin:setFillColor (0, 0.8, 0.8)
txtKin = display.newText( "NEXT OF KIN", display.contentWidth/1.17, display.contentHeight/1.725, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )

-- Next of Kin Email
backKinEmail = display.newRect(display.contentWidth/2, display.contentHeight/1.57, display.contentWidth, display.contentHeight/15)
backKinEmail:setFillColor (0, 0.8, 0.8)
inputKinEmail = native.newTextField(0,0,200,30)
txtKinEmail = display.newText( "Email", display.contentWidth/0.84, display.contentHeight/1.5375, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinEmail.x = display.contentWidth/2.9
inputKinEmail.y = display.contentHeight/1.57
inputKinEmail:setTextColor(0,0,0) 
--set input type
inputKinEmail.inputType = "default"
--define the placeholder
inputKinEmail.placeholder = "-- insert NOK first name --"
--set font
inputKinEmail.font = native.newFont(native.systemFont, 12)

-- Next of Kin First Name
backKinFname = display.newRect(display.contentWidth/2, display.contentHeight/1.4, display.contentWidth, display.contentHeight/15)
backKinFname:setFillColor (0, 0.8, 0.8)
inputKinFname = native.newTextField(0,0,200,30)
txtKinFname = display.newText( "First Name", display.contentWidth/0.84, display.contentHeight/1.3775, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinFname.x = display.contentWidth/2.9
inputKinFname.y = display.contentHeight/1.4
inputKinFname:setTextColor(0,0,0) 
--set input type
inputKinFname.inputType = "default"
--define the placeholder
inputKinFname.placeholder = "-- insert NOK first name --"
--set font
inputKinFname.font = native.newFont(native.systemFont, 12)

-- Next of Kin SurnName
backKinSname = display.newRect(display.contentWidth/2, display.contentHeight/1.27, display.contentWidth, display.contentHeight/15)
backKinSname:setFillColor (0, 0.8, 0.8)
inputKinSname = native.newTextField(0,0,200,30)
txtKinSname = display.newText( "Surname", display.contentWidth/0.84, display.contentHeight/1.25, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinSname.x = display.contentWidth/2.9
inputKinSname.y = display.contentHeight/1.27
inputKinSname:setTextColor(0,0,0) 
--set input type
inputKinSname.inputType = "default"
--define the placeholder
inputKinSname.placeholder = "-- insert NOK Surname --"
--set font
inputKinSname.font = native.newFont(native.systemFont, 12)

-- Next of Kin Mobile no
backKinMobile = display.newRect(display.contentWidth/2, display.contentHeight/1.16, display.contentWidth, display.contentHeight/15)
backKinMobile:setFillColor (0, 0.8, 0.8)
inputKinMobile = native.newTextField(0,0,200,30)
txtKinMobile = display.newText( "Mobile no", display.contentWidth/0.84, display.contentHeight/1.14, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinMobile.x = display.contentWidth/2.9
inputKinMobile.y = display.contentHeight/1.16
inputKinMobile:setTextColor(0,0,0) 
--set input type
inputKinMobile.inputType = "default"
--define the placeholder
inputKinMobile.placeholder = "-- insert NOK Mobile --"
--set font
inputKinMobile.font = native.newFont(native.systemFont, 12)


-- scroll pane for local lawyer & country lists

function getScroll( scrollType )
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

function addButtonToScroll(scroll, row, num)
  button = widget.newButton(
    {
      id = scroll.id .. row.id,
      label = row.name,
      shape = "roundedRect",
      cornerRadius = 0,
      fillColor = white,
      strokeWidth = 0,
      height = display.contentHeight/9,
      width = 300,
      x = display.contentWidth/2,
      y = (num * 75) + 30,
      onRelease = handleInput
    }
  )
  scroll:insert(button)
  table.insert(currentButtons, button)
end

lawyerScroll = getScroll( "lawyer" )
lawyerSearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,50)
lawyerSearch.placeholder = "Search Lawyer"
lawyerSearch.id = "lawyerId"
lawyerSearch:addEventListener("userInput", searchListenerLaw)

countryScroll = getScroll( "country" )
countrySearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,50)
countrySearch.placeholder = "Search Country"
countrySearch.id = "countryId"
countrySearch:addEventListener("userInput", searchListenerCountry)

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

-- scroll panes for phrase lists
function addPhraseToScroll(scroll, row, num)
  button1 = display.newText(
    {
      text = row.english,
      height = display.contentHeight/8.4,
      width = display.contentWidth - 30,
      x = display.contentWidth/2,
      y = (num * 60) + 30
    }
  )
  button2 = display.newText(
    {
      text = row.translated,
      height = display.contentHeight/8.4,
      width = display.contentWidth - 60,
      x = display.contentWidth/2 + 30,
      y = button1.y + display.contentHeight/8.4
    }
  )
  bg1 = display.newRect( button1.x, button1.y - 20, display.contentWidth, button1.height + 10 )
  bg1:setFillColor(1,1,1)
  bg2 = display.newRect( button2.x - 10, button2.y - 20, button2.width + 20, button2.height + 10 )
  bg2:setFillColor(1,1,1)
  button1:setFillColor(black)
  button2:setFillColor(black)
  scroll:insert(bg1)
  scroll:insert(button1)
  scroll:insert(bg2)
  scroll:insert(button2)
  table.insert(currentButtons, button1)
  table.insert(currentButtons, bg1)
  table.insert(currentButtons, button2)
  table.insert(currentButtons, bg2)
end

function populatePhrases( scroll, search, phraseType )
  if search == nil then
    query = [[SELECT * FROM phrase WHERE countryid=]] .. currentCountryId .. [[ AND phrasetype=]] .. phraseType
  else
    query = [[SELECT * FROM phrase WHERE UPPER(english) LIKE "%]] 
    .. search:upper() .. [[%" AND countryid=]] .. currentCountryId 
    .. [[ AND phrasetype=]] .. phraseType
  end
  query = query .. [[ ORDER BY english ASC]]
  print("Query = " .. query)
  i = 0
  for row in db:nrows(query) do
    addPhraseToScroll(scroll, row, i)
    i = i + 2
  end
end

phraseScroll = getScroll( "phrase" )
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

-- Current Country display group (inc button)

local countryGroup = display.newGroup()

local globe = display.newImage("globe.png" ,display.contentWidth/5, display.contentHeight/10)
globe:scale(.125,.125)
countryGroup:insert(globe)

local fingerPress = display.newImage ("fingerpress.png",display.contentWidth/1.15, display.contentHeight/10)
fingerPress:scale(.4, .4)
countryGroup:insert(fingerPress)

countrySelectButton = addButton( 99, display.contentWidth/1.9, display.contentHeight/10, display.contentWidth, display.contentHeight/10, "countrySelect", 'Current Country: Australia')
countryGroup:insert(countrySelectButton)
countrySelectButton:toBack()

menuBarButtons = {
    addButton( 1, display.contentWidth/2, display.contentHeight + 10, 130, 38, "panic", 'Panic Button'), 
    addButton( 2, homeButton.x, homeButton.y, homeButton.width*0.22, homeButton.height*0.22, "icon", homeButton ),
    addButton( 3, panicSettingsButton.x, panicSettingsButton.y, panicSettingsButton.width*0.12, panicSettingsButton.height*0.12, "icon", panicSettingsButton ),
    homeButton,
    panicSettingsButton
  }
  
mainMenuButtons = {
    countryGroup,
		addButton( 4, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Local Lawyers'),
		addButton( 5, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Phrase Translation'), 
		addButton( 6, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Useful Contacts'), 
  }
  
phraseMenuButtons = {
    countryGroup,
		addButton( 7, display.contentWidth/2, 2*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Useful Phrases'),
		addButton( 8, display.contentWidth/2, 3.5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Legal Phrases'), 
		addButton( 9, display.contentWidth/2, 5*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Favourite Phrases'), 
  }
  
loginButtons = {
		addButton( 10, display.contentWidth/2, 6*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "", 'Login'),
		addButton( 11, display.contentWidth/2, 7*display.contentHeight/8, display.contentWidth, display.contentHeight/11.5, "",  'Register'),
    backLoadEmail,
    txtLoadEmail,
    inputLoadEmail,
    backLoadPassword,
    txtLoadPassword,
    inputLoadPassword,
  }

registrationButtons = {
  addButton( 12, display.contentWidth/2, 7.55*display.contentHeight/8, display.contentWidth/2, display.contentHeight/15, "", 'Confirm'),
  addButton( 13, display.contentWidth/2, 8.3*display.contentHeight/8, display.contentWidth/2, display.contentHeight/15, "",  'Back'),
	backRegistration,
	txtRegistration,
	backRegEmail,
	inputRegEmail,
	txtRegEmail,
	backFname,
	inputFname,
	txtFname,
	backSname,
	inputSname,
	txtSname,
	backMobile,
	inputMobile,
	txtMobile,
	backRegPassword,
	inputRegPassword,
	txtRegPassword,
	backKin,
	txtKin,
	backKinEmail,
	inputKinEmail,
	txtKinEmail,
	backKinFname,
	inputKinFname,
	txtKinFname,
	backKinSname,
	inputKinSname,
	txtKinSname,
	backKinMobile,
	inputKinMobile,
	txtKinMobile
}

localLawyerButtons = {
  lawyerScroll,
  lawyerSearch
}

countryButtons = {
  countryScroll,
  countrySearch
}

phraseButtons = {
  countryGroup,
  phraseScroll,
  phraseText,
  phraseRectangle
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
hideButtons(countryButtons)
hideButtons(phraseMenuButtons)
hideButtons(menuBarButtons)
hideButtons(localLawyerButtons)
showButtons(loginButtons)
hideButtons(mainMenuButtons)
hideButtons(registrationButtons)

lunit.run("unit_tests")
