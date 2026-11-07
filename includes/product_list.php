<?php
include __DIR__ . '/auth.php';
include __DIR__ . '/../config/database.php';
$allowed = ["iphone", "macbook", "tablets", "earbuds", "chargers"];
$category = $_GET["category"] ?? "";
if (!in_array($category, $allowed, true)) {
    http_response_code(400);
    echo json_encode(["error" => "category"]);
    exit;
}
$userId = (int) $_SESSION["user_id"];
$q = trim($_GET["q"] ?? "");
$sql = "SELECT p.id, p.category, p.series, p.name, p.variant, p.image,
               p.price, p.stock, p.status,
               (w.id IS NOT NULL) AS is_favourite
        FROM products p
        LEFT JOIN wishlist w ON w.product_id = p.id AND w.user_id = ?
        WHERE p.category = ?";
$types = "is";
$params = [$userId, $category];
if ($q !== "") {
    $sql .= " AND (p.name LIKE ? OR p.series LIKE ? OR p.variant LIKE ?)";
    $like = "%" . addcslashes($q, "%_") . "%";
    $types .= "sss";
    array_push($params, $like, $like, $like);
}
$sql .= " ORDER BY p.series DESC, p.id ASC";
$stmt = $conn->prepare($sql);
$stmt->bind_param($types, ...$params);
$stmt->execute();
$result = $stmt->get_result();
$products = [];
while ($row = $result->fetch_assoc()) {
    $row["id"] = (int) $row["id"];
    $row["price"] = (int) $row["price"];
    $row["stock"] = (int) $row["stock"];
    $row["is_favourite"] = (bool) $row["is_favourite"];
    $products[] = $row;
}
echo json_encode($products);