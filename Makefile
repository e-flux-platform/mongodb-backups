build:
	DOCKER_BUILDKIT=1 DOCKER_SCAN_SUGGEST=false docker build -t e-flux-tools-mongo-backup:latest -f Dockerfile --platform=linux/amd64 .
	docker tag e-flux-tools-mongo-backup:latest gcr.io/eflux-production/e-flux-tools-mongo-backup:latest
	docker tag e-flux-tools-mongo-backup:latest gcr.io/eflux-staging/e-flux-tools-mongo-backup:latest

push:
	docker push gcr.io/eflux-staging/e-flux-tools-mongo-backup:latest
	docker push gcr.io/eflux-production/e-flux-tools-mongo-backup:latest

