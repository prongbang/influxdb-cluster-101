install_influxdb:
	docker compose -f influxdb.yml up 

install_chronograf:
	docker compose -f chronograf.yml up 

install_telegraf:
	docker compose -f telegraf.yml up 

install_influx_admin:
	docker compose -f influxdb-admin.yml up

kubctl_deployment:
	kubectl apply -f deployment/data-deployment.yaml
	kubectl apply -f deployment/meta-deployment.yaml

kubctl_service:
	kubectl apply -f deployment/data-service.yaml
	kubectl apply -f deployment/meta-service.yaml

kubctl_ingress:
	kubectl apply -f deployment/ingress.yaml