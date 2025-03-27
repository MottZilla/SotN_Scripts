--[[
	CV SotN - Start Anywhere
	by: MottZilla
	July 7th 2024
]]--

ChosenStage = 0x1F
StartAnywhereCloseSignal = 0
--			"String must be exact length                      " or else parsing will fail.
--			Keep this in mind if you edit any names. The Hex code must be at the end of the string.

LocationNameTable = { 	"Marble Gallery                              #0x00", 
			"Outer Wall                                  #0x01",
			"Long Library                                #0x02",
			"Catacombs                                   #0x03",
			"Olrox's Quarters                            #0x04",
			"Abandon Mine                                #0x05",
			"Royal Chapel                                #0x06",
			"Entrance                                    #0x07",
			"Castle Center                               #0x08",
			"Underground Caverns                         #0x09",
			"Colosseum                                   #0x0A",
			"Castle Keep                                 #0x0B",
			"Alchemy Lab                                 #0x0C",
			"Clock Tower                                 #0x0D",
			"Warp Rooms                                  #0x0E",
			"Nightmare                                   #0x12",
			"Cerberus                                    #0x16",
			"Maria at Center Clock                       #0x17",
			"Richter Battle                              #0x18",
			"Hippogryph                                  #0x19",
			"Doppleganger 10                             #0x1A",
			"Scylla                                      #0x1B",
			"Minotaur and Werewolf                       #0x1C",
			"Granfaloon                                  #0x1D",
			"Olrox                                       #0x1E",
			"Prologue/Final Stage                        #0x1F",
			"Black Marble Gallery                        #0x20",
			"Reverse Outer Wall                          #0x21",
			"Forbidden Library                           #0x22",
			"Floating Catacombs                          #0x23",
			"Death Wing's Lair                           #0x24",
			"Reverse Mines (Cave)                        #0x25",
			"Anti-Chapel                                 #0x26",
			"Reverse Entrance                            #0x27",
			"Reverse Castle Center                       #0x28",
			"Reverse Caverns                             #0x29",
			"Reverse Colosseum                           #0x2A",
			"Reverse Castle Keep                         #0x2B",
			"Necromancy Lab                              #0x2C",
			"Reverse Clock Tower                         #0x2D",
			"Reverse Warp Rooms                          #0x2E",
			"Darkwing Bat                                #0x35",
			"Galamoth                                    #0x36",
			"Akmodan II                                  #0x37",
			"Shaft                                       #0x38",
			"Doppleganger 40                             #0x39",
			"Creature                                    #0x3A",
			"Medusa                                      #0x3B",
			"Death                                       #0x3C",
			"Beelzebub                                   #0x3D",
			"Fake Trio                                   #0x3E",
			"Debug Room                                  #0x40",
			"Entrance (1st Visit)                        #0x41", }

StaticText = { "by: MottZilla" }

function StartAnywhereWindowClosed()
	StartAnywhereCloseSignal = 1
end

function SetStage()
	local TempStr = ""
	if(InMainMenu() == 0) then return end

	TempStr = forms.gettext(dropdownLocations)
	--TempStr = bizstring.remove(TempStr,23,4)
	ChosenStage = TempStr
	ChosenStage = bizstring.substring(forms.gettext(dropdownLocations),23+22,4)
	
	-- bizstring.substring(forms.gettext(dropdownLocations),23,4)
	ChosenStage = tonumber(ChosenStage)
	memory.write_u8(0x1AF590,ChosenStage)
	memory.write_u8(0x1AF594,ChosenStage)

	memory.write_u16_le(0x100364,200)	-- HP
	memory.write_u16_le(0x1003A4,200)	-- MP
	memory.write_u16_le(0x1003AC,0x7BB4)	-- MP
	memory.write_u16_le(0x1003C4,0x7BA8)	-- Hearts
end

function InMainMenu()
	local CheckWord1 = memory.read_u32_le(0x1AF578)
	local CheckWord2 = memory.read_u32_le(0x1AF57C)

	if(CheckWord1 ~= 0x0C06B59B) then return 0 end
	if(CheckWord2 ~= 0x00000000) then return 0 end

	return 1
end

formStartAnywhere = forms.newform(340,90,"Set Starting Location",StartAnywhereWindowClosed)
dropdownLocations = forms.dropdown(formStartAnywhere,LocationNameTable,4,4,160,200)
dropdownName = forms.dropdown(formStartAnywhere,StaticText,230,4,80,20)

while StartAnywhereCloseSignal == 0 do
	if(memory.read_u8(0x974A0) == 0x45) then SetStage() end
	emu.frameadvance();
end