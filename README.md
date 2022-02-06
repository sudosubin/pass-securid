# pass-securid

A [pass](https://www.passwordstore.org/) extension for managing RSA SecurIDs.

## Usage

### Basic use

To insert new RSA SecurID token, run:

```sh
pass securid insert [pass-name]
```

To append RSA SecurID token to existing pass file, run:

```sh
pass securid append pass-name
```

To show RSA SecurID code, run:

```sh
pass securid pass-name
```

### Help

```text
Usage:

    pass securid [code,show] [--clip,-c] pass-name
        Show a SecurID and optionally put it on the clipboard.
        If put on the clipboard, it will be cleared in $CLIP_TIME seconds.

    pass securid insert [--force,-f] pass-name
        Insert new SecurID token.

    pass securid append [--force,-f] pass-name
        Appends a SecurID token to an existing password file.

    pass securid help
        Show this text.

    pass securid version
        Show version information.

More information may be found in the pass-securid(1) man page.
```

## Installation

<!-- markdownlint-disable-next-line MD036 -->
**Requirements**

- `pass` 1.7.0 or later
- `stoken`

### From git

```sh
git clone https://github.com/sudosubin/pass-securid.git
cd pass-securid
sudo make install
```
