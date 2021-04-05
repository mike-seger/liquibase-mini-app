-- Schema initialization
DROP DATABASE IF EXISTS user01;
CREATE DATABASE user01;
GRANT ALL PRIVILEGES ON user01.* TO 'user01'@'%'
