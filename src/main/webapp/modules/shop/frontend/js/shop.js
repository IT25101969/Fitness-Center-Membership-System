/* ═══════════════════════════════════════════════════════════════════════
   APEX FITNESS — SUPPLEMENT SHOP JS
   ═══════════════════════════════════════════════════════════════════════ */

var allSupps = [], catFilter = 'all', cart = [];

// ─── Load Data ────────────────────────────────────────────────────────
fetch('/api/supplements')
  .then(function(r) { return r.json(); })
  .then(function(data) {
    allSupps = data;
    loadCart();
    buildFilters();
    updateStats();
    renderSupps();
    updateCartUI();
  })
  .catch(function() {
    document.getElementById('spGrid').innerHTML = '<div class="empty-state"><i class="bi bi-exclamation-triangle"></i><p>Could not load supplements.</p></div>';
  });

// ─── Filters ──────────────────────────────────────────────────────────
function buildFilters() {
  var cats = {};
  allSupps.forEach(function(s) { cats[s.category] = (cats[s.category] || 0) + 1; });
  var row = document.getElementById('catRow');
  row.innerHTML = '<button class="f-btn active" onclick="setCat(\'all\',this)">All (' + allSupps.length + ')</button>';
  Object.keys(cats).sort().forEach(function(cat) {
    var btn = document.createElement('button');
    btn.className = 'f-btn';
    btn.textContent = cat + ' (' + cats[cat] + ')';
    btn.onclick = function() { setCat(cat, btn); };
    row.appendChild(btn);
  });
}

function setCat(v, btn) {
  catFilter = v;
  document.querySelectorAll('#catRow .f-btn').forEach(function(b) { b.classList.remove('active'); });
  btn.classList.add('active');
  renderSupps();
}

function updateStats() {
  document.getElementById('statTotal').textContent = allSupps.length;
  document.getElementById('statInStock').textContent = allSupps.filter(function(s) { return s.inStock; }).length;
  var cats = {}, brands = {};
  allSupps.forEach(function(s) { cats[s.category] = 1; brands[s.brand] = 1; });
  document.getElementById('statCategories').textContent = Object.keys(cats).length;
  document.getElementById('statBrands').textContent = Object.keys(brands).length;
}

// ─── Sorting & Filtering ─────────────────────────────────────────────
function getFiltered() {
  var q = (document.getElementById('spSearch').value || '').trim().toLowerCase();
  var sort = document.getElementById('sortSelect').value;
  var list = allSupps.filter(function(s) {
    if (catFilter !== 'all' && s.category !== catFilter) return false;
    if (q && s.name.toLowerCase().indexOf(q) === -1 && s.brand.toLowerCase().indexOf(q) === -1 && s.description.toLowerCase().indexOf(q) === -1 && s.category.toLowerCase().indexOf(q) === -1) return false;
    return true;
  });
  if (sort === 'price-asc') list.sort(function(a,b) { return parseFloat(a.price) - parseFloat(b.price); });
  else if (sort === 'price-desc') list.sort(function(a,b) { return parseFloat(b.price) - parseFloat(a.price); });
  else if (sort === 'name-asc') list.sort(function(a,b) { return a.name.localeCompare(b.name); });
  else if (sort === 'name-desc') list.sort(function(a,b) { return b.name.localeCompare(a.name); });
  return list;
}

