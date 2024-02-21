CREATE USER 'admin'@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

CREATE DATABASE gmod;
CREATE DATABASE gmod_alpha;
CREATE DATABASE gmod_bravo;
CREATE DATABASE gmod_charlie;
CREATE DATABASE svencoop;

CREATE ROLE gmod;
CREATE ROLE gmod_alpha;
CREATE ROLE gmod_bravo;
CREATE ROLE gmod_charlie;
CREATE ROLE svencoop;
GRANT ALL ON `gmod%`.* TO gmod;
GRANT ALL ON `gmod_alpha%`.* TO gmod_alpha;
GRANT ALL ON `gmod_bravo%`.* TO gmod_bravo;
GRANT ALL ON `gmod_charlie%`.* TO gmod_charlie;
GRANT ALL ON `svencoop%`.* TO svencoop;

/* Internal users */
CREATE USER 'php'@'${MYSQL_HOST}' IDENTIFIED BY '${PHP_PASSWORD}';
CREATE USER 'gmod_alpha'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_ALPHA_PASSWORD}';
CREATE USER 'gmod_bravo'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_BRAVO_PASSWORD}';
CREATE USER 'gmod_charlie'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_CHARLIE_PASSWORD}';
CREATE USER 'svencoop'@'${MYSQL_HOST}' IDENTIFIED BY '${SVENCOOP_PASSWORD}';
CREATE USER 'synergy'@'${MYSQL_HOST}' IDENTIFIED BY '${SYNERGY_PASSWORD}';
CREATE USER 'hl2dm'@'${MYSQL_HOST}' IDENTIFIED BY '${HL2DM_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'php'@'${MYSQL_HOST}' WITH GRANT OPTION;
GRANT gmod TO 'gmod'@'${MYSQL_HOST}';
GRANT gmod_alpha TO 'gmod_alpha'@'${MYSQL_HOST}';
GRANT gmod_bravo TO 'gmod_bravo'@'${MYSQL_HOST}';
GRANT gmod_charlie TO 'gmod_charlie'@'${MYSQL_HOST}';
GRANT svencoop TO 'svencoop'@'${MYSQL_HOST}';
GRANT synergy TO 'synergy'@'${MYSQL_HOST}';
GRANT hl2dm TO 'hl2dm'@'${MYSQL_HOST}';

/* Your custom users AKA staff members */
CREATE USER 'doormatt'@'%' IDENTIFIED BY '${DOORMATT_PASSWORD}';
CREATE USER 'blunto'@'%' IDENTIFIED BY '${BLUNTO_PASSWORD}';
CREATE USER 'berb'@'%' IDENTIFIED BY '${BERB_PASSWORD}';
CREATE USER 'freeman'@'%' IDENTIFIED BY '${FREEMAN_PASSWORD}';
CREATE USER 'pepe'@'%' IDENTIFIED BY '${PEPE_PASSWORD}';

GRANT gmod_alpha TO 'doormatt'@'%', 'blunto'@'%', 'berb'@'%';
GRANT svencoop TO 'freeman'@'%', 'pepe'@'%';
SET DEFAULT ROLE gmod_alpha TO 'doormatt', 'blunto', 'berb';
SET DEFAULT ROLE svencoop TO 'freeman', 'pepe';

FLUSH PRIVILEGES;
