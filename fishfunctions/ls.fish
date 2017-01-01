function ls --description 'List contents of directory'
  switch (uname)
    case Linux
      command ls -FG --color=auto $argv
    case Darwin
      command ls -G $argv

  end
end
