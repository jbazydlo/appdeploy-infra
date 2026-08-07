.PHONY: clusterup clusterdown kubeconfig argoup argotunnel deploypodinfo

clusterup:
	terraform init
	terraform apply -auto-approve -var-file="appdeploy-infra.tfvars"
	@$(MAKE) --no-print-directory  kubeconfig

clusterdown:
	terraform destroy -auto-approve -var-file="appdeploy-infra.tfvars"

kubeconfig:
	@echo "Fetching kubeconfig from cluster..."
	@IP=$$(terraform output -raw node-ip); \
	ssh-keygen -R $$IP 2>/dev/null || true; \
	scp -i ~/.ssh/hetzner_key root@$$IP:/etc/rancher/k3s/k3s.yaml ./kubeconfig; \
	sed -i "s/127.0.0.1/$$IP/g" ./kubeconfig; \
	echo "Kubeconfig saved. Use: export KUBECONFIG=./kubeconfig"

argoup:
	@echo "Installing ArgoCD..."
	@helm upgrade --install argocd argo/argo-cd --namespace argocd --create-namespace --version 10.2.1 --set server.service.type=LoadBalancer
	@echo "Default password:"
	@sleep 20
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

argotunnel:
	@echo "Enabling ArgoCD tunnel..."
	@kubectl port-forward service/argocd-server -n argocd 8088:443

deploypodinfo:
	@echo "Installing podinfo appset..."
	@kubectl apply -f ../appdeploy-gitops/argocd/appsets/podinfo.yaml

