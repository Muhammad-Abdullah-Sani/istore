document.addEventListener("DOMContentLoaded", function () {
  var page = document.body.dataset.page;
  loadNav();
  loadFooter();
  if (page === "product") {
    initProductPage();
  } else if (page === "admin") {
    initAdminPage();
  } else if (page === "dashboard") {
    initDashboardPage();
  } else if (page === "profile") {
    initProfilePage();
  } else if (page === "checkout") {
    initCheckoutPage();
  } else if (page === "add-favourite") {
    initAddFavouritePage();
  } else if (page === "favourites") {
    initFavouritesPage();
  } else if (page === "login" || page === "signup") {
    showAuthMessage();
  }
});

function el(tag, className, text) {
  var node = document.createElement(tag);
  if (className) {
    node.className = className;
  }
  if (text !== undefined) {
    node.textContent = text;
  }
  return node;
}

function loadNav() {
  var nameEl = document.getElementById("nav-name");

  if (!nameEl) {
    return;
  }

  fetch("../../includes/user.php", { credentials: "same-origin" })
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }

      return res.json();
    })
    .then(function (user) {
      if (!user) {
        return;
      }

      nameEl.textContent = user.name;

      var welcome = document.getElementById("welcome-name");

      if (welcome) {
        welcome.textContent = user.name;
      }

      var nav = document.querySelector(".nav-links");

      if (nav) {
        var oldFavouriteLinks = nav.querySelectorAll(
          'a[href="favourites.html"], .favourite-link',
        );

        oldFavouriteLinks.forEach(function (link) {
          link.remove();
        });

        var favouriteLink = el("a", "favourite-link", "Favourites");
        favouriteLink.href = "favourites.html";
        nav.appendChild(favouriteLink);
      }

      document.querySelectorAll(".admin-link").forEach(function (a) {
        a.hidden = false;

        if (user.role !== "admin" && !a.dataset.accessChecked) {
          a.dataset.accessChecked = "true";

          a.addEventListener("click", function (e) {
            e.preventDefault();
            alert("You can't access this page.");
          });
        }
      });
    })
    .catch(function (error) {
      console.log("Navigation error:", error);
    });
}

function loadFooter() {
  var holder = document.getElementById("site-footer");
  if (!holder) {
    return;
  }

  fetch("../../includes/footer.php", { credentials: "same-origin" })
    .then(function (res) {
      if (!res.ok) {
        throw new Error("request failed");
      }
      return res.text();
    })
    .then(function (html) {
      holder.innerHTML = html;
    })
    .catch(function () {});
}

function showAuthMessage() {
  var params = new URLSearchParams(window.location.search);
  var box = document.getElementById("messages");
  var bad = {
    login: "Invalid email or password.",
    name: "Enter your name (maximum 30 characters).",
    email: "Enter a valid email.",
    password:
      "Password must be at least 8 characters with a number and a special character.",
    confirm: "Please click the confirmation box.",
    exists: "This email is already registered.",
  };

  if (!box) {
    return;
  }
  if (params.get("registered")) {
    box.replaceChildren(el("p", "success", "Account created! Please log in."));
  } else if (bad[params.get("error")]) {
    box.replaceChildren(el("p", "error", bad[params.get("error")]));
  }
}

function showProfileMessage() {
  var params = new URLSearchParams(window.location.search);
  var box = document.getElementById("messages");
  var good = {
    name: "Name updated.",
    password: "Password changed.",
  };
  var bad = {
    name: "Enter your name (maximum 30 characters).",
    current: "Current password is wrong.",
    password:
      "New password must be at least 8 characters with a number and a special character.",
    mismatch: "New passwords do not match.",
    action: "Something went wrong. Try again.",
  };

  if (!box) {
    return;
  }
  if (good[params.get("updated")]) {
    box.replaceChildren(el("p", "success", good[params.get("updated")]));
  } else if (bad[params.get("error")]) {
    box.replaceChildren(el("p", "error", bad[params.get("error")]));
  }
}

function initProfilePage() {
  document.body.classList.remove("loading");
  showProfileMessage();

  fetch("../../includes/user.php", { credentials: "same-origin" })
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }
      return res.json();
    })
    .then(function (user) {
      if (!user) {
        return;
      }
      document.getElementById("profile-name").textContent = user.name;
      document.getElementById("profile-email").textContent = user.email;
      document.getElementById("profile-since").textContent = String(
        user.created_at,
      ).slice(0, 10);
      document.getElementById("avatar").textContent = user.name
        .charAt(0)
        .toUpperCase();
      document.getElementById("name").value = user.name;
    })
    .catch(function () {
      alert("Could not load profile.");
    });
}

