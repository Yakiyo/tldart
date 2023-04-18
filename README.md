# tldart
[![CI](https://github.com/Yakiyo/tldart/actions/workflows/ci.yml/badge.svg)](https://github.com/Yakiyo/tldart/actions/workflows/ci.yml)
[![Pub Package](https://img.shields.io/pub/v/tldart.svg)](https://pub.dev/packages/tldart)

Fast tldr client written in dart.

![screenie](https://i.ibb.co/p4c2tVZ/image.png)

## Installation
- Installing it through the [Dart SDK](https://github.com/dart-lang/sdk) **[Recommended]**
```bash
$ dart pub global activate tldart
```
This will add the `tldr` executable to your path.

- Manual installation
Simple binaries for windows, macos and linux are available in zip files in the [release](https://github.com/Yakiyo/tldart/releases/latest) section. You can download the zip file, extract the `tldr.exe` (or `tldr` depending on your platform) and add the directory to your path.

## Usage
Tldart follows the [tldr client specifications](https://github.com/tldr-pages/tldr/blob/main/CLIENT-SPECIFICATION.md), so it should be the same as any other tldr client if you've used any before.

tldart stores a local copy of tldr-pages in your `~/.tldr` directory. If its missing, the app will prompt you to update the cache directory.
### Search for a page
```bash
$ tldr man # to search for `man`

$ tldr git log # to search for `git-log`

$ tldr -p linux mv # to search for `mv` for linux platform

$ tldr -l ar chrome # to search for `chrome` in arabic lang
```

You can specify the language with the `--language` or `-l` flag.

Platform can be specified with `--platform` or `-p` flag. (One of 'linux', 'macos', 'windows', 'sunos', 'osx', 'android'). By default the platform used is the user's current platform, if the query is not available for the platform, the app switches to the `common` platform. 

### Listing all commands
```bash
$ tldr --list
```
Lists all the available command in your local cache

### Updating local cache
```bash
$ tldr --update
# or
$ tldr -u
```
This downloads the tldr archive, unzips it and stores it in your `~/.tldr/cache` directory. This might take a few seconds or minutes as the archive file is big and unzipping it takes a bit of time.

The app emits some debug logs internally. This can be viewed by setting the `DEBUG` env variable to anything, as long as its not empty. For example in bash:
```bash
$ DEBUG=1 tldr -u
```

For any problems, queries or bugs, feel free to open a new [issue](https://github.com/Yakiyo/tldart/issues/).

## Credits
This project was heavily inspired by dbrgn's [tealdeer](https://github.com/dbrgn/tealdeer).

## Author

**tldart** © [Yakiyo](https://github.com/Yakiyo). Authored and maintained by Yakiyo.

Released under [MIT](https://opensource.org/licenses/MIT) License

