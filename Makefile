CLUSTER_NAME := foo

#
# Main commands
#
.PHONY: start
start: start/k3d context cilium/install falco/deploy

.PHONY: delete
delete:
	k3d cluster delete ${CLUSTER_NAME}

.PHONY: context
context:
	kubectl config use-context k3d-${CLUSTER_NAME}

.PHONY: update-deps
update-deps:
	helm dep update

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

.PHONY: start/k3d
start/k3d:
	@k3d cluster list ${CLUSTER_NAME} || ( \
		k3d cluster create ${CLUSTER_NAME} \
			--config ./k3d-default.yaml \
	)


.PHONY: cilium/install
cilium/install:
	./bpf-scaffold.sh
	./cilium-install.sh

.PHONY: falco/deploy
falco/deploy:
	./falco-deploy.sh

#
# Dashboard
#
.PHONY: dashboard/install
dashboard/install:
	helm install --namespace kubernetes-dashboard --create-namespace kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --set extraArgs.enable-skip-login=true
	@echo
	@echo ignore the above, run make dashboard/auth followed by make dashboard/proxy

.PHONY: dashboard/auth
dashboard/auth:
	kubectl apply -f ./local/k8s/dashboard-rbac.yaml

.PHONY: dashboard/proxy
dashboard/proxy:
	@echo "Dashboard Url: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:https/proxy/#/workloads?namespace=default"
	kubectl proxy

.PHONY: dashboard/uninstall
dashboard/uninstall:
	helm uninstall kubernetes-dashboard --namespace kubernetes-dashboard
	kubectl delete namespace kubernetes-dashboard
	kubectl delete clusterrolebinding kubernetes-dashboard

.PHONY: k8s/apply
k8s/apply: context
	kubectl apply -f local/k8s/grafana-service.yaml
