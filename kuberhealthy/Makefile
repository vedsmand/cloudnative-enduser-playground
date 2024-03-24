.PHONY: install
install: install-kuberhealthy

.PHONY: install-kuberhealthy
install-kuberhealthy:
ifeq ($(shell helm repo list | grep kuberhealthy | wc -l), 0)
		helm repo add kuberhealthy https://kuberhealthy.github.io/kuberhealthy/helm-repos
endif
	helm install --set prometheus.enabled=true -n kuberhealthy kuberhealthy kuberhealthy/kuberhealthy --create-namespace
	kubectl wait --for=condition=Ready -n kuberhealthy pods -l "app=kuberhealthy" --timeout=5m

.PHONY: clean
clean:
	helm uninstall kuberhealthy -n kuberhealthy
	kubectl delete namespace kuberhealthy
