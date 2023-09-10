# K8s

- Deployment

```shell
make kubctl_deployment
```

- Service

```shell
make kubctl_service
```

- Ingress

```shell
make kubctl_ingress
```

```shell
kubectl exec -it influxdb-meta-deployment-596f9f849c-b7rhf -- bash
influxd-ctl add-meta influxdb-meta-deployment-596f9f849c-b7rhf:8091
influxd-ctl add-data influxdb-data-deployment-85744dbb9c-jlm9d:8088
```
