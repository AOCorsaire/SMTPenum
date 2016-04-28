# SMTPenum

Enumerate local users via SMTP for underlying service leakage and potentially OS disclosure.

## About

Small bits of research on how this works, why it works, and what can be done to avoid this.

### Usage

`SMTPenum.pl <server_ip> <port>`

#### Example

```sh
$ ./SMTPenum.pl localhost 25
Testing: admin
Testing: administrator
Testing: _apt
Testing: arpwatch
Testing: avahi
...[SNIP]...
Found: administrator
Found: tomcat
Found: mysql
```

### TODO
- progress bar
- log reults to confirm false positives
- startTLS support
- AUTH enumeration
- more SMTP commands
- grow users/services list
- OS guessing VIA services
