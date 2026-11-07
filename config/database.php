<?php
$host = "localhost";
$username = "authuser";
$password = "Iphone@123!";
$database = "istore";
$conn = new mysqli(
    $host,
    $username,
    $password,
    $database
);
if ($conn->connect_error) {
    die("Database connection failed.");
}
$conn->set_charset("utf8mb4");
?>