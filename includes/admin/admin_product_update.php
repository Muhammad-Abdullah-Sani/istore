<?php
include __DIR__ . '/admin_api.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo json_encode(["error" => "method"]);
    exit;
}
$id = filter_var($_POST["id"] ?? "", FILTER_VALIDATE_INT, ["options" => ["min_range" => 1]]);
$stock = filter_var($_POST["stock"] ?? "", FILTER_VALIDATE_INT, ["options" => ["min_range" => 0]]);
$price = filter_var($_POST["price"] ?? "", FILTER_VALIDATE_INT, ["options" => ["min_range" => 0]]);
$status = $_POST["status"] ?? "";
if ($id === false || $stock === false || $price === false
    || !in_array($status, ["available", "coming_soon"], true)) {
    http_response_code(400);
    echo json_encode(["error" => "input"]);
    exit;
}
$stmt = $conn->prepare("UPDATE products SET stock = ?, price = ?, status = ? WHERE id = ?");
$stmt->bind_param("iisi", $stock, $price, $status, $id);
$stmt->execute();
$stmt->close();
echo json_encode(["ok" => true]);