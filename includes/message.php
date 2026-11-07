<?php
$messages = [
    "login"    => "Invalid email or password.",
    "name"     => "Enter your name (maximum 30 characters).",
    "email"    => "Enter a valid email.",
    "password" => "Password must be at least 8 characters with a number and a special character.",
    "confirm"  => "Please click the confirmation box.",
    "exists"   => "This email is already registered.",
];
if (isset($_GET["error"]) && isset($messages[$_GET["error"]])) {
    echo '<p class="error">' . $messages[$_GET["error"]] . '</p>';
}
if (isset($_GET["registered"])) {
    echo '<p class="success">Account created! Please log in.</p>';
}