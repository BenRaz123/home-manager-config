ARGS ?= "-h"
UNAME ?= "test"

test:
	sudo docker run --rm -it -v "$(PWD):/hm_conf/" ubuntu  \
		bash -c 'apt update &>/dev/null; apt install -y sudo xz-utils curl &>/dev/null; useradd -m $(UNAME); echo "$(UNAME) ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; mkdir -p /home/$(UNAME)/.config/; ln -s /hm_conf/ /home/$(UNAME)/.config/home-manager; chown -R $(UNAME) /home/$(UNAME); su $(UNAME) -c "bash /hm_conf/setup.sh $(ARGS)"; su $(UNAME) -c bash'
