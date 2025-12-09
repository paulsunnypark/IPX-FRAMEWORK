<?php
// MariaDB 버전 및 호환성 확인 스크립트

$host = '127.0.0.1';
$user = 'root';
$password = 'st5300!@#';

try {
    $pdo = new PDO("mysql:host=$host", $user, $password, [
        PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
    ]);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // 버전 확인
    $version = $pdo->query('SELECT VERSION()')->fetchColumn();
    echo "MariaDB Version: $version\n";
    
    // 버전 파싱
    preg_match('/(\d+)\.(\d+)\.(\d+)/', $version, $matches);
    $major = (int)$matches[1];
    $minor = (int)$matches[2];
    $patch = (int)$matches[3];
    
    echo "Major: $major, Minor: $minor, Patch: $patch\n\n";
    
    // 기능 확인
    echo "Feature Check:\n";
    echo "--------------\n";
    
    // JSON 지원 확인
    $jsonSupport = $pdo->query("SELECT JSON_TYPE('{}')")->fetchColumn();
    if ($jsonSupport !== null) {
        echo "✓ JSON support: Available\n";
    } else {
        echo "✗ JSON support: Not available\n";
    }
    
    // CTE 지원 확인 (MariaDB 10.2+)
    try {
        $pdo->exec("WITH test AS (SELECT 1 as n) SELECT * FROM test");
        echo "✓ CTE (Common Table Expression): Supported\n";
    } catch (PDOException $e) {
        echo "✗ CTE (Common Table Expression): Not supported\n";
    }
    
    // Window Functions 지원 확인 (MariaDB 10.2+)
    try {
        $wfStmt = $pdo->query("SELECT ROW_NUMBER() OVER() as rn FROM (SELECT 1 as n) t");
        $wfStmt->fetchAll(PDO::FETCH_ASSOC);
        $wfStmt = null; // 명시적으로 해제
        echo "✓ Window Functions: Supported\n";
    } catch (PDOException $e) {
        echo "✗ Window Functions: Not supported\n";
    }
    
    // 현재 데이터베이스 목록
    echo "\nExisting Databases:\n";
    echo "-------------------\n";
    $dbStmt = $pdo->query('SHOW DATABASES');
    $databases = $dbStmt->fetchAll(PDO::FETCH_COLUMN);
    $dbStmt = null; // 명시적으로 해제
    foreach ($databases as $db) {
        if (!in_array($db, ['information_schema', 'performance_schema', 'mysql', 'sys'])) {
            echo "  - $db\n";
        }
    }
    
    // 호환성 평가
    echo "\nCompatibility Assessment:\n";
    echo "------------------------\n";
    
    $compatible = true;
    $issues = [];
    
    // IPX-Framework 요구사항: MySQL 8.0+ 또는 MariaDB 10.3+
    if ($major < 10 || ($major == 10 && $minor < 3)) {
        $compatible = false;
        $issues[] = "MariaDB 10.3+ required (current: $major.$minor.$patch)";
    }
    
    if ($compatible) {
        echo "✓ MariaDB version is compatible with IPX-Framework\n";
        echo "✓ Can be used for development\n";
    } else {
        echo "✗ MariaDB version may have compatibility issues:\n";
        foreach ($issues as $issue) {
            echo "  - $issue\n";
        }
    }
    
} catch (PDOException $e) {
    echo "Error connecting to MariaDB: " . $e->getMessage() . "\n";
    exit(1);
}

