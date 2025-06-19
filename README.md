<div align="center">

# Bacon's [NixOS] & [Home Manager] "Dotfiles"
*With inspiration from [Wimpy's World] and [others](#Inspiration)*
<br />
</div>

## ⚠️  Warning ⚠️
This repository contains machine and user-specific values:
- Disk/Partition Tables
- Machine Hardware Drivers
- User Program Configurations
- Encrypted User Secrets (git tokens, ssh keys, logins, etc.)

I ***highly*** recommend that you use this repository as a reference, and don't install it on your machine blindly without doing your homework.

**Some actions may be destructive, I am not responsible for any action you take.**

## Hardware
Hardware is named off Saturn's moons and other space themed names.

Dual booted and VM systems only have one entry unless there is a distinct OS/State difference between VMs.

All my hardware is listed here regardless of their management state by this repository.

|  Hostname  |  Board                         |  CPU                    |  RAM  | Storage               | Primary GPU              |  Role   |  OS              | State | Comments           |
| :-------:  | :----------------------------: | :---------------------: | :---: | :-------------------: | :----------------------: | :-----: | :--------------: | :---: | :----------------: |
| `titan`    | [MSI MPG X570 GAMING PLUS]     | [AMD Ryzen 9 3900X]     | 32GB  | 512GB🏃+256GB🏃+2TB👴 | [NVIDIA RTX 2070 Super]  | 🖥      | 🎭(❄ + 🪟)       | 🟡    | Primary Desktop    |
| `artemis`  | [ThinkPad X1 Carbon Gen 7]     | [Intel Core i7-8665U]   | 16GB  | 512GB🏃               | [Intel UHD Graphics 620] | 💻      | 🎭(❄ + 🪟)       | 🟡    | Primary Laptop     |
| `dione`    | [Beelink EQR6 SEI]             | [AMD Ryzen 5 6600H]     | 16GB  | 512GB🏃               | [AMD Radeon 660M]        | ☁       | 🔍(🐧)           | 🤷    | Docker/VM Host     |
| `hyperion` | [HP ProDesk 400 G3 SFF]        | [Intel Core i3-6100]    | 4GB   | 256GB🚶               | [Intel HD Graphics 530]  | 🛜      | 🔍(OPNSense)     | 🤷    | Router             |
| `phoebe`   | [Asus H81M-A]                  | [Intel Core i3-4150T]   | 16GB  | 64GB🚶+(4x8TB👴)      | [Intel HD Graphics 4400] | 💾      | 🔍(TrueNAS Core) | 🤷  | NAS                |
| (unnamed)  | [Supermicro X8SAX] (modified?) | 2x [Intel Xeon X5670]   | 96GB  | None                  | None                     | None    | None             | 🚧    | [Themis RES-12XR3] |


**Key**
| Storage        | Role                       | OS                                   | State                                                         |
| :------------: | :------------------------: | :----------------------------------: | :-----------------------------------------------------------: |
| 🏃 - NVMe SSD  | 🖥 - Desktop               | 🎭 - Dual Boot                       | ✅ - Full Nixification using this repo                        |
| 🚶 - SATA SSD  | 💻 - Laptop                | ❄  - NixOS                           | ☑  - Nix on part of a dual-booted system.                     |
| 👴 - HDD (any) | 🛜 - Router                | 🪟 - Windows                         | 🟡 - Nixification in progress.                                |
|                | 💾 - NAS/Storage Server    | 🐧 - Other Linux                     | 🤷 - Might use Nix in the future.                             |
|                | ☁  - Miscellaneous Server  | 🔍 - Proxmox Host/Client             | ❌ - No plans to ever use Nix.                                |
|                |                            | 🔎 - Other VM Host/Client (e.g. KVM) | ⏲ - Plans to build, waiting on parts, waiting to setup, etc.  |
|                |                            |                                      | 🚧 - No longer in service.                                    |


## Inspiration
[Wimpy's World] - README format, file structure, general introduction to Nix syntax

<!-- Hyperlinks -->

<!-- NixOS Related -->
[NixOS]: https://nixos.org
[Home Manager]: https://github.com/nix-community/home-manager

<!-- Hardware: Boards -->
[MSI MPG X570 GAMING PLUS]: https://www.msi.com/Motherboard/MPG-X570-GAMING-PLUS/Specification
[ThinkPad X1 Carbon Gen 7]: https://psref.lenovo.com/syspool/Sys/PDF/ThinkPad/ThinkPad_X1_Carbon_7th_Gen/ThinkPad_X1_Carbon_7th_Gen_Spec.pdf
[Beelink EQR6 SEI]: https://www.amazon.com/dp/B0CKQD5HC9
[HP ProDesk 400 G3 SFF]: https://www.amazon.com/dp/B0849SH3XK
[Asus H81M-A]: https://www.asus.com/us/supportonly/h81ma/
[Supermicro X8SAX]: https://theretroweb.com/motherboards/s/supermicro-x8sax

<!-- Hardware: CPU -->
[AMD Ryzen 9 3900X]: https://www.amd.com/en/support/downloads/drivers.html/processors/ryzen/ryzen-3000-series/amd-ryzen-9-3900x.html
[Intel Core i7-8665U]: https://www.intel.com/content/www/us/en/products/sku/193563/intel-core-i78665u-processor-8m-cache-up-to-4-80-ghz/specifications.html
[AMD Ryzen 5 6600H]: https://www.amd.com/en/support/downloads/drivers.html/processors/ryzen/ryzen-6000-series/amd-ryzen-5-6600h.html
[Intel Core i3-6100]: https://www.intel.com/content/www/us/en/products/sku/90729/intel-core-i36100-processor-3m-cache-3-70-ghz/specifications.html
[Intel Core i3-4150T]: https://www.intel.com/content/www/us/en/products/sku/77487/intel-core-i34150t-processor-3m-cache-3-00-ghz/specifications.html
[Intel Xeon X5670]: https://www.intel.com/content/www/us/en/products/sku/47920/intel-xeon-processor-x5670-12m-cache-2-93-ghz-6-40-gts-intel-qpi/specifications.html

<!-- Hardware: Graphics -->
[NVIDIA RTX 2070 Super]: https://www.nvidia.com/en-us/geforce/graphics-cards/compare/?section=compare-20
[Intel UHD Graphics 620]: https://www.intel.com/content/www/us/en/support/products/126789/graphics/processor-graphics/intel-uhd-graphics-family/intel-uhd-graphics-620.html
[AMD Radeon 660M]: https://www.techpowerup.com/gpu-specs/radeon-660m.c3870
[Intel HD Graphics 530]: https://www.intel.com/content/www/us/en/support/products/88345/graphics/processor-graphics/intel-hd-graphics-family/intel-hd-graphics-530.html
[Intel HD Graphics 4400]: https://www.intel.com/content/www/us/en/support/products/81497/graphics/processor-graphics/intel-hd-graphics-family/intel-hd-graphics-4400.html

<!-- Hardware: Other -->
[Themis RES-12XR3]: https://www.mrcy.com/legacy_assets/siteassets/product-datasheets/rugged-servers/res12xr3_ds-0221-0003.pdf

<!-- Inspiration -->
[Wimpy's World]: https://github.com/wimpysworld
