import json
import requests
from pprint import pprint
 
api_key = "pnu_PxirMNgAXP5xsEIXNqEziqQpJikcJ81CyfHe"
account_id = "60a02238-cfc1-4e3d-9784-53f5ea65191b"
workspace_id = "20d43868-3e22-440c-9bb2-dc9e1b51126f"
 
headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {api_key}'
}
 
url = f"https://api.prefect.cloud/api/accounts/{account_id}/workspaces/{workspace_id}"
 
 
def get_read_deployment(url, headers, id):
    url = url + f"/deployments/{id}"
    r = requests.request("GET", url, headers=headers)
    print(r.status_code)
    pretty_json = json.loads(r.text)
    print (json.dumps(pretty_json, indent=2))
 
 
def post_read_deployments(url, headers, deployment_id):
    url = url + "/deployments/filter"
 
    payload = json.dumps({
    "deployments": {
        "operator": "and_",
        "id": {
        "any_": deployment_id
        }
    }
    })
 
    response = requests.request("POST", url, headers=headers, data=payload)
    print(response.status_code)
    pretty_json = json.loads(response.text)
    print (json.dumps(pretty_json, indent=2))
 
def get_all_deployments(url, headers):
    url = url + "/deployments/filter"
 
    offset = 0
    count = 10
    deployments = []
 
    while True:
        payload = json.dumps({
        "offset": offset,
        "count": count
        })
 
        response = requests.request("POST", url, headers=headers, data = payload)
        data = response.json()
        if not data or len(data) <= count:

            break
        deployments.extend(data)
        offset += count
    return data
 
 
def extract_id_and_name(deployments):
    result = []
    for deployment in deployments:
        id_name_dict = {'id': deployment['id'], 'name': deployment['name']}
        if id_name_dict not in result:
            result.append(id_name_dict)
    return result
 
 
def main():
    deployments = get_all_deployments(url, headers)
    print(deployments)
    id_and_name = extract_id_and_name(deployments)
    pprint (id_and_name)
    print (len(id_and_name))
    print ("============================Bulk Read All Deployments====================================================")
    deployment_ids = [""]
    print ("================================GET Deployments by ID====================================================")
    for id in deployment_ids:
        get_read_deployment(url, headers, "e24a3c83-06c8-4984-bef8-cdecf795b9c7")


    #print ("=================================POST READ_DEPLOYMENTS by LIST===========================================")
    #post_read_deployments(url, headers, deployment_ids)
    #print(deployments)
 
 
if __name__ == "__main__":
    main()

