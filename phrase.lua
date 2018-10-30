widget = require( "widget" )
buttonCreator = require("buttonCreator")
scrollCreator = require("scrollCreator")
user = require("user")

radioPhraseType = 0

addPhraseButton = display.newImage("addButton.png")
 addPhraseButton:scale(0.5,0.5)
 addPhraseButton.y = display.contentHeight/5.8
 addPhraseButton.x = display.contentWidth/1.125
 addPhraseButton.isVisible = false

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

backradioPhrase = display.newRect(display.contentWidth/2, display.contentHeight/2.5, display.contentWidth, display.contentHeight/15)
backradioPhrase:setFillColor (0, 0.8, 0.8) 
txtaddUsefulPhrase = display.newText( "Useful", display.contentWidth/1.375, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )
txtaddLegalPhrase = display.newText( "Legal", display.contentWidth/0.925, display.contentHeight/2.425, display.contentWidth, display.contentHeight/15, native.systemFont, 15 )

function onSwitchPress( event )
  local switch = event.target
  radioPhraseType = event.target.id
  print (radioPhraseType)
end

-- Create two associated radio buttons (inserted into the same display group)
radioPhraseGroup = display.newGroup()
local radioLegalPhrase = widget.newSwitch(
    {
        left = 225,
        top = 175,
        style = "radio",
        id = "1",
        onPress = onSwitchPress
    }
)
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
-- Create a group for the radio button set
radioPhraseGroup:insert( backradioPhrase )
radioPhraseGroup:insert( txtaddUsefulPhrase )
radioPhraseGroup:insert( txtaddLegalPhrase )
radioPhraseGroup:insert( radioLegalPhrase )
radioPhraseGroup:insert( radioUsefulPhrase )

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

phraseScroll = getScroll("phrase")
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

phrasesGroup = display.newGroup()
phrasesGroup:insert(phraseText)
phrasesGroup:insert(addPhraseButton)

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

-- function which handles the addition of new phrases (INSERT)
function addNewPhrase()
  query = [[INSERT INTO phrase (english, translated, countryid, phrasetype) VALUES ("]]
    .. inputaddPhraseEnglish.text .. [[", "]] .. inputaddPhraseTrans.text .. [[", "]] .. currentCountryId .. [[", "]] .. radioPhraseType .. [[");]]
  db:exec(query)
  print(query)
end

-- function which deletes phrases
function deletePhrase(id)
	 phraseID = string.sub( id, 10 )
	 query = [[DELETE FROM phrase WHERE id=]] .. phraseID
	 db:exec(query)
	 print(query)
end