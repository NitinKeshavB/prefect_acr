from prefect import get_client
from prefect.client.schemas.filters import DeploymentFilter, DeploymentFilterName, FlowRunFilter, FlowRunFilterState, FlowRunFilterStateType
import asyncio
 
async def get_client_response() -> asyncio.coroutine:
    async with get_client() as client:
        response = await client.read_flow_runs(
            deployment_filter=DeploymentFilter(name=DeploymentFilterName
            (like_="default")),
            flow_run_filter=FlowRunFilter(
                state=FlowRunFilterState(
                    type=FlowRunFilterStateType(
                        any_=["FAILED", "COMPLETED"])),
        )
    )
    print(response)
    print(len(response))
 
asyncio.run(get_client_response())