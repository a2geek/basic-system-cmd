# ONLINE Command

Displays all volumes online.

```
]ONLINE

S3,D2 /RAM
S6,D1 ERR=$27
S6,D2 ERR=$27

]
```

Accepts slot/drive parameters.

```
]ONLINE,S3,D2
 
S3,D2 /RAM

]
```

Error code of $57 indicates duplicate volumes are online, and `ONLINE` reports which disk is a duplicate.

```
]ONLINE
 
S6,D1 /MY.DISK
S6,D2 ERR=$57 (S6,D1)

]
```

