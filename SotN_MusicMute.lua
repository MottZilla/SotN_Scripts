--[[
	Castlevania: Symphony of the Night
	Music Muting Script
	By: MottZilla
--]]

XATrack = 0
InsBuf = 0

while true do
	XATrack = memory.read_u16_le(0x138458)	-- Read Current XA Track Number
	InsBuf = memory.read_u32_le(0x13627C)	-- Read Instruction

	-- If Dialog and XA Muted
	if(InsBuf == 0x34050000 and XATrack > 0x3F) then memory.write_u32_le(0x13627C,0x3C058014); memory.write_u32_le(0x136280,0x84A5B668) end

	-- If Song and XA Not Muted
	if(InsBuf == 0x3C058014 and XATrack < 0x40) then memory.write_u32_le(0x13627C,0x34050000); memory.write_u32_le(0x136280,0x00000000) end
	emu.frameadvance();
end


