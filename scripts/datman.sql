insert into prefect.flow (flow_nm  ,flow_type  ,proj_cd  ,Proj_cd_desc  ,layer  ,is_active  ,cron_schedule  ,retry  ,email_notif  ,slack_notif  ,created_tsmp  ,updated_tsmp )
values ('datman_landing_entity_1','databricks-job-submit','datman','landing job for first entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('datman_landing_entity_2','db-job-submit','datman','landing job for second entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('datman_landing_entity_3','databricks-job-submit','datman','landing job for third entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('datman_landing_entity_4','db-job-submit','datman','landing job for fourth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('datman_landing_entity_5','databricks-job-submit','datman','landing job for fifth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('datman_landing_entity_6','databricks-job-submit','datman','landing job for sixth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('datman_landing_entity_7','db-job-submit','datman','landing job for seventh entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),

insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (13, 'deployment','datman_landing_entity_1','flow workpool', current_timestamp, current_timestamp),
	   (13, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (13, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (13, 'parameters:job_id','157107892089699','flow parameters', current_timestamp, current_timestamp),
	   (13, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (13, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (13, 'keyvault','datman_landing_entity_1','flow az keyvault', current_timestamp, current_timestamp);


insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (14, 'deployment','datman_landing_entity_2','flow workpool', current_timestamp, current_timestamp),
	   (14, 'entrypoint','flows/async_postgres_sql_exec.py:db_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (14, 'parameters:db_credentials_block_name','async-metadata-db-pgsql','flow parameters', current_timestamp, current_timestamp),
	   (14, 'parameters:sql_query','select public.get_common_actor_name()','flow parameters', current_timestamp, current_timestamp),
	   (14, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (14, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (14, 'keyvault','datman_landing_entity_2','flow az keyvault', current_timestamp, current_timestamp);
	   



insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (15, 'deployment','datman_landing_entity_3','flow workpool', current_timestamp, current_timestamp),
	   (15, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (15, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (15, 'parameters:job_id','324922768946285','flow parameters', current_timestamp, current_timestamp),
	   (15, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (15, 'tags:2','depends_on:db-job-submit/datman_landing_entity_2','flow tags', current_timestamp, current_timestamp),
	   (15, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (15, 'keyvault','datman_landing_entity_3','flow az keyvault', current_timestamp, current_timestamp);
	   


insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (16, 'deployment','datman_landing_entity_4','flow workpool', current_timestamp, current_timestamp),
	   (16, 'entrypoint','flows/async_postgres_sql_exec.py:db_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (16, 'parameters:db_credentials_block_name','async-metadata-db-pgsql','flow parameters', current_timestamp, current_timestamp),
	   (16, 'parameters:sql_query','select public.get_film_count()','flow parameters', current_timestamp, current_timestamp),
	   (16, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (16, 'tags:2','depends_on:db-job-submit/datman_landing_entity_2','flow tags', current_timestamp, current_timestamp),
	   (16, 'tags:3','depends_on:databricks-job-submit/datman_landing_entity_1','flow tags', current_timestamp, current_timestamp),
	   (16, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (16, 'keyvault','datman_landing_entity_4','flow az keyvault', current_timestamp, current_timestamp);

   
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (17, 'deployment','datman_landing_entity_5','flow workpool', current_timestamp, current_timestamp),
	   (17, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (17, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (17, 'parameters:job_id','94525445717850','flow parameters', current_timestamp, current_timestamp),
	   (17, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (17, 'tags:2','depends_on:databricks-job-submit/datman_landing_entity_1','flow tags', current_timestamp, current_timestamp),
	   (17, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (17, 'keyvault','datman_landing_entity_5','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (18, 'deployment','datman_landing_entity_6','flow workpool', current_timestamp, current_timestamp),
	   (18, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (18, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (18, 'parameters:job_id','157107892089699','flow parameters', current_timestamp, current_timestamp),
	   (18, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (18, 'tags:2','depends_on:databricks-job-submit/datman_landing_entity_5','flow tags', current_timestamp, current_timestamp),
	   (18, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (18, 'keyvault','datman_landing_entity_6','flow az keyvault', current_timestamp, current_timestamp);


insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (19, 'deployment','datman_landing_entity_7','flow workpool', current_timestamp, current_timestamp),
	   (19, 'entrypoint','flows/async_postgres_sql_exec.py:db_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (19, 'parameters:db_credentials_block_name','async-metadata-db-pgsql','flow parameters', current_timestamp, current_timestamp),
	   (19, 'parameters:sql_query','select public.get_common_actor_name()','flow parameters', current_timestamp, current_timestamp),
	   (19, 'tags:1','group:datman','flow tags', current_timestamp, current_timestamp),
	   (19, 'tags:2','depends_on:db-job-submit/datman_landing_entity_4','flow tags', current_timestamp, current_timestamp),
	   (19, 'tags:3','depends_on:databricks-job-submit/datman_landing_entity_3','flow tags', current_timestamp, current_timestamp),
	   (19, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (19, 'keyvault','datman_landing_entity_7','flow az keyvault', current_timestamp, current_timestamp);
	   