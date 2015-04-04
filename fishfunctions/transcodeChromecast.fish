function transcodeChromecast --argument input output
	fmpeg -i "$input" -c:v libx264 -profile:v high -level 5 -crf 18 -maxrate 10M -bufsize 16M -pix_fmt yuv420p -vf "scale=iw*sar:ih, scale='if(gt(iw,ih),min(1920,iw),-1)':'if(gt(iw,ih),-1,min(1080,ih))'" -x264opts bframes=3:cabac=1 -movflags faststart -c:a libfdk_aac -b:a 320k -y "$output"
end
