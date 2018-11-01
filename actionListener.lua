----------------------------------------------------------------------------------------
--
-- actionListener.lua
--
-----------------------------------------------------------------------------------------

-- Listener for button presses

function handleInput( event )
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
    contactsScroll = getScroll("contacts")
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
  elseif id == 9 then
    hideButtons(currentButtons)
    showButtons(menuBarButtons)
    showButtons(phraseButtons)
    addPhraseButton.isVisible = false
    phraseText.text = "Favourite phrases"
    populatePhrases(phraseScroll, nil, "favourite")
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
    if phraseText.text == "Favourite phrases" then
      removeFavourite(id)
    else
      deletePhrase(id)
    end
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
  elseif string.starts(id, "favourite") then
    addFavourite(id:sub(10))
  end
end