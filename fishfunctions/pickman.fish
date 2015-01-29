function pickman
	apropos -l . | pick -do | head -1 | xargs man
end
