import asyncio
from typing import Dict, List
import time

import networkx as nx
from prefect import get_client, task, flow
from prefect.deployments import run_deployment
from prefect.logging import get_run_logger
from prefect.server.schemas.filters import DeploymentFilterTags, DeploymentFilter
from prefect_sqlalchemy import SqlAlchemyConnector, ConnectionComponents, AsyncDriver
from prefect.futures import PrefectFuture


async def metadb_fetchone_job_submit(db_credentials_block_name: str, sql_query):
   async with await SqlAlchemyConnector.load(db_credentials_block_name) as database:
            if sql_query.upper().startswith('INSERT') or sql_query.upper().startswith('UPDATE'):
                _run_result= await database.execute(sql_query)
            else:
                 _run_result= await database.fetch_one(sql_query)                
                 
            await database.reset_async_connections()    
   return _run_result

async def metadb_fetchmany_job_submit(db_credentials_block_name: str, sql_query):
    all_rows = []
    async with await SqlAlchemyConnector.load(db_credentials_block_name) as database:
        while True:
            new_rows = await database.fetch_many(sql_query)
            if len(new_rows) == 0:
                await database.reset_async_connections() 
                break
            all_rows.append(new_rows)
    return all_rows


async def _get_deployments_with_dependencies(filter_tags: DeploymentFilterTags) -> Dict[str, List[str]]:
    """
    Get deployments that match the filter and build a dictionary of {deployment -> list of upstream deployments}
    """
    result = dict()

    async with get_client() as client:
        deployments = await client.read_deployments(
            deployment_filter=DeploymentFilter(
                tags=filter_tags
            )
        )

        for deployment in deployments:
            dependencies = []
            for tag in deployment.tags:
                if not tag.startswith("depends_on:"):
                    continue

                parts = tag.split(":", 2)
                dependencies.append(parts[1])

            deployment_flow = await client.read_flow(deployment.flow_id)
            result[f"{deployment_flow.name}/{deployment.name}"] = dependencies

    return result


async def _construct_nx_graph(deployments: Dict[str, List[str]]) -> nx.DiGraph:
    """
    Constructs a DAG from our dictionary of {deployment -> list of upstream deployments}
    """
    nodes = []
    edges = []

    for node, upstreams in deployments.items():
        nodes.append(node)
        for upstream in upstreams:
            edge = (upstream, node)
            edges.append(edge)

    graph = nx.DiGraph()
    graph.add_nodes_from(nodes)
    graph.add_edges_from(edges)
    return graph