function showAdminMessage() {
  var params = new URLSearchParams(window.location.search);
  var box = document.getElementById("messages");

  if (!box) {
    return;
  }
  if (params.get("added")) {
    box.replaceChildren(el("p", "success", "Product added."));
  } else if (params.get("error")) {
    box.replaceChildren(
      el(
        "p",
        "error",
        "Could not add product (" +
          params.get("error") +
          "). Check the fields and try again.",
      ),
    );
  }
}

function initAdminPage() {
  document.body.classList.remove("loading");
  showAdminMessage();
  initUsersTable();
  initStockTable();
  initOrdersTable();

  fetch("../../includes/admin/admin_stats.php", { credentials: "same-origin" })
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }
      if (res.status === 403) {
        alert("You can't access this page.");
        window.location.href = "dashboard.html";
        return null;
      }
      if (!res.ok) {
        throw new Error("request failed");
      }
      return res.json();
    })
    .then(function (stats) {
      if (!stats) {
        return;
      }
      document.getElementById("stat-accounts").textContent = stats.accounts;
      document.getElementById("stat-week").textContent = stats.week;
      document.getElementById("stat-admins").textContent = stats.admins;
      document.getElementById("stat-orders").textContent = stats.orders;
    })
    .catch(function () {
      alert("Could not load admin stats.");
    });
}

function initUsersTable() {
  var body = document.getElementById("users-body");
  var form = document.getElementById("search-form");
  var input = form ? form.querySelector("input[name='q']") : null;
  var me = 0;
  var lastQuery = "";

  if (!body || !form || !input) {
    return;
  }

  function render(users) {
    body.replaceChildren();

    if (users.length === 0) {
      var emptyRow = el("tr");
      var emptyCell = el("td", "empty", "No users found.");
      emptyCell.colSpan = 5;
      emptyRow.appendChild(emptyCell);
      body.appendChild(emptyRow);
      return;
    }

    users.forEach(function (u) {
      var tr = el("tr");
      var roleCell = el("td");

      roleCell.appendChild(el("span", "role", u.role + " "));

      if (u.id === me) {
        roleCell.appendChild(el("em", "you", "(you)"));
      } else {
        var btn = el(
          "button",
          "btn",
          u.role === "admin" ? "Remove admin" : "Make admin",
        );
        btn.type = "button";
        btn.dataset.id = u.id;
        btn.dataset.role = u.role === "admin" ? "user" : "admin";
        btn.dataset.name = u.name;
        roleCell.appendChild(btn);
      }

      tr.appendChild(el("td", null, String(u.id)));
      tr.appendChild(el("td", null, u.name));
      tr.appendChild(el("td", null, u.email));
      tr.appendChild(roleCell);
      tr.appendChild(el("td", null, String(u.created_at).slice(0, 10)));
      body.appendChild(tr);
    });
  }

  function load(q) {
    lastQuery = q;

    fetch("../../includes/admin/admin_users.php?q=" + encodeURIComponent(q), {
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 401 || res.status === 403) {
          return null;
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function (data) {
        if (data) {
          me = data.me;
          render(data.users);
        }
      })
      .catch(function () {
        alert("Could not load users.");
      });
  }

  function changeRole(btn) {
    var data = new URLSearchParams();
    data.append("user_id", btn.dataset.id);
    data.append("role", btn.dataset.role);
    btn.disabled = true;

    fetch("../../includes/admin/admin_user_role.php", {
      method: "POST",
      body: data,
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 409) {
          throw new Error("self");
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function () {
        load(lastQuery);
      })
      .catch(function (err) {
        if (err.message === "self") {
          alert("You can't change your own role.");
        } else {
          alert("Could not change role. Try again.");
        }
        btn.disabled = false;
      });
  }

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    load(input.value.trim());
  });

  body.addEventListener("click", function (e) {
    var btn = e.target.closest("button[data-id]");
    if (!btn) {
      return;
    }
    var action =
      btn.dataset.role === "admin" ? "make admin" : "remove admin from";
    if (confirm("Do you want to " + action + " " + btn.dataset.name + "?")) {
      changeRole(btn);
    }
  });

  load("");
}

