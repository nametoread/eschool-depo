magic: deploy provision

deploy:
	cd terraform; \
	terraform fmt -recursive; \
	terraform init; \
	terraform apply; \
	cd ..

wipe:
	cd terraform; \
	terraform destroy; \
	cd ..

bully:
	cd terraform; \
	rm -rf .terraform; \
	rm terraform.tfstat* .terraform.lock.hcl; \
	cd ..

provision:
	cd ansible; \
	ansible-playbook -i .inventory main.yml; \
	cd ..

setup:
	cd ansible; \
	ansible-playbook -i .inventory playbooks/1-server.yml; \
	cd ..

configure:
	cd ansible; \
	ansible-playbook -i .inventory playbooks/2-env.yml; \
	cd ..

update:
	cd ansible; \
	ansible-playbook -i .inventory playbooks/3-project.yml; \
	cd ..
