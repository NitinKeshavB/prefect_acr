CREATE TABLE prefect.flow (
	flow_id SERIAL PRIMARY KEY,
	flow_nm varchar(255) NOT NULL,
	flow_type varchar(100) NOT NULL,
	proj_cd varchar(100)NOT NULL,
	Proj_cd_desc varchar(255) NULL,
	layer varchar(100) NULL,
	is_active varchar(10) NULL,
	cron_schedule varchar(255) NULL,
	retry int4 null,
	email_notif varchar(255) null,
	slack_notif varchar(255) null,
	created_tsmp timestamp NULL,
	updated_tsmp timestamp NULL,
	UNIQUE(flow_nm)
	
);
create index flow_flow_nm_dx on prefect.flow(flow_nm);



CREATE TABLE prefect.flow_attr (
	flow_id int8 NULL,
	flow_attr_key varchar(100) NULL,
	flow_attr_val varchar(255) NULL,
	flow_attr_desc varchar(255) null,
	created_tsmp timestamp NULL,
	updated_tsmp timestamp NULL,
	
	CONSTRAINT fk_flow
      FOREIGN KEY(flow_id)
	  REFERENCES prefect.flow(flow_id)
	
);



CREATE TABLE prefect.flow_depends (
	proj_cd varchar(100) NULL,
	layer varchar(100) NULL,
	flow_id int8 NULL,
	flow_nm varchar(100) NULL,
	dependent_flow_id int8 NULL,
	dependent_flow_nm varchar(100) NULL,
	created_tsmp timestamp NULL,
	updated_tsmp timestamp NULL,
	
	CONSTRAINT fk_flow_depends
      FOREIGN KEY(flow_id)
	  REFERENCES prefect.flow(flow_id)
);


CREATE TABLE prefect.flow_run_status (
	run_id int8 NULL,
	proj_cd varchar(255) not null, 
	flow_id int8 NULL,
	flow_nm varchar(255) NULL,
	last_extr_run_tsmp timestamp NULL,
	flow_status varchar(100) NULL,
	flow_start_tsmp timestamp NULL,
	flow_end_tsmp timestamp NULL,
	flow_log varchar(2000) NULL
);


---------------------------------------------------------| inserts for flow table | ---------------------------------------------------------

