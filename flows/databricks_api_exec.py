from prefect import flow
from prefect_databricks import DatabricksCredentials
from prefect_databricks.flows import (
    jobs_runs_submit_by_id_and_wait_for_completion,
)


@flow
def databricks_job_submit(databricks_credentials_block_name: str, job_id):
    databricks_credentials = DatabricksCredentials.load(name=databricks_credentials_block_name)

    run = jobs_runs_submit_by_id_and_wait_for_completion(
        databricks_credentials=databricks_credentials, job_id=job_id
    )

    return run



if __name__ == "__main__":
    with tags("kubernetes"):
        databricks_job_submit()
        #databricks_credentials_block_name="qa-databricks-repo", job_id="157107892089699"