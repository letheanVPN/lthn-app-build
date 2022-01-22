# Adding PGP signing

If you don't have a PGP key, you can make one on the mail server in Settings > PGP Keys.

```
$ gpg --list-keys
/Users/schacon/.gnupg/pubring.gpg
---------------------------------
pub   2048R/0A46826A 2014-06-04
uid                  Scott Chacon (Git signing key) <schacon@gmail.com>
sub   2048R/874529A9 2014-06-04
```

```shell
git config --global user.signingkey 0A46826A
```

you should be able to get your IDE to sign commits