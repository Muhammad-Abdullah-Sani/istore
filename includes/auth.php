<?php
include_once __DIR__ . '/session.php';
header("Content-Type: application/json; charset=utf-8");
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(["error" => "login"]);
    exit;
}