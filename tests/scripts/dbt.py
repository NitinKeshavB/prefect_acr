import asyncio
from prefect import flow,task
from prefect_databricks import DatabricksCredentials
from prefect_databricks.flows import (
    jobs_runs_submit_by_id_and_wait_for_completion,
)
from prefect.server.schemas.filters import DeploymentFilterTags, DeploymentFilter
from prefect_sqlalchemy import SqlAlchemyConnector, ConnectionComponents, AsyncDriver

@task
async def metadb_fetchone_job_submit(db_credentials_block_name: str, sql_query):
   async with await SqlAlchemyConnector.load(db_credentials_block_name) as database:
            if sql_query.upper().startswith('INSERT') or sql_query.upper().startswith('UPDATE'):
                _run_result= await database.execute(sql_query)
            else:
                 _run_result= await database.fetch_one(sql_query)                
                 
            await database.reset_async_connections()    
   return _run_result

@flow
async def databricks_job_submit(exec_name, databricks_credentials_block_name: str, job_id):

    #Load creds
    databricks_credentials = await DatabricksCredentials.load(name=databricks_credentials_block_name)
    
    #exec databricks job
    try:
        exec_result= await jobs_runs_submit_by_id_and_wait_for_completion(databricks_credentials=databricks_credentials, job_id=job_id )
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status('{exec_name}','successfully completed')")

    except Exception as _err:
         print(f"err:  {_err}")
         res= str(_err)[0:2000]
         _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.err_flow_run_status('{exec_name}','{res}');")

    """
    if str(state_info).lower() == "completed()":
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status('{exec_name}','success!')")
    else:
        print(f"\n ----------------> FAILURE is {str(await exec_result.result(raise_on_failure=False))}")
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.err_flow_run_status('{exec_name}','failed');")
        raise Exception ('Error in Databricks Execution!')
    """


asyncio.run(databricks_job_submit('gpa_landing_entity_1',databricks_credentials_block_name="qa-databricks-repo", job_id="157107892089699"))