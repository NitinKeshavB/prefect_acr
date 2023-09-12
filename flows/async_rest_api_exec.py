import asyncio
from prefect import flow,task
import requests
import json
from prefect_sqlalchemy import SqlAlchemyConnector


@task
async def metadb_fetchone_job_submit(db_credentials_block_name: str, sql_query):
   async with await SqlAlchemyConnector.load(db_credentials_block_name) as database:
            if sql_query.upper().startswith('INSERT') or sql_query.upper().startswith('UPDATE'):
                _run_result= await database.execute(sql_query)
            else:
                 _run_result= await database.fetch_one(sql_query)                
                 
            await database.reset_async_connections()    
   return _run_result

@task
async def _get_api_job_submit (endpoint, headers, params):

    get_api_out={}
    
    if params:
        
        response = requests.request("GET", endpoint, headers=json.loads(headers), params=json.loads(params))
    else:
        response = requests.request("GET", endpoint, headers=json.loads(headers))

    get_api_out["status_code"] = str(response.status_code)
    get_api_out["response"] = str(response.json())
    if response.status_code != 200:
        raise Exception(f"Failed GET API call: {get_api_out}")
    print(get_api_out)
    return get_api_out

@flow
async def get_api_job_submit (exec_name,endpoint, headers, params):
    exec_result = await _get_api_job_submit.submit(endpoint, headers, params )
    res= str(await exec_result.result(raise_on_failure=False)).replace("'","")[0:2000]
    state_info= await exec_result.get_state()
    
    if str(state_info).lower() == "completed()":
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status('{exec_name}','{str(res)}')")
    else:
        print(f"\n ----------------> FAILURE is {str(await exec_result.result(raise_on_failure=False))}")
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.err_flow_run_status('{exec_name}','{str(res)}');")
        raise Exception ('Error in Get API call!')

###################### Flow 2 #######################################################

@task
async def _post_api_job_submit (endpoint, headers, payload):

    post_api_out={}
    if payload:
        response = requests.request("POST", endpoint, headers=json.loads(headers), data = json.dumps(json.loads(payload)))
    else:
        response = requests.request("POST", endpoint, headers=json.loads(headers))

    post_api_out["status_code"] = str(response.status_code)
    post_api_out["response"] = str(response.json())
    if response.status_code != 200:
        raise Exception(f"Failed POST API call: {post_api_out}")

    print(post_api_out)
    return post_api_out

@flow
async def post_api_job_submit (exec_name,endpoint, headers, payload):
    exec_result = await _post_api_job_submit.submit(endpoint, headers, payload )
    res= str(await exec_result.result(raise_on_failure=False)).replace("'","")[0:2000]
    state_info= await exec_result.get_state()
    
    if str(state_info).lower() == "completed()":
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status('{exec_name}','{str(res)}'::text)")
    else:
        print(f"\n ----------------> FAILURE is {str(await exec_result.result(raise_on_failure=False))}")
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.err_flow_run_status('{exec_name}','{str(res)}'::text);")
        raise Exception ('Error in POST API call!')



###################### Flow 3 #######################################################

@task
async def _patch_api_job_submit (endpoint, headers, payload):

    patch_api_out={}
    if payload:
        response = requests.request("PATCH", endpoint, headers=json.loads(headers), data = json.dumps(json.loads(payload)))
    else:
        raise Exception("Pass payload to update!")

    if response.status_code != 204:
        raise Exception(f"Failed PATCH API call: {patch_api_out}")
    
    patch_api_out["status_code"] = str(response.status_code)
    patch_api_out["response"] = "Patch Update successful!"

    return patch_api_out



@flow
async def patch_api_job_submit (exec_name, endpoint, headers, payload):
    exec_result = await _patch_api_job_submit.submit(endpoint, headers, payload )
    res= str(await exec_result.result(raise_on_failure=False)).replace("'","")[0:2000]
    state_info= await exec_result.get_state()
    
    if str(state_info).lower() == "completed()":
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status('{exec_name}','{str(res)}')")
    else:
        print(f"\n ----------------> FAILURE is {str(await exec_result.result(raise_on_failure=False))}")
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.err_flow_run_status('{exec_name}','{str(res)}');")
        raise Exception ('Error in PATCH API call!')
    

