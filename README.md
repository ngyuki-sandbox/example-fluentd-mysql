# fluentd mysql

## データベース

```sh
# [logdb]
sudo yum install https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
sudo yum install mysql-community-server mysql-community-client

sudo mysqld --initialize --user mysql
sudo systemctl start mysqld
sudo systemctl status mysqld
sudo systemctl enable mysqld
sudo cat /var/log/mysqld.log  | grep -i password

mysql -u root -p mysql
```

```sql
alter user root@localhost identified by 'qwerty';
create user app@localhost identified by 'qwerty';
create user app@'%'       identified by 'qwerty';
create database app_log;
grant all on app_log.* to app@localhost;
grant all on app_log.* to app@'%';
\q
```

```sh
cat <<'EOS'> ~/.my.cnf
[client]
user = root
password = qwerty
EOS

mysql app_log
```

```sql
CREATE TABLE t_app_log (
  seq           bigint          NOT NULL AUTO_INCREMENT,
  log_time      double          NOT NULL DEFAULT 0,
  ipaddr        varchar (64)    NOT NULL DEFAULT '',
  process_id    int             NOT NULL DEFAULT 0,
  priority      tinyint         NOT NULL DEFAULT 0,
  message       varchar (1024)  NOT NULL DEFAULT '',
  PRIMARY KEY (seq)
);

CREATE TABLE t_alarm_log (
  seq           bigint          NOT NULL AUTO_INCREMENT,
  log_time      double          NOT NULL DEFAULT 0,
  ipaddr        varchar (64)    NOT NULL DEFAULT '',
  process_id    int             NOT NULL DEFAULT 0,
  priority      tinyint         NOT NULL DEFAULT 0,
  message       varchar (1024)  NOT NULL DEFAULT '',
  PRIMARY KEY (seq)
);

CREATE TABLE t_last_alarm (
  ipaddr        varchar (64)    NOT NULL DEFAULT '',
  log_time      double          NOT NULL DEFAULT 0,
  PRIMARY KEY (ipaddr)
);

\q
```

## Fluentd

```sh
# [ap01]
curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sudo sh

sudo tee /etc/sysconfig/td-agent <<'EOS'
TD_AGENT_USER=root
TD_AGENT_GROUP=root
EOS

sudo yum install https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
sudo yum install gcc mysql-community-devel mysql-community-client

sudo /opt/td-agent/usr/sbin/td-agent-gem install fluent-plugin-mysql
sudo /opt/td-agent/usr/sbin/td-agent-gem install fluent-plugin-record-modifier
sudo /opt/td-agent/usr/sbin/td-agent-gem install fluent-plugin-filter

sudo touch /var/log/app.log
sudo chown $USER: /var/log/app.log

/vagrant/start-td-agent.sh
```

```sh
# [logdb]
mysql app_log -e 'delete from t_app_log; delete from t_alarm_log;'

while sleep 1; do
  clear
  mysql app_log -e 'select * from t_last_alarm; select * from t_alarm_log; select * from t_app_log;'
done

# [ap01]
/vagrant/save-log.sh 3 eee
/vagrant/save-log.sh 4 www
/vagrant/save-log.sh 5 nnn
```


