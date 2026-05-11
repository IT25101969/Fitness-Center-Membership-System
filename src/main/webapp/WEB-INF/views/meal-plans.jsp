<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Meal Plans & Nutrition — APEX FITNESS</title>
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <style>
    :root {
      --black: #080808; --dark: #111; --card: #161616;
      --accent: #C8F03D; --accent2: #a8d020;
      --white: #fff; --gray: #888; --border: rgba(255,255,255,.08);
      --radius: 16px;
      --font-display: 'Bebas Neue', sans-serif;
      --font-body: 'Inter', sans-serif;
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body { background: var(--black); color: var(--white); font-family: var(--font-body); min-height: 100vh; }
    a { text-decoration: none; color: inherit; }

    /* ── NAV ── */
    .top-nav {
      position: sticky; top: 0; z-index: 100;
      background: rgba(8,8,8,.92); backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
      display: flex; align-items: center; justify-content: space-between;
      padding: 1rem 3rem;
    }
    .top-nav .brand { font-family: var(--font-display); font-size: 1.6rem; letter-spacing: 2px; }
    .top-nav .brand span { color: var(--accent); }
    .top-nav .back-btn {
      display: inline-flex; align-items: center; gap: .5rem;
      color: rgba(255,255,255,.7); font-size: .88rem; font-weight: 500;
      transition: color .2s;
    }
    .top-nav .back-btn:hover { color: var(--accent); }

    /* ── HERO ── */
    .meals-hero {
      background: linear-gradient(135deg, #1a1a00 0%, #111 100%);
      border-bottom: 1px solid rgba(200,240,61,.15);
      padding: 4rem 3rem 3rem;
      text-align: center; position: relative; overflow: hidden;
    }
    .meals-hero::before {
      content: ''; position: absolute; inset: 0;
      background: radial-gradient(circle at 50% 100%, rgba(200,240,61,.08) 0%, transparent 60%);
    }
    .meals-hero .tag {
      display: inline-block; background: rgba(200,240,61,.1); color: var(--accent);
      font-size: .72rem; font-weight: 700; letter-spacing: 2px;
      text-transform: uppercase; padding: .4rem 1rem; border-radius: 50px;
      border: 1px solid rgba(200,240,61,.2); margin-bottom: 1rem;
    }
    .meals-hero h1 {
      font-family: var(--font-display); font-size: clamp(2.8rem,6vw,5rem);
      letter-spacing: 2px; line-height: 1; position: relative;
    }
    .meals-hero h1 span { color: var(--accent); }
    .meals-hero p {
      color: rgba(255,255,255,.6); margin-top: 1rem; max-width: 600px;
      margin-left: auto; margin-right: auto; font-size: 1rem; position: relative;
    }

    /* ── FILTER TABS ── */
    .filter-bar {
      display: flex; align-items: center; justify-content: center; gap: 1rem; flex-wrap: wrap;
      padding: 2rem 3rem;
    }
    .filter-btn {
      padding: .6rem 1.5rem; border-radius: 50px; font-size: .85rem; font-weight: 600;
      border: 1px solid var(--border); cursor: pointer; transition: all .2s;
      background: var(--card); color: rgba(255,255,255,.7);
    }
    .filter-btn:hover, .filter-btn.active {
      background: var(--accent); color: var(--black); border-color: var(--accent);
    }

    /* ── MEAL CARDS GRID ── */
    .meals-body { padding: 0 3rem 5rem; }
    .meals-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 2rem;
    }
    
    .meal-card {
      background: var(--card); border: 1px solid var(--border); border-radius: var(--radius);
      overflow: hidden; transition: transform .3s, border-color .3s, box-shadow .3s;
      display: flex; flex-direction: column;
    }
    .meal-card:hover {
      transform: translateY(-8px); border-color: var(--accent);
      box-shadow: 0 20px 40px rgba(200,240,61,.1);
    }
    .meal-img-wrap {
      height: 200px; background: #222; position: relative;
      display: flex; align-items: center; justify-content: center;
      color: var(--gray); font-size: 3rem;
      border-bottom: 1px solid var(--border);
    }
    .meal-goal-badge {
      position: absolute; top: 1rem; right: 1rem;
      background: rgba(8,8,8,.8); backdrop-filter: blur(4px);
      color: var(--white); border: 1px solid var(--border);
      font-size: .7rem; font-weight: 700; padding: .3rem .8rem; border-radius: 50px;
      text-transform: uppercase; letter-spacing: 1px;
    }
    .meal-card.fat-loss .meal-goal-badge { color: #f87171; border-color: rgba(248,113,113,.4); }
    .meal-card.muscle-gain .meal-goal-badge { color: var(--accent); border-color: rgba(200,240,61,.4); }
    .meal-card.maintenance .meal-goal-badge { color: #60a5fa; border-color: rgba(96,165,250,.4); }

    .meal-content { padding: 1.5rem; display: flex; flex-direction: column; flex: 1; }
    .meal-title { font-size: 1.25rem; font-weight: 700; margin-bottom: .5rem; line-height: 1.3; }
    .meal-desc { font-size: .85rem; color: rgba(255,255,255,.6); margin-bottom: 1.5rem; line-height: 1.5; flex: 1; }
    
    /* Nutrients */
    .nutrients-box {
      background: rgba(255,255,255,.03); border: 1px solid rgba(255,255,255,.08);
      border-radius: 12px; padding: 1rem; margin-bottom: 1.5rem;
    }
    .macros-grid {
      display: grid; grid-template-columns: repeat(4, 1fr); gap: .5rem; text-align: center;
    }
    .macro-item { display: flex; flex-direction: column; gap: .2rem; }
    .macro-val { font-family: var(--font-display); font-size: 1.4rem; color: var(--white); }
    .macro-lbl { font-size: .65rem; color: var(--gray); text-transform: uppercase; font-weight: 600; letter-spacing: 1px; }
    .macro-item.cals .macro-val { color: var(--accent); }
    
    .meal-list {
      list-style: none; padding: 0; margin: 0 0 1.5rem;
      border-top: 1px solid var(--border); padding-top: 1rem;
    }
    .meal-list li {
      font-size: .8rem; color: rgba(255,255,255,.8); padding: .3rem 0;
      display: flex; gap: .5rem;
    }
    .meal-list li i { color: var(--accent); font-size: .9rem; }

    .btn-meal {
      width: 100%; display: block; text-align: center;
      background: rgba(200,240,61,.1); color: var(--accent);
      border: 1px solid rgba(200,240,61,.3); border-radius: 10px;
      padding: .8rem; font-size: .85rem; font-weight: 700;
      transition: all .2s;
    }
    .meal-card:hover .btn-meal { background: var(--accent); color: var(--black); }

    /* ── FOOTER ── */
    .pub-footer {
      border-top: 1px solid var(--border); padding: 2rem 3rem;
      display: flex; align-items: center; justify-content: space-between; gap: 1rem;
      color: var(--gray); font-size: .8rem; flex-wrap: wrap;
      margin-top: 4rem;
    }
    .pub-footer .brand { font-family: var(--font-display); font-size: 1.2rem; }
    .pub-footer .brand span { color: var(--accent); }

    /* ── MOBILE ── */
    @media (max-width: 700px) {
      .top-nav, .filter-bar, .meals-body, .pub-footer { padding-left: 1.2rem; padding-right: 1.2rem; }
      .meals-hero { padding: 2.5rem 1.2rem 2rem; }
      .macros-grid { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
    }
  </style>
</head>
<body>

<nav class="top-nav">
  <a href="${pageContext.request.contextPath}/landing.html" class="brand">APEX<span>FITNESS</span></a>
  <a href="${pageContext.request.contextPath}/landing.html#nutrition" class="back-btn">
    <i class="bi bi-arrow-left"></i> Back to Home
  </a>
</nav>

<div class="meals-hero">
  <div class="tag">Nutrition</div>
  <h1>EXPERT <span>MEAL PLANS</span></h1>
  <p>Scientifically formulated meal plans designed to optimize performance, build lean muscle, and accelerate fat loss.</p>
</div>

<div class="filter-bar">
  <button class="filter-btn active" data-filter="all">All Plans</button>
  <button class="filter-btn" data-filter="fat-loss">Fat Loss</button>
  <button class="filter-btn" data-filter="muscle-gain">Muscle Gain</button>
  <button class="filter-btn" data-filter="maintenance">Maintenance & Performance</button>
</div>

<div class="meals-body">
  <div class="meals-grid">

    <!-- Plan 1 -->
    <div class="meal-card fat-loss" data-category="fat-loss">
      <div class="meal-img-wrap">
        <i class="bi bi-egg-fried"></i>
        <div class="meal-goal-badge">Fat Loss</div>
      </div>
      <div class="meal-content">
        <h3 class="meal-title">Shred & Burn</h3>
        <p class="meal-desc">A high-protein, low-carb plan designed to preserve muscle mass while creating a steady caloric deficit for maximum fat loss.</p>
        
        <div class="nutrients-box">
          <div class="macros-grid">
            <div class="macro-item cals"><span class="macro-val">1500</span><span class="macro-lbl">Kcal</span></div>
            <div class="macro-item"><span class="macro-val">140g</span><span class="macro-lbl">Protein</span></div>
            <div class="macro-item"><span class="macro-val">100g</span><span class="macro-lbl">Carbs</span></div>
            <div class="macro-item"><span class="macro-val">50g</span><span class="macro-lbl">Fats</span></div>
          </div>
        </div>

        <ul class="meal-list">
          <li><i class="bi bi-check-circle-fill"></i> <strong>Breakfast:</strong> Scrambled egg whites & spinach</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Lunch:</strong> Grilled chicken salad with olive oil</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Dinner:</strong> Baked salmon & steamed asparagus</li>
        </ul>
        <button type="button" class="btn-meal" onclick="downloadPDF(this)">Download Full Plan PDF <i class="bi bi-download" style="margin-left: 5px;"></i></button>
      </div>
    </div>

    <!-- Plan 2 -->
    <div class="meal-card muscle-gain" data-category="muscle-gain">
      <div class="meal-img-wrap">
        <i class="bi bi-cup-hot-fill"></i>
        <div class="meal-goal-badge">Muscle Gain</div>
      </div>
      <div class="meal-content">
        <h3 class="meal-title">Lean Mass Builder</h3>
        <p class="meal-desc">Caloric surplus plan loaded with complex carbs and high-quality protein to fuel intense workouts and maximize hypertrophy.</p>
        
        <div class="nutrients-box">
          <div class="macros-grid">
            <div class="macro-item cals"><span class="macro-val">2800</span><span class="macro-lbl">Kcal</span></div>
            <div class="macro-item"><span class="macro-val">180g</span><span class="macro-lbl">Protein</span></div>
            <div class="macro-item"><span class="macro-val">320g</span><span class="macro-lbl">Carbs</span></div>
            <div class="macro-item"><span class="macro-val">80g</span><span class="macro-lbl">Fats</span></div>
          </div>
        </div>

        <ul class="meal-list">
          <li><i class="bi bi-check-circle-fill"></i> <strong>Breakfast:</strong> Oatmeal, whey protein, peanut butter</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Lunch:</strong> Lean beef mince, sweet potato, broccoli</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Dinner:</strong> Chicken breast, brown rice, avocado</li>
        </ul>
        <button type="button" class="btn-meal" onclick="downloadPDF(this)">Download Full Plan PDF <i class="bi bi-download" style="margin-left: 5px;"></i></button>
      </div>
    </div>

    <!-- Plan 3 -->
    <div class="meal-card maintenance" data-category="maintenance">
      <div class="meal-img-wrap">
        <i class="bi bi-basket-fill"></i>
        <div class="meal-goal-badge">Maintenance</div>
      </div>
      <div class="meal-content">
        <h3 class="meal-title">Athletic Performance</h3>
        <p class="meal-desc">A balanced macro approach perfect for CrossFitters and athletes wanting to maintain weight while improving endurance and strength.</p>
        
        <div class="nutrients-box">
          <div class="macros-grid">
            <div class="macro-item cals"><span class="macro-val">2200</span><span class="macro-lbl">Kcal</span></div>
            <div class="macro-item"><span class="macro-val">150g</span><span class="macro-lbl">Protein</span></div>
            <div class="macro-item"><span class="macro-val">200g</span><span class="macro-lbl">Carbs</span></div>
            <div class="macro-item"><span class="macro-val">80g</span><span class="macro-lbl">Fats</span></div>
          </div>
        </div>

        <ul class="meal-list">
          <li><i class="bi bi-check-circle-fill"></i> <strong>Breakfast:</strong> Whole eggs, avocado toast</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Lunch:</strong> Turkey wrap, greek yogurt</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Dinner:</strong> White fish, quinoa, mixed veg</li>
        </ul>
        <button type="button" class="btn-meal" onclick="downloadPDF(this)">Download Full Plan PDF <i class="bi bi-download" style="margin-left: 5px;"></i></button>
      </div>
    </div>

    <!-- Plan 4 -->
    <div class="meal-card fat-loss" data-category="fat-loss">
      <div class="meal-img-wrap">
        <i class="bi bi-apple"></i>
        <div class="meal-goal-badge">Fat Loss</div>
      </div>
      <div class="meal-content">
        <h3 class="meal-title">Aggressive Cut</h3>
        <p class="meal-desc">A short-term keto-style plan. Extremely low carbs to deplete glycogen stores rapidly and force the body to use fat for fuel.</p>
        
        <div class="nutrients-box">
          <div class="macros-grid">
            <div class="macro-item cals"><span class="macro-val">1300</span><span class="macro-lbl">Kcal</span></div>
            <div class="macro-item"><span class="macro-val">160g</span><span class="macro-lbl">Protein</span></div>
            <div class="macro-item"><span class="macro-val">25g</span><span class="macro-lbl">Carbs</span></div>
            <div class="macro-item"><span class="macro-val">60g</span><span class="macro-lbl">Fats</span></div>
          </div>
        </div>

        <ul class="meal-list">
          <li><i class="bi bi-check-circle-fill"></i> <strong>Breakfast:</strong> Black coffee, 3 eggs cooked in butter</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Lunch:</strong> Tuna salad with olive oil dressing</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Dinner:</strong> Sirloin steak, zucchini noodles</li>
        </ul>
        <button type="button" class="btn-meal" onclick="downloadPDF(this)">Download Full Plan PDF <i class="bi bi-download" style="margin-left: 5px;"></i></button>
      </div>
    </div>

    <!-- Plan 5 -->
    <div class="meal-card maintenance" data-category="maintenance">
      <div class="meal-img-wrap">
        <i class="bi bi-cup-straw"></i>
        <div class="meal-goal-badge">Maintenance</div>
      </div>
      <div class="meal-content">
        <h3 class="meal-title">Plant-Based Power</h3>
        <p class="meal-desc">A 100% vegan meal plan optimized for athletes. Contains complete amino acid profiles without relying on animal products.</p>
        
        <div class="nutrients-box">
          <div class="macros-grid">
            <div class="macro-item cals"><span class="macro-val">2000</span><span class="macro-lbl">Kcal</span></div>
            <div class="macro-item"><span class="macro-val">130g</span><span class="macro-lbl">Protein</span></div>
            <div class="macro-item"><span class="macro-val">220g</span><span class="macro-lbl">Carbs</span></div>
            <div class="macro-item"><span class="macro-val">65g</span><span class="macro-lbl">Fats</span></div>
          </div>
        </div>

        <ul class="meal-list">
          <li><i class="bi bi-check-circle-fill"></i> <strong>Breakfast:</strong> Tofu scramble, sourdough bread</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Lunch:</strong> Lentil and chickpea curry, brown rice</li>
          <li><i class="bi bi-check-circle-fill"></i> <strong>Dinner:</strong> Seitan steak, roast potatoes</li>
        </ul>
        <button type="button" class="btn-meal" onclick="downloadPDF(this)">Download Full Plan PDF <i class="bi bi-download" style="margin-left: 5px;"></i></button>
      </div>
    </div>

  </div>
</div>

<footer class="pub-footer">
  <div class="brand">APEX<span>FITNESS</span></div>
  <span>28 St Michaels Rd, Colombo 00300 &nbsp;·&nbsp; +94 11 234 5678</span>
  <a href="${pageContext.request.contextPath}/landing.html" style="color:var(--accent);">← Back to Website</a>
</footer>

<script>
  function downloadPDF(btn) {
    try {
      const card = btn.closest('.meal-card');
      const title = card.querySelector('.meal-title').innerText;
      const desc  = card.querySelector('.meal-desc').innerText;
      const badge = card.querySelector('.meal-goal-badge').innerText;
      const filename = title.toLowerCase().replace(/[^a-z0-9]/g, '-') + '-meal-plan.pdf';

      // Get macros
      const macroItems = card.querySelectorAll('.macro-item');
      const macros = [];
      macroItems.forEach(function(item) {
        macros.push({
          val: item.querySelector('.macro-val').innerText,
          lbl: item.querySelector('.macro-lbl').innerText
        });
      });

      // Get meals
      const mealItems = card.querySelectorAll('.meal-list li');
      const meals = [];
      mealItems.forEach(function(li) {
        meals.push(li.innerText.replace(/^\s*✓?\s*/, '').trim());
      });

      // Button loading state
      const origHTML = btn.innerHTML;
      btn.innerHTML = '<i class="bi bi-hourglass-split"></i> Generating...';
      btn.disabled = true;

      // Build PDF with jsPDF
      const { jsPDF } = window.jspdf;
      const doc = new jsPDF('p', 'mm', 'a4');
      const W = doc.internal.pageSize.getWidth();
      var y = 20;

      // ── Header band ──
      doc.setFillColor(22, 22, 22);
      doc.rect(0, 0, W, 50, 'F');
      doc.setFillColor(200, 240, 61);
      doc.rect(0, 48, W, 2, 'F');

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(28);
      doc.setTextColor(255, 255, 255);
      doc.text('APEX FITNESS', 20, y + 10);

      doc.setFontSize(10);
      doc.setTextColor(200, 240, 61);
      doc.text('EXPERT MEAL PLAN', 20, y + 20);

      // Badge
      doc.setFontSize(9);
      doc.setTextColor(200, 200, 200);
      doc.text(badge.toUpperCase(), W - 20, y + 10, { align: 'right' });

      y = 65;

      // ── Plan title ──
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(22);
      doc.setTextColor(40, 40, 40);
      doc.text(title, 20, y);
      y += 10;

      // ── Description ──
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(10);
      doc.setTextColor(100, 100, 100);
      var descLines = doc.splitTextToSize(desc, W - 40);
      doc.text(descLines, 20, y);
      y += descLines.length * 5 + 10;

      // ── Macros table ──
      doc.setFillColor(245, 245, 245);
      doc.roundedRect(20, y, W - 40, 28, 4, 4, 'F');

      var macroX = 30;
      var cellW = (W - 60) / macros.length;
      macros.forEach(function(m, i) {
        var cx = macroX + i * cellW;
        doc.setFont('helvetica', 'bold');
        doc.setFontSize(18);
        doc.setTextColor(i === 0 ? 80 : 40, i === 0 ? 160 : 40, i === 0 ? 20 : 40);
        doc.text(m.val, cx + cellW / 2, y + 12, { align: 'center' });

        doc.setFont('helvetica', 'normal');
        doc.setFontSize(7);
        doc.setTextColor(140, 140, 140);
        doc.text(m.lbl.toUpperCase(), cx + cellW / 2, y + 20, { align: 'center' });
      });
      y += 38;

      // ── Daily meal plan ──
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(14);
      doc.setTextColor(40, 40, 40);
      doc.text('DAILY MEAL PLAN', 20, y);
      y += 3;

      doc.setDrawColor(200, 240, 61);
      doc.setLineWidth(0.8);
      doc.line(20, y, 80, y);
      y += 10;

      meals.forEach(function(meal) {
        doc.setFillColor(200, 240, 61);
        doc.circle(24, y - 1.5, 1.5, 'F');
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(10);
        doc.setTextColor(60, 60, 60);
        var mealLines = doc.splitTextToSize(meal, W - 55);
        doc.text(mealLines, 30, y);
        y += mealLines.length * 5 + 4;
      });
      y += 10;

      // ── Guidelines box ──
      doc.setFillColor(248, 248, 248);
      doc.roundedRect(20, y, W - 40, 45, 4, 4, 'F');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(10);
      doc.setTextColor(40, 40, 40);
      doc.text('GENERAL GUIDELINES', 28, y + 10);

      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8);
      doc.setTextColor(100, 100, 100);
      var tips = [
        'Drink 3-4 litres of water daily',
        'Space meals 3-4 hours apart for optimal absorption',
        'Prepare meals in advance for the week',
        'Adjust portions based on your body weight and activity level',
        'Consult your APEX trainer before making major dietary changes'
      ];
      tips.forEach(function(tip, i) {
        doc.text('\u2022  ' + tip, 28, y + 18 + i * 5);
      });
      y += 55;

      // ── Footer ──
      doc.setDrawColor(220, 220, 220);
      doc.line(20, y, W - 20, y);
      y += 8;
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7);
      doc.setTextColor(160, 160, 160);
      doc.text('APEX FITNESS  |  28 St Michaels Rd, Colombo 00300  |  +94 11 234 5678', W / 2, y, { align: 'center' });
      doc.text('This meal plan is for informational purposes only. Consult a healthcare professional before starting any diet.', W / 2, y + 5, { align: 'center' });
      doc.text('Generated on ' + new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' }), W / 2, y + 10, { align: 'center' });

      // Save
      doc.save(filename);

      // Restore button
      setTimeout(function() {
        btn.innerHTML = origHTML;
        btn.disabled = false;
      }, 500);

    } catch (err) {
      console.error('PDF generation error:', err);
      alert('PDF generation failed. Please try again.');
      btn.innerHTML = 'Download Full Plan PDF <i class="bi bi-download" style="margin-left: 5px;"></i>';
      btn.disabled = false;
    }
  }

  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      // active state
      document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      // filter logic
      const filter = btn.dataset.filter;
      document.querySelectorAll('.meal-card').forEach(card => {
        if (filter === 'all' || card.dataset.category === filter) {
          card.style.display = 'flex';
        } else {
          card.style.display = 'none';
        }
      });
    });
  });
</script>

</body>
</html>
