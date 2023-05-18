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
CREATE USER 'gmod'@'gmod' IDENTIFIED BY '${GMOD_PASSWORD}';
CREATE USER 'svencoop'@'svencoop' IDENTIFIED BY '${SVENCOOP_PASSWORD}';
GRANT gmod TO 'gmod'@'gmod';
GRANT svencoop TO 'svencoop'@'svencoop';

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
