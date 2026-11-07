# I Store

I Store is a web-based online store for Apple products (iPhone, MacBook, Tablets, Earbuds and Chargers). Customers can create an account, browse the catalog, save favourites and place orders. Admins can manage products, stock, users and orders from a dedicated admin panel.

The front end is plain HTML, CSS and JavaScript. The back end is PHP with a MySQL database, and the pages talk to small PHP endpoints using `fetch()` and JSON.

---

## Features

### Customer
- **Sign up / Log in / Log out** with form validation (name up to 30 characters, valid email, password of at least 8 characters containing a number and a special character). Passwords are stored hashed.
- **Dashboard** showing total products, in-stock products and number of categories, with a tile for each category and a search across the whole catalog.
- **Category pages** for iPhone, MacBook, Tablets, Earbuds and Chargers, with a Show/Hide button, search, and products grouped by series. Items marked "coming soon" or out of stock cannot be bought.
- **Favourites**: save a product with a description, a reason, a priority (Low / Medium / High) and personal notes. View all favourites on one page and remove a product from favourites.
- **Checkout**: choose a quantity (1 to 10), enter delivery details (name, phone, address, city, CNIC), pick a payment method (JazzCash, Easypaisa or Bank Transfer), see the store's payment details with copy buttons, and enter the transaction ID. The order is saved with the status `pending` and the stock is reduced.
- **Profile**: update your name and change your password.

### Admin
- **Overview** with the number of accounts, new accounts in the last 7 days, admins and purchases.
- **Add product** (name, category, series, variant, description, price, stock, status) with an image upload or an image link.
- **User management**: search users and change a user's role between `user` and `admin` (an admin cannot change their own role).
- **Stock management**: search and filter products by category, show low stock only (5 or fewer), and edit stock, price and status.
- **Order management**: search and filter orders, view the items and payment details, and update the order status (`pending`, `confirmed`, `shipped`, `delivered`, `cancelled`). Cancelling an order returns its items to stock, and a cancelled order cannot be reopened.

---

## Technologies Used

| Layer | Technology |
|-------|------------|
| Front end | HTML5, CSS3, JavaScript (vanilla, `fetch` API) |
| Back end | PHP (mysqli with prepared statements, sessions) |
| Database | MySQL 8 |
| Web server | Apache (LAMP stack) or the PHP built-in server |

---

## Project Structure

```
istore/
├── config/
│   ├── database.php        # Database connection settings
│   └── payment.php         # Payment method details shown at checkout
├── database/
│   └── istore.sql          # Database structure and data
├── includes/               # PHP back end (endpoints)
│   ├── admin/              # Admin-only endpoints
│   ├── favourite/          # Favourites endpoints
│   ├── login.php, signup.php, logout.php, profile.php
│   ├── product_list.php, dashboard_stats.php, user.php
│   ├── checkout_product.php, order_place.php
│   └── session.php, auth.php, footer.php
├── public/
│   ├── css/                # Stylesheets
│   ├── html/               # Pages (login, signup, dashboard, categories, checkout, admin ...)
│   └── js/app.js           # Front-end logic for all pages
└── README.md
```

---

## Setup Instructions (LAMP on Ubuntu/Debian)

These steps assume a Linux machine with a terminal. LAMP stands for Linux, Apache, MySQL and PHP.

### 1. Install Apache, MySQL, PHP and Git

```bash
sudo apt update
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql git -y
```

Make sure Apache and MySQL are running:

```bash
sudo systemctl start apache2
sudo systemctl start mysql
```

### 2. Get the project

Clone the repository into Apache's web folder:

```bash
cd /var/www/html
sudo git clone <your-repository-url> istore
```

Replace `<your-repository-url>` with the HTTPS link of this repository (the green **Code** button on GitHub).

### 3. Create the database and import the data

Open the MySQL shell:

```bash
sudo mysql
```

