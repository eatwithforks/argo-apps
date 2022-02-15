.PHONY: get-argocd-password proxy-argocd-ui bootstrap teardown

proxy-argocd-ui:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

get-argocd-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

bootstrap:
	kubectl apply -f cluster-charts/projects/project-$(env).yml
	kubectl apply -f cluster-charts/root-app-$(env).yml

teardown:
	kubectl delete -f cluster-charts/projects/project-$(env).yml
	kubectl delete -f cluster-charts/root-app-$(env).yml
	kubectl delete -f cluster-charts/apps-children/$(env)/