insert into prefect.flow (flow_nm  ,flow_type  ,proj_cd  ,Proj_cd_desc  ,layer  ,is_active  ,cron_schedule  ,retry  ,email_notif  ,slack_notif  ,created_tsmp  ,updated_tsmp )
values ('gpa_landing_entity_1','databricks-job-submit','gpa','landing job for first entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_2','db-job-submit','gpa','landing job for second entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_3','databricks-job-submit','gpa','landing job for third entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_4','db-job-submit','gpa','landing job for fourth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_5','databricks-job-submit','gpa','landing job for fifth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_6','databricks-job-submit','gpa','landing job for sixth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_7','db-job-submit','gpa','landing job for seventh entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_8','get-api-job-submit','gpa','landing job for eight entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_9','post-api-job-submit','gpa','landing job for ninth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_10','databricks-job-submit','gpa','landing job for tenth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_11','get-api-job-submit','gpa','landing job for eleventh entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp),
('gpa_landing_entity_12','get-api-job-submit','gpa','landing job for twelfth entity','landing','Y','0 5 * * *',3,'nitinkeshavb@outlook.com,nitinkeshav11@outlook.com','https://hooks.slack.com/services/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',current_timestamp,current_timestamp);

---------------------------------------------------------| inserts for flow attr table | ---------------------------------------------------------





insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (1, 'deployment','gpa_landing_entity_1','flow workpool', current_timestamp, current_timestamp),
	   (1, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (1, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (1, 'parameters:job_id','157107892089699','flow parameters', current_timestamp, current_timestamp),
	   (1, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (1, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (1, 'keyvault','gpa_landing_entity_1','flow az keyvault', current_timestamp, current_timestamp);


insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (2, 'deployment','gpa_landing_entity_2','flow workpool', current_timestamp, current_timestamp),
	   (2, 'entrypoint','flows/async_postgres_sql_exec.py:db_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (2, 'parameters:db_credentials_block_name','async-metadata-db-pgsql','flow parameters', current_timestamp, current_timestamp),
	   (2, 'parameters:sql_query','select public.get_common_actor_name()','flow parameters', current_timestamp, current_timestamp),
	   (2, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (2, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (2, 'keyvault','gpa_landing_entity_2','flow az keyvault', current_timestamp, current_timestamp);
	   



insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (3, 'deployment','gpa_landing_entity_3','flow workpool', current_timestamp, current_timestamp),
	   (3, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (3, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (3, 'parameters:job_id','324922768946285','flow parameters', current_timestamp, current_timestamp),
	   (3, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (3, 'tags:2','depends_on:databricks-job-submit/gpa_landing_entity_2','flow tags', current_timestamp, current_timestamp),
	   (3, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (3, 'keyvault','gpa_landing_entity_3','flow az keyvault', current_timestamp, current_timestamp);
	   


insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (4, 'deployment','gpa_landing_entity_4','flow workpool', current_timestamp, current_timestamp),
	   (4, 'entrypoint','flows/async_postgres_sql_exec.py:db_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (4, 'parameters:db_credentials_block_name','async-metadata-db-pgsql','flow parameters', current_timestamp, current_timestamp),
	   (4, 'parameters:sql_query','select public.get_film_count()','flow parameters', current_timestamp, current_timestamp),
	   (4, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (4, 'tags:2','depends_on:db-job-submit/gpa_landing_entity_2','flow tags', current_timestamp, current_timestamp),
	   (4, 'tags:3','depends_on:databricks-job-submit/gpa_landing_entity_1','flow tags', current_timestamp, current_timestamp),
	   (4, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (4, 'keyvault','gpa_landing_entity_4','flow az keyvault', current_timestamp, current_timestamp);

   
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (5, 'deployment','gpa_landing_entity_5','flow workpool', current_timestamp, current_timestamp),
	   (5, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (5, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (5, 'parameters:job_id','94525445717850','flow parameters', current_timestamp, current_timestamp),
	   (5, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (5, 'tags:2','depends_on:databricks-job-submit/gpa_landing_entity_1','flow tags', current_timestamp, current_timestamp),
	   (5, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (5, 'keyvault','gpa_landing_entity_5','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (6, 'deployment','gpa_landing_entity_6','flow workpool', current_timestamp, current_timestamp),
	   (6, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (6, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (6, 'parameters:job_id','157107892089699','flow parameters', current_timestamp, current_timestamp),
	   (6, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (6, 'tags:2','depends_on:databricks-job-submit/gpa_landing_entity_5','flow tags', current_timestamp, current_timestamp),
	   (6, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (6, 'keyvault','gpa_landing_entity_6','flow az keyvault', current_timestamp, current_timestamp);


insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (7, 'deployment','gpa_landing_entity_7','flow workpool', current_timestamp, current_timestamp),
	   (7, 'entrypoint','flows/async_postgres_sql_exec.py:db_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (7, 'parameters:db_credentials_block_name','async-metadata-db-pgsql','flow parameters', current_timestamp, current_timestamp),
	   (7, 'parameters:sql_query','select public.get_common_actor_name()','flow parameters', current_timestamp, current_timestamp),
	   (7, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (7, 'tags:2','depends_on:db-job-submit/gpa_landing_entity_4','flow tags', current_timestamp, current_timestamp),
	   (7, 'tags:3','depends_on:databricks-job-submit/gpa_landing_entity_3','flow tags', current_timestamp, current_timestamp),
	   (7, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (7, 'keyvault','gpa_landing_entity_7','flow az keyvault', current_timestamp, current_timestamp);
	   

insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (8, 'deployment','gpa_landing_entity_8','flow workpool', current_timestamp, current_timestamp),
	   (8, 'entrypoint','flows/async_rest_api_exec.py:get_api_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (8, 'parameters:endpoint','https://api.prefect.cloud/api/accounts/60a02238-cfc1-4e3d-9784-53f5ea65191b/workspaces/20d43868-3e22-440c-9bb2-dc9e1b51126f/health','flow parameters', current_timestamp, current_timestamp),
	   (8, 'parameters:headers','{"Authorization": "Bearer pnu_PxirMNgAXP5xsEIXNqEziqQpJikcJ81CyfHe", "Content-Type": "application/json"}','flow parameters', current_timestamp, current_timestamp),
	   (8, 'parameters:params','','flow parameters', current_timestamp, current_timestamp),
	   (8, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (8, 'tags:2','depends_on:databricks-job-submit/gpa_landing_entity_3','flow tags', current_timestamp, current_timestamp),
	   (8, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (8, 'keyvault','gpa_landing_entity_8','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (9, 'deployment','gpa_landing_entity_9','flow workpool', current_timestamp, current_timestamp),
	   (9, 'entrypoint','flows/async_rest_api_exec.py:post_api_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (9, 'parameters:endpoint','https://api.prefect.cloud/api/accounts/60a02238-cfc1-4e3d-9784-53f5ea65191b/workspaces/20d43868-3e22-440c-9bb2-dc9e1b51126f/deployments/filter','flow parameters', current_timestamp, current_timestamp),
	   (9, 'parameters:headers','{"Authorization": "Bearer pnu_PxirMNgAXP5xsEIXNqEziqQpJikcJ81CyfHe", "Content-Type": "application/json"}','flow parameters', current_timestamp, current_timestamp),
	   (9, 'parameters:payload','{"sort": "CREATED_DESC","offset": 0}','flow parameters', current_timestamp, current_timestamp),
	   (9, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (9, 'tags:2','depends_on:get-api-job-submit/gpa_landing_entity_8','flow tags', current_timestamp, current_timestamp),
	   (9, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (9, 'keyvault','gpa_landing_entity_9','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (10, 'deployment','gpa_landing_entity_10','flow workpool', current_timestamp, current_timestamp),
	   (10, 'entrypoint','flows/async_databricks_api_exec.py:databricks_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (10, 'parameters:databricks_credentials_block_name','qa-databricks-repo','flow parameters', current_timestamp, current_timestamp),
	   (10, 'parameters:job_id','157107892089699','flow parameters', current_timestamp, current_timestamp),
	   (10, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (10, 'tags:2','depends_on:db-job-submit/gpa_landing_entity_7','flow tags', current_timestamp, current_timestamp),
	   (10, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (10, 'keyvault','gpa_landing_entity_10','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (11, 'deployment','gpa_landing_entity_11','flow workpool', current_timestamp, current_timestamp),
	   (11, 'entrypoint','flows/async_rest_api_exec.py:get_api_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (11, 'parameters:endpoint','https://get-temp-prefect.azurewebsites.net/api/CityTemperature','flow parameters', current_timestamp, current_timestamp),
	   (11, 'parameters:headers','{"Content-Type": "application/json"}','flow parameters', current_timestamp, current_timestamp),
	   (11, 'parameters:params','{"name":"chicago"}','flow parameters', current_timestamp, current_timestamp),
	   (11, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (11, 'tags:2','depends_on:databricks-job-submit/gpa_landing_entity_10','flow tags', current_timestamp, current_timestamp),
	   (11, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (11, 'keyvault','gpa_landing_entity_11','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
insert into prefect.flow_attr (flow_id, flow_attr_key, flow_attr_val, flow_attr_desc, created_tsmp, updated_tsmp )
values (12, 'deployment','gpa_landing_entity_12','flow workpool', current_timestamp, current_timestamp),
	   (12, 'entrypoint','flows/async_rest_api_exec.py:get_api_job_submit','flow entrypoint', current_timestamp, current_timestamp),
	   (12, 'parameters:endpoint','https://get-temp-prefect.azurewebsites.net/api/CityTemperature','flow parameters', current_timestamp, current_timestamp),
	   (12, 'parameters:headers','{"Content-Type": "application/json"}','flow parameters', current_timestamp, current_timestamp),
	   (12, 'parameters:params','{"name":"bengaluru"}','flow parameters', current_timestamp, current_timestamp),
	   (12, 'tags:1','group:gpa','flow tags', current_timestamp, current_timestamp),
	   (12, 'tags:2','depends_on:get-api-job-submit/gpa_landing_entity_11','flow tags', current_timestamp, current_timestamp),
	   (12, 'work_pool','*common_work_pool','flow workpool', current_timestamp, current_timestamp),
	   (12, 'keyvault','gpa_landing_entity_12','flow az keyvault', current_timestamp, current_timestamp);
	   
	   
	   
	   
insert into prefect.flow_depends values ('gpa','landing',3,'gpa_landing_entity_3',2,'gpa_landing_entity_2',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',4,'gpa_landing_entity_4',1,'gpa_landing_entity_1',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',4,'gpa_landing_entity_4',2,'gpa_landing_entity_2',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',5,'gpa_landing_entity_5',1,'gpa_landing_entity_1',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',6,'gpa_landing_entity_6',5,'gpa_landing_entity_5',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',7,'gpa_landing_entity_7',4,'gpa_landing_entity_4',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',7,'gpa_landing_entity_7',3,'gpa_landing_entity_3',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',8,'gpa_landing_entity_8',3,'gpa_landing_entity_3',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',9,'gpa_landing_entity_9',8,'gpa_landing_entity_8',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',10,'gpa_landing_entity_10',7,'gpa_landing_entity_7',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',11,'gpa_landing_entity_11',10,'gpa_landing_entity_10',current_timestamp,current_timestamp);
insert into prefect.flow_depends values ('gpa','landing',12,'gpa_landing_entity_12',11,'gpa_landing_entity_11',current_timestamp,current_timestamp);




