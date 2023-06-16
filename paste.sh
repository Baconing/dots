mkdir -p ~/.config
mkdir -p ~/.bin

cp -r .bin/* ~/.bin
cp -r .config/i3 ~/.config/i3
cp -r .config/polybar ~/.config/polybar
cp -r .config/dunst ~/.config/dunst
cp -r .config/picom.conf ~/.config/picom.conf
cp -r .config/alacritty ~/.config/alacritty

echo "make sure to add ~/.bin to your path!"
