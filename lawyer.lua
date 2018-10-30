actionListener = require("actionListener")

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

addLawyerButton = display.newImage("addButton.png")
 addLawyerButton:scale(0.5,0.5)
 addLawyerButton.y = display.contentHeight/5.5
 addLawyerButton.x = display.contentWidth/1.125
 addLawyerButton.isVisible = false
 
lawyerScroll = getScroll( "lawyer" )
lawyerSearch = native.newTextField(display.contentWidth/2,display.contentHeight/5.5,0.5*display.contentWidth,26)
lawyerSearch.placeholder = "Search Lawyer"
lawyerSearch.id = "lawyerId"
 
function searchListenerLaw( event )
  if ( event.phase == "ended" or event.phase == "submitted" ) then
    lawyerScroll:removeSelf()
    lawyerScroll = getScroll("lawyer")
    table.insert(currentButtons, lawyerScroll)
    populateScroll(lawyerScroll, lawyerSearch.text)
  end
end
lawyerSearch:addEventListener("userInput", searchListenerLaw)

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

-- function which handles the addition of new laywers (INSERT)
function addNewLawyer()
  query = [[INSERT INTO lawyer (email, name, mobilenum, countryid) VALUES ("]]
    .. inputaddLawyerEmail.text .. [[", "]] .. inputaddLawyerFname.text .. " " .. inputaddLawyerSname.text .. [[", "]] .. inputaddLawyerMobile.text .. [[", "]] .. currentCountryId ..[[");]]
  db:exec(query)
end

-- function which deletes lawyers
function deleteLawyer(id)
	 lawyerID = string.sub( id, 10 )
	 query = [[DELETE FROM lawyer WHERE id=]] .. lawyerID
	 db:exec(query)
	 print(query)
end