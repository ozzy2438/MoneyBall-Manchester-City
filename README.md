# ⚽ Manchester City WSL Championship Analytics: Data-Driven Transfer Strategy

## 🎯 Project Overview

**Critical challenge solved:** Converting £2.5M transfer budget into measurable competitive advantage for Manchester City Women's championship pursuit through advanced predictive analytics.

This comprehensive data science project delivers actionable transfer recommendations by analyzing performance gaps, identifying market inefficiencies, and predicting league point improvements from strategic player acquisitions and releases.

**Target Impact:** +8-12 league points improvement via optimized squad composition and tactical system alignment.

## 📊 Background Summary

**The Challenge:** Manchester City Women fell from title contenders to mid-table despite maintaining high transfer spending - demonstrating the critical need for data-driven recruitment over traditional scouting methods.

**The Solution:** End-to-end analytics pipeline combining SQL data modeling, Python predictive modeling, and Power BI executive dashboards to transform raw performance data into strategic transfer decisions.

**Key Question Answered:** Which specific players should Manchester City buy or sell to maximize championship probability within budget constraints?

## 📺 Project Walkthrough Video
**[3-Minute Executive Overview](https://www.canva.com/design/DAGzxo8J3VM/4UN-WJI8tbTppTjsJeVMiw/edit?utm_content=DAGzxo8J3VM&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)** - Essential insights and methodology demonstration

---

### Dashboard Overview (side‑by‑side)

<p align="center">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/451ac6a51f3aeb58f1c9458dfe23ae1e63a6567a/4-b28e25c6.jpg?raw=1" width="49%" alt="Page 1 — Club Overview (budget donut, PPG vs GA/90, season trend)">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/451ac6a51f3aeb58f1c9458dfe23ae1e63a6567a/4-30d6399c.jpg?raw=1" width="49%" alt="Page 2 — Transfer Decisions (value map + shortlist table)">
</p>

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools Used](#tools-used)
- [Data Preparation](#data-preparation)
- [EDA](#eda)
- [Analysis](#analysis)
- [Results and Findings](#results-and-findings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
- [References](#references)

## Project Overview

Comprehensive data analytics project delivering actionable transfer recommendations for Manchester City Women's championship pursuit. This analysis addresses the critical challenge faced by football clubs: maximizing competitive advantage from limited transfer budgets through data-driven decision making.

**Key Question Answered:** Which players should Manchester City Women buy or sell to optimize league points return on £2.5M transfer investment?

## Data Sources

| **Source** | **Description** | **Coverage** | **Key Metrics** |
|------------|-----------------|--------------|-----------------|
| **[FBref WSL Statistics](https://fbref.com/en/)** | Open source player performance data downloaded from FBref | 2023-24 Season, 12 Teams | xG, xA, Pass Completion %, Defensive Actions |
| **Official WSL Results** | Match results and league standings | Complete season data | Goals, Points, League Position |
| **Market Valuations** | Player transfer values | 85% complete coverage | Market Value, Contract Status |

**Data Access & Quality:**
- **Open Source:** All performance data freely downloaded from [FBref.com](https://fbref.com/en/) - publicly available football statistics
- **Data Processing:** Missing market values handled through positional averages
- **Standardization:** Performance metrics normalized per 90 minutes for fair comparison
- **Validation:** All datasets cross-referenced against multiple sources for accuracy

## Tools Used

- **SQL (PostgreSQL)** - Data modeling and transformation | [Download](https://www.postgresql.org/download/)
- **Power BI Desktop** - Interactive dashboard creation | [Download](https://powerbi.microsoft.com/desktop/)
- **Python/Jupyter** - Statistical analysis and modeling | [Download](https://www.anaconda.com/download)
- **Git** - Version control | [Download](https://git-scm.com/downloads)

## Data Preparation

1. **Data Import**: Raw CSV files from FBref processed into structured database tables
2. **Quality Assessment**: Missing value analysis and outlier detection across 300+ player records
3. **Feature Engineering**: Created composite performance metrics and role impact scores
4. **League Calibration**: Calculated goal-to-points conversion rates across WSL teams
5. **Transfer Logic**: Developed buy/sell recommendation algorithms based on performance thresholds
6. **Validation**: Cross-referenced results with actual transfer market activity

## EDA

**Critical Questions Investigated:**

1. **What performance gaps separate title contenders from mid-table teams?**
   - Championship teams average 1.2+ points per game vs. 0.8 for relegation candidates
   - Defensive stability (goals against) more predictive than attacking output

2. **How efficiently do clubs convert transfer spending into league points?**
   - No linear correlation between budget size and league position
   - Quality of acquisitions matters more than quantity

3. **Which individual metrics best predict team contribution?**
   - Pass completion % and role impact score strongest predictors
   - Goals/assists less reliable due to positional variations

4. **Where do market inefficiencies exist?**
   - Undervalued players cluster in defensive midfield positions
   - Over-reliance on attacking metrics creates market bubbles

### Dashboard Screenshots

#### Club Overview — Budget, Trends, Squad
<!-- Club Overview IMAGES (paired, not stacked) -->
<div align="center">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/e344efec2f8309d91ae3ca1b686f7322db9b267b/3-b28e25c6.jpg?raw=1" width="49%" alt="KPI strip — points_gap, pyth_gap, xg/xga, attendance">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/1b95a1eea76d71ae4be2c0a3a473739603f04b70/2-b28e25c6.jpg?raw=1" width="49%" alt="Donut + PPG vs GA/90 scatter + season trend">
</div>

<div align="center">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/451ac6a51f3aeb58f1c9458dfe23ae1e63a6567a/4-b28e25c6.jpg?raw=1" width="49%" alt="Club Overview — combined view (donut + scatter + trend)">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/e344efec2f8309d91ae3ca1b686f7322db9b267b/1-b28e25c6.jpg?raw=1" width="49%" alt="Player matrix by season — minutes, composite percentile, goals/shots per90">
</div>

<div align="center">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/e344efec2f8309d91ae3ca1b686f7322db9b267b/1-b28e25c6.jpg?raw=1" width="49%" alt="Player matrix by season — minutes, composite percentile, goals/shots per90">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/1b95a1eea76d71ae4be2c0a3a473739603f04b70/2-30d6399c.jpg?raw=1" width="49%" alt="Owner insights panel next to matrix — executive takeaways">
</div>

**What to notice**
- KPI cards give quick context: points_gap, pyth_gap, xg/xga, attendance.
- Donut shows annual budget distribution by team.
- Scatter highlights relationship between GA/90 and PPG.
- Line chart shows three-season points trend.
- Matrix breaks down player contributions by season.


#### Transfer Decisions — Buy/Sell and Value Map
<!-- Transfer Decisions IMAGES (paired, not stacked) -->
<div align="center">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/1b95a1eea76d71ae4be2c0a3a473739603f04b70/1-30d6399c.jpg?raw=1" width="49%" alt="Decision KPIs — Sell Avg Comp %, Buy Points Uplift, Sell Players, Sell Minutes">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/e344efec2f8309d91ae3ca1b686f7322db9b267b/2-b28e25c6.jpg?raw=1" width="49%" alt="Priority Players to Buy/Sell — ranked lists">
</div>

<div align="center">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/451ac6a51f3aeb58f1c9458dfe23ae1e63a6567a/3-30d6399c.jpg?raw=1" width="49%" alt="Priority Players to Buy & Sell — detailed bars">
  <img src="https://github.com/ozzy2438/MoneyBall-Manchester-City/blob/451ac6a51f3aeb58f1c9458dfe23ae1e63a6567a/4-30d6399c.jpg?raw=1" width="49%" alt="Transfer Value Map + Decision table (paired with shortlist)">
</div>

**What to notice**
- Left: **Priority Players to Buy** ranked by `predicted_points_uplift`.
- Right: **Priority Players to Sell** with owner reasons and minutes to free.
- Scatter: **X = `comp_pct`**, **Y = `predicted_points_uplift`**, **Size = minutes**, **Legend = position**.
- Table: cross-check of first team/season/scenario for shortlisted players.


## Analysis

### Core Methodology

**SQL Data Models** - Located in `sql/` directory:

```sql
-- League calibration (01_base.sql)
CREATE VIEW wsl_v_points_per_goal AS
SELECT season, AVG(points/goals_for) as pts_per_goal
FROM team_season_stats
GROUP BY season;

-- Transfer recommendation engine (02_rules.sql)
CREATE VIEW wsl_v_player_transfer_flags AS
SELECT player_id,
       CASE WHEN comp_pct < 0.7 AND role_impact < 0.5 THEN 'SELL'
            WHEN expected_goals_added > 0.2 THEN 'BUY'
            ELSE 'HOLD' END as recommendation
FROM player_performance_metrics;
```

**Python Analysis** - `notebooks/manchester_city_transfer_analysis.ipynb`:

```python
# Predictive modeling for championship probability
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor

# Feature engineering
features = ['goals_for_avg', 'goals_against_avg', 'pass_completion',
           'defensive_actions', 'expected_goals_diff']

# Model performance comparison
best_model = GradientBoostingRegressor(n_estimators=100)
current_probability = 5.2%  # Based on 2023-24 metrics
target_probability = 79.7%  # If performance targets achieved
```

**Power BI Dashboard** - `powerbi/MoneyBall-Manchester-City.pbix`

---

## Results and Findings

### Quantitative Results

1. **Current Championship Probability:** 5.2% (based on 2023-24 performance analysis)
2. **Target Championship Probability:** 79.7% (achievable with recommended changes)
3. **Projected Points Improvement:** +8.5 league points through strategic transfers
4. **Budget Optimization:** 47% improvement in points-per-£ efficiency
5. **Squad Utilization:** 1,800 minutes freed through 5 strategic player releases

### Critical Performance Gaps Identified

- **Defensive Transition:** City concedes 0.3 goals/90 above championship standard
- **Midfield Control:** Pass completion 12% below title-winning teams
- **Squad Depth:** Over-reliance on 3 players (accounting for 65% of total minutes)
- **Set Piece Vulnerability:** 23% of goals conceded from dead ball situations

## Recommendations

### Immediate Actions (Next Transfer Window)

- **Release 5 underperforming assets** → Free £600K wages + 1,800 minutes for higher-impact signings
- **Target 3 priority acquisitions** → Focus on defensive midfield specialists with 85%+ pass completion
- **Tactical system adjustment** → Implement possession-based approach to leverage new player profiles

### Strategic Transfer Priorities

1. **Defensive Midfielder** - Primary need to address transition vulnerability
2. **Creative Midfielder** - Secondary priority for chance creation improvement
3. **Versatile Defender** - Squad depth to reduce over-reliance on key players

### Expected Impact

- **Short-term:** +8.5 league points improvement (potential 3-position climb)
- **Medium-term:** 47% improvement in transfer ROI efficiency
- **Long-term:** Sustainable competitive advantage through data-driven recruitment

## Limitations

### Data Constraints

- **Transfer fees not modeled** - Market values may not reflect actual costs due to contract situations
- **Injury history excluded** - Player availability risks not incorporated in current analysis
- **Tactical compatibility simplified** - Role impact scores provide approximation, not detailed system fit

### Model Assumptions

- **Linear performance relationships** - Assumes individual metrics translate directly to team success
- **Static competitive environment** - Other teams' transfer activities not considered
- **Performance consistency** - Expected similar output across different tactical systems

### Impact on Results

- Championship probability estimates carry ±15% confidence interval
- Transfer recommendations require validation against actual tactical requirements
- Financial projections exclude agent fees, contract variables, and wage negotiations

## References

- [Expected Goals Methodology - FBref](https://fbref.com/en/expected-goals-model-explained/) - Statistical foundation for performance metrics
- [Transfer Market Analysis - UEFA Technical Reports](https://www.uefa.com/womenseuro/news/) - Industry benchmarks for player valuation
- [Football Analytics Frameworks - MIT Sloan Sports Conference](https://www.sloansportsconference.com/) - Academic research on performance prediction
- [Data-Driven Recruitment - Harvard Business Review](https://hbr.org/2013/03/the-big-idea-before-you-make-that-big-decision) - Business applications of sports analytics
- [Women's Football Performance Standards - FIFA Technical Study](https://www.fifa.com/technical/women-football) - Competition-specific performance benchmarks

---

**Quick Access:**
- 📊 **Power BI Dashboard:** [`powerbi/MoneyBall-Manchester-City.pbix`](./powerbi/MoneyBall-Manchester-City.pbix)
- 🗄️ **SQL Models:** [`sql/`](./sql/) directory
- 📔 **Python Analysis:** [`notebooks/manchester_city_transfer_analysis.ipynb`](./notebooks/manchester_city_transfer_analysis.ipynb)
- 📁 **Raw Data:** [`data/`](./data/) directory


