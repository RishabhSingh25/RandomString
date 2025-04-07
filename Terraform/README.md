# IAC 

This folder has 3 files
1.  main.tf : Provider and IAC for EC2 instance
2.  userdata.sh : Bash script that runs at server initialisation to install aws, Docker and start the App container at port 8081
3.  Outputs.tf : Generate Public Endpoint

# Running the IAC

## Install terraform 
Download the binary from official repo and move it to /usr/local/bin or any other $PATH of your system.

## Clone the repo

```bash
  git clone https://github.com/RishabhSingh25/RandomString.git
```

## Cd to terafform directory 
```bash
  cd Terraform
```

## Initialise the root Module 
```bash
  terraform init
```

## Plan the resources to be created 
```bash
  terraform plan
```
## Apply the resources for creation 
```bash
  terraform apply -auto-approve
```
After successful creation of resources. Terraform will provide the public IP. Wait for few seconds for userdata script. Then the docker content will be available at public IP.

# For debugging 

Uncomment the SSH method in the main.tf

