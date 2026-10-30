<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Waste Disposal Guide | EcoTrack</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            margin: 0;
            background: #f4faf5;
            font-family: Arial, sans-serif;
            color: #26382c;
        }

        .navbar {
            background: #14532d;
        }

        .navbar-brand {
            color: white !important;
            font-weight: bold;
            font-size: 25px;
        }

        .navbar .nav-link {
            color: white !important;
        }

        .hero {
            background: linear-gradient(135deg, #14532d, #198754);
            color: white;
            text-align: center;
            padding: 45px 15px;
        }

        .hero h1 {
            font-size: 35px;
            font-weight: bold;
        }

        .main-container {
            max-width: 1150px;
            margin: 35px auto;
            padding: 0 18px;
        }

        .search-panel {
            background: white;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 35px;
        }

        .search-panel h2,
        .section-heading {
            color: #14532d;
            font-weight: bold;
        }

        .search-input {
            min-height: 48px;
        }

        .search-button {
            min-height: 48px;
            background: #198754;
            color: white;
            border: none;
            padding: 10px 22px;
            border-radius: 6px;
        }

        .search-button:hover {
            background: #14532d;
            color: white;
        }

        .result-box {
            background: #e7f7eb;
            border-left: 5px solid #198754;
            padding: 18px;
            margin-top: 18px;
            border-radius: 8px;
        }

        .result-box h3 {
            color: #14532d;
            font-size: 21px;
            font-weight: bold;
        }

        .not-found {
            background: #fff3cd;
            padding: 18px;
            border-left: 5px solid #ffc107;
            border-radius: 8px;
            margin-top: 18px;
        }

        .category-card {
            height: 100%;
            background: white;
            border: none;
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.07);
            transition: transform 0.2s;
        }

        .category-card:hover {
            transform: translateY(-4px);
        }

        .category-icon {
            font-size: 38px;
            margin-bottom: 10px;
        }

        .category-card h3 {
            color: #14532d;
            font-size: 21px;
            font-weight: bold;
        }

        .tips {
            background: #eff8f0;
            padding: 14px;
            margin-top: 12px;
            border-radius: 8px;
        }

        .tips li {
            margin-bottom: 7px;
        }

        .toggle-btn {
            background: white;
            color: #198754;
            border: 1px solid #198754;
            border-radius: 6px;
            padding: 8px 12px;
            margin-top: 12px;
        }

        .toggle-btn:hover {
            background: #198754;
            color: white;
        }

        .hidden {
            display: none !important;
        }

        .highlight-card {
            outline: 3px solid #198754;
            background: #f0fff4;
        }

        .eco-tip {
            background: #dff3e5;
            color: #14532d;
            padding: 22px;
            margin-top: 35px;
            border-radius: 12px;
            text-align: center;
        }

        footer {
            margin-top: 45px;
            padding: 18px;
            background: #14532d;
            color: white;
            text-align: center;
        }
    </style>
</head>

<body>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">

        <a class="navbar-brand"
           href="<%= request.getContextPath() %>/dashboard.jsp">
            🌱 EcoTrack
        </a>

        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarContent"
                aria-controls="navbarContent"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/dashboard.jsp">
                        Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/quiz.jsp">
                        Daily Quiz
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/challenges.jsp">
                        Challenges
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/leaderboard.jsp">
                        Leaderboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="<%= request.getContextPath() %>/logout">
                        Logout
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>

<!-- Page heading -->
<section class="hero">
    <div class="container">
        <h1>♻️ Waste Disposal Guide</h1>

        <p>
            Find the right way to dispose of everyday waste
            and help protect our planet.
        </p>

        <% if (fullName != null) { %>
            <p class="mt-3 mb-0">
                Welcome, <strong><%= fullName %></strong>!
            </p>
        <% } %>
    </div>
</section>

