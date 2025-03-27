-- Castlevania: SotN
-- Hold X to Gravity Jump Further
-- Written By: MottZilla

while true do
	SR_Input = memory.read_u16_le(0x72EE8)
	if bit.band(SR_Input,0x0040) == 0x0040 then
		if memory.read_u16_le(0x73404) == 8 and memory.read_u16_le(0x73406) == 0 then
			memory.write_u8(0x72F6A,2)
		end
	end
	emu.frameadvance();
end