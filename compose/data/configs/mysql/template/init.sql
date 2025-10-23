CREATE USER 'admin'@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

CREATE DATABASE gmod_alpha;
CREATE DATABASE gmod_bravo;
CREATE DATABASE gmod_charlie;
CREATE DATABASE gmod_shared;

CREATE ROLE gmod_alpha;
CREATE ROLE gmod_bravo;
CREATE ROLE gmod_charlie;
GRANT ALL ON `gmod_alpha%`.* TO gmod_alpha;
GRANT ALL ON `gmod_bravo%`.* TO gmod_bravo;
GRANT ALL ON `gmod_charlie%`.* TO gmod_charlie;
GRANT ALL ON `gmod_shared`.* TO gmod_alpha;
GRANT ALL ON `gmod_shared`.* TO gmod_bravo;
GRANT ALL ON `gmod_shared`.* TO gmod_charlie;

/* Internal users */
CREATE USER 'php'@'${MYSQL_HOST}' IDENTIFIED BY '${PHP_PASSWORD}';
CREATE USER 'gmod_alpha'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_ALPHA_PASSWORD}';
CREATE USER 'gmod_bravo'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_BRAVO_PASSWORD}';
CREATE USER 'gmod_charlie'@'${MYSQL_HOST}' IDENTIFIED BY '${GMOD_CHARLIE_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'php'@'${MYSQL_HOST}' WITH GRANT OPTION;
GRANT gmod_alpha TO 'gmod_alpha'@'${MYSQL_HOST}';
GRANT gmod_bravo TO 'gmod_bravo'@'${MYSQL_HOST}';
GRANT gmod_charlie TO 'gmod_charlie'@'${MYSQL_HOST}';

/* Your custom users AKA staff members */
/*
CREATE USER 'geist'@'%' IDENTIFIED BY '${GEIST_PASSWORD}';
GRANT ark TO 'geist'@'%';
SET DEFAULT ROLE gmod_alpha TO 'geist';
*/

FLUSH PRIVILEGES;
