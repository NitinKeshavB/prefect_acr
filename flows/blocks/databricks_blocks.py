from prefect_databricks import DatabricksCredentials

DATABRICKS = {
    "qa-databricks-repo": ("adb-5068639147243604.4.azuredatabricks.net", "dapi2a9a52acf21a13290c63563ffbc9ea75"),
}

for name, data in DATABRICKS.items():
    id_, token = data
    credentials = DatabricksCredentials(
        databricks_instance=id_,
        token=token
    )
    credentials.save(name, overwrite=True)
