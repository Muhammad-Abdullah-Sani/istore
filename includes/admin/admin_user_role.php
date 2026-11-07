<?php
include __DIR__ . '/admin_api.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo json_encode(["error" => "method"]);
    exit;
}
$targetId = (int) ($_POST["user_id"] ?? 0);
$role = $_POST["role"] ?? "";
if ($targetId <= 0 || !in_array($role, ["user", "admin"], true)) {
    http_response_code(400);
    echo json_encode(["error" => "input"]);
    exit;
}
if ($targetId === $adminId) {
    http_response_code(409);
    echo json_encode(["error" => "self"]);
    exit;
}
$stmt = $conn->prepare("SELECT id FROM users WHERE id = ?");
$stmt->bind_param("i", $targetId);
$stmt->execute();
if (!$stmt->get_result()->fetch_assoc()) {
    http_response_code(404);
    echo json_encode(["error" => "user"]);
    exit;
}
$stmt->close();
$stmt = $conn->prepare("UPDATE users SET role = ? WHERE id = ?");
$stmt->bind_param("si", $role, $targetId);
$stmt->execute();
echo json_encode(["role" => $role]);