function initStockTable() {
  var body = document.getElementById("stock-body");
  var form = document.getElementById("stock-form");
  var summary = document.getElementById("stock-summary");
  var limit = 5;

  if (!body || !form) {
    return;
  }

  var qInput = form.querySelector("input[name='q']");
  var catSelect = form.querySelector("select[name='category']");
  var lowBox = form.querySelector("input[name='low']");

  function setBadge(wrap, stock) {
    wrap.replaceChildren();
    if (stock <= 0) {
      wrap.appendChild(el("span", "badge out", " Out of stock"));
    } else if (stock <= limit) {
      wrap.appendChild(el("span", "badge low", " Low stock"));
    }
  }

  function makeRow(p) {
    var tr = el("tr");
    var nameCell = el("td");
    var stockCell = el("td");
    var priceCell = el("td");
    var statusCell = el("td");
    var saveCell = el("td");

    var stockInput = el("input", "stock-input");
    stockInput.type = "number";
    stockInput.min = "0";
    stockInput.value = p.stock;
    stockInput.dataset.field = "stock";

    var badge = el("span", "badge-wrap");
    setBadge(badge, p.stock);

    var priceInput = el("input", "price-input");
    priceInput.type = "number";
    priceInput.min = "0";
    priceInput.value = p.price;
    priceInput.dataset.field = "price";

    var statusSelect = el("select");
    statusSelect.dataset.field = "status";
    [
      ["available", "Available"],
      ["coming_soon", "Coming soon"],
    ].forEach(function (o) {
      var opt = el("option", null, o[1]);
      opt.value = o[0];
      statusSelect.appendChild(opt);
    });
    statusSelect.value = p.status;

    var saveBtn = el("button", "btn", "Save");
    saveBtn.type = "button";
    saveBtn.dataset.save = "1";

    tr.dataset.id = p.id;
    nameCell.appendChild(el("strong", null, p.name));
    nameCell.appendChild(
      el("div", "muted", p.series + (p.variant ? " \u00B7 " + p.variant : "")),
    );
    stockCell.appendChild(stockInput);
    stockCell.appendChild(badge);
    priceCell.appendChild(priceInput);
    statusCell.appendChild(statusSelect);
    saveCell.appendChild(saveBtn);

    tr.appendChild(nameCell);
    tr.appendChild(el("td", null, p.category));
    tr.appendChild(stockCell);
    tr.appendChild(priceCell);
    tr.appendChild(statusCell);
    tr.appendChild(saveCell);
    return tr;
  }

  function render(products) {
    body.replaceChildren();

    if (products.length === 0) {
      var emptyRow = el("tr");
      var emptyCell = el("td", "empty", "No products found.");
      emptyCell.colSpan = 6;
      emptyRow.appendChild(emptyCell);
      body.appendChild(emptyRow);
      return;
    }

    products.forEach(function (p) {
      body.appendChild(makeRow(p));
    });
  }

  function load() {
    var params = new URLSearchParams();
    params.append("q", qInput.value.trim());
    params.append("category", catSelect.value);
    if (lowBox.checked) {
      params.append("low", "1");
    }

    fetch("../../includes/admin/admin_products.php?" + params.toString(), {
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 401 || res.status === 403) {
          return null;
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function (data) {
        if (!data) {
          return;
        }
        limit = data.low_limit;
        if (summary) {
          summary.textContent =
            "Low or out of stock (" + limit + " or fewer): " + data.low_count;
        }
        render(data.products);
      })
      .catch(function () {
        alert("Could not load stock.");
      });
  }

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    load();
  });

  body.addEventListener("click", function (e) {
    var btn = e.target.closest("button[data-save]");
    if (!btn) {
      return;
    }

    var tr = btn.closest("tr");
    var stock = tr.querySelector("[data-field='stock']").value;
    var price = tr.querySelector("[data-field='price']").value;
    var status = tr.querySelector("[data-field='status']").value;
    var data = new URLSearchParams();

    data.append("id", tr.dataset.id);
    data.append("stock", stock);
    data.append("price", price);
    data.append("status", status);
    btn.disabled = true;

    fetch("../../includes/admin/admin_product_update.php", {
      method: "POST",
      body: data,
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 400) {
          throw new Error("input");
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function () {
        setBadge(tr.querySelector(".badge-wrap"), parseInt(stock, 10));
        btn.textContent = "Saved";
        setTimeout(function () {
          btn.textContent = "Save";
          btn.disabled = false;
        }, 1200);
      })
      .catch(function (err) {
        if (err.message === "input") {
          alert("Stock and price must be whole numbers (0 or more).");
        } else {
          alert("Could not save. Try again.");
        }
        btn.disabled = false;
      });
  });

  load();
}

