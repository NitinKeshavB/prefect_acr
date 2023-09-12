from prefect_sqlalchemy import SqlAlchemyConnector
import asyncio
from prefect import flow, task
import time


""" @flow
def db_job_submit(db_credentials_block_name: str, sql_query):
    sqlalchemy_connector = SqlAlchemyConnector.load("db_credentials_block_name")
    async with sqlalchemy_connector.get_connection(begin=False) as connection:
       _run_result= asyncio.run(connection.execute(sql_query))

    return _run_result """

""" @flow
async def db_job_submit(db_credentials_block_name: str, sql_query):
    async with SqlAlchemyConnector.load(db_credentials_block_name) as database:
        _run_result = await database.fetch_one(sql_query)
        #await database.reset_async_connections() """

@task
async def job_submit(_db_credentials_block_name: str, _sql_query):
   async with await SqlAlchemyConnector.load(_db_credentials_block_name) as database:
            if _sql_query.upper().startswith('INSERT') or _sql_query.upper().startswith('UPDATE'):
                _run_result= await database.execute(_sql_query)
            else:
                 _run_result= await database.fetch_one(_sql_query)                
                 
            await database.reset_async_connections()
    
   return(_run_result)

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
async def db_job_submit(exec_name, db_credentials_block_name: str, sql_query):
    #exec databricks job
    #time.sleep(30)
    exec_result = await job_submit.submit(db_credentials_block_name, sql_query )
    res= str(await exec_result.result(raise_on_failure=False)).replace("'","")
    state_info= await exec_result.get_state()
    
    if str(state_info).lower() == "completed()":
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status('{exec_name}','{str(res)}')")
    else:
        print(f"\n ----------------> FAILURE is {str(await exec_result.result(raise_on_failure=False))}")
        _ret_status = await metadb_fetchone_job_submit.submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.err_flow_run_status('{exec_name}','{str(res)}');")
        raise Exception ('Error in Sql!')
 

#asyncio.run(db_job_submit('gpa_landing_entity_2','async-metadata-db-pgsql','select public.get_common_()'))