async def run_orchestrator_flow(filter_tags: DeploymentFilterTags) -> None:
    """
    Runs an orchestrator flow by constructing a graph of deployments to execute, where :filter_tags specifies which
    deployments to build the graph from, and using the 'depends_on' tag to specify dependencies between deployments.
    Deployment flows are then executed in topological order, based on these dependencies.
    """
    run_details={}
    prj_nm = str(filter_tags).split('group:')[-1].split("'")[0]
    print(f"Starting Project run ---> {prj_nm}")

    _ret_status = await metadb_fetchone_job_submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.gen_flow_run_id('{prj_nm}')")

    if 'RUN_ID' in str(_ret_status):
        run_details['run_id']=str(_ret_status).split('RUN_ID')[-1].split('"')[0].replace(':','')
        run_details['run_status']=str(_ret_status).split('RUN_ID')[0].split('"')[-1].replace(':','')
    else:
        raise Exception (f"Issue in generating run_id: {str(_ret_status)}")
    
    print(f"run details : {run_details}")
    _ret_status = await metadb_fetchmany_job_submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select F.flow_type||'/'||F.flow_nm as deployment_nm, (coalesce (FR.FLOW_STATUS, 'PENDING')) AS flow_status from (SELECT * FROM prefect.flow WHERE proj_cd = '{prj_nm}' and is_active = 'Y') F left join (select * from prefect.flow_run_status where RUN_ID = {run_details['run_id']} AND proj_cd = '{prj_nm}') FR  on fr.flow_id = f.flow_id  ;")
        
    #print(_ret_status)
    job_statuses={}
    for k,v in enumerate(_ret_status):
        for key, val in enumerate(v):
            job_statuses[val[0]]=val[1]

    print(job_statuses)
    
    deployments = await _get_deployments_with_dependencies(filter_tags)

    if len(deployments) == 0:
        get_run_logger().warning("No deployments found for given filter")
        return
    
    graph = await _construct_nx_graph(deployments)
    futures = dict()
    future_check_l=[]
    for deployment_name in nx.topological_sort(graph):
        
        if run_details['run_status'].upper() == 'FAILED': ## ignores completed ones 
            if job_statuses.get(deployment_name, 'NA') != 'COMPLETED':
                upstream_deployment_names = list(graph.predecessors(deployment_name))
                for k_u,v_u in enumerate(list(graph.predecessors(deployment_name))):
                    if job_statuses.get((str(v_u).strip()),'NA') == 'COMPLETED':
                        upstream_deployment_names.remove(str(v_u).strip())

                upstream_deployment_futures = [futures[t] for t in upstream_deployment_names  if t.replace(" ","") ]
                print(f"CHECKS COMPLETED: Submitting task {deployment_name} that waits for {upstream_deployment_futures}")
                print(f"inserting status in metadata table")
                flow_nm = str(deployment_name).split("/")[-1]
                _ret_status = await metadb_fetchone_job_submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select DISTINCT prefect.ins_flow_run_status({run_details['run_id']},'{flow_nm}','{prj_nm}')")


                #submits tasks for execution
                @task(name=deployment_name)
                async def worker_task(name: str):
                    get_run_logger().info(f"Running deployment {name}")
                    await run_deployment(name)

                futures[deployment_name] = await worker_task.submit(
                    name=deployment_name,
                    wait_for=upstream_deployment_futures,
                    ) 
                future_check_l.append(deployment_name)
                #print(f"updating metadata for {futures[deployment_name]}")
                #_ret_status = await metadb_fetchone_job_submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.upd_flow_run_status({run_details['run_id']},'{flow_nm}')")

            else:
                upstream_deployment_names = list(graph.predecessors(deployment_name))
                print(f"SKIPPING COMPLETED task {deployment_name} that waits for {upstream_deployment_names}")
                
            

        else: ## NEW RUN
            upstream_deployment_names = list(graph.predecessors(deployment_name))       
            upstream_deployment_futures = [futures[t] for t in upstream_deployment_names  if t.replace(" ","") ]
            print(f"CHECKS COMPLETED: Submitting task {deployment_name} that waits for {upstream_deployment_futures}")
            print(f"inserting status in metadata table")
            flow_nm = str(deployment_name).split("/")[-1]
            _ret_status = await metadb_fetchone_job_submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.ins_flow_run_status({run_details['run_id']},'{flow_nm}','{prj_nm}')")

            #submits tasks for execution
            @task(name=deployment_name)
            async def worker_task(name: str):
                get_run_logger().info(f"Running deployment {name}")
                await run_deployment(name)

            futures[deployment_name] = await worker_task.submit(
                name=deployment_name,
                wait_for=upstream_deployment_futures,
                                ) 
            future_check_l.append(deployment_name)
            #print(f"updating metadata for {futures[deployment_name]}")
            #print(f"type metadata for {type(futures[deployment_name])}")
    
    #tasks completion status
    final_state=None
    for future_k, future_v  in enumerate(reversed(future_check_l)):
        state = await futures[future_v].get_state()
        final_state=future_v
        print(f"state is {state} for {futures[future_v]}")
        while str(state).lower() == 'pending()' or str(state).lower() == 'running()':
            time.sleep(15)
            print("-------> Waiting for TASK Completion <-------------")
            print(f"Task state waiting for {futures[future_v]}")
            print("-------> getting there!! hold tight <-------------")
            state = await futures[future_v].get_state()
            if str(state).lower() != 'pending()' and str(state).lower() != 'running()' :
                break
    
    print("-------> All TASKS have been Completed <-------------")
    return futures[final_state]



@flow(name="orchestration-gpa-flow")
async def example_flow():

    await run_orchestrator_flow(DeploymentFilterTags(all_=["group:gpa"]))
    
    run_details={}
    prj_nm = 'gpa'
    time.sleep(15) ## allowing all commits 
    _ret_status = await metadb_fetchone_job_submit(db_credentials_block_name = "async-metadata-db-pgsql", sql_query = f"select prefect.gen_flow_run_id('{prj_nm}')")

    if 'RUN_ID' in str(_ret_status):
        run_details['run_id']=str(_ret_status).split('RUN_ID')[-1].split('"')[0].replace(':','')
        run_details['run_status']=str(_ret_status).split('RUN_ID')[0].split('"')[-1].replace(':','')
    else:
        raise Exception (f"Issue in generating run_id: {str(_ret_status)}")
    
    if run_details['run_status'].lower() == 'failed':
        raise Exception (f"Failures Exist in flows. Please restart after fixing!!")


if __name__ == "__main__":
    asyncio.run(example_flow())

    