function initDashboardPage() {
  document.body.classList.remove("loading");
  fetch("../../includes/dashboard_stats.php", { credentials: "same-origin" })
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }
      if (!res.ok) {
        throw new Error("request failed");
      }
      return res.json();
    })
    .then(function (stats) {
      if (!stats) {
        return;
      }
      document.getElementById("stat-total").textContent = stats.total;
      document.getElementById("stat-instock").textContent = stats.in_stock;
      document.getElementById("stat-cats").textContent = stats.categories;

      document.querySelectorAll("[data-count]").forEach(function (tile) {
        var n = stats.counts[tile.dataset.count] || 0;
        tile.textContent = n + (n === 1 ? " item \u203A" : " items \u203A");
      });
    })
    .catch(function () {
      alert("Could not load dashboard stats.");
    });

  /* ---------- Full catalog search (saari categories mein) ---------- */

  var form = document.getElementById("search-form");
  var box = document.getElementById("products");
  var pages = {
    iphone: "iphone.html",
    macbook: "macbook.html",
    tablets: "tablet.html",
    earbuds: "earbuds.html",
    chargers: "charger.html",
  };
  var labels = {
    iphone: "iPhone",
    macbook: "MacBook",
    tablets: "Tablets",
    earbuds: "Earbuds",
    chargers: "Chargers",
  };

  function makeResult(p) {
    var card = el("article", "card");
    var imgWrap = el("a", "card-img");
    var body = el("div", "card-body");
    var actions = el("div", "card-actions");
    var link = el("a", "btn", "View in " + labels[p.category] + " \u2192");

    imgWrap.href = pages[p.category];
    link.href = pages[p.category];

    if (p.image) {
      var img = el("img");
      img.alt = p.name;
      img.loading = "lazy";
      img.referrerPolicy = "no-referrer";
      img.src = /^https?:\/\//i.test(p.image) ? p.image : "../" + p.image;
      img.addEventListener("error", function () {
        imgWrap.classList.add("no-img");
        imgWrap.textContent = "No image";
      });
      imgWrap.appendChild(img);
    } else {
      imgWrap.classList.add("no-img");
      imgWrap.textContent = "No image";
    }

    body.appendChild(el("h3", "card-name", p.name));
    if (p.variant) {
      body.appendChild(el("p", "card-variant", p.variant));
    }
    body.appendChild(
      el("p", "card-price", "Rs " + p.price.toLocaleString("en-PK")),
    );

    if (p.status === "coming_soon") {
      body.appendChild(el("p", "card-status", "Coming soon"));
    } else if (p.stock <= 0) {
      body.appendChild(el("p", "card-status", "Out of stock"));
    }

    actions.appendChild(link);
    card.appendChild(imgWrap);
    card.appendChild(body);
    card.appendChild(actions);
    return card;
  }

  function showResults(list, q) {
    if (list.length === 0) {
      box.replaceChildren(
        el("p", "empty", "No products found for \u201C" + q + "\u201D."),
      );
      return;
    }

    var grid = el("div", "cards");
    list.forEach(function (p) {
      grid.appendChild(makeResult(p));
    });

    box.replaceChildren(
      el(
        "p",
        "result-count",
        list.length +
          (list.length === 1 ? " result" : " results") +
          " for \u201C" +
          q +
          "\u201D",
      ),
      grid,
    );
  }

  if (form && box) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      var q = form.elements.q.value.trim();

      if (q === "") {
        box.replaceChildren();
        return;
      }

      box.replaceChildren(el("p", "empty", "Searching..."));

      Promise.all(
        Object.keys(pages).map(function (cat) {
          return fetch(
            "../../includes/product_list.php?category=" +
              encodeURIComponent(cat) +
              "&q=" +
              encodeURIComponent(q),
            { credentials: "same-origin" },
          ).then(function (res) {
            if (res.status === 401) {
              window.location.href = "login.html";
              return [];
            }
            if (!res.ok) {
              throw new Error("request failed");
            }
            return res.json();
          });
        }),
      )
        .then(function (lists) {
          showResults([].concat.apply([], lists), q);
        })
        .catch(function () {
          box.replaceChildren(el("p", "empty", "Could not search products."));
        });
    });
  }
}