// ─── Render Products ──────────────────────────────────────────────────
function renderSupps() {
  var list = getFiltered();
  var grid = document.getElementById('spGrid');
  document.getElementById('spCount').innerHTML = 'Showing <b>' + list.length + '</b> of <b>' + allSupps.length + '</b> supplements';

  if (list.length === 0) {
    grid.innerHTML = '<div class="empty-state"><i class="bi bi-search"></i><p>No supplements found.<br>Try adjusting your filters.</p></div>';
    return;
  }

  var html = '';
  list.forEach(function(s, i) {
    var catClass = s.category.replace(/ /g, '-');
    var imgSrc = s.hasLocalImage ? s.localImageUrl : (s.imageUrl || '');
    var inCart = cart.some(function(c) { return c.id === s.id; });

    html += '<div class="sp-card" style="animation-delay:' + (i * 0.03) + 's">';
    html += '<span class="sp-stock ' + (s.inStock ? 'in' : 'out') + '"><i class="bi ' + (s.inStock ? 'bi-check-circle-fill' : 'bi-x-circle-fill') + '"></i> ' + (s.inStock ? 'In Stock' : 'Sold Out') + '</span>';

    if (imgSrc) {
      html += '<div class="sp-img-wrap"><img src="' + imgSrc + '" alt="' + esc(s.name) + '" loading="lazy" onerror="this.parentElement.innerHTML=\'<div class=sp-no-img><i class=bi\\ bi-capsule></i><span>No Image</span></div>\'"></div>';
    } else {
      html += '<div class="sp-img-wrap"><div class="sp-no-img"><i class="bi bi-capsule"></i><span>No Image</span></div></div>';
    }

    html += '<div class="sp-body">';
    html += '<div class="sp-cat ' + catClass + '">' + s.category + '</div>';
    html += '<div class="sp-name">' + s.name + '</div>';
    html += '<div class="sp-brand"><i class="bi bi-building"></i> ' + s.brand + '</div>';
    html += '<div class="sp-desc">' + s.description + '</div>';
    html += '<div class="sp-footer">';
    html += '<div class="sp-price">' + s.formattedPrice + '</div>';
    html += '<div class="sp-actions">';
    if (s.inStock) {
      if (inCart) {
        html += '<button class="sp-action added"><i class="bi bi-check-lg"></i> Added</button>';
      } else {
        html += '<button class="sp-action" onclick="addToCart(\'' + s.id + '\')"><i class="bi bi-bag-plus-fill"></i> Add</button>';
      }
    } else {
      html += '<button class="sp-action" disabled><i class="bi bi-x-circle"></i> Sold Out</button>';
    }
    html += '</div></div></div></div>';
  });

  grid.innerHTML = html;
}

function esc(s) { return s ? s.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;') : ''; }

// ─── Cart ─────────────────────────────────────────────────────────────
function loadCart() {
  try { cart = JSON.parse(localStorage.getItem('apexCart') || '[]'); } catch(e) { cart = []; }
}
function saveCart() { localStorage.setItem('apexCart', JSON.stringify(cart)); }

function addToCart(id) {
  var s = allSupps.find(function(x) { return x.id === id; });
  if (!s || !s.inStock) return;
  var existing = cart.find(function(c) { return c.id === id; });
  if (existing) { existing.qty++; } else {
    cart.push({ id: s.id, name: s.name, price: parseFloat(s.price), formattedPrice: s.formattedPrice, img: s.hasLocalImage ? s.localImageUrl : (s.imageUrl || ''), qty: 1 });
  }
  saveCart();
  updateCartUI();
  renderSupps();
  // Bump animation
  var cnt = document.getElementById('cartCount');
  cnt.classList.remove('bump');
  void cnt.offsetWidth;
  cnt.classList.add('bump');
}

function removeFromCart(id) {
  cart = cart.filter(function(c) { return c.id !== id; });
  saveCart();
  updateCartUI();
  renderSupps();
}

function updateQty(id, delta) {
  var item = cart.find(function(c) { return c.id === id; });
  if (!item) return;
  item.qty += delta;
  if (item.qty <= 0) { removeFromCart(id); return; }
  saveCart();
  updateCartUI();
}

function clearCart() {
  cart = [];
  saveCart();
  updateCartUI();
  renderSupps();
}

function getCartTotal() {
  return cart.reduce(function(sum, c) { return sum + (c.price * c.qty); }, 0);
}

function formatPrice(n) { return 'Rs. ' + n.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 }); }

function updateCartUI() {
  var cnt = document.getElementById('cartCount');
  var totalItems = cart.reduce(function(s, c) { return s + c.qty; }, 0);
  cnt.textContent = totalItems;

  var itemsEl = document.getElementById('cartItems');
  var footerEl = document.getElementById('cartFooter');

  if (cart.length === 0) {
    itemsEl.innerHTML = '<div class="cart-empty"><i class="bi bi-bag-x"></i><p>Your cart is empty</p></div>';
    footerEl.style.display = 'none';
    return;
  }

  footerEl.style.display = 'block';
  var html = '';
  cart.forEach(function(c) {
    html += '<div class="cart-item">';
    if (c.img) {
      html += '<img class="cart-item-img" src="' + c.img + '" alt="" onerror="this.style.display=\'none\'">';
    }
    html += '<div class="cart-item-info">';
    html += '<div class="cart-item-name">' + esc(c.name) + '</div>';
    html += '<div class="cart-item-price">' + formatPrice(c.price) + ' × ' + c.qty + '</div>';
    html += '<div class="cart-item-controls">';
    html += '<button class="qty-btn" onclick="updateQty(\'' + c.id + '\',-1)">−</button>';
    html += '<span class="qty-val">' + c.qty + '</span>';
    html += '<button class="qty-btn" onclick="updateQty(\'' + c.id + '\',1)">+</button>';
    html += '</div></div>';
    html += '<button class="cart-item-remove" onclick="removeFromCart(\'' + c.id + '\')"><i class="bi bi-trash3"></i></button>';
    html += '</div>';
  });
  itemsEl.innerHTML = html;
  document.getElementById('cartTotal').textContent = formatPrice(getCartTotal());
}

