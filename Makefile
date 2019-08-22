#Makefile

import_image:
	@echo "** Importing the Cisco CSR Vagrant Image **"
	vagrant box add iosxe/16.09.01 serial-csr1000v-universalk9.16.09.01.box


prepenv:
	@echo "*** Creating Virtual Environment ***"
	( \
		python3 -m venv venv; \
		source venv/bin/activate; \
		pip install --upgrade pip; \
		pip install -r requirements.txt; \
)


vagrant:
	@echo "*** Stopping Existing VMs ***"
	vboxmanage list runningvms | sed -E 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate
	@echo "*** Bringing Up the Router ***"
	vagrant up

provision_1001:
	@echo "*** Configuring the Router ***"
	python provision/provision_lab.py -hn DEVWKS-1001

prep_1001:
	@echo "*** Opening the Lab Guide File ***"
	open https://github.com/CiscoDevNet/chrisbog-workshops/blob/clus19/DEVWKS-1001/Guide/DEVWKS_1001_Guided_1.md

start_1001: vagrant provision_1001 prep_1001

cleanup:
	@echo "*** Destroying the Vagrant box ***"
	vagrant destroy -f

