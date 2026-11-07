<?php
include_once __DIR__ . '/../session.php';
include_once __DIR__ . '/../../config/database.php';
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../public/html/login.html");
    exit;
}
$adminId = (int) $_SESSION['user_id'];
$adminStmt = $conn->prepare("SELECT role FROM users WHERE id = ?");
$adminStmt->bind_param("i", $adminId);
$adminStmt->execute();
$adminRow = $adminStmt->get_result()->fetch_assoc();
$adminStmt->close();
if (!$adminRow || $adminRow['role'] !== 'admin') {
    header("Location: ../../public/html/dashboard.html");
    exit;
}
$_SESSION['user_role'] = 'admin';
?>