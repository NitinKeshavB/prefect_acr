import asyncio

from prefect import task, flow

@task
async def print_values(values):
    for value in values:
        await asyncio.sleep(1) # yield
        print("inside tasks")
        print(f"{value}")
        print("ending tasks")
        raise Exception ('Issue in Databricks Exec')
    return True

@flow
async def async_flow():
    future= await print_values.submit("a")
    result = await future.result(raise_on_failure=False)
    s= await future.get_state()
    print(f"values in result {result}")
    for att in dir(future):
        print (att, getattr(future,att))
    
    if str(s).lower() == "completed()":
        print ("task has completed")
    else:
        print (f"task has failed")
        
    

asyncio.run(async_flow())