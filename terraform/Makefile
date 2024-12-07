all: lint

lint:
	terraform init -reconfigure
	terraform idate
	tflint --recursive --format=compact --init
	tflint --recursive --format=compact

apply-root:
	godotenv -f .env.root terraform -chdir=./root init -reconfigure
	godotenv -f .env.root terraform -chdir=./root plan -var-file=root.tfvars
	godotenv -f .env.root terraform -chdir=./root apply -var-file=root.tfvars

apply-infra:
	godotenv -f .env.infra terraform -chdir=./infra init -reconfigure
	godotenv -f .env.infra terraform -chdir=./infra plan -var-file=infra.tfvars
	godotenv -f .env.infra terraform -chdir=./infra apply -var-file=infra.tfvars

apply-backup:
	godotenv -f .env.backup terraform -chdir=./backup init -reconfigure
	godotenv -f .env.backup terraform -chdir=./backup plan -var-file=pfs.tfvars
	godotenv -f .env.backup terraform -chdir=./backup apply -var-file=pfs.tfvars
