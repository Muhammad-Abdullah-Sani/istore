<?php
include __DIR__ . '/auth.php';
include __DIR__ . '/../config/database.php';
$total = (int) $conn->query("SELECT COUNT(*) FROM products")->fetch_row()[0];
$inStock = (int) $conn->query("SELECT COUNT(*) FROM products WHERE stock > 0 AND status = 'available'")->fetch_row()[0];
$counts = [];
$result = $conn->query("SELECT category, COUNT(*) AS total FROM products GROUP BY category");
while ($row = $result->fetch_assoc()) {
    $counts[$row["category"]] = (int) $row["total"];
}
echo json_encode([
    "total" => $total,
    "in_stock" => $inStock,
    "categories" => count($counts),
    "counts" => $counts
]);