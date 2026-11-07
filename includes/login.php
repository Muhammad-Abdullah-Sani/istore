<?php
include __DIR__ . '/session.php';
include __DIR__ . '/../config/database.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../public/html/login.html");
    exit;
}
$email = trim($_POST["email"] ?? "");
$password = $_POST["password"] ?? "";
$stmt = $conn->prepare("SELECT id, name, email, password_hash, role FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$user = $stmt->get_result()->fetch_assoc();
if ($user && password_verify($password, $user["password_hash"])) {
    session_regenerate_id(true);
    $_SESSION["user_id"] = $user["id"];
    $_SESSION["user_name"] = $user["name"];
    $_SESSION["user_email"] = $user["email"];
    $_SESSION["user_role"] = $user["role"];
    if ($user["role"] === "admin") {
        header("Location: ../public/html/admin.html");
    } 
    else {
        header("Location: ../public/html/dashboard.html");
    }
    exit;
}
header("Location: ../public/html/login.html?error=login");
exit;