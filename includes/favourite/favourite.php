<?php
include __DIR__ . '/../auth.php';
include __DIR__ . '/../../config/database.php';
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
$stmt = $conn->prepare("SELECT id FROM products WHERE id = ?");
$stmt->bind_param("i", $productId);
$stmt->execute();
if (!$stmt->get_result()->fetch_assoc()) {
    http_response_code(404);
    echo json_encode(["error" => "product"]);
    exit;
}
$stmt = $conn->prepare("SELECT id FROM wishlist WHERE user_id = ? AND product_id = ?");
$stmt->bind_param("ii", $userId, $productId);
$stmt->execute();
$existing = $stmt->get_result()->fetch_assoc();
if ($existing) {
    $stmt = $conn->prepare("DELETE FROM wishlist WHERE id = ?");
    $id = (int) $existing["id"];
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $favourite = false;
} 
else {
    $stmt = $conn->prepare("INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)");
    $stmt->bind_param("ii", $userId, $productId);
    $stmt->execute();
    $favourite = true;
}
echo json_encode(["favourite" => $favourite]);