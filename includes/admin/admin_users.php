<?php
include __DIR__ . '/admin_api.php';
$q = trim($_GET["q"] ?? "");
$sql = "SELECT id, name, email, role, created_at FROM users";
$types = "";
$params = [];
if ($q !== "") {
    $sql .= " WHERE name LIKE ? OR email LIKE ?";
    $like = "%" . addcslashes($q, "%_") . "%";
    $types = "ss";
    $params = [$like, $like];
}
$sql .= " ORDER BY id ASC";
$stmt = $conn->prepare($sql);
if ($params) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();
$users = [];
while ($row = $result->fetch_assoc()) {
    $row["id"] = (int) $row["id"];
    $users[] = $row;
}
echo json_encode(["me" => $adminId, "users" => $users]);