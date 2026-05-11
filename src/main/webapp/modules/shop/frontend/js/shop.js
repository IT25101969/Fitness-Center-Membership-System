:root{--accent:#C8F03D;--black:#0a0a0a;--card:#111;--card2:#161616;--border:rgba(255,255,255,.07);--gray:rgba(255,255,255,.45);--font-display:'Bebas Neue',sans-serif;--font-body:'Inter',sans-serif;--radius:16px;--danger:#f87171}
*{margin:0;padding:0;box-sizing:border-box}
body{background:var(--black);color:#fff;font-family:var(--font-body);min-height:100vh;overflow-x:hidden}
::selection{background:var(--accent);color:#000}

/* ═══ NAV ═══ */
.nav{display:flex;align-items:center;justify-content:space-between;padding:0 3rem;height:70px;background:rgba(10,10,10,.95);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);position:sticky;top:0;z-index:100}
.nav-logo{font-family:var(--font-display);font-size:1.6rem;letter-spacing:2px;color:#fff;text-decoration:none}
.nav-logo span{color:var(--accent)}
.nav-links{display:flex;align-items:center;gap:1.5rem}
.nav-back{display:flex;align-items:center;gap:.5rem;color:rgba(255,255,255,.55);font-size:.82rem;font-weight:600;text-decoration:none;transition:color .2s}
.nav-back:hover{color:var(--accent)}
.cart-btn{position:relative;background:transparent;border:1px solid var(--border);border-radius:50px;padding:.55rem .9rem;color:#fff;font-size:1rem;cursor:pointer;transition:all .25s}
.cart-btn:hover{border-color:var(--accent);color:var(--accent)}
.cart-count{position:absolute;top:-6px;right:-6px;background:var(--accent);color:#000;font-size:.6rem;font-weight:800;width:18px;height:18px;border-radius:50%;display:flex;align-items:center;justify-content:center;transition:transform .2s}
.cart-count.bump{animation:bump .3s ease}
@keyframes bump{0%,100%{transform:scale(1)}50%{transform:scale(1.4)}}

/* ═══ HERO ═══ */
.sp-hero{padding:5rem 2rem 3rem;text-align:center;position:relative;overflow:hidden}
.hero-bg{position:absolute;inset:0;background:radial-gradient(ellipse at 50% 0%,rgba(200,240,61,.06) 0%,transparent 60%);pointer-events:none}
.sp-tag{display:inline-flex;align-items:center;gap:.4rem;font-size:.65rem;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:var(--accent);border:1px solid rgba(200,240,61,.25);padding:.35rem 1.2rem;border-radius:50px;margin-bottom:1rem;animation:fadeDown .6s ease}
.sp-hero h1{font-family:var(--font-display);font-size:clamp(3rem,7vw,5.5rem);letter-spacing:3px;line-height:1;margin-bottom:.75rem;animation:fadeDown .7s ease}
.sp-hero h1 span{color:var(--accent)}
.sp-hero p{color:var(--gray);font-size:.95rem;max-width:520px;margin:0 auto;line-height:1.7;animation:fadeDown .8s ease}
@keyframes fadeDown{from{opacity:0;transform:translateY(-15px)}to{opacity:1;transform:translateY(0)}}

/* ═══ SEARCH ═══ */
.search-wrap{max-width:560px;margin:2rem auto 0;position:relative;animation:fadeDown .9s ease}
.search-wrap i{position:absolute;left:1.25rem;top:50%;transform:translateY(-50%);color:rgba(255,255,255,.3);font-size:1rem;pointer-events:none}
.search-wrap input{width:100%;padding:1rem 1.5rem 1rem 3.25rem;border-radius:50px;border:1px solid rgba(255,255,255,.1);background:rgba(255,255,255,.04);color:#fff;font-family:var(--font-body);font-size:.9rem;outline:none;transition:all .3s}
.search-wrap input:focus{border-color:rgba(200,240,61,.5);background:rgba(200,240,61,.02);box-shadow:0 0 30px rgba(200,240,61,.06)}
.search-wrap input::placeholder{color:rgba(255,255,255,.25)}

/* ═══ STATS ═══ */
.sp-stats{display:flex;justify-content:center;gap:2rem;padding:2.5rem 1rem .5rem;flex-wrap:wrap}
.sp-stat{text-align:center;min-width:100px}
.sp-stat-val{font-family:var(--font-display);font-size:2.5rem;color:var(--accent);line-height:1}
.sp-stat-lbl{font-size:.65rem;color:var(--gray);text-transform:uppercase;letter-spacing:1.5px;margin-top:.3rem}

/* ═══ TOOLBAR ═══ */
.toolbar{max-width:1200px;margin:0 auto;padding:2rem 1.5rem .5rem;display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap}
.filter-row{display:flex;gap:.45rem;flex-wrap:wrap;flex:1}
.f-btn{padding:.5rem 1.1rem;border-radius:50px;border:1px solid rgba(255,255,255,.1);background:transparent;color:rgba(255,255,255,.5);font-size:.72rem;font-weight:600;cursor:pointer;font-family:var(--font-body);transition:all .2s;white-space:nowrap}
.f-btn.active,.f-btn:hover{border-color:var(--accent);color:var(--accent);background:rgba(200,240,61,.07)}
.sort-wrap select{background:rgba(255,255,255,.04);border:1px solid var(--border);border-radius:50px;color:rgba(255,255,255,.6);padding:.5rem 1rem;font-family:var(--font-body);font-size:.72rem;font-weight:600;outline:none;cursor:pointer}
.sort-wrap select:focus{border-color:rgba(200,240,61,.4)}
.sort-wrap select option{background:#1a1a1a;color:#fff}

/* ═══ STATS BAR ═══ */
.stats-bar{display:flex;align-items:center;justify-content:space-between;max-width:1200px;margin:0 auto;padding:.75rem 1.5rem;font-size:.75rem;color:var(--gray)}
.stats-bar span b{color:#fff;font-weight:700}
.stats-bar-brand{font-size:.6rem;letter-spacing:1.5px;text-transform:uppercase}

/* ═══ GRID ═══ */
.sp-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1.4rem;max-width:1200px;margin:0 auto;padding:0 1.5rem 5rem}

/* ═══ CARD ═══ */
.sp-card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:all .35s cubic-bezier(.4,0,.2,1);position:relative;animation:cardIn .4s ease both;display:flex;flex-direction:column}
@keyframes cardIn{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.sp-card:hover{transform:translateY(-6px);border-color:rgba(200,240,61,.22);box-shadow:0 20px 50px rgba(0,0,0,.5),0 0 30px rgba(200,240,61,.04)}
.sp-card::before{content:'';position:absolute;top:0;left:-100%;width:55%;height:100%;background:linear-gradient(90deg,transparent,rgba(200,240,61,.03),transparent);transition:left .6s;z-index:2;pointer-events:none}
.sp-card:hover::before{left:150%}

.sp-img-wrap{width:100%;height:230px;position:relative;overflow:hidden;flex-shrink:0;background:linear-gradient(135deg,rgba(255,255,255,.02),rgba(255,255,255,.01));display:flex;align-items:center;justify-content:center}
.sp-img-wrap img{max-width:80%;max-height:80%;object-fit:contain;transition:transform .5s ease}
.sp-card:hover .sp-img-wrap img{transform:scale(1.08)}
.sp-no-img{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:.5rem;width:100%;height:100%}
.sp-no-img i{font-size:2.5rem;color:rgba(255,255,255,.08)}
.sp-no-img span{font-size:.55rem;letter-spacing:2px;text-transform:uppercase;color:rgba(255,255,255,.08)}

.sp-stock{position:absolute;top:12px;right:12px;padding:.25rem .65rem;border-radius:20px;font-size:.6rem;font-weight:700;letter-spacing:.5px;z-index:3;backdrop-filter:blur(8px);display:flex;align-items:center;gap:.3rem}
.sp-stock.in{background:rgba(52,211,153,.15);color:#34d399;border:1px solid rgba(52,211,153,.2)}
.sp-stock.out{background:rgba(248,113,113,.15);color:#f87171;border:1px solid rgba(248,113,113,.2)}

.sp-body{padding:1.2rem 1.4rem 1.4rem;display:flex;flex-direction:column;flex-grow:1}
.sp-cat{display:inline-block;padding:.18rem .55rem;border-radius:20px;font-size:.58rem;font-weight:700;letter-spacing:.5px;text-transform:uppercase;margin-bottom:.4rem;width:fit-content}
.sp-cat.Protein{background:rgba(96,165,250,.12);color:#60a5fa}
.sp-cat.Creatine{background:rgba(167,139,250,.12);color:#a78bfa}
.sp-cat.Pre-Workout{background:rgba(248,113,113,.12);color:#f87171}
.sp-cat.BCAA{background:rgba(52,211,153,.12);color:#34d399}
.sp-cat.Mass-Gainer{background:rgba(251,191,36,.12);color:#fbbf24}
.sp-cat.Fat-Burner{background:rgba(244,114,182,.12);color:#f472b6}
.sp-cat.Vitamins{background:rgba(45,212,191,.12);color:#2dd4bf}
.sp-cat.Other{background:rgba(148,163,184,.12);color:#94a3b8}

.sp-name{font-weight:700;font-size:1rem;color:#fff;margin-bottom:.15rem;line-height:1.3}
.sp-brand{font-size:.7rem;color:rgba(255,255,255,.35);margin-bottom:.5rem;display:flex;align-items:center;gap:.3rem}
.sp-desc{font-size:.73rem;color:rgba(255,255,255,.45);line-height:1.55;margin-bottom:1rem;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;flex-grow:1}
.sp-footer{display:flex;justify-content:space-between;align-items:center;margin-top:auto;gap:.5rem}
.sp-price{font-family:var(--font-display);font-size:1.45rem;color:var(--accent);letter-spacing:1px}
.sp-actions{display:flex;gap:.4rem}
.sp-action{padding:.5rem 1rem;border-radius:50px;border:1px solid rgba(200,240,61,.3);background:rgba(200,240,61,.06);color:var(--accent);font-size:.68rem;font-weight:700;cursor:pointer;transition:all .25s;font-family:var(--font-body);display:flex;align-items:center;gap:.3rem}
.sp-action:hover{background:var(--accent);color:#000;transform:scale(1.04)}
.sp-action.added{background:var(--accent);color:#000;pointer-events:none}
.sp-action:disabled{opacity:.4;cursor:not-allowed;pointer-events:none}

/* ═══ EMPTY / LOADING ═══ */
.empty-state{text-align:center;padding:5rem 2rem;color:var(--gray);grid-column:1/-1}
.empty-state i{font-size:3rem;display:block;margin-bottom:1rem;color:rgba(255,255,255,.1)}
@keyframes spin{to{transform:rotate(360deg)}}
.loading{grid-column:1/-1;text-align:center;padding:4rem;color:rgba(255,255,255,.3)}
.loading i{font-size:2rem;animation:spin .8s linear infinite;display:block;margin-bottom:.5rem}

/* ═══ CART DRAWER ═══ */
.cart-overlay{position:fixed;inset:0;background:rgba(0,0,0,.65);backdrop-filter:blur(4px);z-index:200;opacity:0;pointer-events:none;transition:opacity .3s}
.cart-overlay.open{opacity:1;pointer-events:auto}
.cart-drawer{position:fixed;top:0;right:-440px;width:420px;max-width:92vw;height:100vh;background:#111;border-left:1px solid var(--border);z-index:201;display:flex;flex-direction:column;transition:right .35s cubic-bezier(.4,0,.2,1);box-shadow:-10px 0 50px rgba(0,0,0,.5)}
.cart-drawer.open{right:0}
.cart-header{display:flex;align-items:center;justify-content:space-between;padding:1.5rem;border-bottom:1px solid var(--border)}
.cart-header h3{font-family:var(--font-display);font-size:1.4rem;letter-spacing:1px;display:flex;align-items:center;gap:.5rem}
.cart-header h3 i{color:var(--accent)}
.cart-close{background:transparent;border:none;color:rgba(255,255,255,.5);font-size:1.2rem;cursor:pointer;padding:.4rem;transition:color .2s}
.cart-close:hover{color:#fff}
.cart-items{flex:1;overflow-y:auto;padding:1rem 1.5rem}
.cart-empty{text-align:center;padding:4rem 1rem;color:rgba(255,255,255,.2)}
.cart-empty i{font-size:3rem;display:block;margin-bottom:.75rem}

.cart-item{display:flex;gap:1rem;padding:1rem;border-radius:12px;background:rgba(255,255,255,.03);border:1px solid var(--border);margin-bottom:.75rem;animation:cardIn .3s ease both}
.cart-item-img{width:55px;height:55px;border-radius:10px;object-fit:contain;background:rgba(255,255,255,.02);flex-shrink:0}
.cart-item-info{flex:1;min-width:0}
.cart-item-name{font-size:.82rem;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.cart-item-price{font-size:.72rem;color:var(--accent);font-weight:700}
.cart-item-controls{display:flex;align-items:center;gap:.5rem;margin-top:.4rem}
.qty-btn{width:26px;height:26px;border-radius:6px;border:1px solid var(--border);background:transparent;color:#fff;font-size:.8rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .2s}
.qty-btn:hover{border-color:var(--accent);color:var(--accent)}
.qty-val{font-size:.82rem;font-weight:700;min-width:20px;text-align:center}
.cart-item-remove{background:transparent;border:none;color:rgba(255,255,255,.25);font-size:.85rem;cursor:pointer;margin-left:auto;transition:color .2s}
.cart-item-remove:hover{color:var(--danger)}

.cart-footer{padding:1.25rem 1.5rem;border-top:1px solid var(--border)}
.cart-total{display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;font-size:.9rem}
.cart-total strong{font-family:var(--font-display);font-size:1.6rem;color:var(--accent)}
.checkout-btn{width:100%;padding:.85rem;border-radius:50px;border:none;background:var(--accent);color:#000;font-weight:800;font-size:.85rem;cursor:pointer;font-family:var(--font-body);transition:all .2s;display:flex;align-items:center;justify-content:center;gap:.5rem;margin-bottom:.5rem}
.checkout-btn:hover{transform:scale(1.02);box-shadow:0 4px 20px rgba(200,240,61,.25)}
.clear-cart-btn{width:100%;padding:.6rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-size:.72rem;font-weight:600;cursor:pointer;font-family:var(--font-body);transition:all .2s;display:flex;align-items:center;justify-content:center;gap:.4rem}
.clear-cart-btn:hover{border-color:var(--danger);color:var(--danger)}

/* ═══ CHECKOUT MODAL ═══ */
.modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.8);backdrop-filter:blur(8px);z-index:300;display:none;align-items:center;justify-content:center;padding:1rem}
.modal-overlay.open{display:flex}
.modal-box{background:#141414;border:1px solid var(--border);border-radius:20px;width:100%;max-width:520px;max-height:90vh;overflow-y:auto;position:relative;animation:modalIn .35s ease;padding:2.5rem 2rem}
@keyframes modalIn{from{opacity:0;transform:scale(.92) translateY(20px)}to{opacity:1;transform:scale(1) translateY(0)}}
.modal-close{position:absolute;top:1rem;right:1rem;background:transparent;border:none;color:rgba(255,255,255,.4);font-size:1.2rem;cursor:pointer;padding:.3rem;transition:color .2s}
.modal-close:hover{color:#fff}
.modal-icon{width:60px;height:60px;border-radius:50%;background:rgba(200,240,61,.08);display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;font-size:1.5rem;color:var(--accent)}
.checkout-step h2{font-family:var(--font-display);font-size:1.8rem;letter-spacing:1px;text-align:center;margin-bottom:1.5rem}

/* Order Items */
.order-items{max-height:200px;overflow-y:auto;margin-bottom:1rem}
.order-item{display:flex;justify-content:space-between;align-items:center;padding:.6rem 0;border-bottom:1px solid var(--border);font-size:.82rem}
.order-item:last-child{border:none}
.order-item-left{display:flex;align-items:center;gap:.5rem;flex:1;min-width:0}
.order-item-name{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.order-item-qty{color:var(--gray);font-size:.7rem}
.order-item-price{font-weight:700;color:var(--accent);white-space:nowrap}
.order-total{display:flex;justify-content:space-between;padding:1rem 0;border-top:2px solid rgba(200,240,61,.2);font-size:1rem;margin-bottom:1rem}
.order-total strong{font-family:var(--font-display);font-size:1.8rem;color:var(--accent)}

/* Payment Methods */
.pay-methods{display:flex;flex-direction:column;gap:.6rem;margin-bottom:1.5rem}
.pay-method{cursor:pointer}
.pay-method input{display:none}
.pay-method-inner{display:flex;align-items:center;gap:1rem;padding:1rem 1.2rem;border-radius:12px;border:1px solid var(--border);background:rgba(255,255,255,.02);transition:all .25s}
.pay-method input:checked~.pay-method-inner{border-color:var(--accent);background:rgba(200,240,61,.05);box-shadow:0 0 20px rgba(200,240,61,.06)}
.pay-method-inner:hover{border-color:rgba(255,255,255,.2)}
.pay-method-inner strong{font-size:.85rem;display:block}
.pay-method-inner small{font-size:.68rem;color:var(--gray)}
.pay-icon{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.2rem;flex-shrink:0}
.card-icon{background:rgba(96,165,250,.12);color:#60a5fa}
.bank-icon{background:rgba(167,139,250,.12);color:#a78bfa}
.mobile-icon{background:rgba(52,211,153,.12);color:#34d399}
.cod-icon{background:rgba(251,191,36,.12);color:#fbbf24}

/* Card / Bank / Mobile Fields */
.card-fields,.bank-fields,.mobile-fields{animation:fadeDown .3s ease}
.field-row{display:flex;gap:.75rem;margin-bottom:.75rem}
.field{flex:1}
.field.full{flex:1 1 100%}
.field label{display:block;font-size:.68rem;font-weight:600;color:var(--gray);margin-bottom:.3rem;text-transform:uppercase;letter-spacing:.5px}
.field input,.field select{width:100%;padding:.7rem .9rem;border-radius:10px;border:1px solid var(--border);background:rgba(255,255,255,.04);color:#fff;font-family:var(--font-body);font-size:.85rem;outline:none;transition:border-color .2s}
.field input:focus,.field select:focus{border-color:rgba(200,240,61,.5)}
.field input::placeholder{color:rgba(255,255,255,.2)}
.field select option{background:#1a1a1a}
.bank-info{background:rgba(167,139,250,.06);border:1px solid rgba(167,139,250,.15);border-radius:12px;padding:1rem 1.2rem;margin-bottom:1rem;font-size:.8rem;line-height:1.8}
.bank-info strong{color:#a78bfa}

.step-nav{display:flex;gap:.75rem;margin-top:.5rem}
.pay-back-btn{flex:0 0 auto;padding:.7rem 1.2rem;border-radius:50px;border:1px solid var(--border);background:transparent;color:var(--gray);font-weight:600;font-size:.78rem;cursor:pointer;font-family:var(--font-body);transition:all .2s;display:flex;align-items:center;gap:.3rem}
.pay-back-btn:hover{border-color:#fff;color:#fff}
.pay-next-btn{flex:1;padding:.8rem 1.5rem;border-radius:50px;border:none;background:var(--accent);color:#000;font-weight:800;font-size:.82rem;cursor:pointer;font-family:var(--font-body);transition:all .2s;display:flex;align-items:center;justify-content:center;gap:.4rem}
.pay-next-btn:hover{transform:scale(1.02);box-shadow:0 4px 20px rgba(200,240,61,.25)}
.pay-next-btn:disabled{opacity:.4;pointer-events:none}

/* Success */
.success-anim{width:80px;height:80px;border-radius:50%;background:rgba(52,211,153,.1);display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;animation:successPop .5s ease}
.success-anim i{font-size:2.5rem;color:#34d399}
@keyframes successPop{from{transform:scale(0);opacity:0}to{transform:scale(1);opacity:1}}
.success-msg{text-align:center;font-size:.85rem;color:var(--gray);margin-bottom:1.5rem;line-height:1.6}
.success-msg strong{color:#34d399}
.order-receipt{background:rgba(255,255,255,.03);border:1px solid var(--border);border-radius:12px;padding:1rem 1.2rem;font-size:.75rem;margin-bottom:1.5rem;line-height:1.8}
.order-receipt strong{color:var(--accent)}

/* ═══ RESPONSIVE ═══ */
@media(max-width:700px){
  .nav{padding:0 1rem}
  .toolbar,.sp-grid,.stats-bar{padding-left:1rem;padding-right:1rem}
  .sp-grid{grid-template-columns:1fr 1fr}
  .sp-stats{gap:1rem}
  .modal-box{padding:1.5rem 1.2rem}
}
@media(max-width:480px){
  .sp-grid{grid-template-columns:1fr}
  .cart-drawer{width:100%;max-width:100%}
}

/* ═══ SCROLLBAR ═══ */
::-webkit-scrollbar{width:6px}
::-webkit-scrollbar-track{background:transparent}
::-webkit-scrollbar-thumb{background:rgba(255,255,255,.1);border-radius:3px}
::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,.2)}
