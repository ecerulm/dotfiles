function killssh --description 'Kill the ControlMaster SSH sessions for host' --argument host
	ssh -v -O exit $host
end
