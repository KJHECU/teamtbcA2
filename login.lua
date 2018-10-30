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