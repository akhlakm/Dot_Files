EMAIL = me@akhlakm.com

all:
	@sed -rn 's/^([a-zA-Z_-]+):$$/"\1"/p' < $(MAKEFILE_LIST) | xargs printf "make %-20s\n"

setup_git:
	git config --global user.name ${USER}
	git config --global user.email ${EMAIL}

setup_github:
	@if [ ! -f ~/.ssh/id_ed25519 ]; then\
		ssh-keygen -t ed25519 -C "me@akhlakm.com";\
		eval "$(ssh-agent -s)";\
		ssh-add ~/.ssh/id_ed25519;\
	fi
	cat ~/.ssh/id_ed25519.pub

portainer:
	sudo chown :docker /var/run/docker.sock
	sudo chmod g+w /var/run/docker.sock
	docker volume create portainer_data
	docker run -d -p 9443:9443 --name portainer \
		--restart=always \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v portainer_data:/data \
		portainer/portainer-ce
	@echo "OK. Portainer WebUI available on port :9443 (port forwarded/firewall allowed?)"

install_docker:
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	sudo groupadd docker || true
	sudo usermod -aG docker ${USER}
	newgrp docker
	mkdir ~/docker
	sudo chown docker ~/docker
	remove get-docker.sh

remove_snap:
	sudo rm -rf /var/cache/snapd/
	sudo apt autoremove --purge snapd
	sudo rm -fr ~/snap

photoprism:
	@docker run -d --name photoprism \
		--security-opt seccomp=unconfined \
		--security-opt apparmor=unconfined \
		-p 2342:2342 \
		-e PHOTOPRISM_UPLOAD_NSFW="true" \
		-e PHOTOPRISM_ADMIN_PASSWORD="${PASS}" \
		-v ~/docker/photoprism/storage:/photoprism/storage \
		-v ~/Media:/photoprism/originals \
		photoprism/photoprism
	@echo "Started photoprism on :2342, need port forward/allow?"
	@echo "Media files are assumed to be in the ~/Media directory."

