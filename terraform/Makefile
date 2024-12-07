all: lint

lint:
	for dir in $(shell find . -type d -depth 1 | grep -v .terraform); do \
		echo "Linting $$dir"; \
		godotenv -f .env.root terraform -chdir=$$dir init -reconfigure; \
		godotenv -f .env.root terraform -chdir=$$dir validate;\
		tflint --chdir=$$dir --recursive --format=compact --init;\
		tflint --chdir=$$dir --recursive --format=compact;\
	done

apply-root:
	godotenv -f .env.root terraform -chdir=./root init -reconfigure
	godotenv -f .env.root terraform -chdir=./root plan -var-file=root.tfvars
	godotenv -f .env.root terraform -chdir=./root apply -var-file=root.tfvars

apply-infra:
	godotenv -f .env.infra terraform -chdir=./infra init -reconfigure
	godotenv -f .env.infra terraform -chdir=./infra plan -var-file=infra.tfvars
	godotenv -f .env.infra terraform -chdir=./infra apply -var-file=infra.tfvars

apply-backup-pfs:
	godotenv -f .env.backup terraform -chdir=./backup init -reconfigure
	godotenv -f .env.backup terraform -chdir=./backup plan -var-file=pfs.tfvars
	godotenv -f .env.backup terraform -chdir=./backup apply -var-file=pfs.tfvars
