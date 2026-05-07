var SM_KEY='apex_admin_supplements';
var SM_FALLBACK=[
  {name:'Nitro Tech Whey Protein',brand:'MuscleTech',cat:'protein',price:15000,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_19_b6335e67-cb44-4e3c-aa33-0e5f7e0d6a5d_1024x1024.png',desc:'30g protein per serving. Advanced whey isolate for lean muscle and recovery.'},
  {name:'Critical Whey Protein',brand:'Applied Nutrition',cat:'protein',price:14500,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_15_ebae186e-6a80-49ad-9d7b-d4faeeadb1a0_1024x1024.png',desc:'24g protein per serving. Premium blend for everyday muscle support.'},
  {name:'100% Whey Professional',brand:'Scitec Nutrition',cat:'protein',price:16000,img:'https://fitnessisland.lk/cdn/shop/files/5146_0f4b0454aca7_1024x1024.webp',desc:'22g protein with amino acids. European quality whey concentrate blend.'},
  {name:'ISO100 Hydrolyzed Isolate',brand:'Dymatize',cat:'protein',price:18000,img:'https://fitnessisland.lk/cdn/shop/files/DymatizeISO100_1024x1024.png',desc:'25g hydrolyzed whey isolate. Ultra-fast absorption for serious athletes.'},
  {name:'Gold Standard 100% Whey',brand:'Optimum Nutrition',cat:'protein',price:20000,img:'https://fitnessisland.lk/cdn/shop/files/extremegold_1024x1024.jpg',desc:'24g protein. The world\'s best-selling whey protein for over 20 years.'},
  {name:'ISO HD Isolate Protein',brand:'BPI Sports',cat:'protein',price:16500,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_22_2830b01d-d93f-40a7-a2d0-ae6a34c53586_1024x1024.png',desc:'25g pure isolate. Zero sugar, ultra-clean formula for lean gains.'},
  {name:'Platinum Creatine Monohydrate',brand:'MuscleTech',cat:'creatine',price:3200,img:'https://fitnessisland.lk/cdn/shop/files/NitroTechwheyGold2.27KG_1024x1024.png',desc:'5g pure creatine per serving. Enhances strength, power, and recovery.'},
  {name:'C4 Original Pre-Workout',brand:'Cellucor',cat:'preworkout',price:5500,img:'https://fitnessisland.lk/cdn/shop/files/MusclemedsCarnivore4lbs_1024x1024.png',desc:'Explosive energy, heightened focus to crush every workout session.'},
  {name:'Xtend BCAA Recovery',brand:'Scivation',cat:'bcaa',price:6800,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_19_b6335e67-cb44-4e3c-aa33-0e5f7e0d6a5d_1024x1024.png',desc:'7g BCAAs per serving. Intra-workout hydration and muscle recovery.'},
  {name:'Serious Mass Weight Gainer',brand:'Optimum Nutrition',cat:'gainer',price:12500,img:'https://fitnessisland.lk/cdn/shop/files/image-removebg-preview_15_ebae186e-6a80-49ad-9d7b-d4faeeadb1a0_1024x1024.png',desc:'1,250 calories per serving. High-protein mass gainer for hard gainers.'},
  {name:'Animal Pak Multivitamin',brand:'Universal Nutrition',cat:'vitamins',price:7200,img:'https://fitnessisland.lk/cdn/shop/files/DymatizeISO100_1024x1024.png',desc:'Complete vitamin & mineral stack for peak athletic performance.'},
  {name:'Hydroxycut Hardcore Elite',brand:'MuscleTech',cat:'burner',price:4800,img:'https://fitnessisland.lk/cdn/shop/files/MusclemedsCarnivore4lbs_1024x1024.png',desc:'Thermogenic fat burner with green coffee extract. Boost metabolism fast.'}
];
var CAT_LABELS={protein:'Protein',creatine:'Creatine',preworkout:'Pre-Workout',bcaa:'BCAA',gainer:'Mass Gainer',vitamins:'Vitamins',burner:'Fat Burner'};

function getProducts(){try{var d=JSON.parse(localStorage.getItem(SM_KEY));return d&&d.length?d:SM_FALLBACK;}catch(e){return SM_FALLBACK;}}

function renderProducts(){
  var products=getProducts(),grid=document.getElementById('suppGrid');
  if(!grid)return;
  grid.innerHTML=products.map(function(p){
    var escaped=p.name.replace(/'/g,"\\'");
    return '<div class="s-card" data-cat="'+p.cat+'"><span class="s-badge '+p.cat+'">'+(CAT_LABELS[p.cat]||p.cat)+'</span>'+
      '<div class="s-img"><img src="'+p.img+'" alt="'+p.name+'"></div>'+
      '<div class="s-body"><div class="s-brand">'+p.brand+'</div><div class="s-name">'+p.name+'</div><div class="s-desc">'+p.desc+'</div>'+
      '<div class="s-bottom"><div class="s-price">RS. '+p.price.toLocaleString()+'</div>'+
      '<button class="s-buy" data-name="'+p.name+'" onclick="addToCart(\''+escaped+'\','+p.price+',\''+p.img+'\')"><i class="bi bi-cart-plus"></i> Add</button></div></div></div>';
  }).join('');
  var cats={};products.forEach(function(p){cats[p.cat]=true;});
  var statsEl=document.querySelector('.stats');
  if(statsEl) statsEl.innerHTML=
    '<div class="stat"><div class="stat-val">'+products.length+'</div><div class="stat-lbl">Products</div></div>'+
    '<div class="stat"><div class="stat-val">'+Object.keys(cats).length+'</div><div class="stat-lbl">Categories</div></div>'+
    '<div class="stat"><div class="stat-val">8</div><div class="stat-lbl">Brands</div></div>'+
    '<div class="stat"><div class="stat-val">100%</div><div class="stat-lbl">Authentic</div></div>';
  document.getElementById('countText').innerHTML='Showing <b>'+products.length+'</b> of <b>'+products.length+'</b> products';
}

var CART=[];
function cartCount(){return CART.reduce(function(s,i){return s+i.qty;},0);}
function cartTotal(){return CART.reduce(function(s,i){return s+i.price*i.qty;},0);}
function fmtPrice(n){return'Rs. '+n.toLocaleString();}

function addToCart(name,price,img){
  var found=CART.find(function(i){return i.name===name;});
  if(found){found.qty++;} else {CART.push({name:name,price:price,img:img,qty:1});}
  updateBadge();renderCart();toast(name+' added to cart!');
  var btns=document.querySelectorAll('.s-buy');
  btns.forEach(function(b){if(b.dataset.name===name){b.classList.add('added');b.innerHTML='<i class="bi bi-check"></i> Added';setTimeout(function(){b.classList.remove('added');b.innerHTML='<i class="bi bi-cart-plus"></i> Add';},1200);}});
}
function updateBadge(){var b=document.getElementById('cartBadge');var c=cartCount();b.textContent=c;b.style.display=c?'flex':'none';b.classList.remove('pop');void b.offsetWidth;b.classList.add('pop');}
function renderCart(){
  var el=document.getElementById('cartItems'),ft=document.getElementById('cartFooter');
  if(!CART.length){el.innerHTML='<div class="cart-empty"><i class="bi bi-bag-x"></i><div>Your cart is empty</div><div style="font-size:.72rem;margin-top:.3rem">Add supplements to get started</div></div>';ft.style.display='none';return;}
  ft.style.display='block';var h='';
  CART.forEach(function(item,i){h+='<div class="ci"><div class="ci-img"><img src="'+item.img+'" alt="'+item.name+'"></div><div class="ci-info"><div class="ci-name">'+item.name+'</div><div class="ci-price">'+fmtPrice(item.price)+'</div></div><div class="ci-qty"><button onclick="changeQty('+i+',-1)">−</button><span>'+item.qty+'</span><button onclick="changeQty('+i+',1)">+</button></div><button class="ci-del" onclick="removeItem('+i+')" title="Remove"><i class="bi bi-trash3"></i></button></div>';});
  el.innerHTML=h;document.getElementById('cartTotalVal').textContent=fmtPrice(cartTotal());
}
function changeQty(i,d){CART[i].qty+=d;if(CART[i].qty<1)CART.splice(i,1);updateBadge();renderCart();}
function removeItem(i){var n=CART[i].name;CART.splice(i,1);updateBadge();renderCart();toast(n+' removed from cart.');}
function clearCart(){CART=[];updateBadge();renderCart();}
function toggleCart(){document.getElementById('cartDrawer').classList.toggle('open');document.getElementById('cartOverlay').classList.toggle('open');}

function fil(cat,btn){
  document.querySelectorAll('.f-btn').forEach(function(b){b.classList.remove('active')});btn.classList.add('active');
  var cards=document.querySelectorAll('.s-card'),shown=0,total=cards.length;
  cards.forEach(function(c){var m=cat==='all'||c.dataset.cat===cat;c.style.display=m?'':'none';if(m)shown++;});
  document.getElementById('countText').innerHTML='Showing <b>'+shown+'</b> of <b>'+total+'</b> products';
}

var payMethod='';
function openCheckout(){
  if(!CART.length)return;toggleCart();
  document.getElementById('checkoutModal').classList.add('open');
  document.getElementById('checkStep1').style.display='block';document.getElementById('checkStep2').style.display='none';document.getElementById('checkStep3').style.display='none';
  var el=document.getElementById('orderRows'),h='';
  CART.forEach(function(item){h+='<div class="order-row"><span class="oname">'+item.name+' × '+item.qty+'</span><span class="oprice">'+fmtPrice(item.price*item.qty)+'</span></div>';});
  el.innerHTML=h;document.getElementById('orderTotalVal').textContent=fmtPrice(cartTotal());document.getElementById('payTotalVal').textContent=fmtPrice(cartTotal());
}
function closeCheckout(){document.getElementById('checkoutModal').classList.remove('open');}
function goStep(n){document.getElementById('checkStep1').style.display=n===1?'block':'none';document.getElementById('checkStep2').style.display=n===2?'block':'none';document.getElementById('checkStep3').style.display=n===3?'block':'none';}
function selectPay(el,method){payMethod=method;document.querySelectorAll('.pay-opt').forEach(function(p){p.classList.remove('sel');});el.classList.add('sel');document.getElementById('placeOrderBtn').disabled=false;}
function placeOrder(){var id='APX-'+Date.now().toString(36).toUpperCase();document.getElementById('orderId').textContent=id;goStep(3);CART=[];updateBadge();renderCart();}

function toast(msg){var t=document.getElementById('toast');t.innerHTML='<i class="bi bi-check-circle-fill"></i> '+msg;t.classList.add('show');setTimeout(function(){t.classList.remove('show');},2500);}

document.addEventListener('DOMContentLoaded',renderProducts);
