require("google-translate")
local JSON = require("json")
local timeText,dateText,sunriseText,sunsetText,citynameText,cityidText,weatherText,desText,tempText,weatherImg,bgImg,bgGroup,textGroup,screenGroup
local cityname,cityid,weather,temp,resjson
local networkListener,request,init,setWeather
local cx = display.contentCenterX
local cy = display.contentCenterY
local width = display.contentWidth
local height = display.contentHeight
local citysid = {707860,519188,679886,4372137,1283378,1270260,1848499,1151254,5106292,2524593,2525595,1725653,679858}
local apikey = "00351eef7c97b491559820f5c540faec"
local i=1
function setWeather()
	transition.to(textGroup, { time = 200, alpha = 0, onComplete = function()
		--timeText.text = os.date("%H : %M", resjson["dt"])
		--dateText.text = os.date("%a, in %b", resjson["dt"])
		citynameText.text = "- "..resjson["name"].." -"
		tempText.text = resjson["main"]["temp"].." °C"
		weatherText.text = resjson["weather"][1]["main"]
		desText.text = resjson["weather"][1]["description"]
		tempWeather = resjson["weather"][1]["icon"]
		sunriseText.text = os.date("Sunrise %H:%M %a, in %b", resjson["sys"]["sunrise"])
		sunsetText.text = os.date("Sunset %H:%M %a, in %b", resjson["sys"]["sunset"])
		if (weather ~= tempWeather) then
			weather = tempWeather
			if (weatherImg) then
				weatherImg:removeSelf()
				weatherImg = nil
			end
			weatherImg = display.newImage("icon/"..weather.. ".png", cx, 170)
			weatherImg:scale(0.25,0.25)
			textGroup:insert(6, weatherImg)

			if (bgGroup[1]) then
				bgGroup[1]:removeSelf()
				bgGroup[1] = nil
			end
			bgImg = display.newImage("bg/"..weather.. ".jpg", cx, 250)
			bgGroup:insert(1,bgImg)
			bgImg:scale(0.5,0.5)
			--bgImg.fill.effect = "filter.blur"
		end
		transition.to(textGroup, { time = 200, alpha = 1 })
	end })
end

function networkListener( event )
	if ( event.isError ) then
		print( "Network error: ", event.response )
	else
		resjson = JSON.decode(event.response)
		if(resjson["cod"] == 200) then
			setWeather()
			reqTranslate( resjson["main"]["temp"].." degrees Celsius", "en" )
		end
	end
end

function request()
	url = "http://api.openweathermap.org/data/2.5/weather?units=metric&id="..citysid[i].."&appid="..apikey
	print(url)
	network.request( url, "GET", networkListener , {})
	i = (i%#citysid) + 1
end

function handle(event)
	if(event.phase == "began") then
		request()
	end
end

function init()
	bgGroup = display.newGroup()
	bgImg = display.newImage("", cx, cy)
	bgGroup:insert(1,bgImg)
	darkscreen = display.newRect(cx, cy, width, height+100)
	darkscreen:setFillColor(0, 0, 0, 0.4)
	bgGroup:insert(2,darkscreen)

	screenGroup = display.newGroup()
	screenGroup:insert(bgGroup)

	darkboxbody = display.newRect(cx, height-150, width, height)
	darkboxbody.anchorY = 0
	darkboxbody:setFillColor(0, 0, 0, 0.5)

	darkline = display.newRect(cx, height-150, width, 70)
	darkline.anchorY = 0
	darkline:setFillColor(0, 0, 0, 0.2)

	screenGroup:insert(darkboxbody)
	screenGroup:insert(darkline)

	local font = native.newFont( "font/CaviarDreams.ttf", 20 )
	local fontBold = native.newFont( "font/CaviarDreams_Bold.ttf", 20 )

	textGroup = display.newGroup()
	timeText = display.newText("", 20, 70, font,20)
	dateText = display.newText("", width-10, 70, font,20)
	citynameText = display.newText("",cx, 20, fontBold,40)
	tempText = display.newText("", cx, cy+40, font,40)
	weatherText = display.newText("", 20, cy+125, font,25)
	desText = display.newText("", width-20, cy+125, font,15)

	sunrise = display.newImage("icon/sunrise.png", 20, height-50)
	sunset = display.newImage("icon/sunset.png", 20, height-10)
	sunrise:scale(0.06,0.06)
	sunset:scale(0.06,0.06)
	sunriseText = display.newText("", cx+80, height-50, font,15)
	sunsetText = display.newText("", cx+80, height-10, font,15)

	timeText.anchorX = 0
	dateText.anchorX = 1
	weatherText.anchorX = 0
	desText.anchorX = 1
	sunriseText.anchorX = 1
	sunsetText.anchorX = 1
	sunrise.anchorX = 0
	sunset.anchorX = 0

	textGroup:insert(1, citynameText)
	a = display.newGroup()
	a:insert(timeText)
	a:insert(dateText)
	textGroup:insert(2, a)
	textGroup:insert(3,tempText)
	b = display.newGroup()
	b:insert(weatherText)
	b:insert(desText)
	textGroup:insert(4, b)
	c = display.newGroup()
	c:insert(sunriseText)
	c:insert(sunsetText)
	c:insert(sunrise)
	c:insert(sunset)
	textGroup:insert(5, c)
	Runtime:addEventListener("touch",handle)
	screenGroup:insert(textGroup)
	textGroup.alpha = 0
	request()
end

init()
