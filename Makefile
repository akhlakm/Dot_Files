EMAIL = me@akhlakm.com

all:
	@sed -rn 's/^([a-zA-Z_-]+):$$/"\1"/p' < $(MAKEFILE_LIST) | xargs printf "make %-20s\n"

update:
	cd ~/Dot_Files/ && git pull
	source ~/Dot_Files/bashrc

setup-git:
	git config --global user.name ${USER}
	git config --global user.email ${EMAIL}

ssh-key:
	@if [ ! -f ~/.ssh/id_ed25519 ]; then\
		ssh-keygen -t ed25519 -C "${EMAIL}";\
		eval "$(ssh-agent -s)";\
		ssh-add ~/.ssh/id_ed25519;\
	fi
	@echo "Please copy and paste the line below to `~/.ssh/authorized_keys` on the remote server."
	cat ~/.ssh/id_ed25519.pub

ssh-add-pubkey:
	@echo "Please `cat ~/.ssh/id_*.pub` on your client and"
	@$(eval key = $(shell bash -c 'read -p "Copy and Paste SSH pubkey line: " temp; echo $$temp'))
	@if [ $(key) == "" ]; then exit 1; fi
	@mkdir -p ~/.ssh && echo "$(key)" >> ~/.ssh/authorized_keys
	@cat ~/.ssh/authorized_keys && echo OK

ssh-upload:
	$(eval server = $(shell bash -c 'read -p "Remote Server IP: " temp; echo $$temp'))
	$(eval username = $(shell bash -c 'read -p "User: " temp; echo $$temp'))
	if [ ! -f ~/.ssh/id_ed25519 ]; then make ssh-key; fi
	cat ~/.ssh/id_ed25519.pub | ssh $(username)@$(server) "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

ssh-disablepassword:
	sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
	sudo sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
	sudo sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
	sudo systemctl restart ssh || sudo systemctl restart sshd

docker-portainer:
	sudo chown :docker /var/run/docker.sock
	sudo chmod g+w /var/run/docker.sock
	docker volume create portainer_data
	docker run -d -p 9443:9443 --name portainer \
		--restart=always \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v portainer_data:/data \
		portainer/portainer-ce
	@echo "OK. Portainer WebUI available on port :9443 (port forwarded/firewall allowed?)"

install-docker:
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	sudo groupadd docker || true
	sudo usermod -aG docker ${USER}
	rm get-docker.sh
	newgrp docker
	mkdir ~/docker
	exit 0

remove-snap:
	sudo rm -rf /var/cache/snapd/
	sudo apt autoremove --purge snapd
	sudo rm -fr ~/snap

docker-photoprism:
	@docker run -d --name photoprism \
		--security-opt seccomp=unconfined \
		--security-opt apparmor=unconfined \
		-p 2342:2342 \
		-e PHOTOPRISM_UPLOAD_NSFW="true" \
		-e PHOTOPRISM_AUTH_MODE="public" \
		-e PHOTOPRISM_ADMIN_PASSWORD="${PASS}" \
		-v ~/docker/photoprism/storage:/photoprism/storage \
		-v ~/Media:/photoprism/originals \
		photoprism/photoprism
	@echo "Started photoprism on :2342, need port forward/allow?"
	@echo "Media files are assumed to be in the ~/Media directory."

unattended-upgrades-debian:
	sudo apt update && sudo apt install unattended-upgrades bsd-mailx
	sudo vim /etc/apt/apt.conf.d/50unattended-upgrades

unattended-upgrades-centos:
	sudo yum install dnf-automatic
	sudo vim /etc/dnf/automatic.conf
	sudo systemctl enable --now dnf-automatic.timer

disable-laptop-sleep:
	echo HandleLidSwitch=lock >> /etc/systemd/logind.conf
	echo HandlePowerKey=ignore >> /etc/systemd/logind.conf