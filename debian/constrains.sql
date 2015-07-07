ALTER TABLE ONLY ppl_model
    ADD CONSTRAINT ppl_model_pkey PRIMARY KEY (id);

ALTER TABLE ONLY ppl_model
    ADD CONSTRAINT ppl_model_name_key UNIQUE (name);
    
ALTER TABLE "exec_schedule_after"
ADD FOREIGN KEY ("pipeline_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE "exec_pipeline"
ADD FOREIGN KEY ("pipeline_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "exec_schedule"
ADD FOREIGN KEY ("pipeline_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "ppl_graph"
ADD FOREIGN KEY ("pipeline_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "ppl_open_event"
ADD FOREIGN KEY ("pipeline_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE "ppl_ppl_conflicts"
ADD FOREIGN KEY ("pipeline_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "ppl_ppl_conflicts"
ADD FOREIGN KEY ("pipeline_conflict_id")
    REFERENCES "ppl_model" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;    
    
ALTER TABLE "ppl_model"
ADD FOREIGN KEY ("user_id")
    REFERENCES "usr_user" ("id")
	ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE ONLY usr_extuser
    ADD CONSTRAINT usr_extuser_id_usr_fkey FOREIGN KEY (id_usr) REFERENCES usr_user(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY exec_schedule
    ADD CONSTRAINT exec_schedule_user_actor_id_fkey FOREIGN KEY (user_actor_id) REFERENCES user_actor(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY exec_schedule
    ADD CONSTRAINT exec_schedule_user_id_fkey FOREIGN KEY (user_id) REFERENCES usr_user(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY exec_pipeline
    ADD CONSTRAINT exec_pipeline_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES usr_user(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY exec_pipeline
    ADD CONSTRAINT exec_pipeline_user_actor_id_fkey FOREIGN KEY (user_actor_id) REFERENCES user_actor(id) ON UPDATE CASCADE ON DELETE CASCADE;
    