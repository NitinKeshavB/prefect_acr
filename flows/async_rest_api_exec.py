import asyncio
from prefect import flow
import requests
import json

@flow
async def get_api_job_submit (endpoint, headers, params):

    get_api_out={}
    
    if params:
        
        response = requests.request("GET", endpoint, headers=json.loads(headers), params=json.dumps(json.loads(params)))
    else:
        response = requests.request("GET", endpoint, headers=json.loads(headers))

    get_api_out["status_code"] = str(response.status_code)
    get_api_out["response"] = str(response.json())
    if response.status_code != 200:
        raise Exception(f"Failed rest call: {get_api_out}")
    print(get_api_out)
    return get_api_out


@flow
async def post_api_job_submit (endpoint, headers, payload):

    post_api_out={}
    if payload:
        response = requests.request("POST", endpoint, headers=json.loads(headers), data = json.dumps(json.loads(payload)))
    else:
        response = requests.request("POST", endpoint, headers=json.loads(headers))

    post_api_out["status_code"] = str(response.status_code)
    post_api_out["response"] = str(response.json())
    if response.status_code != 200:
        raise Exception(f"Failed rest call: {post_api_out}")

    print(post_api_out)
    return post_api_out


@flow
async def patch_api_job_submit (endpoint, headers, payload):

    patch_api_out={}
    if payload:
        response = requests.request("PATCH", endpoint, headers=json.loads(headers), data = json.dumps(json.loads(payload)))
    else:
        raise Exception("Pass payload to update!")

    if response.status_code != 204:
        raise Exception(f"Failed rest call: {patch_api_out}")
    
    patch_api_out["status_code"] = str(response.status_code)
    patch_api_out["response"] = "Patch Update successful!"

    return patch_api_out



