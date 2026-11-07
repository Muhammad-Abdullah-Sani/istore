<?php
include __DIR__ . '/admin_api.php';
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo json_encode(["error" => "method"]);
    exit;
}
function back($query)
{
    header("Location: ../../public/html/admin.html?" . $query);
    exit;
}
$categories = ["iphone", "macbook", "tablets", "earbuds", "chargers"];
$category = $_POST["category"] ?? "";
$series = trim($_POST["series"] ?? "");
$name = trim($_POST["name"] ?? "");
$variant = trim($_POST["variant"] ?? "");
$description = trim($_POST["description"] ?? "");
$priceRaw = $_POST["price"] ?? "";
$stockRaw = $_POST["stock"] ?? "";
$status = $_POST["status"] ?? "available";
$imageUrl = trim($_POST["image_url"] ?? "");
if (!in_array($category, $categories, true)) {
    back("error=category");
}
if ($series === "" || mb_strlen($series) > 100) {
    back("error=series");
}
if ($name === "" || mb_strlen($name) > 150) {
    back("error=name");
}
if (mb_strlen($variant) > 150) {
    back("error=variant");
}
if (mb_strlen($description) > 2000) {
    back("error=description");
}
if (filter_var($priceRaw, FILTER_VALIDATE_INT) === false || (int) $priceRaw < 0) {
    back("error=price");
}
if (filter_var($stockRaw, FILTER_VALIDATE_INT) === false || (int) $stockRaw < 0) {
    back("error=stock");
}
if (!in_array($status, ["available", "coming_soon"], true)) {
    back("error=status");
}
$image = null;
$file = $_FILES["image_file"] ?? null;
if ($file && $file["error"] === UPLOAD_ERR_OK) {
    $types = ["image/jpeg" => "jpg", "image/png" => "png", "image/webp" => "webp"];
    $info = @getimagesize($file["tmp_name"]);
    if (!$info || !isset($types[$info["mime"]]) || $file["size"] > 3 * 1024 * 1024) {
        back("error=image");
    }
    $dir = __DIR__ . "/../../public/images";
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }
    $fileName = bin2hex(random_bytes(8)) . "." . $types[$info["mime"]];
    if (!move_uploaded_file($file["tmp_name"], $dir . "/" . $fileName)) {
        back("error=upload");
    }
    $image = "images/" . $fileName;
} 
elseif ($file && $file["error"] !== UPLOAD_ERR_NO_FILE) {
    back("error=upload");
} 
elseif ($imageUrl !== "") {
    $scheme = strtolower((string) parse_url($imageUrl, PHP_URL_SCHEME));
    if (!filter_var($imageUrl, FILTER_VALIDATE_URL)
        || !in_array($scheme, ["http", "https"], true)
        || strlen($imageUrl) > 1000) {
        back("error=image");
    }
    $image = $imageUrl;
}
$price = (int) $priceRaw;
$stock = (int) $stockRaw;
$variantValue = $variant === "" ? null : $variant;
$descriptionValue = $description === "" ? null : $description;
$stmt = $conn->prepare(
    "INSERT INTO products (category, series, name, variant, description, image, price, stock, status)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
);
$stmt->bind_param("ssssssiis", $category, $series, $name, $variantValue, $descriptionValue, $image, $price, $stock, $status);
$stmt->execute();
back("added=1");