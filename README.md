# influxdb-cluster

https://github.com/chengshiwen/influxdb-cluster

Architectural overview:

![architecture.png](https://iili.io/Vw1XTB.png)

Network overview:

![architecture](https://docs.influxdata.com/img/enterprise/1-8-network-diagram.png)

## Backup Images

```shell
docker pull NAME:tag
docker tag NAME:tag myaccount/name:tag
docker login
docker push myaccount/name:tag
```