<main class="main-container">

    <!-- SEARCH SECTION -->
    <section class="search-panel">

        <h2>🔍 Search for a Waste Item</h2>

        <p>
            Enter an item such as plastic bottle, battery,
            newspaper, food waste or mobile phone.
        </p>

        <form id="wasteSearchForm">

            <div class="row g-2">

                <div class="col-md-8">
                    <input type="text"
                           id="wasteSearch"
                           class="form-control search-input"
                           placeholder="Example: plastic bottle"
                           autocomplete="off">
                </div>

                <div class="col-md-2">
                    <button type="submit"
                            class="search-button w-100">
                        Search
                    </button>
                </div>

                <div class="col-md-2">
                    <button type="button"
                            id="clearSearch"
                            class="btn btn-outline-secondary w-100"
                            style="min-height:48px">
                        Clear
                    </button>
                </div>

            </div>

        </form>

        <div id="searchResult" aria-live="polite"></div>

    </section>

    <!-- WASTE CATEGORIES -->
    <section>

        <h2 class="section-heading">Waste Categories</h2>

        <p class="text-muted mb-4">
            Explore these categories to learn the correct disposal methods.
        </p>

        <div class="row g-4">

            <!-- Organic waste -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="organic-card">

                    <div class="category-icon">🍌</div>
                    <h3>Organic Waste</h3>

                    <p>
                        Food scraps, fruit peels, vegetable waste
                        and garden leaves.
                    </p>

                    <div class="tips hidden" id="organicTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Put suitable food scraps in a compost bin.</li>
                            <li>Separate wet waste from dry waste.</li>
                            <li>Keep plastic out of compost.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="organicTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

            <!-- Recyclable waste -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="recyclable-card">

                    <div class="category-icon">📰</div>
                    <h3>Recyclable Waste</h3>

                    <p>
                        Paper, cardboard, accepted plastic bottles
                        and suitable metal containers.
                    </p>

                    <div class="tips hidden" id="dryTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Keep paper and cardboard dry.</li>
                            <li>Empty and clean accepted containers.</li>
                            <li>Separate materials by type.</li>
                            <li>Check local recycling rules.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="dryTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

            <!-- E-waste -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="ewaste-card">

                    <div class="category-icon">📱</div>
                    <h3>E-Waste</h3>

                    <p>
                        Old mobile phones, computers, chargers
                        and electronic devices.
                    </p>

                    <div class="tips hidden" id="ewasteTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Use an authorised e-waste collection centre.</li>
                            <li>Erase personal data before recycling devices.</li>
                            <li>Do not put electronics in ordinary bins.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="ewasteTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

            <!-- Batteries -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="battery-card">

                    <div class="category-icon">🔋</div>
                    <h3>Batteries</h3>

                    <p>
                        Household batteries and rechargeable batteries.
                    </p>

                    <div class="tips hidden" id="batteryTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Use designated battery collection points.</li>
                            <li>Never burn batteries.</li>
                            <li>Do not put batteries in ordinary bins.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="batteryTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

            <!-- Glass -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="glass-card">

                    <div class="category-icon">🍾</div>
                    <h3>Glass Waste</h3>

                    <p>
                        Glass bottles and jars accepted by local recycling services.
                    </p>

                    <div class="tips hidden" id="glassTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Empty bottles and jars before recycling.</li>
                            <li>Safely contain broken glass.</li>
                            <li>Follow local glass-recycling rules.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="glassTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

            <!-- Hazardous waste -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="hazard-card">

                    <div class="category-icon">☣️</div>
                    <h3>Hazardous Waste</h3>

                    <p>
                        Paints, pesticides and certain household chemicals.
                    </p>

                    <div class="tips hidden" id="hazardTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Follow product labels and local collection rules.</li>
                            <li>Never pour chemicals into drains.</li>
                            <li>Keep chemicals in labelled containers.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="hazardTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

            <!-- Sanitary waste -->
            <div class="col-md-6 col-lg-4">
                <div class="category-card" id="sanitary-card">

                    <div class="category-icon">🧻</div>
                    <h3>Sanitary Waste</h3>

                    <p>
                        Used sanitary pads, diapers and hygiene products.
                    </p>

                    <div class="tips hidden" id="sanitaryTips">
                        <strong>Disposal Tips:</strong>
                        <ul>
                            <li>Wrap used products securely.</li>
                            <li>Use the designated waste bin.</li>
                            <li>Never flush pads or diapers down toilets.</li>
                        </ul>
                    </div>

                    <button type="button" class="toggle-btn"
                            data-target="sanitaryTips">
                        View Disposal Tips
                    </button>

                </div>
            </div>

        </div>
    </section>

    <!-- Eco tip -->
    <section class="eco-tip">
        <h3>🌍 Eco Tip of the Day</h3>
        <p class="mb-0">
            Remember the 3Rs: Reduce, Reuse and Recycle.
            Small daily actions can make a big difference!
        </p>
    </section>

    <div class="text-center mt-4">
        <a href="<%= request.getContextPath() %>/dashboard.jsp"
           class="btn btn-success px-4 py-2">
            ← Back to Dashboard
        </a>
    </div>

</main>

