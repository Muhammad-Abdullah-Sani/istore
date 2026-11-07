<?php
include __DIR__ . '/../session.php';
if (!isset($_SESSION["user_id"])) {
    header("Location: ../../public/html/login.html");
    exit;
}
include __DIR__ . '/../../config/database.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../../public/html/dashboard.html");
    exit;
}
$userId = (int) $_SESSION["user_id"];
$productId = (int) ($_POST["product_id"] ?? 0);
$description = trim($_POST["description"] ?? "");
$reason = trim($_POST["reason"] ?? "");
$priority = $_POST["priority"] ?? "Medium";
$notes = trim($_POST["notes"] ?? "");
if ($productId <= 0 || $description === "" || $reason === "" ||
    strlen($description) > 1000 || strlen($reason) > 255 ||
    strlen($notes) > 1000 ||
    !in_array($priority, ["Low", "Medium", "High"], true)) {
    $back = $productId > 0
        ? "../../public/html/add-favourite.html?product=" . $productId . "&error=invalid"
        : "../../public/html/dashboard.html";
    header("Location: " . $back);
    exit;
}
$stmt = $conn->prepare("SELECT id FROM products WHERE id = ?");
$stmt->bind_param("i", $productId);
$stmt->execute();
if (!$stmt->get_result()->fetch_assoc()) {
    header("Location: ../../public/html/dashboard.html");
    exit;
}
$stmt = $conn->prepare(
    "SELECT id FROM wishlist WHERE user_id = ? AND product_id = ?"
);
$stmt->bind_param("ii", $userId, $productId);
$stmt->execute();
$existing = $stmt->get_result()->fetch_assoc();

if ($existing) {
    $stmt = $conn->prepare(
        "UPDATE wishlist
         SET description = ?, reason = ?, priority = ?, notes = ?
         WHERE id = ? AND user_id = ?"
    );
    $stmt->bind_param(
        "ssssii",
        $description,
        $reason,
        $priority,
        $notes,
        $existing["id"],
        $userId
    );
} else {
    $stmt = $conn->prepare(
        "INSERT INTO wishlist
         (user_id, product_id, description, reason, priority, notes)
         VALUES (?, ?, ?, ?, ?, ?)"
    );
    $stmt->bind_param(
        "iissss",
        $userId,
        $productId,
        $description,
        $reason,
        $priority,
        $notes
    );
}
if ($stmt->execute()) {
    header("Location: ../../public/html/favourites.html?saved=1");
    exit;
}
header("Location: ../../public/html/add-favourite.html?product=" . $productId . "&error=save");
exit;
?>