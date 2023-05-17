CREATE USER 'admin'@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

CREATE ROLE gmod;
CREATE ROLE svencoop;

CREATE DATABASE gmod_nzombies;
CREATE DATABASE gmod_anticheat;
CREATE DATABASE svencoop;

GRANT INSERT, UPDATE, DELETE ON `gmod%`.* TO gmod;
GRANT INSERT, UPDATE, DELETE ON `svencoop%`.* TO svencoop;

# Your custom users AKA staff members
CREATE USER 'gmod_lua'@'gmod' IDENTIFIED BY '${GMOD_LUA_PASSWORD}';
CREATE USER 'doormatt'@'%' IDENTIFIED BY '${DOORMATT_PASSWORD}';
CREATE USER 'blunto'@'%' IDENTIFIED BY '${BLUNTO_PASSWORD}';
CREATE USER 'berb'@'%' IDENTIFIED BY '${BERB_PASSWORD}';
CREATE USER 'freeman'@'%' IDENTIFIED BY '${FREEMAN_PASSWORD}';
CREATE USER 'pepe'@'%' IDENTIFIED BY '${PEPE_PASSWORD}';

GRANT gmod TO 'gmod_lua'@'gmod', 'doormatt'@'%', 'blunto'@'%', 'berb'@'%';
GRANT svencoop TO 'freeman'@'%', 'pepe'@'%';
