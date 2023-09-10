
kubctl_deployment:
	kubectl apply -f deployment/data-deployment.yaml
	kubectl apply -f deployment/meta-deployment.yaml

kubctl_service:
	kubectl apply -f deployment/data-service.yaml
	kubectl apply -f deployment/meta-service.yaml

kubctl_ingress:
	kubectl apply -f deployment/ingress.yaml