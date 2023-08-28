from prefect_sqlalchemy import SqlAlchemyConnector, ConnectionComponents, SyncDriver

connector = SqlAlchemyConnector(
    connection_info=ConnectionComponents(
        driver=SyncDriver.POSTGRESQL_PSYCOPG2,
        username="jllsbxprefect",
        password="!llsbxprefect2023",
        host="jllsbxprefect.postgres.database.azure.com",
        port=5432,
        database="postgres",
    )
)

connector.save("metadata-db-pgsql",overwrite=True)