function initProductPage() {
  var category = document.body.dataset.category;
  var showBtn = document.getElementById("show-btn");
  var form = document.getElementById("search-form");
  var input = document.getElementById("search-input");
  var box = document.getElementById("products");
  var shown = false;

  document.body.classList.remove("loading");

  if (!showBtn || !form || !input || !box) {
    return;
  }

  function loadProducts(q) {
    var url =
      "../../includes/product_list.php?category=" +
      encodeURIComponent(category) +
      "&q=" +
      encodeURIComponent(q);

    box.hidden = false;
    box.replaceChildren(el("p", "empty", "Loading..."));

    fetch(url, { credentials: "same-origin" })
      .then(function (res) {
        if (res.status === 401) {
          window.location.href = "login.html";
          return null;
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function (list) {
        if (list) {
          renderProducts(list);
        }
      })
      .catch(function () {
        box.replaceChildren(el("p", "empty", "Could not load products."));
      });
  }

  function renderProducts(list) {
    var groups = {};
    var order = [];

    if (list.length === 0) {
      box.replaceChildren(el("p", "empty", "No products found."));
      return;
    }

    list.forEach(function (p) {
      if (!groups[p.series]) {
        groups[p.series] = [];
        order.push(p.series);
      }
      groups[p.series].push(p);
    });

    box.replaceChildren();

    order.forEach(function (series) {
      var section = el("section", "series-group");
      var grid = el("div", "cards");

      section.appendChild(el("h2", "series-title", series));
      groups[series].forEach(function (p) {
        grid.appendChild(makeCard(p));
      });
      section.appendChild(grid);
      box.appendChild(section);
    });
  }

  function makeCard(p) {
    var card = el("article", "card");
    var imgWrap = el("div", "card-img");
    var body = el("div", "card-body");
    var actions = el("div", "card-actions");
    var buyBtn = el("button", "btn buy", "Buy");
    var favBtn = el("button", "btn fav");

    card.dataset.id = p.id;

    if (p.image) {
      var img = el("img");
      img.alt = p.name;
      img.loading = "lazy";
      img.referrerPolicy = "no-referrer";
      img.src = /^https?:\/\//i.test(p.image) ? p.image : "../" + p.image;
      img.addEventListener("error", function () {
        imgWrap.classList.add("no-img");
        imgWrap.textContent = "No image";
      });
      imgWrap.appendChild(img);
    } else {
      imgWrap.classList.add("no-img");
      imgWrap.textContent = "No image";
    }

    body.appendChild(el("h3", "card-name", p.name));
    if (p.variant) {
      body.appendChild(el("p", "card-variant", p.variant));
    }
    body.appendChild(
      el("p", "card-price", "Rs " + p.price.toLocaleString("en-PK")),
    );

    if (p.status === "coming_soon") {
      body.appendChild(el("p", "card-status", "Coming soon"));
      buyBtn.disabled = true;
    } else if (p.stock <= 0) {
      body.appendChild(el("p", "card-status", "Out of stock"));
      buyBtn.disabled = true;
    }

    buyBtn.type = "button";
    buyBtn.dataset.action = "buy";

    favBtn.type = "button";
    favBtn.dataset.action = "favourite";
    if (p.is_favourite) {
      favBtn.classList.add("active");
      favBtn.textContent = "\u2665 Favourite";
    } else {
      favBtn.textContent = "\u2661 Favourite";
    }

    actions.appendChild(buyBtn);
    actions.appendChild(favBtn);

    card.appendChild(imgWrap);
    card.appendChild(body);
    card.appendChild(actions);
    return card;
  }

  function toggleFavourite(productId, btn) {
    var data = new URLSearchParams();
    data.append("product_id", productId);
    btn.disabled = true;

    fetch("../../includes/favourite/favourite.php", {
      method: "POST",
      body: data,
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 401) {
          window.location.href = "login.html";
          return null;
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function (result) {
        if (!result) {
          return;
        }
        btn.classList.toggle("active", result.favourite);
        btn.textContent = result.favourite
          ? "\u2665 Favourite"
          : "\u2661 Favourite";
      })
      .catch(function (err) {
        console.error(err);
        alert("Could not update favourite. Try again.");
      })
      .finally(function () {
        btn.disabled = false;
      });
  }

  function addToCart(productId, btn) {
    var data = new URLSearchParams();
    data.append("product_id", productId);
    btn.disabled = true;

    fetch("../../includes/cart_add.php", {
      method: "POST",
      body: data,
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 401) {
          window.location.href = "login.html";
          return null;
        }
        if (res.status === 409) {
          throw new Error("stock");
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function (result) {
        if (!result) {
          return;
        }
        btn.textContent = "Added (" + result.quantity + ")";
        setTimeout(function () {
          btn.textContent = "Buy";
          btn.disabled = false;
        }, 1500);
      })
      .catch(function (err) {
        console.error(err);
        if (err.message === "stock") {
          alert("This product is out of stock.");
        } else {
          alert("Could not add to cart. Try again.");
        }
        btn.disabled = false;
      });
  }

  showBtn.addEventListener("click", function () {
    if (shown) {
      box.hidden = true;
      shown = false;
      showBtn.textContent = "Show";
      return;
    }
    shown = true;
    showBtn.textContent = "Hide";
    loadProducts(input.value.trim());
  });

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    shown = true;
    showBtn.textContent = "Hide";
    loadProducts(input.value.trim());
  });

  box.addEventListener("click", function (e) {
    var btn = e.target.closest("button[data-action]");
    if (!btn) {
      return;
    }
    var card = btn.closest(".card");

    if (btn.dataset.action === "favourite") {
      if (btn.classList.contains("active")) {
        toggleFavourite(card.dataset.id, btn);
      } else {
        window.location.href = "add-favourite.html?product=" + card.dataset.id;
      }
    } else if (btn.dataset.action === "buy") {
      window.location.href = "checkout.html?product=" + card.dataset.id;
    }
  });
}
function initCheckoutPage() {
  var productId = new URLSearchParams(window.location.search).get("product");
  var messages = document.getElementById("messages");
  var summary = document.getElementById("order-summary");
  var form = document.getElementById("checkout-form");
  var success = document.getElementById("order-success");
  var details = document.getElementById("payment-details");
  var qtyInput = document.getElementById("quantity");
  var placeBtn = document.getElementById("place-btn");
  var product = null;
  var payment = {};
  var errors = {
    quantity: "Choose a quantity between 1 and 10.",
    full_name: "Enter your full name.",
    phone: "Enter a valid phone number.",
    address: "Enter your full address (at least 10 characters).",
    city: "Enter your city.",
    cnic: "Enter a valid 13-digit CNIC.",
    payment_method: "Choose a payment method.",
    transaction_id: "Enter the transaction ID (6 to 60 letters or numbers).",
  };

  function money(n) {
    return "Rs " + n.toLocaleString("en-PK");
  }

  function showError(text) {
    messages.replaceChildren(el("p", "error", text));
    window.scrollTo(0, 0);
  }

  function currentQty() {
    var q = parseInt(qtyInput.value, 10);
    return q > 0 ? q : 1;
  }

  function currentTotal() {
    return product.price * currentQty();
  }

  function renderPaymentDetails() {
    var chosen = form.querySelector("input[name=payment_method]:checked");
    var info = chosen ? payment[chosen.value] : null;

    details.replaceChildren();

    if (!info) {
      return;
    }

    var card = el("div", "payment-card");

    card.appendChild(el("h3", "", info.title + " Payment"));
    card.appendChild(
      el(
        "p",
        "",
        "Please send " + money(currentTotal()) + " to the following account.",
      ),
    );

    function addDetail(label, value) {
      var row = el("div", "payment-detail");
      var text = el("div", "payment-detail-info");

      text.appendChild(el("span", "payment-label", label));
      text.appendChild(el("strong", "payment-value", value));

      var copyBtn = el("button", "copy-btn", "Copy");
      copyBtn.type = "button";

      copyBtn.addEventListener("click", function () {
        navigator.clipboard.writeText(value);
        copyBtn.textContent = "Copied!";

        setTimeout(function () {
          copyBtn.textContent = "Copy";
        }, 1500);
      });

      row.appendChild(text);
      row.appendChild(copyBtn);
      card.appendChild(row);
    }

    addDetail("Account title", info.account_title);

    if (info.bank) {
      addDetail("Bank", info.bank);
    }

    addDetail("Account number", info.number);

    if (info.iban) {
      addDetail("IBAN", info.iban);
    }

    details.appendChild(card);
  }
  function renderTotal() {
    var t = document.getElementById("order-total");
    if (t) {
      t.textContent = "Total: " + money(currentTotal());
    }
    renderPaymentDetails();
  }

  function renderSummary() {
    var total = el("p", "", "Total: " + money(product.price));
    total.id = "order-total";
    summary.replaceChildren(
      el("h2", "", "Your order"),
      el(
        "p",
        "",
        product.name + (product.variant ? " \u00B7 " + product.variant : ""),
      ),
      el("p", "", "Price: " + money(product.price)),
      total,
    );
  }

  function showSuccess(result) {
    var link = el("a", "btn", "Continue shopping");
    link.href = "dashboard.html";

    messages.replaceChildren();
    summary.hidden = true;
    form.hidden = true;
    success.hidden = false;
    success.replaceChildren(
      el("h2", "", "Order placed successfully!"),
      el("p", "", "Order number: #" + result.order_id),
      el("p", "", "Total: " + money(result.total)),
      el(
        "p",
        "",
        "Your payment is pending verification. We will confirm your order after checking the transaction.",
      ),
      el("p", "", "Thank you for shopping with I Store."),
      link,
    );
    window.scrollTo(0, 0);
  }

  if (!productId) {
    showError("No product selected.");
    return;
  }

  fetch(
    "../../includes/checkout_product.php?id=" + encodeURIComponent(productId),
    {
      credentials: "same-origin",
    },
  )
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }
      if (res.status === 404) {
        throw new Error("missing");
      }
      if (!res.ok) {
        throw new Error("request failed");
      }
      return res.json();
    })
    .then(function (data) {
      if (!data) {
        return;
      }
      product = data.product;
      payment = data.payment;

      if (product.status !== "available" || product.stock <= 0) {
        showError("Sorry, this product is not available right now.");
        return;
      }
      qtyInput.max = Math.min(product.stock, 10);
      renderSummary();
      form.hidden = false;
    })
    .catch(function (err) {
      showError(
        err.message === "missing"
          ? "Product not found."
          : "Could not load this product. Try again.",
      );
    });

  qtyInput.addEventListener("input", renderTotal);

  form.addEventListener("change", function (e) {
    if (e.target.name === "payment_method") {
      renderPaymentDetails();
    }
  });

  form.addEventListener("submit", function (e) {
    var data = new URLSearchParams(new FormData(form));

    e.preventDefault();
    data.append("product_id", product.id);
    placeBtn.disabled = true;

    fetch("../../includes/order_place.php", {
      method: "POST",
      body: data,
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 401) {
          window.location.href = "login.html";
          return null;
        }
        return res.json().then(function (body) {
          return { ok: res.ok, status: res.status, body: body };
        });
      })
      .then(function (r) {
        if (!r) {
          return;
        }
        if (r.ok) {
          showSuccess(r.body);
        } else if (r.status === 409) {
          showError("Sorry, there is not enough stock for this quantity.");
        } else if (errors[r.body.error]) {
          showError(errors[r.body.error]);
        } else {
          showError("Could not place your order. Try again.");
        }
      })
      .catch(function () {
        showError("Could not place your order. Try again.");
      })
      .finally(function () {
        placeBtn.disabled = false;
      });
  });
}

