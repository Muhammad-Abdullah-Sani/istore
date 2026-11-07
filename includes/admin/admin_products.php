<?php
include __DIR__ . '/admin_api.php';

$lowLimit = 5;
$allowed = ["iphone", "macbook", "tablets", "earbuds", "chargers"];

$q = trim($_GET["q"] ?? "");
$category = $_GET["category"] ?? "";
$lowOnly = ($_GET["low"] ?? "") === "1";

$sql = "SELECT id, category, series, name, variant, price, stock, status FROM products WHERE 1 = 1";
$types = "";
$params = [];

if (in_array($category, $allowed, true)) {
    $sql .= " AND category = ?";
    $types .= "s";
    $params[] = $category;
}

if ($q !== "") {
    $sql .= " AND (name LIKE ? OR series LIKE ? OR variant LIKE ?)";
    $like = "%" . addcslashes($q, "%_") . "%";
    $types .= "sss";
    array_push($params, $like, $like, $like);
}

if ($lowOnly) {
    $sql .= " AND stock <= ?";
    $types .= "i";
    $params[] = $lowLimit;
}

$sql .= " ORDER BY stock ASC, id ASC";

$stmt = $conn->prepare($sql);
if ($params) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();
$products = [];
while ($row = $result->fetch_assoc()) {
    $row["id"] = (int) $row["id"];
    $row["price"] = (int) $row["price"];
    $row["stock"] = (int) $row["stock"];
    $products[] = $row;
}

$lowStmt = $conn->prepare("SELECT COUNT(*) FROM products WHERE stock <= ?");
$lowStmt->bind_param("i", $lowLimit);
$lowStmt->execute();
$lowCount = (int) $lowStmt->get_result()->fetch_row()[0];

echo json_encode([
    "low_limit" => $lowLimit,
    "low_count" => $lowCount,
    "products" => $products
]);