<?php
include __DIR__ . '/admin_api.php';
$accounts = (int) $conn->query("SELECT COUNT(*) FROM users")->fetch_row()[0];
$week = (int) $conn->query("SELECT COUNT(*) FROM users WHERE created_at >= (NOW() - INTERVAL 7 DAY)")->fetch_row()[0];
$admins = (int) $conn->query("SELECT COUNT(*) FROM users WHERE role = 'admin'")->fetch_row()[0];
$orders = (int) $conn->query("SELECT COUNT(*) FROM orders WHERE status <> 'cancelled'")->fetch_row()[0];
echo json_encode([
    "accounts" => $accounts,
    "week" => $week,
    "admins" => $admins,
    "orders" => $orders
]);