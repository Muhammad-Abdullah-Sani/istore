<?php
include __DIR__ . '/auth.php';
include __DIR__ . '/../config/database.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
include __DIR__ . '/auth.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo json_encode(["error" => "method"]);
    exit;
}
$userId = (int) $_SESSION["user_id"];
$productId = (int) ($_POST["product_id"] ?? 0);
if ($productId <= 0) {
    http_response_code(400);
    echo json_encode(["error" => "product"]);
    exit;
}
$stmt = $conn->prepare("SELECT stock, status FROM products WHERE id = ?");
$stmt->bind_param("i", $productId);
$stmt->execute();
$product = $stmt->get_result()->fetch_assoc();
if (!$product) {
    http_response_code(404);
    echo json_encode(["error" => "product"]);
    exit;
}
if ($product["status"] !== "available" || (int) $product["stock"] <= 0) {
    http_response_code(409);
    echo json_encode(["error" => "stock"]);
    exit;
}
$stmt = $conn->prepare("SELECT id, quantity FROM cart_items WHERE user_id = ? AND product_id = ?");
$stmt->bind_param("ii", $userId, $productId);
$stmt->execute();
$existing = $stmt->get_result()->fetch_assoc();
if ($existing) {
    $quantity = min((int) $existing["quantity"] + 1, (int) $product["stock"]);
    $id = (int) $existing["id"];
    $stmt = $conn->prepare("UPDATE cart_items SET quantity = ? WHERE id = ?");
    $stmt->bind_param("ii", $quantity, $id);
    $stmt->execute();
} 
else {
    $quantity = 1;
    $stmt = $conn->prepare("INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)");
    $stmt->bind_param("iii", $userId, $productId, $quantity);
    $stmt->execute();
}
echo json_encode(["quantity" => $quantity]);