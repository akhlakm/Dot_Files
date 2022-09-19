EMAIL = me@akhlakm.com
DOT = ~/Dot_Files

all:
	@sed -rn 's/^([a-zA-Z_-]+):$$/"\1"/p' < $(MAKEFILE_LIST) | xargs printf "make %-20s\n"

update:
	cd $(DOT)/ && git pull
	@echo "Please reload bashrc."

setup-git:
	git config --global user.name ${USER}
	git config --global user.email ${EMAIL}

ssh-key:
	@if [ ! -f ~/.ssh/id_ed25519 ]; then\
		ssh-keygen -t ed25519 -C "${EMAIL}";\
		chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys\
	fi
	@echo "Please copy and paste on the remote servers: make ssh-add-pubkey"
	cat ~/.ssh/id_ed25519.pub

ssh-add-pubkey:
	@$(eval key = $(shell bash -c 'read -p "Please run 'make ssh-key' on your client and copy and paste the key line: " temp; echo $$temp'))
	@if [ "$(key)" = "" ]; then exit 1; fi
	@mkdir -p ~/.ssh && echo "$(key)" >> ~/.ssh/authorized_keys
	@cat ~/.ssh/authorized_keys && echo OK
	@chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
	@exit 0

ssh-upload:
	$(eval server = $(shell bash -c 'read -p "Remote Server IP: " temp; echo $$temp'))
	$(eval username = $(shell bash -c 'read -p "User: " temp; echo $$temp'))
	if [ ! -f ~/.ssh/id_ed25519 ]; then make ssh-key; fi
	cat ~/.ssh/id_ed25519.pub | ssh $(username)@$(server) "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

ssh-disablepassword:
	sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
	sudo sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
	sudo sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
	@sudo systemctl restart ssh || sudo systemctl restart sshd

ssh-enablepassword:
	sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	@sudo systemctl restart ssh || sudo systemctl restart sshd

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

ansible:
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python3 get-pip.py --user || python get-pip.py --user
	python3 -m pip install --user ansible || python -m pip install --user ansible
	echo "export PATH=\$${PATH}:${HOME}/.local/bin" >> ~/.bash_aliases
	echo "export ANSIBLE_CONFIG=$(DOT)/ansible/ansible.cfg" >> ~/.bash_aliases
	sudo adduser ansible
	sudo usermod -aG sudo ansible || sudo usermod -aG wheel ansible
	sudo usermod -aG ansible ${USER}
	@echo "OK. Please source your bash_aliases."

ansible-test:
	ansible all -m ping

network-static-centos:
	@read -p "Please update the following file with the device name. Press Enter ..." temp
	@editor $(DOT)/network/rhel.conf
	$(eval interface = $(shell bash -c 'read -p "Device Name [ex. enp0s1]: " temp; echo $$temp'))
	@if [ "$(interface)" = "" ]; then exit 1; fi
	@sudo cp $(DOT)/network/rhel.conf /etc/sysconfig/network-scripts/ifcfg-$(interface)
	@echo OK. Please reboot for the changes to take effect.

network-static-debian:
	@ip addr
	@read -p "Please update the following file with the device name. Press Enter ..." temp
	@editor $(DOT)/network/debian.conf
	@sudo cp $(DOT)/network/debian.conf /etc/systemd/network/static.network
	@sudo systemctl restart systemd-networkd.service
	@echo OK.
