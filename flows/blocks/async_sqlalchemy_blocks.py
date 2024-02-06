from prefect_sqlalchemy import SqlAlchemyConnector, ConnectionComponents, AsyncDriver

connector = SqlAlchemyConnector(
    connection_info=ConnectionComponents(
        driver=AsyncDriver.POSTGRESQL_ASYNCPG,
        username="jllsbxprefect",
        password="Airflow123",
        host="jllsbxprefect.postgres.database.azure.com",
        port=5432,
        database="postgres",
    )
)

connector.save("async-metadata-db-pgsql",overwrite=True)
