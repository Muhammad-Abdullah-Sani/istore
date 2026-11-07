<?php
include __DIR__ . '/admin_api.php';
$allowed = ["pending", "confirmed", "shipped", "delivered", "cancelled"];
$q = trim($_GET["q"] ?? "");
$status = $_GET["status"] ?? "";

$sql = "SELECT o.id, o.total, o.status, o.full_name, o.phone, o.address, o.city,
               o.payment_method, o.transaction_id, o.created_at, u.email
        FROM orders o
        LEFT JOIN users u ON u.id = o.user_id
        WHERE 1 = 1";
$types = "";
$params = [];
if (in_array($status, $allowed, true)) {
    $sql .= " AND o.status = ?";
    $types .= "s";
    $params[] = $status;
}
if ($q !== "") {
    $sql .= " AND (o.full_name LIKE ? OR o.phone LIKE ? OR o.transaction_id LIKE ? OR o.id = ?)";
    $like = "%" . addcslashes($q, "%_") . "%";
    $types .= "sssi";
    array_push($params, $like, $like, $like, (int) $q);
}
$sql .= " ORDER BY o.id DESC LIMIT 200";
$stmt = $conn->prepare($sql);
if ($params) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();
$orders = [];
$ids = [];
while ($row = $result->fetch_assoc()) {
    $row["id"] = (int) $row["id"];
    $row["total"] = (int) $row["total"];
    $row["items"] = [];
    $orders[$row["id"]] = $row;
    $ids[] = $row["id"];
}
if ($ids) {
    $list = implode(",", $ids);
    $itemResult = $conn->query(
        "SELECT i.order_id, i.quantity, i.price, COALESCE(p.name, 'Deleted product') AS name, p.variant
         FROM order_items i
         LEFT JOIN products p ON p.id = i.product_id
         WHERE i.order_id IN ($list)"
    );
    while ($it = $itemResult->fetch_assoc()) {
        $orders[(int) $it["order_id"]]["items"][] = [
            "name" => $it["name"],
            "variant" => $it["variant"],
            "quantity" => (int) $it["quantity"],
            "price" => (int) $it["price"]
        ];
    }
}
$counts = ["pending" => 0, "confirmed" => 0, "shipped" => 0, "delivered" => 0, "cancelled" => 0];
$countResult = $conn->query("SELECT status, COUNT(*) AS c FROM orders GROUP BY status");
while ($c = $countResult->fetch_assoc()) {
    $counts[$c["status"]] = (int) $c["c"];
}
echo json_encode(["counts" => $counts, "orders" => array_values($orders)]);