function initOrdersTable() {
  var body = document.getElementById("orders-body");
  var form = document.getElementById("orders-form");
  var summary = document.getElementById("orders-summary");
  var statuses = ["pending", "confirmed", "shipped", "delivered", "cancelled"];
  var methods = {
    jazzcash: "JazzCash",
    easypaisa: "Easypaisa",
    bank_transfer: "Bank Transfer",
  };

  if (!body || !form) {
    return;
  }

  var qInput = form.querySelector("input[name='q']");
  var statusSelect = form.querySelector("select[name='status']");

  function money(n) {
    return "Rs " + n.toLocaleString("en-PK");
  }

  function makeRow(o) {
    var tr = el("tr");
    var customer = el("td");
    var itemsCell = el("td");
    var payCell = el("td");
    var statusCell = el("td");

    tr.dataset.id = o.id;

    customer.appendChild(el("strong", null, o.full_name));
    customer.appendChild(el("div", "muted", o.phone));
    customer.appendChild(el("div", "muted", o.address + ", " + o.city));
    if (o.email) {
      customer.appendChild(el("div", "muted", o.email));
    }

    o.items.forEach(function (it) {
      itemsCell.appendChild(
        el(
          "div",
          null,
          it.quantity +
            " x " +
            it.name +
            (it.variant ? " (" + it.variant + ")" : ""),
        ),
      );
    });

    payCell.appendChild(
      el("div", null, methods[o.payment_method] || o.payment_method),
    );
    payCell.appendChild(el("div", "muted", "ID: " + o.transaction_id));

    if (o.status === "cancelled") {
      statusCell.appendChild(el("span", "badge out", "cancelled"));
    } else {
      var select = el("select");
      select.dataset.field = "status";
      statuses.forEach(function (s) {
        var opt = el("option", null, s);
        opt.value = s;
        select.appendChild(opt);
      });
      select.value = o.status;

      var saveBtn = el("button", "btn", "Save");
      saveBtn.type = "button";
      saveBtn.dataset.save = "1";

      statusCell.appendChild(select);
      statusCell.appendChild(saveBtn);
    }

    tr.appendChild(el("td", null, "#" + o.id));
    tr.appendChild(el("td", null, String(o.created_at).slice(0, 16)));
    tr.appendChild(customer);
    tr.appendChild(itemsCell);
    tr.appendChild(el("td", null, money(o.total)));
    tr.appendChild(payCell);
    tr.appendChild(statusCell);
    return tr;
  }

  function render(orders) {
    body.replaceChildren();

    if (orders.length === 0) {
      var emptyRow = el("tr");
      var emptyCell = el("td", "empty", "No orders found.");
      emptyCell.colSpan = 7;
      emptyRow.appendChild(emptyCell);
      body.appendChild(emptyRow);
      return;
    }

    orders.forEach(function (o) {
      body.appendChild(makeRow(o));
    });
  }

  function load() {
    var params = new URLSearchParams();
    params.append("q", qInput.value.trim());
    params.append("status", statusSelect.value);

    fetch("../../includes/admin/admin_orders.php?" + params.toString(), {
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 401 || res.status === 403) {
          return null;
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function (data) {
        if (!data) {
          return;
        }
        if (summary) {
          summary.textContent =
            "Pending: " +
            data.counts.pending +
            " | Confirmed: " +
            data.counts.confirmed +
            " | Shipped: " +
            data.counts.shipped +
            " | Delivered: " +
            data.counts.delivered +
            " | Cancelled: " +
            data.counts.cancelled;
        }
        render(data.orders);
      })
      .catch(function () {
        alert("Could not load orders.");
      });
  }

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    load();
  });

  body.addEventListener("click", function (e) {
    var btn = e.target.closest("button[data-save]");
    if (!btn) {
      return;
    }

    var tr = btn.closest("tr");
    var status = tr.querySelector("[data-field='status']").value;
    var data = new URLSearchParams();

    if (
      status === "cancelled" &&
      !confirm(
        "Cancel order " +
          tr.firstChild.textContent +
          "? The stock will be returned.",
      )
    ) {
      return;
    }

    data.append("id", tr.dataset.id);
    data.append("status", status);
    btn.disabled = true;

    fetch("../../includes/admin/admin_order_status.php", {
      method: "POST",
      body: data,
      credentials: "same-origin",
    })
      .then(function (res) {
        if (res.status === 409) {
          throw new Error("cancelled");
        }
        if (!res.ok) {
          throw new Error("request failed");
        }
        return res.json();
      })
      .then(function () {
        btn.textContent = "Saved";
        setTimeout(load, 700);
      })
      .catch(function (err) {
        if (err.message === "cancelled") {
          alert("This order is already cancelled and can't be changed.");
        } else {
          alert("Could not save. Try again.");
        }
        btn.disabled = false;
      });
  });

  load();
}

