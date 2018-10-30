----------------------------------------------------------------------------------------
--
-- unit_tests.lua
--
-- Using - https://github.com/JesterXL/lunatest
--
-----------------------------------------------------------------------------------------
-- required for unit tests
module(..., package.seeall)

-- test background image is loaded
function test_background()
  local background = display.newImage("background.jpg")
  assert_not_nil(background, "Background image cannot be found.")
end
-- end test

-- test opening db file
function test_open_db()
  local sqlite3 = require( "sqlite3" )
  local path = system.pathForFile( "data.db", system.ResourceDirectory )
  assert_match(path, "data.db", "wrong filename for db file.")
  local db = sqlite3.open( path )
end
-- end test

-- test image loaded for home button
function test_home_button()
  local homeButton = display.newImage("home_white_192x192.png")
  assert_not_nil(homeButton, "home button image cannot be found.")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10
end

-- test image loaded for panic settings button
function test_panic_button()
  local panicSettingsButton = display.newImage("User-Profile.png")
  assert_not_nil(panicSettingsButton, "panic settings button image cannot be found.")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10
end

-- test image loaded for addButton
function test_add_lawyer_button()
  local addLawyerButton = display.newImage("addButton.png")
  assert_not_nil(addLawyerButton, "addButton image cannot be found.")
  addLawyerButton:scale(0.5,0.5)
  addLawyerButton.y = display.contentHeight/5.5
  addLawyerButton.x = display.contentWidth/1.125
  addLawyerButton.isVisible = false
end

-- test image loaded for addButton
function test_add_phrase_button()
  local addPhraseButton = display.newImage("addButton.png")
  assert_not_nil(addPhraseButton, "addButton image cannot be found.")
  addPhraseButton:scale(0.5,0.5)
  addPhraseButton.y = display.contentHeight/5.8
  addPhraseButton.x = display.contentWidth/1.125
  addPhraseButton.isVisible = false
end

-- test image loaded for globe
function test_display_globe()
  local globe = display.newImage("globe.png" ,display.contentWidth/5, display.contentHeight/10)
  assert_not_nil(globe, "globe image cannot be found.")
  globe:scale(.125,.125)
end

-- test image loaded for fingerpress
function test_finger_press()
  local fingerPress = display.newImage ("fingerpress.png",display.contentWidth/1.15, display.contentHeight/10)
  assert_not_nil(fingerPress, "fingerpress image cannot be found.")
  fingerPress:scale(.4, .4)
end

-- test regForm returns boolean value
function test_regform()
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
    
    assert_not_boolean(regForm, "value is not a boolean")
    return regForm
  end
end

-- test addLawyerValid function returns a boolean value
function test_addLawyer()
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

    assert_not_boolean(addLawyerForm, "value is not a boolean")
    return addLawyerForm
  end
end

-- test addPhraseValid function returns a boolean value
function test_addPhrase()
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

    assert_not_boolean(addLawyerForm, "value is not a boolean")
    return addPhraseForm
  end
end

-- test adButton function returns a table value
function test_addButton()
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

    assert_not_table (button, "button is not a table")
    return button
  end
end
