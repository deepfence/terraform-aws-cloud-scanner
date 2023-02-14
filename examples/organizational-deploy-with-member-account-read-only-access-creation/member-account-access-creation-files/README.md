# Member accounts access creation files

This folder contains Jinja templates and doit script files to automate creation of read only role in multiple member accounts. Please follow readme instructions in [this](https://github.com/deepfence/terraform-aws-cloud-scanner/tree/main/examples/organizational-deploy-with-member-account-read-only-access-creation) link on how to use the same.

### Generate terraform files from jinja templates
```shell
git clone https://github.com/deepfence/terraform-aws-cloud-scanner.git
cd terraform-aws-cloud-scanner/examples/organizational-deploy-with-member-account-read-only-access-creation/member-account-access-creation-files/
pip3 install -r requirements.txt
python3 generate_terraform_script.py
```