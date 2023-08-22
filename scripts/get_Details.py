import requests
import json

account_id = "60a02238-cfc1-4e3d-9784-53f5ea65191b"
workspace_id= "20d43868-3e22-440c-9bb2-dc9e1b51126f"
name = "hello"

PREFECT_API_URL="https://api.prefect.cloud/api/accounts/{account_id}/workspaces/{workspace_id}"
PREFECT_API_KEY="pnu_PxirMNgAXP5xsEIXNqEziqQpJikcJ81CyfHe"
data = {
    "sort": "CREATED_DESC",
    "limit": 5,
}


data= {
  "flow_runs": {
        "state": {
            "type": {
              "any_": ["FAILED"]
            }
        }
    }
 }


headers = {"Authorization": f"Bearer {PREFECT_API_KEY}", "x-prefect-api-version": "0.8.4", "Content-Type": "application/json"}
endpoint = f"{PREFECT_API_URL}/flows/filter"


response = requests.post(endpoint, headers=headers, json=data)
print(response.json())


