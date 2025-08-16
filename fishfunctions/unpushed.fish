function unpushed
	echo -s (git cherry -v "@{upstream}" 2>/dev/null)
end
