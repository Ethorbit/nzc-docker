CREATE USER 'admin'@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

CREATE DATABASE gmod_alpha;
CREATE DATABASE gmod_bravo;
CREATE DATABASE gmod_charlie;
CREATE DATABASE hl2dm_alpha;
CREATE DATABASE hl2dm_bravo;
CREATE DATABASE svencoop;
CREATE DATABASE synergy;

CREATE ROLE gmod_alpha;
CREATE ROLE gmod_bravo;
CREATE ROLE gmod_charlie;
CREATE ROLE hl2dm_alpha;
CREATE ROLE hl2dm_bravo;
CREATE ROLE svencoop;
CREATE ROLE synergy;
GRANT ALL ON `gmod_alpha%`.* TO gmod_alpha;
GRANT ALL ON `gmod_bravo%`.* TO gmod_bravo;
GRANT ALL ON `gmod_charlie%`.* TO gmod_charlie;
GRANT ALL ON `hl2dm_alpha%`.* TO hl2dm_alpha;
GRANT ALL ON `hl2dm_bravo%`.* TO hl2dm_bravo;
GRANT ALL ON `svencoop%`.* TO svencoop;
GRANT ALL ON `synergy%`.* TO synergy;

/* Internal users */
CREATE USER 'php'@'${MYSQL_HOST}' IDENTIFIED BY '${PHP_PASSWORD}';
CREATE USER 'gmod_alpha'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_ALPHA_PASSWORD}';
CREATE USER 'gmod_bravo'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_BRAVO_PASSWORD}';
CREATE USER 'gmod_charlie'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_CHARLIE_PASSWORD}';
CREATE USER 'hl2dm_alpha'@'${MYSQL_HOST}' IDENTIFIED BY '${HL2DM_ALPHA_PASSWORD}';
CREATE USER 'hl2dm_bravo'@'${MYSQL_HOST}' IDENTIFIED BY '${HL2DM_BRAVO_PASSWORD}';
CREATE USER 'svencoop'@'${MYSQL_HOST}' IDENTIFIED BY '${SVENCOOP_PASSWORD}';
CREATE USER 'synergy'@'${MYSQL_HOST}' IDENTIFIED BY '${SYNERGY_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'php'@'${MYSQL_HOST}' WITH GRANT OPTION;
GRANT gmod_alpha TO 'gmod_alpha'@'${MYSQL_HOST}';
GRANT gmod_bravo TO 'gmod_bravo'@'${MYSQL_HOST}';
GRANT gmod_charlie TO 'gmod_charlie'@'${MYSQL_HOST}';
GRANT hl2dm_alpha TO 'hl2dm_alpha'@'${MYSQL_HOST}';
GRANT hl2dm_bravo TO 'hl2dm_bravo'@'${MYSQL_HOST}';
GRANT svencoop TO 'svencoop'@'${MYSQL_HOST}';
GRANT synergy TO 'synergy'@'${MYSQL_HOST}';

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
