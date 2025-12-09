-- IPX-Framework 데이터베이스 초기화 스크립트
-- Docker 컨테이너 시작 시 자동 실행됨

-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS `ipx_master` 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `ipx_vr` 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- 애플리케이션 사용자 생성
CREATE USER IF NOT EXISTS 'ipx_app'@'%' IDENTIFIED BY 'strong_password';

-- 권한 부여
GRANT ALL PRIVILEGES ON `ipx_master`.* TO 'ipx_app'@'%';
GRANT ALL PRIVILEGES ON `ipx_vr`.* TO 'ipx_app'@'%';

-- 권한 적용
FLUSH PRIVILEGES;

-- 데이터베이스 목록 확인
SHOW DATABASES;

