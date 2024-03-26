.PHONY: install
install:
	kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml
	kubectl wait --for=condition=Ready pod -l app=helm-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=image-automation-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=image-reflector-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=kustomize-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=notification-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=source-controller -n flux-system --timeout 3m

.PHONY: clean
clean:
	kubectl delete namespace flux-system
