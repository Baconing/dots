{ desktop, ... }:
{
  import = [
    ./${desktop}
    ./dbus
  ];
}
