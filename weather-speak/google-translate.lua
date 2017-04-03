function reqTranslateListener( event )
	if (event.phase == "ended") then
		audio.play(audio.loadSound(event.response.filename,system.DocumentsDirectory))
	end
end

function reqTranslate( text, lang )
	--print("http://translate.google.com/translate_tts?ie=UTF-8&q=" .. text .. "&tl=" .. lang .."&client=tw-ob")
	network.download(
	 	"https://api.naturalreaders.com/v2/tts/?t=" .. text,
	 	"GET",
	 	reqTranslateListener,
	 	{},
	 	math.random(150000) .. ".mp3",
	 	system.DocumentsDirectory
	)
end