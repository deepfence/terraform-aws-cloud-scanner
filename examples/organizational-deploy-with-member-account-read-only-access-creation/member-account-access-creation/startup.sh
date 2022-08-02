# this bash script will download the required jinja template files from Deepfence repository, 
# delete any non required files/dir for user, install dependencies to run jinja2 template, 
# run jinja template to create terraform files,
# run the terraform files to create the required access in member accounts
#!/bin/bash
git clone https://github.com/deepfence/terraform-aws-cloud-scanner.git
cd terraform-aws-cloud-scanner/examples/organizational-deploy-with-member-account-read-only-access-creation/member-account-access-creation/
mv * ../../../../
cd ../../../../
rm -rf terraform-aws-cloud-scanner
echo "" >> dodo.py
cat account_details.txt >> dodo.py
pip install -r requirements.txt
doit
rm -rf __pycache__ readonlyaccess.tf.j2 dodo.py requirements.txt taskaccess.tf.j2 
terraform init 
terraform plan --out tfplan.binary
terraform apply tfplan.binary
echo "yes"