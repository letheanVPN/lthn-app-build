---
title: Docker Image File System
description: The layout of our docker image internal filesystem
---

If the docker hub name is `lthn/chain` then  $PROJECT would be `chain`

`export HOME=/home/lthn`
`export PROJECT=chain`

```
$HOME/bin/$PROJECT/
$HOME/config/$PROJECT/
$HOME/data/$PROJECT/
$HOME/src/$PROJECT/
$HOME/wallet/$PROJECT/
```