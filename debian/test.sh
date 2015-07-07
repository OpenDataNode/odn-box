#!/bin/bash 
dbname=unifiedviews
rm data.sql

getNewUserId() {
  oldUserId=$1
  newUserId=`su - postgres -c  "psql -A -t -d unifiedviews -c \"select id from usr_user where username = ( select organization  from usr_organization where usr =  ( select username from tmp where id = ${oldUserId}));
\""`
   echo "$newUserId" 
}

getNewUserName() {
    oldUserId=$1
    username=`su - postgres -c  "psql -A -t -d unifiedviews -c \"select username from usr_user where username = ( select organization  from usr_organization where usr =  ( select username from tmp where id = ${oldUserId}));
\""`
    echo "$username"
}

getUserActorId() {
    userId=$1
    username=`su - postgres -c  "psql -A -t -d unifiedviews -c \"select user_actor.id from usr_extuser INNER JOIN user_actor ON usr_extuser.id_extuser = user_actor.id_extuser  where id_usr= ${userId};\""`
    echo "$username"
}

su - postgres -c  "psql -A -t -d unifiedviews -c \"delete from  usr_organization;\""

result=`ldapsearch -x -D cn=idm,ou=Administrators,dc=opendata,dc=org  -b  ou=people,dc=opendata,dc=org  -w secret  objectClass=inetOrgPerson uid | grep "uid:"`
while read -r user; do
    user=`echo ${user}| grep -oP ": \K.*" `
    org=`ldapsearch -x -D cn=idm,ou=Administrators,dc=opendata,dc=org  -b  ou=people,dc=opendata,dc=org  -w secret  uid=${user} | grep ou:`
    org=`echo ${org}| grep -oP ": \K.*" `
    
    query="INSERT INTO \"usr_organization\" VALUES (nextval('seq_usr_organization'), '${user}', '${org}');"
    echo $query >> data.sql

done <<< "$result"

su - postgres -c  "psql -A -t -d unifiedviews -c \"select concat('INSERT INTO  \"user_actor\" VALUES (nextval(''seq_usr_user''),''', username,''', ''',full_name,''' );') from usr_user;\"" > user_actors.sql
su - postgres -c "psql  -d ${dbname}" <  user_actors.sql

echo "disable constrains"
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  ppl_model  DROP CONSTRAINT ppl_model_pkey CASCADE\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  ppl_model  DROP CONSTRAINT ppl_model_name_key CASCADE;\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  ppl_model  DROP CONSTRAINT ppl_model_user_id_fkey  CASCADE;\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  usr_extuser  DROP CONSTRAINT usr_extuser_id_usr_fkey CASCADE;\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  exec_schedule  DROP CONSTRAINT exec_schedule_user_actor_id_fkey CASCADE;\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  exec_schedule  DROP CONSTRAINT exec_schedule_user_id_fkey CASCADE;\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  exec_pipeline  DROP CONSTRAINT exec_pipeline_owner_id_fkey CASCADE;\" "
su - postgres -c  "psql -A -t -d unifiedviews -c \"ALTER TABLE  exec_pipeline  DROP CONSTRAINT exec_pipeline_user_actor_id_fkey CASCADE;\" "


su - postgres -c "psql -A -t -d unifiedviews -c \"drop table IF EXISTS tmp;\""
su - postgres -c "psql -A -t -d unifiedviews -c \"create table tmp as table usr_user;\" "
echo "delete old accounts"
su - postgres -c  "psql -A -t -d unifiedviews -c \"delete from usr_user; \""

su - postgres -c "psql  -d ${dbname}" <  schema.sql
su - postgres -c "psql  -d ${dbname}" <  data.sql

su - postgres -c "psql -A -t -d unifiedviews -c \"select concat('INSERT INTO  \"usr_user\" VALUES (nextval(''seq_usr_user''),''', organization,''' ,1,''100000:3069f2086098a66ec0a859ec7872b09af7866bc7ecafe2bed3ec394454056db2:b5ab4961ae8ad7775b3b568145060fabb76d7bca41c7b535887201f79ee9788a'',', ' ''', organization,'''',',20);') from usr_organization;\"" > update.sql
su - postgres -c "psql  -d ${dbname}" <  update.sql

echo "update ppl_model"
# update user_id ppl_model
list=`su - postgres -c  "psql -A -t -d unifiedviews -c \" select user_id from ppl_model;\""`
while read -r user_id; do
    if [ ! -z $user_id ] ; then
        newUserId=`getNewUserId  $user_id`
        userActorId=`getUserActorId $user_id`
        su - postgres -c  "psql -A -t -d unifiedviews -c \"UPDATE ppl_model set user_id = ${newUserId}, user_actor_id=${userActorId} where user_id = ${user_id};\""
        echo "old id : " $user_id " new id: "$newUserId
    fi
  
done <<< "$list"


echo "update exec_pipeline"
list=`su - postgres -c  "psql -A -t -d unifiedviews -c \" select owner_id from exec_pipeline;\""`
while read -r user_id; do
    if [ ! -z $user_id ] ; then
        newUserId=`getNewUserId  $user_id`
        if [ ! -z  $newUserId ] ; then
            userActorId=`getUserActorId $user_id`
            su - postgres -c  "psql -A -t -d unifiedviews -c \"UPDATE exec_pipeline set owner_id = ${newUserId}, user_actor_id=${userActorId} where owner_id = ${user_id};\""
            echo "old id : " $user_id " new id: "$newUserId
        fi
    fi
done <<< "$list"


echo "update exec_schedule"
list=`su - postgres -c  "psql -A -t -d unifiedviews -c \" select user_id from exec_schedule;\""`
while read -r user_id; do
    if [ ! -z $user_id ] ; then
        newUserId=`getNewUserId  $user_id`
         if [ ! -z  $newUserId ] ; then
                userActorId=`getUserActorId $user_id`
                su - postgres -c  "psql -A -t -d unifiedviews -c \"UPDATE exec_schedule set user_id = ${newUserId}, user_actor_id=${userActorId} where user_id = ${user_id};\""
                echo "old id : " $user_id " new id: "$newUserId
         fi        
    fi
   
done <<< "$list"


echo "update dpu_template"
list=`su - postgres -c  "psql -A -t -d unifiedviews -c \" select user_id from dpu_template;\""`
while read -r user_id; do
    if [ ! -z $user_id ] ; then
        newUserId=`getNewUserId  $user_id`
        if [ ! -z  $newUserId ] ; then
            su - postgres -c  "psql -A -t -d unifiedviews -c \"UPDATE dpu_template set user_id = ${newUserId} where user_id = ${user_id};\""
            echo "old id : " $user_id " new id: "$newUserId
        fi        
    fi
  
done <<< "$list"


echo "update usr_extuser"
list=`su - postgres -c  "psql -A -t -d unifiedviews -c \" select id_usr from usr_extuser;\""`
while read -r user_id; do
    newUserId=`getNewUserId  $user_id`
    if [ ! -z  $newUserId ] ; then
        username=`getNewUserName $user_id`
        su - postgres -c  "psql -A -t -d unifiedviews -c \"UPDATE usr_extuser set id_usr = ${newUserId}, id_extuser='${username}' where id_usr = ${user_id};\""
        echo "old id : " $user_id " new id: "$newUserId
    fi
done <<< "$list"


echo "delete tmp table"
su - postgres -c  "psql -A -t -d unifiedviews -c \"drop table IF EXISTS tmp;\""
# activate constrains
echo "set constrains back"
su - postgres -c "psql  -d ${dbname}" <  constrains.sql

