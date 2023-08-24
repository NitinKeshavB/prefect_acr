CREATE TABLE prefect.flow (
	flow_id SERIAL PRIMARY KEY,
	flow_nm varchar(255) NULL,
	proj_cd varchar(100) NULL,
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
	flow_run_id int8 NULL,
	flow_id int8 NULL,
	flow_nm varchar(255) NULL,
	last_extr_run_tsmp timestamp NULL,
	flow_status varchar(100) NULL,
	flow_start_tsmp timestamp NULL,
	flow_end_tsmp timestamp NULL,
	flow_log varchar(2000) NULL
);

