rm -rf .config
rm -rf .bin

mkdir .config

cp -r ~/.config/i3 .config/i3
cp -r ~/.bin .bin
cp -r ~/.config/polybar .config/polybar
cp -r ~/.config/dunst .config/dunst
git submodule add https://github.com/adi1090x/rofi.git .config/rofi
#cp -r ~/.zshrc .zshrc
cp -r ~/.config/picom.conf .config/picom.conf
cp -r ~/.config/alacritty .config/alacritty
