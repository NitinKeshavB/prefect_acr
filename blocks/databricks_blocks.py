from prefect_databricks import DatabricksCredentials

DATABRICKS = {
    "qa-databricks-repo": ("adb-5068639147243604.4.azuredatabricks.net", "dapi8b3929ad60e97a2b1062f0156f3e279c"),
}

for name, data in DATABRICKS.items():
    id_, token = data
    credentials = DatabricksCredentials(
        databricks_instance=id_,
        token=token
    )
    credentials.save(name, overwrite=True)
