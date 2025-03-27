--[[

	Castlevania Symphony of the Night (Usa)
	HitBox Toggle
	Written By: MottZilla
--]]

TerminateHBV = 0

function HBVWindowClosed()
TerminateHBV = 1
end

function ShowHitBoxes()
	memory.write_u8(0xBD1C0,1)
	memory.write_u8(0x1362B0,1)
end

function HideHitBoxes()
	memory.write_u8(0xBD1C0,0)
	memory.write_u8(0x1362B0,0)
end

formHBV = forms.newform(280,70,"HitBox Control",HBVWindowClosed)
buttonHitBoxOn = forms.button(formHBV,"Enable",ShowHitBoxes,2,2,100,24)
buttonHitBoxOff = forms.button(formHBV,"Disable",HideHitBoxes,102,2,100,24)


while TerminateHBV == 0 do
	emu.frameadvance();
end