# analyze_sys
Get systerm info. Include GPU/CPU/MEMORY/IO/NET.

### Download auto configure script and execute it.

```shell
wget https://raw.githubusercontent.com/BobWr/analyze_sys/master/analyze_sys_auto_config.sh

chmod +x analyze_sys_auto_config.sh

./analyze_sys_auto_config.sh
```

### start record

```shell
curl localhost:9999
```

##### One case this command returns: `curl: (7) Failed connect to localhost:9999; Connection refused. ` that's because of the xinted.service restart failed. you can restart it by yourslef.

```shell
#stop
sudo systemctl stop xinetd.service

#start
sudo systemctl start xinetd.service
```

##### Makesure command `curl localhost:9999` returns `Analyze start.`and log files will save into `data`.

### stop record

```shell
curl localhost:9998
```

##### Wait a few minutes until it returns:

```shell
HTTP/1.1 200 OK
Content-Type: text/plain
Connection: close
Content-Length: DATA_LENGTH

DATA
```
