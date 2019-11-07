# analyze_sys
Get systerm info. Include GPU/CPU/MEMORY/IO/NET.

### Download auto configure script and execute it.

```shell
wget https://raw.githubusercontent.com/BobWr/analyze_sys/golang/analyze_sys_auto_config.sh

chmod +x analyze_sys_auto_config.sh

./analyze_sys_auto_config.sh
```

### start record. Makesure port `9999` is open.

```shell
curl localhost:9999/record
```

### stop record and get logs. This interface can be called many times.

```shell
curl localhost:9999/data
```

##### Wait a few minutes until it returns:

```shell
{
    "net" : {
        "rxpck_s" : "",
        "txpck_s" : "",
        "rxkB_s" : "",
        "txkB_s" : "",
        "rxcmp_s" : "",
        "txcmp_s" : ""
    },
    "cpu" : {
        "user" : "",
        "nice" : "",
        "system" : "",
        "iowait" : "",
        "steal" : "",
        "idle" : ""
    },
    "mem" : {
        "kbmemfree" : "",
        "kbmemused" : "",
        "memused" : ""
    },
    "io" : {
        "tps" : "",
        "rtps" : "",
        "wtps" : ""
    },
    "gpu" : {
        "use" : ""
    }
}
```
