----------------------------------------------------------------------------------------
--
-- registration.lua
--
-----------------------------------------------------------------------------------------

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

-- function which handles the registration of new users (INSERT)
function submitRegistration()
  query = [[INSERT INTO user (email, password, name, mobilenum, nokemail, nokname, nokmobile) VALUES ("]]
    .. inputRegEmail.text .. [[", "]] .. inputRegPassword.text .. [[", "]] .. inputFname.text .. " " .. inputSname.text
    .. [[", "]] .. inputMobile.text .. [[", "]] .. inputKinEmail.text .. [[", "]] .. inputKinFname.text .. " " .. inputKinSname.text
    .. [[", "]] .. inputKinMobile.text .. [[");]]
  db:exec(query)
end