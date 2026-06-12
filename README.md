# ✈️ Airlines Business Loyalty Analysis

## 📖 Business Context
The airline industry is becoming increasingly competitive, making customer retention a key driver of profitability. Loyalty programs play a crucial role in strengthening relationships, rewarding frequent flyers, and maximizing customer lifetime value (CLV). This project analyzes the airline's loyalty data to evaluate tier performance, customer behavior, and retention patterns, providing actionable insights to optimize the program's overall effectiveness.

---

## 🎯 Objectives
* Evaluate overall loyalty performance through key metrics such as retention rate, average flights per customer, and CLV.
* Assess tier-based behavior across Aurora, Nova, and Star tiers to identify value contribution and responsiveness to promotions.
* Compare Promotion vs. Standard enrollments to determine whether promotional campaigns drive sustainable loyalty or short-term activation.
* Provide data-driven recommendations to improve retention, optimize promotional investment, and enhance tier upgrade strategies for long-term loyalty growth.

---

## 🛠️ Tools Used
* **Azure SQL:** Data querying and preparation.
* **Google Sheets:** Data visualization and analysis.

---

## 🗂️ Data Overview & Preparation
The analysis utilizes a star schema consisting of one Fact table and two Dimension tables:
* **Calendar Table (Dim):** Provides the structure of time.
* **Customer Loyalty History Table (Dim):** Records demographic profiles and membership details.
* **Customer Flight Activity Table (Fact):** Records monthly flight activity, distance flown, and points earned/redeemed.

### Data Cleaning Steps
* **Customer Flight Activity Table:** Confirmed 392,936 total rows with NO NULL values.
* **Customer Loyalty History Table:** Contained 16,737 total rows.
* **Cancellation Data:** 14,670 NULL values in Cancellation Year/Month were kept as they represent active customers still using their loyalty cards.
* **Salary Data:** Handled 4,238 missing values by replacing them with `0` to avoid biased data removal. Addressed 20 negative salary values by converting them to positive absolute values using the `ABS()` function.

---

## 📊 Key Insights & Findings

### Overall Performance Metrics
* **Total Customers:** 16,737.
* **Total Flights:** 508,808.
* **Average Flights per Customer:** 30.40.
* **Flight Distances:** The majority of flights are short to medium distances, with 1-5,000 km accounting for ~53% (267.1K flights) and 5,001-15,000 km accounting for ~43% (216.5K flights). Long-haul flights (>15,000 km) are rare, making up only ~4% of the volume.
* **Seasonality:** Travel demand consistently spikes during holiday seasons (e.g., December 2017: +38.91%, December 2018: +46.68%) and mid-year summer vacations (e.g., May 2018: +45.18%).

### Persona & Tier Analysis
The loyalty program utilizes a pyramid structure where value concentration increases with the tier level:

* **Star Tier (Entry-Level):** Represents the largest customer base (7,637 members) and the highest flight volume, but generates the lowest CLV (~6.7K). Members are predominantly younger, single (30.13%), price-sensitive, and fly short-haul routes based on promotions.
* **Nova Tier (Mid-Level):** A mature, family-oriented segment (59.80% married) with 5,671 members. They show stable spending power, a moderate CLV (~8.1K), and consistent flight frequency, making them ideal candidates for upgrades.
* **Aurora Tier (Premium):** The smallest segment (3,429 members) but delivers the highest CLV (~10.7K). These are highly educated, stable travelers who are least influenced by promotions and highly sensitive to quality and recognition.

### Enrollment Strategy: Promotion vs. Standard
* The 2018 Promotion group showed a short-term retention rate of 88.16%, slightly higher than the Standard group's 87.62%.
* Promotions effectively activate new users but have minimal impact on long-term loyalty.
* Lower-tier members (Star) are the most responsive to promotional efforts, while the premium Aurora tier shows no significant change in retention due to promotions.
* Standard enrollments demonstrate a highly stable long-term retention baseline of ~83-85% across multiple years.

---

## 💡 Strategic Recommendations

### 1. Personalize Strategy by Tier
| Tier | Focus | Recommended Action |
| :--- | :--- | :--- |
| **Star** | Activation | Continue promotions paired with gamified campaigns (e.g., "Fly 3 Get 1") to build flying habits. Launch a 3-month "Starter Journey". |
| **Nova** | Growth | Introduce a "Nova → Aurora Challenge" (e.g., fly 5 times in 60 days) and offer family-oriented upsell bundles (baggage perks, points pooling). |
| **Aurora** | Retention | Replace monetary discounts with exclusive perks (lounge access, fast check-in). Implement a Status Protection Policy (6-12 month extension during inactive periods). |

### 2. Optimize Long-Term Loyalty
* **Post-Promotion Journeys:** Convert short-term promotional activation into sustained retention by launching 3-6 month post-promo journeys featuring milestone rewards and reactivation emails.
* **Monitor & Optimize:** Build Cohort Dashboards to track Retention, CLV, and Flights at 3, 12, and 24-month intervals. Schedule tier-based campaigns around established seasonal peaks (June-July, December).

---
*Project Date: October 31, 2025* | *Author: Pham Tien Phap
