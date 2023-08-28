from prefect_sqlalchemy import SqlAlchemyConnector
import asyncio
from prefect import flow


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

@flow
async def db_job_submit(db_credentials_block_name: str, sql_query):
   async with await SqlAlchemyConnector.load(db_credentials_block_name) as database:
            if sql_query.upper().startswith('INSERT') or sql_query.upper().startswith('UPDATE'):
                _run_result= await database.execute(sql_query)
            else:
                 _run_result= await database.fetch_one(sql_query)                
                 
            await database.reset_async_connections()
    
   print(_run_result)
   

if __name__ == "__main__":
     asyncio.run(db_job_submit())