function initFavouritesPage() {
  var box = document.getElementById("favourite-list");

  fetch("../../includes/favourite/favourites_list.php", {
    credentials: "same-origin",
  })
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }
      if (!res.ok) {
        throw new Error("Request failed");
      }
      return res.json();
    })
    .then(function (list) {
      if (!list) return;

      box.replaceChildren();

      if (list.length === 0) {
        box.appendChild(
          el("p", "empty", "You have no favourite products yet."),
        );
        return;
      }

      list.forEach(function (p) {
        var card = el("article", "favourite-card");
        var img = el("img");
        var price = el("p", "", "Rs " + p.price.toLocaleString("en-PK"));

        img.alt = p.name;
        img.loading = "lazy";
        img.src = /^https?:\/\//i.test(p.image) ? p.image : "../" + p.image;

        card.appendChild(img);
        card.appendChild(el("h2", "", p.name));
        card.appendChild(el("p", "", p.series + " " + (p.variant || "")));
        card.appendChild(price);
        card.appendChild(el("p", "", "Description: " + p.description));
        card.appendChild(el("p", "", "Reason: " + p.reason));
        card.appendChild(
          el(
            "span",
            "priority " + p.priority.toLowerCase(),
            p.priority + " Priority",
          ),
        );

        if (p.notes) {
          card.appendChild(el("p", "", "Notes: " + p.notes));
        }

        box.appendChild(card);
      });
    })
    .catch(function () {
      box.replaceChildren(el("p", "empty", "Could not load your favourites."));
    });
}
function initAddFavouritePage() {
  var params = new URLSearchParams(window.location.search);
  var productId = params.get("product") || params.get("product_id");
  var messageBox = document.getElementById("favourite-message");
  var preview = document.getElementById("favourite-product");
  var form = document.getElementById("favourite-form");
  var idInput = document.getElementById("product-id");

  function showError(text) {
    messageBox.replaceChildren(el("p", "error", text));
  }

  if (params.get("error")) {
    showError(
      "Could not save your favourite. Please check the fields and try again.",
    );
  }

  if (!productId) {
    preview.replaceChildren(el("p", "empty", "No product selected."));
    return;
  }

  fetch(
    "../../includes/checkout_product.php?id=" + encodeURIComponent(productId),
    { credentials: "same-origin" },
  )
    .then(function (res) {
      if (res.status === 401) {
        window.location.href = "login.html";
        return null;
      }
      if (res.status === 404) {
        throw new Error("missing");
      }
      if (!res.ok) {
        throw new Error("request failed");
      }
      return res.json();
    })
    .then(function (data) {
      if (!data) {
        return;
      }

      var p = data.product;
      var img = el("img");
      var info = el("div");

      img.alt = p.name;
      img.src = /^https?:\/\//i.test(p.image) ? p.image : "../" + p.image;

      info.appendChild(el("h2", "", p.name));
      info.appendChild(
        el("p", "", p.series + (p.variant ? " \u00B7 " + p.variant : "")),
      );
      info.appendChild(
        el("p", "price", "Rs " + p.price.toLocaleString("en-PK")),
      );

      preview.replaceChildren(img, info);
      idInput.value = p.id;
      form.hidden = false;
    })
    .catch(function (err) {
      preview.replaceChildren(
        el(
          "p",
          "empty",
          err.message === "missing"
            ? "Product not found."
            : "Could not load this product. Try again.",
        ),
      );
    });
}
