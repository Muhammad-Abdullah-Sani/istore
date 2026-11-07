<?php
ini_set("session.use_cookies", 1);
ini_set("session.use_strict_mode", 1);
ini_set("session.cookie_httponly", 1);
ini_set("session.cookie_samesite", "Lax");
ini_set("session.cookie_secure", 0);
ini_set("session.gc_maxlifetime", 1800);
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
?>