.PHONY: install
install: install-kind

.PHONY: install-kind
install-kind:
ifneq ($(shell kind get nodes), kind-control-plane)
	./kind-with-extras.sh
	kubectl wait --for=condition=Ready node/kind-control-plane --timeout=3m
endif

.PHONY: clean
clean:
	kind delete cluster
	docker rm kind-registry -f
