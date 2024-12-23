HFStep = 0
HFTimer = 0

while true do
HFStep = memory.read_u8(0x138FCC)
HFTimer = memory.read_u8(0x138FCE)

	gui.drawString(90,20,"Step: " .. HFStep .. " Timer: " .. HFTimer)

	emu.frameadvance();
end