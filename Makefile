.PHONY: install
install: install-kind install-prometheus install-grafana port-fwd-grafana

.PHONY: install-kind
install-kind:
ifneq ($(shell kind get nodes), kind-control-plane)
	bootstrap/kind-with-extras.sh
	kubectl wait --for=condition=Ready node/kind-control-plane --timeout=3m
endif

.PHONY: install-prometheus
install-prometheus:
ifeq ($(shell helm repo list | grep prometheus-community | wc -l), 0)
	$(shell helm repo add prometheus-community https://prometheus-community.github.io/helm-charts)
endif
	helm install prometheus prometheus-community/prometheus --create-namespace --namespace prometheus
	kubectl wait --for=condition=Ready -n prometheus pods -l "app.kubernetes.io/instance=prometheus" --timeout=5m

.PHONY: install-grafana
install-grafana:
ifeq ($(shell helm repo list | grep grafana | wc -l), 0)
	$(shell helm repo add grafana https://grafana.github.io/helm-charts)
	$(shell helm repo update)
endif
	kubectl create namespace grafana
	helm install grafana grafana/grafana --namespace grafana --values bootstrap/grafana-values.yaml
	kubectl wait --for=condition=Ready -n grafana pods -l "app.kubernetes.io/instance=grafana" --timeout=5m

.PHONY: port-fwd-grafana
port-fwd-grafana:
	$(eval pod_name = $(shell kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}"))
	@kubectl --namespace grafana port-forward $(pod_name) 3000 > /dev/null 2>&1 &
	$(eval grafana-password = $(shell kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode))
	@echo you can now access Grafana at http://localhost:3000
	@echo "username: admin"
	@echo "password: $(grafana-password)"

.PHONY: clean
clean:
	kind delete cluster
	docker rm kind-registry -f
