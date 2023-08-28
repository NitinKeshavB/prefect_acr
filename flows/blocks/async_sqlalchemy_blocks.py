from prefect_sqlalchemy import SqlAlchemyConnector, ConnectionComponents, AsyncDriver

connector = SqlAlchemyConnector(
    connection_info=ConnectionComponents(
        driver=AsyncDriver.POSTGRESQL_ASYNCPG,
        username="jllsbxprefect",
        password="!llsbxprefect2023",
        host="jllsbxprefect.postgres.database.azure.com",
        port=5432,
        database="postgres",
    )
)

connector.save("async-metadata-db-pgsql",overwrite=True)