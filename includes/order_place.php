<?php
include __DIR__ . '/auth.php';
include __DIR__ . '/../config/database.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
function fail($code, $error)
{
    http_response_code($code);
    echo json_encode(["error" => $error]);
    exit;
}
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    fail(405, "method");
}
$userId = (int) $_SESSION["user_id"];
$productId = (int) ($_POST["product_id"] ?? 0);
$quantity = filter_var($_POST["quantity"] ?? "1", FILTER_VALIDATE_INT, ["options" => ["min_range" => 1, "max_range" => 10]]);
$fullName = trim($_POST["full_name"] ?? "");
$phone = trim($_POST["phone"] ?? "");
$address = trim($_POST["address"] ?? "");
$city = trim($_POST["city"] ?? "");
$cnic = preg_replace('/\D/', '', $_POST["cnic"] ?? "");
$method = $_POST["payment_method"] ?? "";
$transactionId = trim($_POST["transaction_id"] ?? "");
if ($productId <= 0) {
    fail(400, "product");
}
if ($quantity === false) {
    fail(400, "quantity");
}
if ($fullName === "" || mb_strlen($fullName) > 100) {
    fail(400, "full_name");
}
if (!preg_match('/^[0-9+\- ]{10,20}$/', $phone)) {
    fail(400, "phone");
}
if (mb_strlen($address) < 10 || mb_strlen($address) > 255) {
    fail(400, "address");
}
if (mb_strlen($city) < 2 || mb_strlen($city) > 80) {
    fail(400, "city");
}
if (strlen($cnic) !== 13) {
    fail(400, "cnic");
}
if (!in_array($method, ["jazzcash", "easypaisa", "bank_transfer"], true)) {
    fail(400, "payment_method");
}
if (!preg_match('/^[A-Za-z0-9\-]{6,60}$/', $transactionId)) {
    fail(400, "transaction_id");
}
$conn->begin_transaction();
try {
    $stmt = $conn->prepare("SELECT price, stock, status FROM products WHERE id = ? FOR UPDATE");
    $stmt->bind_param("i", $productId);
    $stmt->execute();
    $product = $stmt->get_result()->fetch_assoc();
    $stmt->close();
    if (!$product) {
        $conn->rollback();
        fail(404, "product");
    }
    if ($product["status"] !== "available" || (int) $product["stock"] < $quantity) {
        $conn->rollback();
        fail(409, "stock");
    }
    $unitPrice = (int) $product["price"];
    $total = $unitPrice * $quantity;
    $stmt = $conn->prepare(
        "INSERT INTO orders (user_id, total, status, full_name, phone, address, city, cnic, payment_method, transaction_id)
        VALUES (?, ?, 'pending', ?, ?, ?, ?, ?, ?, ?)"
    );
    $stmt->bind_param("iisssssss", $userId, $total, $fullName, $phone, $address, $city, $cnic, $method, $transactionId);
    $stmt->execute();
    $orderId = $conn->insert_id;
    $stmt->close();
    $stmt = $conn->prepare("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("iiii", $orderId, $productId, $quantity, $unitPrice);
    $stmt->execute();
    $stmt->close();
    $stmt = $conn->prepare("UPDATE products SET stock = stock - ? WHERE id = ?");
    $stmt->bind_param("ii", $quantity, $productId);
    $stmt->execute();
    $stmt->close();
    $conn->commit();
} catch (Throwable $e) {
    $conn->rollback();
    fail(500, "server");
}
echo json_encode(["order_id" => $orderId, "total" => $total]);