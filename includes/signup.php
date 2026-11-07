<?php
include __DIR__ . '/session.php';
include __DIR__ . '/../config/database.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../public/html/signup.html");
    exit;
}
$name = trim($_POST["name"] ?? "");
$email = trim($_POST["email"] ?? "");
$password = $_POST["password"] ?? "";
$error = "";
if ($name === "" || mb_strlen($name) > 30) {
    $error = "name";
} 
elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $error = "email";
} 
elseif (strlen($password) < 8 || !preg_match('/[0-9]/', $password) || !preg_match('/[^A-Za-z0-9]/', $password)) {
    $error = "password";
} 
elseif (!isset($_POST["confirm"])) {
    $error = "confirm";
}
if ($error === "") {
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    if ($stmt->get_result()->num_rows > 0) {
        $error = "exists";
    }
}
if ($error !== "") {
    header("Location: ../public/html/signup.html?error=" . $error);
    exit;
}
$passwordHash = password_hash($password, PASSWORD_DEFAULT);
$stmt = $conn->prepare("INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $email, $passwordHash);
$stmt->execute();
header("Location: ../public/html/login.html?registered=1");
exit;