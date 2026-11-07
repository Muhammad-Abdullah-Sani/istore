<?php
include __DIR__ . '/../auth.php';
include __DIR__ . '/../../config/database.php';
$userId = (int) $_SESSION["user_id"];
$stmt = $conn->prepare(
    "SELECT p.id, p.name, p.series, p.variant, p.image, p.price,
            w.description, w.reason, w.priority, w.notes
     FROM wishlist w
     JOIN products p ON p.id = w.product_id
     WHERE w.user_id = ?
     ORDER BY w.id DESC"
);
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();
$favourites = [];
while ($row = $result->fetch_assoc()) {
    $row["id"] = (int) $row["id"];
    $row["price"] = (int) $row["price"];
    $favourites[] = $row;
}
echo json_encode($favourites);
?>
