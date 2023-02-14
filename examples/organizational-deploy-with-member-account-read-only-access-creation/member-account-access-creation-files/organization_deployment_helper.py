import re
from pathlib import Path

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

    name = input("Enter name (example: deepfence-cloud-scanner): ")
    region = input("AWS Region to deploy Cloud Scanner: ")
    for account in accounts:
        print(account["Id"], account["Name"])

    deployment_member_account = int(input("AWS member account id to deploy Cloud Scanner: "))
    selected_accounts = input("Enter comma separated account ids to monitor. (Enter all - to include all accounts): "
                              ).split(",")
    if not selected_accounts:
        print("No account selected")
        return

    if selected_accounts == ["all"]:
        pass
    else:
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

    management_console_url = input("Enter management console url (example: deepfence.customer.com or 64.1.1.1): ")
    deepfence_key = input("Enter deepfence key: ")

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


if __name__ == '__main__':
    task_render()
