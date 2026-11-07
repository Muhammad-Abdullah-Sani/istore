<?php
include __DIR__ . '/session.php';
include __DIR__ . '/../config/database.php';

if (!isset($_SESSION["user_id"])) {
    header("Location: ../public/html/login.html");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../public/html/profile.html");
    exit;
}

function back($query)
{
    header("Location: ../public/html/profile.html?" . $query);
    exit;
}

$userId = (int) $_SESSION["user_id"];
$action = $_POST["action"] ?? "";

if ($action === "name") {
    $name = trim($_POST["name"] ?? "");

    if ($name === "" || mb_strlen($name) > 30) {
        back("error=name");
    }

    $stmt = $conn->prepare("UPDATE users SET name = ? WHERE id = ?");
    $stmt->bind_param("si", $name, $userId);
    $stmt->execute();
    $_SESSION["user_name"] = $name;

    back("updated=name");
}

if ($action === "password") {
    $current = $_POST["current_password"] ?? "";
    $new = $_POST["new_password"] ?? "";
    $confirm = $_POST["confirm_password"] ?? "";

    $stmt = $conn->prepare("SELECT password_hash FROM users WHERE id = ?");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$row || !password_verify($current, $row["password_hash"])) {
        back("error=current");
    }
    if (strlen($new) < 8 || !preg_match('/[0-9]/', $new) || !preg_match('/[^A-Za-z0-9]/', $new)) {
        back("error=password");
    }
    if ($new !== $confirm) {
        back("error=mismatch");
    }

    $hash = password_hash($new, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("UPDATE users SET password_hash = ? WHERE id = ?");
    $stmt->bind_param("si", $hash, $userId);
    $stmt->execute();
    session_regenerate_id(true);

    back("updated=password");
}

back("error=action");