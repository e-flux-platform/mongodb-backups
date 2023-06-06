build:
	DOCKER_BUILDKIT=1 DOCKER_SCAN_SUGGEST=false docker build -t e-flux-tools-mongo-backup:latest -f Dockerfile --platform=linux/amd64 .
	docker tag e-flux-tools-mongo-backup:latest europe-west3-docker.pkg.dev/eflux-staging/docker/e-flux-tools-mongo-backup:latest
	docker tag e-flux-tools-mongo-backup:latest europe-west3-docker.pkg.dev/eflux-production/docker/e-flux-tools-mongo-backup:latest

push:
	docker push europe-west3-docker.pkg.dev/eflux-staging/docker/e-flux-tools-mongo-backup:latest
	docker push europe-west3-docker.pkg.dev/eflux-production/docker/e-flux-tools-mongo-backup:latest
