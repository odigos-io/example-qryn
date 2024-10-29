
.PHONY: create-ns
create-ns:
	kubectl get namespace qryn || kubectl create namespace qryn

.PHONY: deploy-clickhouse
deploy-clickhouse:
	@kubectl apply -f clickhouse/ -n qryn
	# wait for the clickhouse cluster to be ready
	@echo "Waiting for clickhouse deployement to be ready..."
	@kubectl wait --namespace qryn deployment/clickhouse --for=condition=available --timeout=120s

.PHONY: deploy-qryn
deploy-qryn:
	@echo "Installing qryn"
	@helm repo add qryn-helm https://metrico.github.io/qryn-helm/
	@helm install --values qryn/qryn-values.yaml qryn qryn-helm/qryn-helm --version 0.1.3 --namespace=qryn

.PHONY: deploy-grafana
deploy-grafana:
	@echo "Installing Grafana"
	@helm repo add grafana https://grafana.github.io/helm-charts
	@helm install --values grafana/grafana-values.yaml grafana --namespace=qryn grafana/grafana

.PHONY: deploy
deploy: create-ns deploy-clickhouse deploy-qryn deploy-grafana

.PHONY: port-forward-clickhouse
port-forward-clickhouse:
	@echo "Port forwarding Clickhouse"
	kubectl port-forward -n qryn svc/clickhouse 8123:8123

.PHONY: port-forward-grafana
port-forward-grafana:
	@echo "Port forwarding Grafana"
	kubectl port-forward -n qryn svc/grafana 3005:80

.PHONY: get-grafana-password
get-grafana-password:
	@kubectl get secret -n qryn grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
