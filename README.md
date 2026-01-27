> [!WARNING]
> This is a rewrite of [old configurations](https://github.com/Baconing/dots-kinda-old).
> These old configurations were primary written with the desktops in mind, and not the servers.
> Now, it's the servers with priority and the desktops will be added at a later date.

<div align="center">

# Bacon's [NixOS] & [Home Manager] "Dotfiles"
*With inspiration from [Wimpy's World] and [others](#Inspiration)*
<br />
</div>
A set of high-availability, reproducible, and easily configurable files for a fleet of machines.

## ⚠️  Warning ⚠️
This repository contains machine and user-specific values:
- Machine Hardware Drivers
- User Program Configurations
- *Encrypted User Secrets* (git tokens, ssh keys, logins, etc.)

I ***highly*** recommend that you use this repository as a reference, and don't install it on your machine blindly without doing your homework.

**Some actions may be destructive, and I am not responsible for any action you take with this repository.**

## Hardware
Hardware is named based off Saturn's moons and other space themed names.

Dual booted and VM systems only have one entry unless there is a distinct OS/State difference between VMs.

All my hardware is listed here regardless of their management state by this repository.

<details>
<summary>Key</summary>

| Storage        | Role                       | OS                                   | State                                                         |
| :------------- | :------------------------- | :----------------------------------- | :------------------------------------------------------------ |
| 🏃 - NVMe SSD  | 🖥 - Desktop               | 🎭 - Dual Boot                       | ✅ - Full Machine Support                                      |
| 🚶 - SATA SSD  | 💻 - Laptop                | ❄  - NixOS                           | 🟡 - Nixification in progress.                                |
| 👴 - HDD (any) | 🛜 - Router                | 🪟 - Windows                         | 🤷 - Might use Nix in the future.                              |
|                | 💾 - NAS/Storage Server    | 🐧 - Other Linux                     | ❌ - No plans to ever use Nix.                                |
|                | ☁  - Miscellaneous Server | 🔍 - Proxmox Host/Client             | ⏲ - Plans to build, waiting on parts, waiting to setup, etc. |
|                |                            | 🔎 - Other VM Host/Client (e.g. KVM) |                                                               |

</details>

<details>
<summary>Main Hardware</summary>

|  Hostname  |  Board                         |  CPU                    |  RAM  | Storage               | GPUs                                                                            |  Role  |  OS              | State | Comments                                               |
| :-------:  | :----------------------------: | :---------------------: | :---: | :-------------------: | :-----------------------------------------------------------------------------: | :----: | :--------------: | :---: | :----------------------------------------------------: |
| `titan`    | [MSI MPG X570 GAMING PLUS]     | [AMD Ryzen 9 3900X]     | 32GB  | 2TB🏃+512GB🏃+2TB👴   | [NVIDIA RTX 2070 Super]                                                         | 🖥      | 🎭(❄+🪟)        | 🤷    | Primary Desktop                                        |
| `tethys`   | [ThinkPad P17 Gen 1]           | [Intel Core i7-10850H]  | 32GB  | 512GB🏃+256GB🏃       | [NVIDIA Quadro T2000 Mobile / Max-Q] + 10th Gen Intel UHD Graphics (@ 1.15 GHz) | 💻      | 🎭(🐧+🪟)        | 🤷    | Primary Laptop                                         |
| `skoll`    | [MSI MPG B550 GAMING PLUS]     | [AMD Ryzen 7 2700X]     | 32GB  | 500GB🚶               | TBA                                                                             | ☁     | ❄               | ⏲    | Primary Compute                                        |
| `hyperion` | [HP ProDesk 400 G3 SFF]        | [Intel Core i3-6100]    | 4GB   | 256GB🚶               | [Intel HD Graphics 530]                                                         | 🛜     | 🔍(OPNSense)     | 🤷    | Router                                                 |
| `phoebe`   | [Asus H81M-A]                  | [Intel Core i3-4150T]   | 16GB  | 64GB🚶+(4x8TB👴)      | [Intel HD Graphics 4400]                                                        | 💾     | 🔍(TrueNAS Core) | 🤷    | NAS                                                    |

</details>

<details>
<summary>Cluster Nodes</summary>
These are various additional (minor) nodes used in the kubernetes cluster for high availability and scaling purposes.

Nodes here are named based off the moons of Jupiter.
| Hostname    | Board                         | CPU                   | RAM  | Storage | GPUs                            | Comments                               |
| :---------: | :---------------------------: | :-------------------: | :--: | :-----: | :-----------------------------: | :------------------------------------: |
| `callisto`  | [Lenovo ThinkCentre M73 Tiny] | [Intel Core i7-4765T] | 8GB  | 500GB🚶 | [Intel HD Graphics 4600]        |                                        |
| `mneme`     | [Lenovo ThinkCentre M73 Tiny] | [Intel Core i5-4460T] | 8GB  | 500GB🚶 | [Intel HD Graphics 4600]        |                                        |
| `eukelade`  | [Lenovo ThinkCentre M73 Tiny] | [Intel Core i3-4130T] | 8GB  | 500GB🚶 | [Intel HD Graphics 4400]        |                                        |
| `harpalyke` | [Lenovo ThinkCentre M73 Tiny] | [Intel Core i3-4130T] | 8GB  | 500GB🚶 | [Intel HD Graphics 4400]        |                                        |
| `kore`      | [Lenovo ThinkCentre M73 Tiny] | [Intel Core i3-4130T] | 8GB  | 500GB🚶 | [Intel HD Graphics 4400]        |                                        |
| `iocaste`   | [Lenovo ThinkCentre M73 Tiny] | [Intel Core i3-4130T] | 8GB  | 500GB🚶 | [Intel HD Graphics 4400]        |                                        |
| `aitne`     | [Beelink EQR6 SEI]            | [AMD Ryzen 7 5700U]   | 16GB | 512GB🏃 | AMD Radeon Graphics (@ 1.9 GHz) | Bad CPU (unstable at high frequencies) |

</details>

<details>
<summary>Decomissioned Hardware</summary>
Hardware that has been decommisioned, either temporarily or indefinitely.

<details>
<summary>Key</summary>

| State                                      |
| :----------------------------------------- |
| 🤔 - Recommission Planned Soon             |
| 🔜 - Temporarily Decomissioned             |
| ⌛ - Indefinitely Decomissioned            |
| 😵 - Hardware Failure                      |
| 🗑️ - No Longer Owned (i.e. sold/recycled) |
</details>

|  Hostname  |  Board                     |  CPU                      |  RAM  | Storage | GPUs                     | State | Reason             | Comments           |
| :-------:  | :------------------------: | :-----------------------: | :---: | :-----: | :----------------------: | :---: | :----------------: | :----------------: |
| `artemis`  | [ThinkPad X1 Carbon Gen 7] | [Intel Core i7-8665U]     | 16GB  | None    | [Intel UHD Graphics 620] | 😵    | Bad RAM (Soldered) | Ex-Primary Laptop  |
| (unnamed)  | [Supermicro X8SAX] (modified?) | 2x [Intel Xeon X5670] | 96GB  | None    | None                     | 🔜    | High Power Draw    | [Themis RES-12XR3] |

</details>

## Inspiration
[Wimpy's World] - README format, file structure, general introduction to Nix syntax

<!-- Links -->

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
[Intel Core i7-10850H]: https://www.intel.com/content/www/us/en/products/sku/201897/intel-core-i710850h-processor-12m-cache-up-to-5-10-ghz/specifications.html
[AMD Ryzen 7 5700U]: https://www.amd.com/en/support/downloads/drivers.html/processors/ryzen/ryzen-5000-series/amd-ryzen-7-5700u.html#amd_support_product_spec
[Intel Core i3-6100]: https://www.intel.com/content/www/us/en/products/sku/90729/intel-core-i36100-processor-3m-cache-3-70-ghz/specifications.html
[Intel Core i3-4150T]: https://www.intel.com/content/www/us/en/products/sku/77487/intel-core-i34150t-processor-3m-cache-3-00-ghz/specifications.html
[Intel Xeon X5670]: https://www.intel.com/content/www/us/en/products/sku/47920/intel-xeon-processor-x5670-12m-cache-2-93-ghz-6-40-gts-intel-qpi/specifications.html

<!-- Hardware: Graphics -->
[NVIDIA RTX 2070 Super]: https://www.nvidia.com/en-us/geforce/graphics-cards/compare/?section=compare-20
[NVIDIA Quadro T2000 Mobile / Max-Q]: https://www.techpowerup.com/gpu-specs/quadro-t2000-max-q.c3436
[Intel UHD Graphics 620]: https://www.techpowerup.com/gpu-specs/uhd-graphics-620-mobile.c2909
[Intel HD Graphics 530]: https://www.techpowerup.com/gpu-specs/hd-graphics-530.c2789
[Intel HD Graphics 4400]: https://www.techpowerup.com/gpu-specs/hd-graphics-4400.c2470
[Intel HD Graphics 4600]: https://www.techpowerup.com/gpu-specs/hd-graphics-4600.c1994

<!-- Hardware: Other -->
[Themis RES-12XR3]: https://www.mrcy.com/legacy_assets/siteassets/product-datasheets/rugged-servers/res12xr3_ds-0221-0003.pdf

<!-- Inspiration -->
[Wimpy's World]: https://github.com/wimpysworld