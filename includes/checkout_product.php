<?php
include __DIR__ . '/auth.php';
include __DIR__ . '/../config/database.php';
$id = (int) ($_GET["id"] ?? 0);
$stmt = $conn->prepare("SELECT id, name, series, variant, image, price, stock, status FROM products WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$product = $stmt->get_result()->fetch_assoc();
if (!$product) {
    http_response_code(404);
    echo json_encode(["error" => "product"]);
    exit;
}
$product["id"] = (int) $product["id"];
$product["price"] = (int) $product["price"];
$product["stock"] = (int) $product["stock"];
echo json_encode([
    "product" => $product,
    "payment" => include __DIR__ . '/../config/payment.php'
]);