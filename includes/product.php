<?php
$active = $active ?? "";
$navLinks = [
    "dashboard" => ["Home", "dashboard.php"],
    "iphone" => ["iPhone", "iphone.php"],
    "macbook" => ["MacBook", "macbook.php"],
    "tablets" => ["Tablets", "tablet.php"],
    "earbuds" => ["Earbuds", "earbuds.php"],
    "chargers" => ["Chargers", "charger.php"]
];
$navName = $_SESSION["user_name"] ?? "Account";
?>
<header class="nav">
    <div class="nav-inner">
        <a class="brand" href="dashboard.php">I Store</a>
        <nav class="nav-links">
            <?php
            foreach ($navLinks as $key => $link) {
                $label = $link[0];
                $href = $link[1];
                if ($active == $key) {
                    $class = "active";
                } 
                else {
                    $class = "";
                }
                echo '<a href="' . $href . '" class="' . $class . '">';
                echo $label;
                echo '</a>';
            }
            ?>
            <?php
            if (($_SESSION["user_role"] ?? "") == "admin") {
                $class = "";
                if ($active == "admin") {
                    $class = "active";
                }
                echo '<a href="admin.php" class="admin-link ' . $class . '">';
                echo 'Admin';
                echo '</a>';
            }
            ?>
        </nav>
        <div class="nav-user">
            <a href="profile.php" class="<?php
                if ($active == "profile") {
                    echo "active";
                }
            ?>"><?php echo htmlspecialchars($navName); ?></a>
            <a href="../../includes/logout.php" class="logout">
                Log out
            </a>
        </div>
    </div>
</header>