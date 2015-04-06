function transcodepsp
	ffmpeg -i $argv[1] -b:v 300k -s 720x480 -vcodec libxvid -b:a 32k -ar 24000 -acodec libvo_aacenc $argv[2]
end
