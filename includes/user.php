<?php
include __DIR__ . '/auth.php';
include __DIR__ . '/../config/database.php';
$id = (int) $_SESSION["user_id"];
$stmt = $conn->prepare("SELECT name, email, role, created_at FROM users WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();
if (!$user) {
    http_response_code(401);
    echo json_encode(["error" => "login"]);
    exit;
}
echo json_encode($user);