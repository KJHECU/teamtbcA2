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

registration = require("registration")
login = require("login")
phrase = require("phrase")
lawyer = require("lawyer")
country = require("country")
profile = require("profile")
scrollCreator = require("scrollCreator")
buttonCreator = require("buttonCreator")
actionListener = require("actionListener")
user = require("user")
widget = require("widget")
database = require("database")

-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then
        db:close()
    end
end

-- function which checks for empty input fields
function isEmpty(field)
	if field.text == "" then
		return true
	else
		return false
	end
end

homeButton = display.newImage("home_white_192x192.png")
  homeButton:scale(0.22, 0.22)
  homeButton.y = display.contentHeight + 10
  homeButton.x = 9.3*display.contentWidth/10

panicSettingsButton = display.newImage("User-Profile.png")
  panicSettingsButton:scale(0.12, 0.12)
  panicSettingsButton.y = display.contentHeight + 10
  panicSettingsButton.x = 7.75*display.contentWidth/10

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