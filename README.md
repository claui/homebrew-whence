**Note: This external Homebrew command is no longer maintained. Feel free to create a fork or switch to one that is actively supported.**

___

# brew whence

## About brew whence

`brew whence` is an external command to Homebrew.  
It lets you look up the Homebrew formula from where you got an executable.

## Example

With `brew whence` installed, run:

```
$ brew whence 7z mvn zdb
```

And you get:

```
Executable                         Comes from
==========                         ==========
/usr/local/bin/7z                  → p7zip 16.02
/usr/local/bin/mvn                 → maven 3.6.3
/usr/local/bin/zdb   (not a link)
```

## Command-line options

The `-H` or `--no-headers` option will print the output in a machine-readable form (tab-separated, no headers):

```
$ brew whence -H 7z mvn zdb
```

```
7z    A  p7zip  16.02                  /usr/local/bin/7z
mvn   A  maven  3.6.3                  /usr/local/bin/mvn
zdb   N                                /usr/local/bin/zdb
```

## Installing

To install the `brew whence` command, run:

```
$ brew tap claui/whence
```

## License

Copyright (c) 2019 – 2020 Claudia <clau@tiqua.de>

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted, provided that the
above copyright notice and this permission notice appear in all
copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
