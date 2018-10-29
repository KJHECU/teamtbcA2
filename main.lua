----------------------------------------------------------------------------------------
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

local currentCountryId = 1
local currentCountry = "Australia"
local userType = 0
local currentUserId
local radioPhraseType = 0

local loginForm = true
local regForm = true
local addLawyerForm = true

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
  elseif id == 3 then
    profileScroll = getScroll( "profile" )
    hideButtons(currentButtons)
    showButtons(profileButtons)
    showButtons(menuBarButtons)
    populateProfile("user", currentUserId, profileScroll)
    profileScroll.isVisible = true
  elseif id == 4 then
    hideButtons(currentButtons)
    populateScroll(lawyerScroll, nil)
    lawyerScroll.isVisible = true
    lawyerScroll:toFront()
    showButtons(localLawyerButtons)
    showButtons(menuBarButtons)
		if userType == 1 then
		 addLawyerButton.isVisible = true
		else
		 addLawyerButton.isVisible = false
		end
  elseif id == 5 then
    hideButtons(mainMenuButtons)
    showButtons(phraseMenuButtons)
    showButtons(menuBarButtons)
  elseif id == 6 then
    hideButtons(mainMenuButtons)
    showButtons(contactsButtons)
    populateContacts(contactsScroll)
    contactsScroll.isVisible = true
  elseif id == 7 then
    hideButtons(phraseMenuButtons)
    phraseText.text = "Useful Phrases"
    populatePhrases(phraseScroll, nil, 0)
    phraseScroll.isVisible = true
    showButtons(phraseButtons)
    showButtons(menuBarButtons)
	if userType == 1 then
		 addPhraseButton.isVisible = true
		else
		 addPhraseButton.isVisible = false
		end
  elseif id == 8 then
    hideButtons(phraseMenuButtons)
    phraseText.text = "Legal Phrases"
    populatePhrases(phraseScroll, nil, 1)
    phraseScroll.isVisible = true
    showButtons(phraseButtons)
    showButtons(menuBarButtons)
    if userType == 1 then
		 addPhraseButton.isVisible = true
		else
		 addPhraseButton.isVisible = false
		end
  elseif id == 10 then
    if loginAccepted() then
      hideButtons(loginButtons)
      showButtons(mainMenuButtons)
      showButtons(menuBarButtons)
      loginError.isVisible = false
	 end
  elseif id == 11 then
	  hideButtons(loginButtons)
	  showButtons(registrationButtons)
  elseif id == 12 then
    if regFormValid() then
      submitRegistration()
      hideButtons(registrationButtons)
      showButtons (loginButtons)
      regConf = native.showAlert( "Registration", "Registration for " .. inputRegEmail.text .. " Successful!", {"Ok"}, onRegister )
    end
  elseif id == 13 then
	  hideButtons(registrationButtons)
	  showButtons(loginButtons)
  elseif id == 14 then
    if userType == 1 then
      hideButtons(currentButtons)
      showButtons(addLawyerButtons)
    end
  elseif id == 15 then
    if addLawyerValid() then
     addNewLawyer()
     showButtons(localLawyerButtons)
     hideButtons(currentButtons)
    end
  elseif id == 16 then
    hideButtons(currentButtons)
    populateScroll(lawyerScroll, nil)
    lawyerScroll.isVisible = true
    showButtons(localLawyerButtons)
    showButtons(menuBarButtons)
  elseif id == 17 then
  if userType == 1 then
    hideButtons(currentButtons)
    showButtons(addPhraseButtons)
  end 
  elseif id == 18 then
    if addPhraseValid() then
     addNewPhrase()
	 hideButtons(currentButtons)
     showButtons(phraseMenuButtons)
  end  
  elseif id == 19 then
    hideButtons(currentButtons)
    showButtons(phraseMenuButtons)
	showButtons(menuBarButtons)
  elseif string.starts(id,"binPhrase") then
    deletePhrase(id)
	hideButtons(currentButtons)
    showButtons(phraseMenuButtons)
	showButtons(menuBarButtons)
  elseif string.starts(id,"binLawyer") then
	print("hitting this")
    deleteLawyer(id)
	hideButtons(currentButtons)
    showButtons(phraseMenuButtons)
	showButtons(menuBarButtons)
  elseif id == 99 then
    hideButtons(currentButtons)
    populateScroll(countryScroll, nil)
    countryScroll.isVisible = true
    countryScroll:toFront()
    showButtons(countryButtons)
    showButtons(menuBarButtons)
  elseif string.starts(id,"country") then
    currentCountryId = id:sub(8)
    for row in db:nrows([[SELECT name FROM country WHERE id=]] .. currentCountryId) do
      countrySelectButton:setLabel("Current Country: " .. row.name)
      currentCountry = row.name
      txtstaticCountry.text = "Current Country: "..currentCountry
    end
    hideButtons(currentButtons)
    showButtons(mainMenuButtons)
    showButtons(menuBarButtons)
  elseif string.starts(id, "lawyer") then
    profileScroll = getScroll( "profile" )
    hideButtons(currentButtons)
    showButtons(profileButtons)
    showButtons(menuBarButtons)
    populateProfile("lawyer", id:sub(7), profileScroll)
    profileScroll.isVisible = true
  end
