<?php
include __DIR__ . '/admin_api.php';
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
$orderId = (int) ($_POST["id"] ?? 0);
$status = $_POST["status"] ?? "";

if ($orderId <= 0 || !in_array($status, ["pending", "confirmed", "shipped", "delivered", "cancelled"], true)) {
    fail(400, "input");
}
$conn->begin_transaction();
try {
    $stmt = $conn->prepare("SELECT status FROM orders WHERE id = ? FOR UPDATE");
    $stmt->bind_param("i", $orderId);
    $stmt->execute();
    $order = $stmt->get_result()->fetch_assoc();
    $stmt->close();
    if (!$order) {
        $conn->rollback();
        fail(404, "order");
    }
    if ($order["status"] === "cancelled" && $status !== "cancelled") {
        $conn->rollback();
        fail(409, "cancelled");
    }
    if ($order["status"] !== "cancelled" && $status === "cancelled") {
        $stmt = $conn->prepare(
            "UPDATE products p
             JOIN (SELECT product_id, SUM(quantity) AS q FROM order_items WHERE order_id = ? GROUP BY product_id) s
               ON s.product_id = p.id
             SET p.stock = p.stock + s.q"
        );
        $stmt->bind_param("i", $orderId);
        $stmt->execute();
        $stmt->close();
    }
    $stmt = $conn->prepare("UPDATE orders SET status = ? WHERE id = ?");
    $stmt->bind_param("si", $status, $orderId);
    $stmt->execute();
    $stmt->close();
    $conn->commit();
} 
catch (Throwable $e) {
    $conn->rollback();
    fail(500, "server");
}
echo json_encode(["status" => $status]);