Run the following, replacing `your_password` with a password of your choice:

```sql
CREATE DATABASE istore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'authuser'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON istore.* TO 'authuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Import the database file:

```bash
sudo mysql istore < /var/www/html/istore/database/istore.sql
```

### 4. Configure the database connection

Open `config/database.php` and make sure the values match the database and user you just created:

```bash
sudo nano /var/www/html/istore/config/database.php
```

```php
$host = "localhost";
$username = "authuser";
$password = "your_password";   // the password you chose in step 3
$database = "istore";
```

Save with `Ctrl + O`, press `Enter`, then exit with `Ctrl + X`.

### 5. Allow image uploads (admin "Add product")

The admin panel can upload product photos into `public/images`. Create that folder and give Apache permission to write to it:

```bash
sudo mkdir -p /var/www/html/istore/public/images
sudo chown -R www-data:www-data /var/www/html/istore/public/images
```

### 6. Open the website

You can run I Store in two ways. Both use the same MySQL database from steps 3 and 4.

#### Option A: Apache (LAMP)

If the project is in `/var/www/html/istore`, Apache already serves it. Open:

```
http://localhost/istore/public/html/login.html
```

#### Option B: PHP built-in server (no Apache needed)

This is handy for quick testing and development. MySQL is still required, because the built-in server only replaces Apache.

1. Install PHP, the MySQL extension and MySQL (skip anything you already have):

```bash
sudo apt install php-cli php-mysql mysql-server git -y
sudo systemctl start mysql
```

2. Check that the `mysqli` extension is available:

```bash
php -m | grep mysqli
```

3. Clone the project anywhere (your home folder is fine) and go into it:

```bash
cd ~
git clone <your-repository-url> istore
cd istore
```

4. Do steps 3 and 4 above to create the database, import it and edit `config/database.php`. From inside the project folder the import command is:

```bash
sudo mysql istore < database/istore.sql
```

5. Create the image upload folder. No `chown` is needed, because the server runs as your own user:

```bash
mkdir -p public/images
```

6. Start the server **from the project root** (the `istore` folder, not `public`):

```bash
php -S localhost:8000
```

7. Open this in your browser:

```
http://localhost:8000/public/html/login.html
```

8. Stop the server with `Ctrl + C` in the terminal.

**Notes**
- Run the command from the project root. The pages call the PHP endpoints in `includes/`, which would not be reachable if you started the server inside `public/`.
- If port 8000 is busy, use another one, e.g. `php -S localhost:8080`, and change the port in the URL.
- The built-in server is for development only. Use Apache for anything public.
- Making an account an admin works the same in both options (see **How to Use**).

---

## How to Use

### As a customer
1. Open `signup.html`, create an account, then log in.
2. On the **Dashboard**, pick a category tile or search the whole catalog.
3. On a category page, click **Show** (or search) to list the products.
4. Click **Favourite** to save a product with your notes, or **Buy** to go to checkout.
5. At checkout, fill in your delivery details, choose a payment method, enter your transaction ID and click **Place order**.
6. Use the **Favourites** link in the menu to see your saved products, and your name in the top right to open your **Profile**.

### As an admin
New accounts are created with the `user` role. To make an account an admin, sign up first, then run this in MySQL (replace the email with yours):

```bash
sudo mysql istore -e "UPDATE users SET role = 'admin' WHERE email = 'your-email@example.com';"
```

Log in again and an **Admin** link appears in the menu. From the admin panel you can view stats, add products, manage users, update stock and prices, and process orders.

---

## Database

The database is called `istore`. The tables the application uses are:

- `users`: accounts, hashed passwords and roles
- `products`: the catalog (category, series, name, variant, price, stock, status, image)
- `orders` and `order_items`: customer orders and what each order contains
- `wishlist`: favourite products with the user's description, reason, priority and notes

The schema also contains `cart_items` and `reviews` tables, which the current interface does not use.