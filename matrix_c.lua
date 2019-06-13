local sX, sY = guiGetScreenSize()
local size = 18
local lineCount = 125
local lineWidth = sX/lineCount
local font = dxCreateFont("font.ttf", size, true)
local possibleCharacters = {97,98,99,101,102,103,104,106,107,108,109,111,112,113,114,116,118,119,120,121}
local linesUsed = {}

local function generateCharacter()
	local characterType = math.random(1,5)
	local character = nil
	if characterType < 5 then
		character = string.char(possibleCharacters[math.random(1,#possibleCharacters)])
	else
		character = string.char(math.random(48,57))
	end
	return character
end

local function createLine(line)
	if linesUsed[line] then
		return
	end
	linesUsed[line] = {}
	for i = 1, math.random(15,50) do
		linesUsed[line][i] = generateCharacter()
	end
	linesUsed[line]["position"] = -#linesUsed[line] -- pozycja ostatniej litery
end

local function getCharacterColor(line, indexCharacter, characterCount)
	if indexCharacter + 3 > characterCount then
		local indexEnd = characterCount - indexCharacter
		local alpha = 0
		if indexEnd == 0 then
			alpha = 1
		elseif indexEnd == 1 then
			alpha = 0.7
		elseif indexEnd == 2 then
			alpha = 0.5
		end
		return tocolor(255,255,255,255*alpha)
	end
	if indexCharacter < 15 then
		local alpha = indexCharacter/15
		return tocolor(12,133,25,240*alpha)
	end
	return tocolor(12,133,25,240)
end

local function randomizeCharacters(line)
	local lastCharacter = #linesUsed[line]
	linesUsed[line][lastCharacter] = generateCharacter()
	for i = 1, #linesUsed[line] -1 do
		if i >= math.random(1,100) then
			linesUsed[line][i] = generateCharacter()
		end
	end
end

local function moveCharacters()
	for line = 1, lineCount do
		if linesUsed[line] then
			randomizeCharacters(line)
			linesUsed[line]["position"] = linesUsed[line]["position"] + 0.5
			if linesUsed[line]["position"] * size > sY then
				linesUsed[line] = nil
			end
		end
	end
end
setTimer(moveCharacters, 60, 0)

local function createLines()
	for i = 1, lineCount do
		local possibility = math.random(1,5)
		if possibility > math.random(1,100) then
			createLine(i)
		end
	end
end
setTimer(createLines, 250, 0)

local function drawMatrix()
	dxDrawRectangle(0,0, sX,sY, 0xFF000000, false)
	for line = 1, lineCount do
		if linesUsed[line] then
			local characterCount = #linesUsed[line]
			for indexCharacter, character in ipairs(linesUsed[line]) do
				local characterX = lineWidth*line
				local characterY = size*(linesUsed[line]["position"]+indexCharacter)
				local characterX2 = lineWidth*line+lineWidth
				local characterY2 = characterY+size
				dxDrawText(character, characterX,characterY, characterX2,characterY2, getCharacterColor(line, indexCharacter, characterCount), 0.7,0.7, font, "center", "center")
			end
		end
	end
end
addEventHandler("onClientRender", root, drawMatrix)