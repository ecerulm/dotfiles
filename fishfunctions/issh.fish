function issh
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $argv
end