end

-- local function for button click

local function onRegister(event)
	if (event.action == "clicked") then
		local i = event.index
		if (i ==  1) then
		end
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

-- function validating registration form
function regFormValid()
  regForm = true
  if isEmpty(inputRegEmail) then
    inputRegEmail.placeholder = "Email not provided"
    regForm = false
  end
  if isEmpty(inputFname) then
    inputFname.placeholder = "First Name not provided"
    regForm = false
  end
	if isEmpty(inputSname) then
    inputSname.placeholder = "Surname not provided"
    regForm = false
  end
	if isEmpty(inputMobile) then
    inputMobile.placeholder = "Mobile not provided"
    regForm = false
	 end
	if isEmpty(inputRegPassword) then
    inputRegPassword.placeholder = "Password not provided"
    regForm = false
  end
	if isEmpty(inputKinEmail) then
    inputKinEmail.placeholder = "Email not provided"
    regForm = false
	 end
	if isEmpty(inputKinFname) then
    inputKinFname.placeholder = "First Name not provided"
    regForm = false
  end
	if isEmpty(inputKinSname) then
    inputKinSname.placeholder = "Surname not provided"
    regForm = false
  end
  if isEmpty(inputKinMobile) then
    inputKinMobile.placeholder = "Mobile not provided"
    regForm = false
  end
  return regForm
end

-- function validating add Lawyer form
function addLawyerValid()
  addLawyerForm = true
  if isEmpty(inputaddLawyerEmail) then
    inputaddLawyerEmail.placeholder = "Email not provided"
    addLawyerForm = false
  end
  if isEmpty(inputaddLawyerFname) then
    inputaddLawyerFname.placeholder = "First Name not provided"
    addLawyerForm = false
  end
	if isEmpty(inputaddLawyerSname) then
    inputaddLawyerSname.placeholder = "Surname not provided"
    addLawyerForm = false
  end
	if isEmpty(inputaddLawyerMobile) then
    inputaddLawyerMobile.placeholder = "Mobile not provided"
    addLawyerForm = false
  end
  return addLawyerForm
end

-- function validating add Phrase form
function addPhraseValid()
  addPhraseForm = true
  if isEmpty(inputaddPhraseEnglish) then
    inputaddPhraseEnglish.placeholder = "English phrase not provided"
    addPhraseForm = false
  end
  if isEmpty(inputaddPhraseTrans) then
    inputaddPhraseTrans.placeholder = "Translated phrase not provided"
    addPhraseForm = false
  end
  return addPhraseForm
end


