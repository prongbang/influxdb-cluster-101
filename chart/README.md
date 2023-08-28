
## Kubernetes & Helm Chart

https://github.com/influxtsdb/helm-charts/tree/master/charts/influxdb-cluster

Download InfluxDB Cluster Helm chart, then run:

https://www.cnblogs.com/klvchen/p/16968727.html

```shell
git clone https://github.com/influxtsdb/helm-charts.git

cd helm-charts/charts/influxdb-cluster

# 搜索两处 storageClass，改成自己的存储，大约在 98 和 213 行，默认存储大小是 25Gi 可以根据自己的需求修改
vi values.yaml
storageClass: "nfs-client"

# 部署
cd /data/yaml/default/InfluxDB/helm-charts/charts
helm upgrade --install influxdb-cluster ./influxdb-cluster

# 查看
helm ls

# 构建集群，注意如果前面 helm upgrade 使用的是官方文档的 helm upgrade --install my-release ./influxdb-cluster， 下面需要更改
kubectl exec -it influxdb-cluster-meta-0 -- bash
influxd-ctl add-meta influxdb-cluster-meta-0.influxdb-cluster-meta:8091
influxd-ctl add-meta influxdb-cluster-meta-1.influxdb-cluster-meta:8091
influxd-ctl add-meta influxdb-cluster-meta-2.influxdb-cluster-meta:8091
influxd-ctl add-data influxdb-cluster-data-0.influxdb-cluster-data:8088
influxd-ctl add-data influxdb-cluster-data-1.influxdb-cluster-data:8088
influxd-ctl show
```

test

```shell
kubectl exec -it influxdb-cluster-meta-0 -- bash

# 创建 database
curl -XPOST "http://influxdb-cluster-data:8086/query" --data-urlencode "q=CREATE DATABASE mydb WITH REPLICATION 2"

# 写入一些数据
curl -XPOST "http://influxdb-cluster-data:8086/write?db=mydb" \
-d 'cpu,host=server01,region=uswest load=42 1434055562000000000'

curl -XPOST "http://influxdb-cluster-data:8086/write?db=mydb&consistency=all" \
-d 'cpu,host=server02,region=uswest load=78 1434055562000000000'

curl -XPOST "http://influxdb-cluster-data:8086/write?db=mydb&consistency=quorum" \
-d 'cpu,host=server03,region=useast load=15.4 1434055562000000000'

# 查询数据
curl -G "http://influxdb-cluster-data:8086/query?pretty=true" --data-urlencode "db=mydb" \
--data-urlencode "q=SELECT * FROM cpu WHERE host='server01' AND time < now() - 1d"
```

Enable username and password authentication

```shell
# 添加用户
kubectl exec -it influxdb-cluster-data-0 -- bash
influx
# 创建用户
CREATE USER admin WITH PASSWORD 'HDyl' WITH ALL PRIVILEGES

# 查看用户
show users;

# 退出
exit

cd /data/yaml/default/InfluxDB/helm-charts/charts/influxdb-cluster/templates
vi data-configmap.yaml
# 在 http 下面添加 auth-enabled = true
[http]
    auth-enabled = true
```

```shell
# 重启 influxdb-cluster
cd /data/yaml/default/InfluxDB/helm-charts/charts/influxdb-cluster/

helm upgrade --install influxdb-cluster  .
```
