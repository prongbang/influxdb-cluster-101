install_influxdb:
	docker compose -f influxdb.yml up 

install_chronograf:
	docker compose -f chronograf.yml up 

install_telegraf:
	docker compose -f telegraf.yml up 

install_influx_admin:
	docker compose -f influxdb-admin.yml up 