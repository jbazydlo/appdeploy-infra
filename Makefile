.PHONY: clusterup clusterdown kubeconfig

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