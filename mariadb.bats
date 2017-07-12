#! /usr/bin/env bats
#
# Functional tests for a MariaDB server set up wit Ansible role bertvv.mariadb
#
# The variable SUT_IP, the IP address of the System Under Test must be set
# outside of the script.

@test 'User ‘appusr’ should be able to run remote queries: SHOW TABLES' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password=sekrit \
    --execute="SHOW TABLES;" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: SELECT' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password=sekrit \
    --execute="SELECT * FROM TestTable;" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: UPDATE' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password=sekrit \
    --execute="UPDATE TestTable SET SurName='Smith' WHERE Id=1;" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: INSERT' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password=sekrit \
    --execute="INSERT INTO TestTable (Id, GivenName, SurName) VALUES (100, 'Jimmy', 'Smith');" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: DELETE' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password=sekrit \
    --execute="DELETE FROM TestTable WHERE Id=100;" \
    myappdb
}

@test 'User ‘appusr’ should not have access to ‘myotherdb’' {
  run mysql --host="${SUT_IP}" \
    --user=otheruser \
    --password=letmein \
    --execute="SHOW TABLES;" \
    otherdb
  [ "${status}" -ne 0 ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}

@test 'User ‘otheruser’ should not have access to ‘myotherdb’' {
  run mysql --host="${SUT_IP}" \
    --user=otheruser \
    --password=letmein \
    --execute="SHOW TABLES;" \
    otherdb
  [ "${status}" -ne 0 ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}


