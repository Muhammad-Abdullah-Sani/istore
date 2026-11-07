<?php
include __DIR__ . '/../auth.php';
include_once __DIR__ . '/../../config/database.php';
$adminId = (int) $_SESSION["user_id"];
$stmt = $conn->prepare("SELECT role FROM users WHERE id = ?");
$stmt->bind_param("i", $adminId);
$stmt->execute();
$adminRow = $stmt->get_result()->fetch_assoc();
$stmt->close();
if (!$adminRow || $adminRow["role"] !== "admin") {
    http_response_code(403);
    echo json_encode(["error" => "admin"]);
    exit;
}