.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Welcome to ToGif example. Please use \`make <target>\` where <target> is one of"
	@echo " "
	@echo "  Next commands are only for dev environment with nextcloud-docker-dev!"
	@echo "  They should run from the host you are developing on(with activated venv) and not in the container with Nextcloud!"
	@echo "  "
	@echo "  build-push        build image and upload to ghcr.io"
	@echo "  "
	@echo "  deploy28          deploy example to registered 'docker_dev' for Nextcloud 28"
	@echo "  deploy27          deploy example to registered 'docker_dev' for Nextcloud 27"
	@echo "  "
	@echo "  run28             install ToGif for Nextcloud 28"
	@echo "  run27             install ToGif for Nextcloud 27"
	@echo "  "
	@echo "  For development of this example use PyCharm run configurations. Development is always set for last Nextcloud."
	@echo "  First run 'to_gif_example' and then 'make manual_register', after that you can use/debug/develop it and easy test."
	@echo "  "
	@echo "  manual_register28 perform registration of running 'to_gif_example' into 'manual_install' deploy daemon."
	@echo "  manual_register27 perform registration of running 'to_gif_example' into 'manual_install' deploy daemon."

.PHONY: build-push
build-push:
	docker login ghcr.io
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/to_gif_example:1.0.0 --tag ghcr.io/cloud-py-api/to_gif_example:latest .

.PHONY: deploy28
deploy28:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister to_gif_example --silent || true
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:deploy to_gif_example docker_dev \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/to_gif_example/main/appinfo/info.xml

.PHONY: run28
run28:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister to_gif_example --silent || true
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:register to_gif_example docker_dev \
		-e --force-scopes \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/to_gif_example/main/appinfo/info.xml

.PHONY: deploy27
deploy27:
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:unregister to_gif_example --silent || true
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:deploy to_gif_example docker_dev \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/to_gif_example/main/appinfo/info.xml

.PHONY: run27
run27:
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:unregister to_gif_example --silent || true
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:register to_gif_example docker_dev \
		-e --force-scopes \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/to_gif_example/main/appinfo/info.xml

.PHONY: manual_register28
manual_register28:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister to_gif_example --silent || true
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:register to_gif_example manual_install --json-info \
  "{\"appid\":\"to_gif_example\",\"name\":\"to_gif_example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"host\":\"host.docker.internal\",\"port\":10040,\"scopes\":{\"required\":[\"FILES\", \"NOTIFICATIONS\"],\"optional\":[]},\"protocol\":\"http\",\"system_app\":0}" \
  -e --force-scopes

.PHONY: manual_register27
manual_register27:
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:unregister to_gif_example --silent || true
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:register to_gif_example manual_install --json-info \
  "{\"appid\":\"to_gif_example\",\"name\":\"to_gif_example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"host\":\"host.docker.internal\",\"port\":10040,\"scopes\":{\"required\":[\"FILES\", \"NOTIFICATIONS\"],\"optional\":[]},\"protocol\":\"http\",\"system_app\":0}" \
  -e --force-scopes