import re
from pathlib import Path
from urllib.parse import urlparse
import boto3
from jinja2 import Environment, FileSystemLoader


def parse_account_id(arn):
    regex = r"^.*:(\d+):(root|user)\/.*$"
    acc_id = re.findall(regex, arn)
    if acc_id:
        return acc_id[0][0]
    return None


def list_org_accounts():
    client = boto3.client('organizations')
    root_accounts = []
    next_token = None

    while True:
        if next_token:
            resp = client.list_roots(MaxResults=20, NextToken=next_token)
        else:
            resp = client.list_roots(MaxResults=20)
        if not resp.get("Roots", []):
            break
        root_accounts.extend(resp["Roots"])
        if "NextToken" in resp:
            next_token = resp["NextToken"]
        else:
            break
    root_account_ids = []
    for root_account in root_accounts:
        acc_id = parse_account_id(root_account["Arn"])
        if acc_id:
            root_account_ids.append(acc_id)

    accounts = []
    next_token = None
    while True:
        if next_token:
            resp = client.list_accounts(MaxResults=20, NextToken=next_token)
        else:
            resp = client.list_accounts(MaxResults=20)
        if not resp.get("Accounts", []):
            break
        for acc in resp["Accounts"]:
            if acc["Id"] not in root_account_ids:
                accounts.append(acc)
        if "NextToken" in resp:
            next_token = resp["NextToken"]
        else:
            break
    return accounts


def task_render():
    account_details = []
    accounts = list_org_accounts()
    if not accounts:
        print("Could not fetch AWS accounts. Please run \"aws configure\"")
        return

    name = input("Enter name of deployment (example: deepfence-cloud-scanner): ")
    if not name:
        print("name should not be empty")
        return
    region = input("AWS Region to deploy Cloud Scanner: ")
    if not region:
        print("region should not be empty")
        return
    print("\nList of account ids and corresponding names:")
    for account in accounts:
        print(account["Id"], account["Name"])

    deployment_member_account = input(
        "Choose one AWS member account to deploy Cloud Scanner ECS Task (IAM roles will be created in remaining accounts): ")
    if not deployment_member_account:
        print("account id should not be empty")
        return
    selected_accounts = input(
        "Enter comma separated account ids to create IAM roles and run scans for those accounts. (Enter all - to create in all accounts): "
        ).split(",")
    if not selected_accounts:
        print("no account selected")
        return

    selected_accounts = [str(i).strip() for i in selected_accounts]

    if selected_accounts == ["all"]:
        selected_accounts = [i["Id"] for i in accounts]
    else:
        if deployment_member_account in selected_accounts:
            selected_accounts.remove(deployment_member_account)
        accounts = [i for i in accounts if i["Id"] in selected_accounts]

    for account in accounts:
        account_details.append({
            'alias': account["Name"].lower().replace(" ", "-"),
            'region': region,
            'member_account_id': account["Id"],
            'ccs_mem_account_id': deployment_member_account
        })

    cwd = Path(".")
    environment = Environment(loader=FileSystemLoader(cwd))

    iam_template_path = Path("readonlyaccess.tf.j2")
    iam_template = environment.get_template(str(iam_template_path))
    with open(f"{iam_template_path.stem}", "w") as output_file:
        output_file.write(iam_template.render(data=account_details))

    management_console_url = input("Enter management console url (example: deepfence.customer.com or 54.54.54.54): ")
    if not management_console_url:
        print("invalid management console url")
        return
    if "http://" in management_console_url or "https://" in management_console_url:
        management_console_url = urlparse(management_console_url).netloc
    deepfence_key = input("Enter deepfence key: ")
    if not deepfence_key:
        print("deepfence key should not be empty")
        return

    main_template_path = Path("main.tf.j2")
    main_template = environment.get_template(str(main_template_path))
    with open(f"{main_template_path.stem}", "w") as output_file:
        output_file.write(main_template.render(data={
            "name": name,
            "region": region,
            "deployment_member_account": deployment_member_account,
            "management_console_url": management_console_url,
            "deepfence_key": deepfence_key,
            "selected_member_accounts": ",".join(selected_accounts)
        }))
    print("Terraform scripts generated successfully (main.tf and readonlyaccess.tf)")
    print("Now run \"terraform init && terraform apply\" to connect the AWS accounts to Deepfence Management Console")


if __name__ == '__main__':
    task_render()
