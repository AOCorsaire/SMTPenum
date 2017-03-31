# SMTPenum

Enumerate local users via SMTP for underlying service leakage and potentially OS disclosure.

## About

Small bits of research on how this works, why it works, and what can be done to avoid this type of enumeration.

### Usage

`SMTPenum.pl <server_ip> <port>`

#### Example

```sh
$ ./SMTPenum.pl localhost 25
[+] SMTPenum Starting
############################################# 100.0%
[+] Done elapsed:  0:16
[+] Found:admin
[+] Found:aws
[+] Found:bin
```

### TODO
- startTLS support
- AUTH enumeration
- more SMTP commands
- grow users/services list
- OS guessing VIA services
 
