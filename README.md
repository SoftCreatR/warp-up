<div align=center>

# Warp-Up
#### Automatically generated referrer bonuses for Cloudflare WARP.

[![Build](https://img.shields.io/github/workflow/status/SoftCreatR/warp-up/TestRun?style=flat-square)](https://github.com/SoftCreatR/imei/actions/workflows/TestRun.yml)

[![Commits](https://img.shields.io/github/last-commit/SoftCreatR/warp-up?style=flat-square)](https://github.com/SoftCreatR/warp-up/commits/main) [![GitHub release](https://img.shields.io/github/release/SoftCreatR/warp-up?style=flat-square)](https://github.com/SoftCreatR/warp-up/releases) [![GitHub license](https://img.shields.io/github/license/SoftCreatR/warp-up?style=flat-square&color=lightgray)](https://github.com/SoftCreatR/warp-up/blob/main/LICENSE.md) ![Installs](https://img.shields.io/badge/dynamic/json?style=flat-square&color=blue&label=Installs&query=value&url=https%3A%2F%2Fapi.countapi.xyz%2Fget%2Fsoftcreatr%2Fwarpup) [![GitHub file size in bytes](https://img.shields.io/github/size/SoftCreatR/warp-up/warp-up.sh?style=flat-square)](https://github.com/SoftCreatR/warp-up/blob/main/warp-up.sh)

[![Codacy grade](https://img.shields.io/codacy/grade/e6f902ad09d14d98b5deea2381b67fde?style=flat-square)](https://www.codacy.com/gh/SoftCreatR/warp-up/dashboard) [![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/SoftCreatR/warp-up?style=flat-square)](https://www.codefactor.io/repository/github/softcreatr/warp-up)

</div>

---

<div align="center">

![Screenshot](https://raw.githubusercontent.com/SoftCreatR/warp-up/main/warp-up.png)

<a href="#about"> About</a> •
<a href="#disclaimer"> Disclaimer</a> •
<a href="#compatibility"> Compatibility</a> •
<a href="#usage"> Usage</a> •
<a href="#roadmap"> Roadmap</a> •
<a href="#contributing"> Contributing</a> •
<a href="#license"> License</a>

</div>

---

## About

[WARP+](https://blog.cloudflare.com/announcing-warp-plus/) uses Cloudflare's virtual private backbone, known as Argo, to achieve higher speeds and ensure your connection is encrypted across the long haul of the Internet.

Warp-Up is a tool, that uses the referral system of WARP+ to add a nearly unlimited amount of extra traffic to your existing WARP account.

---

## Disclaimer

This software and information is designed for educational purposes only.

This information is provided 'as is' and in no event shall the
provider or 1-2.dev be liable for any damages, including, without
limitation, damages resulting from lost data or lost profits or
revenue, the costs of recovering such data, the costs of substitute
data, claims by third parties or for other similar costs, or any
special, incidental, or consequential damages arising out of use or
misuse of this data. The accuracy or reliability of the data is not
guaranteed or warranted in any way, and the provider disclaim
liability of any kind whatsoever, including, without limitation,
liability for quality, performance, merchantability and fitness
for a particular purpose arising out of the use, or inability
to use the data. Information obtained via this software MUST
NEVER BE USED to take medical decisions.

All respective trademarks belong to Cloudflare, Inc.
1-2.dev is not affiliated with or endorsed by Cloudflare.

---

## Compatibility

Every Warp-Up build will be automatically tested against the latest Ubuntu LTS Versions (16.04 and newer) using Travis CI. Compatibility with other operating systems (such as Debian 10) is tested manually.

In fact, Warp-Up should work flawlessly on every system with Bash 5 and Curl.

### Operating System

#### Recommended

* Ubuntu 22.04 (__Jammy__ Jellyfish)
* Ubuntu 20.04 (__Focal__ Fossa)
* Ubuntu 18.04 (__Bionic__ Beaver)
* Debian 10 (__Buster__)
* Raspbian 10 (__Buster__)
* Windows 11 (requires [WSL 2](https://docs.microsoft.com/windows/wsl/install))
* Windows 10 20H2 (requires [WSL 2](https://docs.microsoft.com/windows/wsl/install))

#### Also compatible

* Ubuntu 21.10 (__Impish__ Indri)
* Ubuntu 21.04 (__Hirsute__ Hippo)
* Ubuntu 20.10 (__Groovy__ Gorilla)
* Ubuntu 19.10 (__Eoan__ Ermine)
* Ubuntu 17.04 (__Zesty__ Zapus)
* Ubuntu 16.04 (__Xenial__ Xerus)
* Debian 11 (__Bullseye__)
* Debian 9 (__Stretch__)
* Raspbian 9 (__Stretch__)

#### Maybe compatible (untested)

* Ubuntu < 16.04
* Debian < 9
* Fedora 32
* Centos 8
* CentOS 7
* macOS
* Windows 10 < 20H2

---

## Usage

Before you can start using this tool, you need a WARP ID. To obtain it, [download and install the 1.1.1.1 app](https://warp.plus/Uxs4a) on your mobile device first, if not already done.

As soon as the app has been installed, open it and tap on the ☰ Icon. Tap Advanced -> Diagnostics and copy your ID from the client configuration.

### One-Step Execution (Linux / WSL)

```bash
bash <(curl -sL dist.1-2.dev/warp-up)
```

**or (Windows / Powershell)**

```powershell
PowerShell -Command "Set-ExecutionPolicy RemoteSigned -scope Process; iwr -useb https://raw.githubusercontent.com/SoftCreatR/warp-up/main/install-warp-up.ps1 | iex && bash warp-up.sh"
```

### Alternative Method

```bash
git clone https://github.com/SoftCreatR/warp-up
cd warp-up
bash warp-up.sh
```

### Docker

```bash
git clone https://github.com/SoftCreatR/warp-up
cd warp-up/docker
```

Edit the file `docker-compose.yml` and configure Warp-Up. See [warp-up.conf.dist](https://github.com/SoftCreatR/warp-up/blob/main/warp-up.conf.dist) for an example configuration.

When done, run: 

```bash
sudo docker build --tag warp-up:latest .
sudo docker run -it warp-up
```

#### Options available

Currently available build options are

* `--id` : Your Warp ID
* `--iterations` : Number of iterations / Amount of GB you want to receive
* `--interval` : Seconds between every request
* `--log-file` : Log everything to the file provided

**Default options** :

* Interval: 20 seconds
* Log File: `warp-up.log`

**Configuration File** :

Instead of executing Warp-Up parameterized or through the wizard, you can create a file `warp-up.conf`, including your default configuration. Available options are:

* REFERRER
* ITERATIONS
* INTERVAL
* DISCLAIMER_AGREE
* LOG_FILE

See [warp-up.conf.dist](https://github.com/SoftCreatR/warp-up/blob/main/warp-up.conf.dist) for an example configuration.

After creating your configuration, simply run `bash warp-up` without parameters, and you are good to go. However, all configuration options can be overridden by executing Warp-Up parameterized, as usual.

#### Additional notes

* You may want to execute Warp-Up on your dedicated server or VPS. Please note, that many IP addresses and ranges are blocked by Cloudflare (e.g. Hetzner) thus they're unable to connect to the cloudflareclient.com API. Instead, you should run Warp-Up on your local machine.

* API requests are limited and may result in error responses. In this case, make sure, that you increase the interval option when running Warp-Up or omit the `--interval` argument to use the default value of 20 seconds.

* You can bypass the disclaimer on startup by executing Warp-Up with the `--disclaimer` argument.

* You may want to run Warp-Up until you stop it manually instead of stopping after N iterations. In this case, execute Warp-Up with `--iterations 0`.

---

## Contributing

If you have any ideas, just open an issue and describe what you would like to add/change in Warp-Up.

If you'd like to contribute, please fork the repository and make changes as you'd like. Pull requests are warmly welcome.

## License 🌳

[ISC](https://github.com/SoftCreatR/warp-up/blob/main/LICENSE) © [1-2.dev](https://1-2.dev)

This package is Treeware. If you use it in production, then we ask that you [**buy the world a tree**](https://ecologi.com/softcreatr?r=61212ab3fc69b8eb8a2014f4) to thank us for our work. By contributing to the ecologi project, you’ll be creating employment for local families and restoring wildlife habitats.
