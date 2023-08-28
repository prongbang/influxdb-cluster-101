
## Kubernetes & Helm Chart

https://github.com/influxtsdb/helm-charts/tree/master/charts/influxdb-cluster

Download InfluxDB Cluster Helm chart, then run:

https://www.cnblogs.com/klvchen/p/16968727.html

```shell
git clone https://github.com/influxtsdb/helm-charts.git

cd helm-charts/charts/influxdb-cluster

# Search for two storageClasses, change them to your own storage, about lines 98 and 213, the default storage size is 25Gi, you can modify it according to your needs
vi values.yaml
storageClass: "nfs-client"

# deployment
cd /data/yaml/default/InfluxDB/helm-charts/charts
helm upgrade --install influxdb-cluster ./influxdb-cluster

# Check
helm ls

# Build a cluster, note that if the previous helm upgrade uses the official document helm upgrade --install my-release ./influxdb-cluster, the following needs to be changed
kubectl exec -it influxdb-cluster-meta-0 -- bash
influxd-ctl add-meta influxdb-cluster-meta-0.influxdb-cluster-meta:8091
influxd-ctl add-meta influxdb-cluster-meta-1.influxdb-cluster-meta:8091
influxd-ctl add-meta influxdb-cluster-meta-2.influxdb-cluster-meta:8091
influxd-ctl add-data influxdb-cluster-data-0.influxdb-cluster-data:8088
influxd-ctl add-data influxdb-cluster-data-1.influxdb-cluster-data:8088
influxd-ctl show
```

Output

```shell
root@influxdb-cluster-meta-0:/# influxd-ctl show
Data Nodes
==========
ID      TCP Address                                             Version
4       influxdb-cluster-data-0.influxdb-cluster-data:8088      1.8.10-c1.1.2
5       influxdb-cluster-data-1.influxdb-cluster-data:8088      1.8.10-c1.1.2

Meta Nodes
==========
ID      TCP Address                                             Version
1       influxdb-cluster-meta-0.influxdb-cluster-meta:8091      1.8.10-c1.1.2
2       influxdb-cluster-meta-1.influxdb-cluster-meta:8091      1.8.10-c1.1.2
3       influxdb-cluster-meta-2.influxdb-cluster-meta:8091      1.8.10-c1.1.2
root@influxdb-cluster-meta-0:/#
```

test

```shell
kubectl exec -it influxdb-cluster-meta-0 -- bash

# create database
curl -XPOST "http://influxdb-cluster-data:8086/query" --data-urlencode "q=CREATE DATABASE mydb WITH REPLICATION 2"

# write some data
curl -XPOST "http://influxdb-cluster-data:8086/write?db=mydb" \
-d 'cpu,host=server01,region=uswest load=42 1434055562000000000'

curl -XPOST "http://influxdb-cluster-data:8086/write?db=mydb&consistency=all" \
-d 'cpu,host=server02,region=uswest load=78 1434055562000000000'

curl -XPOST "http://influxdb-cluster-data:8086/write?db=mydb&consistency=quorum" \
-d 'cpu,host=server03,region=useast load=15.4 1434055562000000000'

# Query data
curl -G "http://influxdb-cluster-data:8086/query?pretty=true" --data-urlencode "db=mydb" \
--data-urlencode "q=SELECT * FROM cpu WHERE host='server01' AND time < now() - 1d"
```

Enable username and password authentication

```shell
# Add user
kubectl exec -it influxdb-cluster-data-0 -- bash
influx
# create user
CREATE USER admin WITH PASSWORD 'HDyl' WITH ALL PRIVILEGES

# view users
show users;

# quit
exit

cd /data/yaml/default/InfluxDB/helm-charts/charts/influxdb-cluster/templates
vi data-configmap.yaml
# Add auth-enabled = true below http
[http]
    auth-enabled = true
```

```shell
# restart influxdb-cluster
cd /data/yaml/default/InfluxDB/helm-charts/charts/influxdb-cluster/

helm upgrade --install influxdb-cluster  .
```