function toggleCart() {
  document.getElementById('cartOverlay').classList.toggle('open');
  document.getElementById('cartDrawer').classList.toggle('open');
  document.body.style.overflow = document.getElementById('cartDrawer').classList.contains('open') ? 'hidden' : '';
}

// ─── Checkout ─────────────────────────────────────────────────────────
var selectedPay = '';

function openCheckout() {
  if (cart.length === 0) return;
  toggleCart();
  selectedPay = '';
  document.getElementById('placeOrderBtn').disabled = true;
  // Reset steps
  document.getElementById('step1').style.display = 'block';
  document.getElementById('step2').style.display = 'none';
  document.getElementById('step3').style.display = 'none';
  document.querySelectorAll('.pay-method input').forEach(function(r) { r.checked = false; });
  hideAllPayFields();

  // Populate order items
  var html = '';
  cart.forEach(function(c) {
    html += '<div class="order-item"><div class="order-item-left"><span class="order-item-name">' + esc(c.name) + '</span><span class="order-item-qty"> ×' + c.qty + '</span></div><span class="order-item-price">' + formatPrice(c.price * c.qty) + '</span></div>';
  });
  document.getElementById('orderItems').innerHTML = html;
  document.getElementById('orderTotal').textContent = formatPrice(getCartTotal());
  document.getElementById('payTotal').textContent = formatPrice(getCartTotal());

  document.getElementById('checkoutModal').classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeCheckout() {
  document.getElementById('checkoutModal').classList.remove('open');
  document.body.style.overflow = '';
}

function goToStep(n) {
  document.getElementById('step1').style.display = n === 1 ? 'block' : 'none';
  document.getElementById('step2').style.display = n === 2 ? 'block' : 'none';
  document.getElementById('step3').style.display = n === 3 ? 'block' : 'none';
}

function selectPay(method) {
  selectedPay = method;
  document.getElementById('placeOrderBtn').disabled = false;
  hideAllPayFields();
  if (method === 'card') document.getElementById('cardFields').style.display = 'block';
  if (method === 'bank') document.getElementById('bankFields').style.display = 'block';
  if (method === 'mobile') document.getElementById('mobileFields').style.display = 'block';
}

function hideAllPayFields() {
  document.getElementById('cardFields').style.display = 'none';
  document.getElementById('bankFields').style.display = 'none';
  document.getElementById('mobileFields').style.display = 'none';
}

function placeOrder() {
  if (!selectedPay || cart.length === 0) return;

  var orderId = 'APX-' + Date.now().toString(36).toUpperCase();
  var payLabels = { card: 'Credit/Debit Card', bank: 'Bank Transfer', mobile: 'Mobile Payment', cod: 'Cash on Delivery' };

  document.getElementById('orderId').textContent = orderId;

  var receipt = '<p><strong>Order ID:</strong> ' + orderId + '</p>';
  receipt += '<p><strong>Date:</strong> ' + new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' }) + '</p>';
  receipt += '<p><strong>Payment:</strong> ' + payLabels[selectedPay] + '</p>';
  receipt += '<p><strong>Items:</strong> ' + cart.reduce(function(s,c){return s+c.qty;}, 0) + '</p>';
  receipt += '<p><strong>Total:</strong> ' + formatPrice(getCartTotal()) + '</p>';
  document.getElementById('orderReceipt').innerHTML = receipt;

  goToStep(3);
}

// ─── Card Input Formatting ────────────────────────────────────────────
function formatCard(el) {
  var v = el.value.replace(/\D/g, '').substring(0, 16);
  el.value = v.replace(/(.{4})/g, '$1 ').trim();
}
function formatExp(el) {
  var v = el.value.replace(/\D/g, '').substring(0, 4);
  if (v.length >= 3) v = v.substring(0,2) + '/' + v.substring(2);
  el.value = v;
}
