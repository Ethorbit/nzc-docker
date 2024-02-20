CREATE USER 'admin'@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

CREATE DATABASE gmod_nzombies;
CREATE DATABASE gmod_anticheat;
CREATE DATABASE svencoop;

CREATE ROLE gmod;
CREATE ROLE svencoop;
GRANT ALL ON `gmod%`.* TO gmod;
GRANT ALL ON `svencoop%`.* TO svencoop;

/* Internal users */
CREATE USER 'php'@'${MYSQL_HOST}' IDENTIFIED BY '${PHP_PASSWORD}';
CREATE USER 'gmod'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_PASSWORD}';
CREATE USER 'svencoop'@'${MYSQL_HOST}' IDENTIFIED BY '${SVENCOOP_PASSWORD}';
CREATE USER 'synergy'@'${MYSQL_HOST}' IDENTIFIED BY '${SYNERGY_PASSWORD}';
CREATE USER 'hl2dm'@'${MYSQL_HOST}' IDENTIFIED BY '${HL2DM_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'php'@'${MYSQL_HOST}' WITH GRANT OPTION;
GRANT gmod TO 'gmod'@'${MYSQL_HOST}';
GRANT svencoop TO 'svencoop'@'${MYSQL_HOST}';
GRANT synergy TO 'synergy'@'${MYSQL_HOST}';
GRANT hl2dm TO 'hl2dm'@'${MYSQL_HOST}';

/* Your custom users AKA staff members */
CREATE USER 'doormatt'@'%' IDENTIFIED BY '${DOORMATT_PASSWORD}';
CREATE USER 'blunto'@'%' IDENTIFIED BY '${BLUNTO_PASSWORD}';
CREATE USER 'berb'@'%' IDENTIFIED BY '${BERB_PASSWORD}';
CREATE USER 'freeman'@'%' IDENTIFIED BY '${FREEMAN_PASSWORD}';
CREATE USER 'pepe'@'%' IDENTIFIED BY '${PEPE_PASSWORD}';

GRANT gmod TO 'doormatt'@'%', 'blunto'@'%', 'berb'@'%';
GRANT svencoop TO 'freeman'@'%', 'pepe'@'%';
SET DEFAULT ROLE gmod TO 'doormatt', 'blunto', 'berb';
SET DEFAULT ROLE svencoop TO 'freeman', 'pepe';

FLUSH PRIVILEGES;
