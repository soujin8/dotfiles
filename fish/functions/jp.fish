#!bin/fish
function jp
  cd (go run main.go show | peco)
end