-- function which handles the registration of new users (INSERT)
function submitRegistration()
  query = [[INSERT INTO user (email, password, name, mobilenum, nokemail, nokname, nokmobile) VALUES ("]]
    .. inputRegEmail.text .. [[", "]] .. inputRegPassword.text .. [[", "]] .. inputFname.text .. " " .. inputSname.text
    .. [[", "]] .. inputMobile.text .. [[", "]] .. inputKinEmail.text .. [[", "]] .. inputKinFname.text .. " " .. inputKinSname.text
    .. [[", "]] .. inputKinMobile.text .. [[");]]
  db:exec(query)
end

-- function which handles the addition of new laywers (INSERT)
function addNewLawyer()
  query = [[INSERT INTO lawyer (email, name, mobilenum, countryid) VALUES ("]]
    .. inputaddLawyerEmail.text .. [[", "]] .. inputaddLawyerFname.text .. " " .. inputaddLawyerSname.text .. [[", "]] .. inputaddLawyerMobile.text .. [[", "]] .. currentCountryId ..[[");]]
  db:exec(query)
end

-- function which handles the addition of new phrases (INSERT)
function addNewPhrase()
  query = [[INSERT INTO phrase (english, translated, countryid, phrasetype) VALUES ("]]
    .. inputaddPhraseEnglish.text .. [[", "]] .. inputaddPhraseTrans.text .. [[", "]] .. currentCountryId .. [[", "]] .. radioPhraseType .. [[");]]
  db:exec(query)
  print(query)
end


-- function which handles login
function loginAccepted()
  emptyField = false
  if isEmpty(inputLoadEmail) then
	  inputLoadEmail.placeholder = "Email not provided"
    emptyField = true
	end
	if isEmpty(inputLoadPassword) then
	  inputLoadPassword.placeholder = "Password not provided"
    emptyField = true
	end
  if emptyField then
    return false
  end
  query = [[SELECT * FROM user WHERE email="]] .. inputLoadEmail.text .. [["]]
  for row in db:nrows(query) do
	if row.password == inputLoadPassword.text then
		  userType = row.usertype
      currentUserId = row.userid
		  return true
		end
	loginError.isVisible = true
	return false
   end
	loginError.isVisible = true
	return false
end


-- function which checks for empty input fields
function isEmpty(field)
	if field.text == "" then
		return true
	else
		return false
	end
end

-- function which deletes phrases
function deletePhrase(id)
	 phraseID = string.sub( id, 10 )
	 query = [[DELETE FROM phrase WHERE id=]] .. phraseID
	 db:exec(query)
	 print(query)
end

-- function which deletes lawyers
function deleteLawyer(id)
	 lawyerID = string.sub( id, 10 )
	 query = [[DELETE FROM lawyer WHERE id=]] .. lawyerID
	 db:exec(query)
	 print(query)
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


homeButton = display.newImage("home_white_192x192.png")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10

panicSettingsButton = display.newImage("User-Profile.png")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10

addLawyerButton = display.newImage("addButton.png")
 addLawyerButton:scale(0.5,0.5)
 addLawyerButton.y = display.contentHeight/5.5
 addLawyerButton.x = display.contentWidth/1.125
 addLawyerButton.isVisible = false
 
addPhraseButton = display.newImage("addButton.png")
 addPhraseButton:scale(0.5,0.5)
 addPhraseButton.y = display.contentHeight/5.8
 addPhraseButton.x = display.contentWidth/1.125
 addPhraseButton.isVisible = false
 

-- login feature which is enabled by default --

-- login username capture
backLoadEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.65, display.contentWidth, display.contentHeight/15)
backLoadEmail:setFillColor (0, 0.8, 0.8)
inputLoadEmail = native.newTextField(0,0,200,30)
txtLoadEmail = display.newText( "Email",display.contentWidth/0.8, display.contentHeight/6.15, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputLoadEmail.x = display.contentWidth/2.9
inputLoadEmail.y = display.contentHeight/6.6
inputLoadEmail:setTextColor(0,0,0)
inputLoadEmail.inputType = "default"
inputLoadEmail.placeholder = "-- enter email--"
inputLoadEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputLoadEmail)

-- login password capture
backLoadPassword = display.newRect(display.contentWidth/2, display.contentHeight/4.2, display.contentWidth, display.contentHeight/15)
backLoadPassword:setFillColor (0, 0.8, 0.8)
inputLoadPassword = native.newTextField(0,0,200,30)
txtLoadPassword = display.newText( "Password", display.contentWidth/0.83, display.contentHeight/4, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputLoadPassword.x = display.contentWidth/2.9
inputLoadPassword.y = display.contentHeight/4.2
inputLoadPassword:setTextColor(0,0,0)
inputLoadPassword.inputType = "default"
inputLoadPassword.isSecure = true
inputLoadPassword.placeholder = "-- enter password --"
inputLoadPassword.font = native.newFont(native.systemFont, 12)
loginError = display.newText( "Invalid Email and/or Password", display.contentWidth/1.5, display.contentHeight/8.5, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
loginError:setFillColor (255,0,0)
loginError.isVisible = false

------- registration fields
-- registration label
backRegistration = display.newRect(display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15)
backRegistration:setFillColor (0, 0.8, 0.8)
txtRegistration = display.newText("REGISTRATION", display.contentWidth/2.5, display.contentHeight/13.5, display.contentWidth, display.contentHeight/15, native.systemFont, 16)
txtRegistration:setFillColor (1,1,1 )
txtRegistration.x = display.contentWidth/1.25
txtRegistration.y = display.contentHeight/12.5

-- registration email field
backRegEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.1, display.contentWidth, display.contentHeight/15)
backRegEmail:setFillColor (0, 0.8, 0.8)
inputRegEmail = native.newTextField(0,0,200,30)
txtRegEmail = display.newText( "Email",display.contentWidth/0.84, display.contentHeight/5.6, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputRegEmail.x = display.contentWidth/2.9
inputRegEmail.y = display.contentHeight/6.2
inputRegEmail:setTextColor(0,0,0)
inputRegEmail.inputType = "default"
inputRegEmail.placeholder = "-- insert email--"
inputRegEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputEmail)

-- registration First Name
backFname = display.newRect(display.contentWidth/2, display.contentHeight/4.1, display.contentWidth, display.contentHeight/15)
backFname:setFillColor (0, 0.8, 0.8)
inputFname = native.newTextField(0,0,200,30)
txtFname = display.newText( "First Name", display.contentWidth/0.84, display.contentHeight/3.9, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputFname.x = display.contentWidth/2.9
inputFname.y = display.contentHeight/4.2
inputFname:setTextColor(0,0,0)
inputFname.inputType = "default"
inputFname.placeholder = "-- insert first name --"
inputFname.font = native.newFont(native.systemFont, 12)

-- registration Surname
backSname = display.newRect(display.contentWidth/2, display.contentHeight/3.1, display.contentWidth, display.contentHeight/15)
backSname:setFillColor (0, 0.8, 0.8)
inputSname = native.newTextField(0,0,200,30)
txtSname = display.newText( "Surname", display.contentWidth/0.84, display.contentHeight/3, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputSname.x = display.contentWidth/2.9
inputSname.y = display.contentHeight/3.1
inputSname:setTextColor(0,0,0)
inputSname.inputType = "default"
inputSname.placeholder = "-- insert first name --"
inputSname.font = native.newFont(native.systemFont, 12)

-- registration Mobile No
backMobile = display.newRect(display.contentWidth/2, display.contentHeight/2.5, display.contentWidth, display.contentHeight/15)
backMobile:setFillColor (0, 0.8, 0.8)
inputMobile = native.newTextField(0,0,200,30)
txtMobile = display.newText( "Mobile no", display.contentWidth/0.84, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputMobile.x = display.contentWidth/2.9
inputMobile.y = display.contentHeight/2.5
inputMobile:setTextColor(0,0,0)
inputMobile.inputType = "default"
inputMobile.placeholder = "-- insert first name --"
inputMobile.font = native.newFont(native.systemFont, 12)

-- registration Password
backRegPassword = display.newRect(display.contentWidth/2, display.contentHeight/2.1, display.contentWidth, display.contentHeight/15)
backRegPassword:setFillColor (0, 0.8, 0.8)
inputRegPassword = native.newTextField(0,0,200,30)
txtRegPassword = display.newText( "Password", display.contentWidth/0.84, display.contentHeight/2.0275, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputRegPassword.x = display.contentWidth/2.9
inputRegPassword.y = display.contentHeight/2.1
inputRegPassword:setTextColor(0,0,0)
inputRegPassword.inputType = "default"
inputRegPassword.isSecure = true
inputRegPassword.placeholder = "-- insert password --"
inputRegPassword.font = native.newFont(native.systemFont, 12)

-- registration Next of Kin label
backKin = display.newRect(display.contentWidth/2, display.contentHeight/1.775, display.contentWidth/1, display.contentHeight/15)
backKin:setFillColor (0, 0.8, 0.8)
txtKin = display.newText( "NEXT OF KIN", display.contentWidth/1.17, display.contentHeight/1.725, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )

-- registration Next of Kin Email
backKinEmail = display.newRect(display.contentWidth/2, display.contentHeight/1.57, display.contentWidth, display.contentHeight/15)
backKinEmail:setFillColor (0, 0.8, 0.8)
inputKinEmail = native.newTextField(0,0,200,30)
txtKinEmail = display.newText( "Email", display.contentWidth/0.84, display.contentHeight/1.5375, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinEmail.x = display.contentWidth/2.9
inputKinEmail.y = display.contentHeight/1.57
inputKinEmail:setTextColor(0,0,0)
inputKinEmail.inputType = "default"
inputKinEmail.placeholder = "-- insert NOK first name --"
inputKinEmail.font = native.newFont(native.systemFont, 12)

-- registration Next of Kin First Name
backKinFname = display.newRect(display.contentWidth/2, display.contentHeight/1.4, display.contentWidth, display.contentHeight/15)
backKinFname:setFillColor (0, 0.8, 0.8)
inputKinFname = native.newTextField(0,0,200,30)
txtKinFname = display.newText( "First Name", display.contentWidth/0.84, display.contentHeight/1.3775, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinFname.x = display.contentWidth/2.9
inputKinFname.y = display.contentHeight/1.4
inputKinFname:setTextColor(0,0,0)
inputKinFname.inputType = "default"
inputKinFname.placeholder = "-- insert NOK first name --"
inputKinFname.font = native.newFont(native.systemFont, 12)

-- registration Next of Kin SurnName
backKinSname = display.newRect(display.contentWidth/2, display.contentHeight/1.27, display.contentWidth, display.contentHeight/15)
backKinSname:setFillColor (0, 0.8, 0.8)
inputKinSname = native.newTextField(0,0,200,30)
txtKinSname = display.newText( "Surname", display.contentWidth/0.84, display.contentHeight/1.25, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinSname.x = display.contentWidth/2.9
inputKinSname.y = display.contentHeight/1.27
inputKinSname:setTextColor(0,0,0)
inputKinSname.inputType = "default"
inputKinSname.placeholder = "-- insert NOK Surname --"
inputKinSname.font = native.newFont(native.systemFont, 12)

-- registration Next of Kin Mobile no
backKinMobile = display.newRect(display.contentWidth/2, display.contentHeight/1.16, display.contentWidth, display.contentHeight/15)
backKinMobile:setFillColor (0, 0.8, 0.8)
inputKinMobile = native.newTextField(0,0,200,30)
txtKinMobile = display.newText( "Mobile no", display.contentWidth/0.84, display.contentHeight/1.14, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputKinMobile.x = display.contentWidth/2.9
inputKinMobile.y = display.contentHeight/1.16
inputKinMobile:setTextColor(0,0,0)
inputKinMobile.inputType = "default"
inputKinMobile.placeholder = "-- insert NOK Mobile --"
inputKinMobile.font = native.newFont(native.systemFont, 12)

------- add local lawyer fields
-- add Lawyer
backaddLawyer = display.newRect(display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15)
backaddLawyer:setFillColor (0, 0.8, 0.8)
txtaddLawyer = display.newText("ADD LAWYER", display.contentWidth/3.3, display.contentHeight/13.5, display.contentWidth, display.contentHeight/15, native.systemFont, 16)
txtaddLawyer:setFillColor (1,1,1 )
txtaddLawyer.x = display.contentWidth/1.25
txtaddLawyer.y = display.contentHeight/12.5

-- add Lawyer email field
backaddLawyerEmail = display.newRect(display.contentWidth/2, display.contentHeight/6.1, display.contentWidth, display.contentHeight/15)
backaddLawyerEmail:setFillColor (0, 0.8, 0.8)
inputaddLawyerEmail = native.newTextField(0,0,200,30)
txtaddLawyerEmail = display.newText( "Email",display.contentWidth/0.84, display.contentHeight/5.6, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputaddLawyerEmail.x = display.contentWidth/2.9
inputaddLawyerEmail.y = display.contentHeight/6.2
inputaddLawyerEmail:setTextColor(0,0,0)
inputaddLawyerEmail.inputType = "default"
inputaddLawyerEmail.placeholder = "-- insert email--"
inputaddLawyerEmail.font = native.newFont(native.systemFont, 12)
native.setKeyboardFocus(inputEmail)

-- add Lawyer First Name
backaddLawyerFname = display.newRect(display.contentWidth/2, display.contentHeight/4.1, display.contentWidth, display.contentHeight/15)
backaddLawyerFname:setFillColor (0, 0.8, 0.8)
inputaddLawyerFname = native.newTextField(0,0,200,30)
txtaddLawyerFname = display.newText( "First Name", display.contentWidth/0.84, display.contentHeight/3.9, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputaddLawyerFname.x = display.contentWidth/2.9
inputaddLawyerFname.y = display.contentHeight/4.05
inputaddLawyerFname:setTextColor(0,0,0)
inputaddLawyerFname.inputType = "default"
inputaddLawyerFname.placeholder = "-- insert first name --"
inputaddLawyerFname.font = native.newFont(native.systemFont, 12)

-- add Lawyer Surname
backaddLawyerSname = display.newRect(display.contentWidth/2, display.contentHeight/3.1, display.contentWidth, display.contentHeight/15)
backaddLawyerSname:setFillColor (0, 0.8, 0.8)
inputaddLawyerSname = native.newTextField(0,0,200,30)
txtaddLawyerSname = display.newText( "Surname", display.contentWidth/0.84, display.contentHeight/3, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputaddLawyerSname.x = display.contentWidth/2.9
inputaddLawyerSname.y = display.contentHeight/3.1
inputaddLawyerSname:setTextColor(0,0,0)
inputaddLawyerSname.inputType = "default"
inputaddLawyerSname.placeholder = "-- insert surname --"
inputaddLawyerSname.font = native.newFont(native.systemFont, 12)

-- add Lawyer Mobile No
backaddLawyerMobile = display.newRect(display.contentWidth/2, display.contentHeight/2.5, display.contentWidth, display.contentHeight/15)
backaddLawyerMobile:setFillColor (0, 0.8, 0.8)
inputaddLawyerMobile = native.newTextField(0,0,200,30)
txtaddLawyerMobile = display.newText( "Mobile no", display.contentWidth/0.84, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputaddLawyerMobile.x = display.contentWidth/2.9
inputaddLawyerMobile.y = display.contentHeight/2.5
inputaddLawyerMobile:setTextColor(0,0,0)
inputaddLawyerMobile.inputType = "default"
inputaddLawyerMobile.placeholder = "-- insert mobile --"
inputaddLawyerMobile.font = native.newFont(native.systemFont, 12)

------- add phrase fields

-- add Phrase heading
backaddPhrase = display.newRect(display.contentWidth/2, display.contentHeight/15, display.contentWidth, display.contentHeight/15)
backaddPhrase:setFillColor (0, 0.8, 0.8)
txtaddPhrase= display.newText("ADD PHRASE", display.contentWidth/3.3, display.contentHeight/13.5, display.contentWidth, display.contentHeight/15, native.systemFont, 16)
txtaddPhrase:setFillColor (1,1,1 )
txtaddPhrase.x = display.contentWidth/1.25
txtaddPhrase.y = display.contentHeight/12.5

-- add Phrase English
backaddPhraseEnglish = display.newRect(display.contentWidth/2, display.contentHeight/6.1, display.contentWidth, display.contentHeight/15)
backaddPhraseEnglish :setFillColor (0, 0.8, 0.8)
inputaddPhraseEnglish  = native.newTextField(0,0,200,30)
txtaddPhraseEnglish  = display.newText( "English",display.contentWidth/0.84, display.contentHeight/5.6, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputaddPhraseEnglish.x = display.contentWidth/2.9
inputaddPhraseEnglish.y = display.contentHeight/6.2
inputaddPhraseEnglish:setTextColor(0,0,0)
inputaddPhraseEnglish.inputType = "default"
inputaddPhraseEnglish.placeholder = "-- insert english phrase--"
inputaddPhraseEnglish.font = native.newFont(native.systemFont, 12)

-- add Phrase Translation
backaddPhraseTrans = display.newRect(display.contentWidth/2, display.contentHeight/4.1, display.contentWidth, display.contentHeight/15)
backaddPhraseTrans:setFillColor (0, 0.8, 0.8)
inputaddPhraseTrans = native.newTextField(0,0,200,30)
txtaddPhraseTrans = display.newText( "Translation", display.contentWidth/0.84, display.contentHeight/3.9, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
inputaddPhraseTrans.x = display.contentWidth/2.9
inputaddPhraseTrans.y = display.contentHeight/4.05
inputaddPhraseTrans:setTextColor(0,0,0)
inputaddPhraseTrans.inputType = "default"
inputaddPhraseTrans.placeholder = "-- insert phrase translation --"
inputaddPhraseTrans.font = native.newFont(native.systemFont, 12)

-- static Country 
backstaticCountry= display.newRect(display.contentWidth/2, display.contentHeight/2.1, display.contentWidth, display.contentHeight/15)
backstaticCountry:setFillColor (0, 0.8, 0.8)
txtstaticCountry = display.newText("Current Country: "..currentCountry, display.contentWidth/1.4, display.contentHeight/2.05, display.contentWidth, display.contentHeight/15)
txtstaticCountry:setTextColor(1,1,1)
txtstaticCountry.font = native.newFont(native.systemFont, 10)

-- Handle press events for add Phrase radio buttons
local function onSwitchPress( event )
    local switch = event.target
	radioPhraseType = event.target.id
	print (radioPhraseType)
end
 
-- Create a group for the radio button set
local radioPhraseGroup = display.newGroup()
 
backradioPhrase = display.newRect(display.contentWidth/2, display.contentHeight/2.5, display.contentWidth, display.contentHeight/15)
backradioPhrase:setFillColor (0, 0.8, 0.8) 
txtaddUsefulPhrase = display.newText( "Useful", display.contentWidth/1.375, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
txtaddLegalPhrase = display.newText( "Legal", display.contentWidth/0.925, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )

radioPhraseGroup:insert( backradioPhrase )
radioPhraseGroup:insert( txtaddUsefulPhrase )
radioPhraseGroup:insert( txtaddLegalPhrase )

-- Create two associated radio buttons (inserted into the same display group)
local radioUsefulPhrase = widget.newSwitch(
    {
        left = 120,
        top = 175,
        style = "radio",
        id = "0",
        initialSwitchState = true,
        onPress = onSwitchPress,
    }
)
radioPhraseGroup:insert( radioUsefulPhrase )
 
local radioLegalPhrase = widget.newSwitch(
    {
        left = 225,
        top = 175,
        style = "radio",
        id = "1",
        onPress = onSwitchPress
    }
)
radioPhraseGroup:insert( radioLegalPhrase )

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
	
	binLawyerIcon = display.newImage("recycle-bin.png", button.x + 120, button.y )
	binLawyerIcon:scale (0.75, 0.75)
	binLawyer = addButton( "binLawyer".. row.id , button.x + 120, button.y , 25, 25, "icon", binLawyerIcon ) --( ID, x, y, width, height, btnType, label )
	
	scroll:insert(binLawyerIcon)
	scroll:insert(binLawyer)
	table.insert(currentButtons, binLawyerIcon)
	table.insert(currentButtons, binLawyer)
		
  else
	  scroll:insert(button)
	  table.insert(currentButtons, button)
  end
end

lawyerScroll = getScroll( "lawyer" )
lawyerSearch = native.newTextField(display.contentWidth/2,display.contentHeight/5.5,0.5*display.contentWidth,26)
lawyerSearch.placeholder = "Search Lawyer"
lawyerSearch.id = "lawyerId"
lawyerSearch:addEventListener("userInput", searchListenerLaw)

countryScroll = getScroll( "country" )
countrySearch = native.newTextField(display.contentWidth/2,display.contentHeight/12,0.9*display.contentWidth,26)
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
contactsScroll = getScroll( "contacts" )

-- scroll panes for phrase lists
function addPhraseToScroll(scroll, row, num)
  button1 = display.newText(
    {
      text = row.english,
      height = display.contentHeight/8,
      width = display.contentWidth - 80,
      x = display.contentWidth/2.3,
      y = (num * 60) + 62,
      fontSize = 14
    }
  )
  button2 = display.newText(
    {
      text = row.translated,
      height = display.contentHeight/9,
      width = display.contentWidth - 80,
      x = display.contentWidth/2 + 30,
      y = button1.y + display.contentHeight/8.4,
	  fontSize = 14
    }
  )
  bg1 = display.newRect( button1.x, button1.y - 10, display.contentWidth + 40, button1.height - 10 )
  bg1:setFillColor(1,1,1)
  bg2 = display.newRect( button2.x , button2.y - 12.25, button2.width + 50, button1.height - 10 )
  bg2:setFillColor(1,1,1)
  button1:setFillColor(black)
  button2:setFillColor(black)
  starIcon = display.newImage("star.png", button1.x + 120, button1.y - 20)
  starIcon:scale(0.05, 0.05)
  favourite = addButton( "favourite".. row.id , button1.x + 120, button1.y - 20, 25, 25, "icon", starIcon ) --( ID, x, y, width, height, btnType, label )
  arrowImage = display.newImage("arrow-down-and-right.png", button1.x - 105, button1.y + 30 )
  binPhraseIcon = display.newImage("recycle-bin.png", button1.x + 160, button1.y - 20)
  binPhraseIcon:scale (0.75, 0.75)
  binPhrase = addButton( "binPhrase".. row.id , button1.x + 160, button1.y - 20, 25, 25, "icon", binIcon ) --( ID, x, y, width, height, btnType, label )
  scroll:insert(bg1)
  scroll:insert(button1)
  scroll:insert(bg2)
  scroll:insert(button2)
  scroll:insert(starIcon)
  scroll:insert(favourite)
  scroll:insert(arrowImage)
  scroll:insert(binPhraseIcon)
  scroll:insert(binPhrase)
  
  table.insert(currentButtons, button1)
  table.insert(currentButtons, bg1)
  table.insert(currentButtons, button2)
  table.insert(currentButtons, bg2)
  table.insert(currentButtons, starIcon)
  table.insert(currentButtons, arrowImage)
  table.insert(currentButtons, favourite)
  table.insert(currentButtons, binPhraseIcon)
  table.insert(currentButtons, binPhrase)
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
    fontSize = 16,
    align = "center"
  }
)
phraseText:setFillColor( 1, 1, 1 )

local phrasesGroup = display.newGroup()
phrasesGroup:insert(phraseText)
phrasesGroup:insert(addPhraseButton)

-- User profile
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
    inputLoadPassword
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

profileButtons = {
  countryGroup,
  profileScroll
}

localLawyerButtons = {
    addLawyerButton,
    addButton( 14, addLawyerButton.x,addLawyerButton.y,0.5*display.contentWidth,26, "lawyerAdd", addLawyerButton),
	  countryGroup,
	  lawyerScroll,
	  lawyerSearch
}

addLawyerButtons = {
  addButton( 15, display.contentWidth/2, 7.55*display.contentHeight/8, display.contentWidth/2, display.contentHeight/15, "", 'Confirm'),
  addButton( 16, display.contentWidth/2, 8.3*display.contentHeight/8, display.contentWidth/2, display.contentHeight/15, "",  'Back'),
  backaddLawyer,
	txtaddLawyer,
	backaddLawyerEmail,
	inputaddLawyerEmail,
	txtaddLawyerEmail,
	backaddLawyerFname,
	inputaddLawyerFname,
	txtaddLawyerFname,
	backaddLawyerSname,
	inputaddLawyerSname,
	txtaddLawyerSname,
	backaddLawyerMobile,
	inputaddLawyerMobile,
	txtaddLawyerMobile,
	backstaticCountry,
	txtstaticCountry,
}

countryButtons = {
  countryScroll,
  countrySearch
}

contactsButtons = {
  countryGroup,
  contactsScroll
}

phraseButtons = {
  addButton( 17, addLawyerButton.x,addLawyerButton.y,0.5*display.contentWidth,26, "phraseAdd", addPhraseButton),
	countryGroup,
	phraseScroll,
	phraseText,
	phraseRectangle,
	addPhraseButton
}

addPhraseButtons = {
	addButton( 18, display.contentWidth/2, 7.55*display.contentHeight/8, display.contentWidth/2, display.contentHeight/15, "", 'Confirm'),
    addButton( 19, display.contentWidth/2, 8.3*display.contentHeight/8, display.contentWidth/2, display.contentHeight/15, "",  'Back'),
		backaddPhrase,
		txtaddPhrase,
		backaddPhraseEnglish,
		txtaddPhraseEnglish,
		inputaddPhraseEnglish,
		backaddPhraseTrans,
		txtaddPhraseTrans,
		inputaddPhraseTrans,
		backstaticCountry,
		txtstaticCountry,
		radioUsefulPhrase,
		radioLegalPhrase,
		backradioPhrase,
		txtaddUsefulPhrase,
		txtaddLegalPhrase,
		radioPhraseGroup
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

hideButtons(addLawyerButtons)
hideButtons(phraseButtons)
hideButtons(countryButtons)
hideButtons(phraseMenuButtons)
hideButtons(menuBarButtons)
hideButtons(localLawyerButtons)
hideButtons(mainMenuButtons)
hideButtons(registrationButtons)
hideButtons(addPhraseButtons)
hideButtons(contactsButtons)
hideButtons(profileButtons)
showButtons(loginButtons)