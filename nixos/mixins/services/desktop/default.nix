{ desktop, displayManager, ... }:
{
  imports = [
    ./${desktop}
    ./dm/${displayManager}
    ./dbus
  ];
}
