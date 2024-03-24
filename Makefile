.PHONY: install
install: install-kind install-prometheus port-forward-prometheus

.PHONY: install-kind
install-kind:
ifneq ($(shell kind get nodes), kind-control-plane)
	./kind-with-extras.sh
	kubectl wait --for=condition=Ready node/kind-control-plane --timeout=3m
endif

.PHONY: install-prometheus
install-prometheus:
ifeq ($(shell helm repo list | grep prometheus-community | wc -l), 0)
		$(shell helm repo add prometheus-community https://prometheus-community.github.io/helm-charts)
endif
	helm install prometheus prometheus-community/prometheus --create-namespace --namespace prometheus
	kubectl wait --for=condition=Ready -n prometheus pods -l "app.kubernetes.io/instance=prometheus" --timeout=5m

.PHONY: port-forward-prometheus
port-forward-prometheus:
	$(eval pod_name = $(shell kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}"))
	nohup kubectl --namespace prometheus port-forward $(pod_name) 9090 &
	@echo prometheus is accessible at http://localhost:9090


.PHONY: clean
clean:
	kind delete cluster
	docker rm kind-registry -f
