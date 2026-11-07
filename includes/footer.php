<?php
header('Content-Type: text/html; charset=utf-8');
$year = date('Y');
?>
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-brand">
            <strong>I Store</strong>
            <p>Apple products, all in one place.</p>
        </div>
        <div class="footer-col">
            <h4>Shop</h4>
            <a href="iphone.html">iPhone</a>
            <a href="macbook.html">MacBook</a>
            <a href="tablet.html">Tablets</a>
            <a href="earbuds.html">Earbuds</a>
            <a href="charger.html">Chargers</a>
        </div>
        <div class="footer-col">
            <h4>Account</h4>
            <a href="dashboard.html">Dashboard</a>
            <a href="profile.html">Profile</a>
            <a href="../../includes/logout.php">Log out</a>
        </div>
    </div>
    <p class="footer-copy">&copy; <?= $year ?> I Store. All rights reserved.</p>
</footer>