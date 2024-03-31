.PHONY: install
install: install-prometheus install-grafana-operator apply-k-grafana port-fwd-grafana

.PHONY: install-prometheus
install-prometheus:
ifeq ($(shell helm repo list | grep prometheus-community | wc -l), 0)
	$(shell helm repo add prometheus-community https://prometheus-community.github.io/helm-charts)
endif
	helm install prometheus prometheus-community/prometheus --create-namespace --namespace prometheus
	kubectl wait --for=condition=Ready -n prometheus pods -l "app.kubernetes.io/instance=prometheus" --timeout=5m

.PHONY: install-grafana-operator
install-grafana-operator:
	kubectl create namespace grafana
	helm upgrade -i grafana-operator oci://ghcr.io/grafana/helm-charts/grafana-operator --version v5.6.3 --namespace grafana
	kubectl wait --for=condition=Ready -n grafana pods -l "app.kubernetes.io/instance=grafana-operator" --timeout=5m

.PHONY: apply-k-grafana
apply-k-grafana:
	kubectl apply -k grafana
	@sleep 2s
	kubectl wait --for=condition=Ready -n grafana pods -l "app=grafana" --timeout=5m

.PHONY: port-fwd-grafana
port-fwd-grafana:
	$(eval pod_name = $(shell kubectl get pods --namespace grafana -l "app=grafana" -o jsonpath="{.items[0].metadata.name}"))
	@kubectl --namespace grafana port-forward $(pod_name) 3000 > /dev/null 2>&1 &
	$(eval grafana-password = $(shell kubectl get secret --namespace grafana grafana-admin-credentials -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode))
	@echo you can now access Grafana at http://localhost:3000
	@echo "username: admin"
	@echo "password: $(grafana-password)"

.PHONY: clean
clean:
	kubectl delete namespace grafana
	kubectl delete namespace prometheus