<footer>
    <p class="mb-0">
        © 2026 EcoTrack | Making Every Action Greener 🌱
    </p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- SEARCH FUNCTIONALITY -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    const searchForm = document.getElementById("wasteSearchForm");
    const searchInput = document.getElementById("wasteSearch");
    const searchResult = document.getElementById("searchResult");
    const clearButton = document.getElementById("clearSearch");

    const wasteItems = [
        {
            keywords: ["banana peel", "banana", "fruit peel", "fruit waste",
                "vegetable waste", "vegetables", "food waste",
                "food scraps", "leftover food", "leaves", "garden waste"],
            category: "organic-card",
            tipsId: "organicTips",
            name: "Organic Waste",
            advice: "Put suitable food scraps and garden waste in a compost bin or designated wet-waste collection."
        },
        {
            keywords: ["plastic bottle", "plastic", "plastic container",
                "water bottle", "milk bottle", "newspaper", "paper",
                "cardboard", "carton", "metal can", "tin can",
                "aluminium can", "aluminum can", "recyclable waste"],
            category: "recyclable-card",
            tipsId: "dryTips",
            name: "Recyclable Waste",
            advice: "Clean accepted recyclable items, keep paper dry and use the appropriate recycling bin."
        },
        {
            keywords: ["mobile phone", "mobile", "phone", "smartphone",
                "laptop", "computer", "keyboard", "mouse", "charger",
                "earphones", "headphones", "electronics", "electronic waste",
                "e waste", "ewaste", "television", "tv", "printer"],
            category: "ewaste-card",
            tipsId: "ewasteTips",
            name: "E-Waste",
            advice: "Take electronics to an authorised e-waste collection centre. Erase personal data before recycling."
        },
        {
            keywords: ["battery", "batteries", "lithium battery",
                "rechargeable battery", "phone battery",
                "laptop battery", "button cell"],
            category: "battery-card",
            tipsId: "batteryTips",
            name: "Batteries",
            advice: "Use a designated battery collection point. Never burn batteries or place them in ordinary waste bins."
        },
        {
            keywords: ["glass", "glass bottle", "glass jar",
                "broken glass", "mirror", "drinking glass"],
            category: "glass-card",
            tipsId: "glassTips",
            name: "Glass Waste",
            advice: "Recycle accepted bottles and jars through local collection services. Safely contain broken glass."
        },
        {
            keywords: ["paint", "paint can", "chemical",
                "cleaning chemical", "cleaner", "pesticide",
                "insecticide", "motor oil", "solvent", "bleach",
                "hazardous waste"],
            category: "hazard-card",
            tipsId: "hazardTips",
            name: "Hazardous Waste",
            advice: "Keep the material in its labelled container and follow local hazardous-waste collection instructions."
        },
        {
            keywords: ["sanitary pad", "pad", "pads", "diaper",
                "nappy", "tissue", "used tissue", "hygiene waste",
                "sanitary waste", "bandage"],
            category: "sanitary-card",
            tipsId: "sanitaryTips",
            name: "Sanitary Waste",
            advice: "Wrap used hygiene products securely and dispose of them according to local waste-management rules."
        }
    ];

   function normalise(text) {
        return text.toLowerCase().trim().replace(/\s+/g, " ");
    }

    function hideAllTips() {
        document.querySelectorAll(".tips").forEach(function (tip) {
            tip.classList.add("hidden");
        });

        document.querySelectorAll(".toggle-btn").forEach(function (button) {
            button.textContent = "View Disposal Tips";
        });
    }

    function clearHighlights() {
        document.querySelectorAll(".category-card").forEach(function (card) {
            card.classList.remove("highlight-card");
        });
    }

    function searchWaste(event) {
        event.preventDefault();

        const query = normalise(searchInput.value);
        searchResult.innerHTML = "";
        hideAllTips();
        clearHighlights();

        if (query === "") {
            searchResult.innerHTML =
                '<div class="alert alert-info mt-3">' +
                'Please enter an item, such as plastic bottle.' +
                '</div>';
            searchInput.focus();
            return;
        }

        const item = wasteItems.find(function (waste) {
            return waste.keywords.some(function (keyword) {
                const key = normalise(keyword);

                return key === query ||
                       key.includes(query) ||
                       query.includes(key);
            });
        });

        if (!item) {
            searchResult.innerHTML =
                '<div class="not-found">' +
                '<h3>Item Not Found</h3>' +
                '<p>Try searching for plastic bottle, banana peel, paper, ' +
                'battery, mobile phone, glass bottle, paint or sanitary pad.</p>' +
                '</div>';
            return;
        }

        const card = document.getElementById(item.category);
        const tips = document.getElementById(item.tipsId);

        if (card) {
            card.classList.add("highlight-card");
        }

        if (tips) {
            tips.classList.remove("hidden");
        }

        searchResult.innerHTML =
            '<div class="result-box">' +
            '<h3>Recommended Category: ' + item.name + '</h3>' +
            '<p><strong>Disposal Instructions:</strong> ' +
            item.advice + '</p>' +
            '<p class="mb-0">The matching category is highlighted below.</p>' +
            '</div>';

        if (card) {
            card.scrollIntoView({
                behavior: "smooth",
                block: "center"
            });
        }
    }

    // Search when the user clicks Search or presses Enter.
    searchForm.addEventListener("submit", searchWaste);

    // Show and hide category disposal tips.
    document.querySelectorAll(".toggle-btn").forEach(function (button) {
        button.addEventListener("click", function () {
            const targetId = button.getAttribute("data-target");
            const target = document.getElementById(targetId);

            if (!target) {
                return;
            }

            const isHidden = target.classList.contains("hidden");

            target.classList.toggle("hidden");

            button.textContent = isHidden
                ? "Hide Disposal Tips"
                : "View Disposal Tips";
        });
    });

    // Clear search results.
    clearButton.addEventListener("click", function () {
        searchInput.value = "";
        searchResult.innerHTML = "";

        hideAllTips();
        clearHighlights();

        searchInput.focus();
    });

    console.log("EcoTrack Waste Disposal Guide loaded successfully.");

});
</script>

</body>
</html>