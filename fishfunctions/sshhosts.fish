function sshhosts
	cat ~/.ssh/config | grep "^Host" | awk '{print $2}' | sort

end
