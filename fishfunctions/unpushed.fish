function unpushed
	echo -s (git cherry -v "@{upstream}" ^/dev/null)
end
