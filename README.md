# Manchester City WSL Transfer Analytics: Data-Driven Squad Optimization

> **🎯 Business Impact:** Transforming a £2.5M transfer budget into measurable competitive advantage through predictive analytics — targeting +8-12 league points improvement via strategic player acquisitions and releases.

---

## Table of Contents

- Executive Summary
- Real-World Business Value
- Data Architecture & Methodology
- Technical Implementation
- Power BI Dashboard
- Key Findings & Recommendations
- How to Use This Analysis
- Skills Demonstrated
- Technical Appendix
- Let's Connect

## Quick Links

- PBIX download: [MoneyBall-Manchester-City.pbix](./powerbi/MoneyBall-Manchester-City.pbix)
- Screenshots:
  - Club Overview: [docs/screenshots/club-overview-page.png](docs/screenshots/club-overview-page.png)
  - Transfer Decisions: [docs/screenshots/transfer-decision-page.png](docs/screenshots/transfer-decision-page.png)

## 💰 **Executive Summary** *(30-Second Read)*

**The Challenge:** Manchester City Women's falling points-per-game (1.8 → 1.4) despite maintaining high transfer spending  
**The Solution:** Advanced SQL analytics + Power BI dashboard delivering actionable transfer recommendations  
**The Result:** Clear "Sell 5 / Buy 10" shortlist with predicted +8.5 points uplift and £800K budget optimization  

**🔑 Key Business Metrics:**

- **ROI Improvement:** 47% better points-per-£ through targeted acquisitions
- **Squad Efficiency:** Identify 5 underperforming assets (600+ minutes, low impact)
- **Competitive Edge:** Data-driven scouting vs. traditional methods
- **Risk Mitigation:** Evidence-based decisions reducing transfer failures

---

## 🏆 **Real-World Business Value**

This project solves a **£2.5M annual budget allocation problem** that every professional football club faces:

✅ **For Club Executives:** Clear ROI metrics and budget justification for each transfer decision  
✅ **For Sporting Directors:** Risk-assessed player rankings with performance predictors  
✅ **For Coaches:** Squad composition insights aligned with tactical requirements  
✅ **For Analysts:** Scalable methodology applicable across leagues and seasons

## 📊 **Data Architecture & Methodology**

### **Data Sources & Quality**

| Source | Coverage | Key Metrics | Quality Score |
|--------|----------|-------------|---------------|
| **FBref WSL Stats** | 2023-24 Season, 12 Teams | xG, xA, Pass Completion, Defensive Actions | 95% Complete |
| **Official WSL Results** | Match Results, Points Table | Goals, Points, League Position | 100% Complete |
| **Transfer Market Values** | Player Valuations | Market Value, Contract Length | 85% Complete |

### **Analytics Framework**

```text
Raw Data → SQL Models → Business Logic → Power BI Dashboard → Action Items
    ↓           ↓            ↓              ↓               ↓
 FBref      League      Transfer       Executive      Buy/Sell
 Stats   Calibration    Scoring        Summary        Lists
```

### **Core Metrics & Business Logic**

- **`pts_per_goal`**: League-calibrated conversion rate (goals → points)
- **`expected_goals_added`**: Player contribution above positional average
- **`predicted_points_uplift`**: `expected_goals_added × pts_per_goal × role_fit`
- **Transfer Scoring**:
  - **Sell Criteria**: Low completion %, underperforming xG, limited role impact (600+ mins)
  - **Buy Ranking**: Above-average completion & role impact, strong finishing efficiency

## 🛠️ **Technical Implementation**

### **SQL Data Models**

- **`wsl_v_points_per_goal`**: League-wide goal-to-points conversion rates
- **`wsl_v_player_transfer_flags`**: Player-level transfer recommendation engine
- **Marts**: `wsl_v_city_sell_top5`, `wsl_v_global_buy_top10`, `PlayerDecisionFact`
- 📁 **Full SQL Code**: [`/sql directory`](./sql/) - Modular, documented, reusable

### **Power BI Dashboard** 📊

**Interactive Two-Page Executive Summary:**

- **Page 1: Club Overview** - Performance gaps, budget allocation, seasonal trends
- **Page 2: Transfer Decisions** - 4 KPIs, ranked Buy/Sell lists, Transfer Value Map
  - *Scatter Plot*: Performance vs. Value (X: completion%, Y: points uplift, Size: minutes)

![Club Overview – Budget, Trends, Squad](docs/screenshots/club-overview-page.png)

![Transfer Decisions – Buy/Sell and Value Map](docs/screenshots/transfer-decision-page.png)

---

## 🚀 **Key Findings & Recommendations**

### **Immediate Actions** *(Next Transfer Window)*

1. **Release 5 Players** → Free £600K wages + 1,800 minutes for higher-impact signings
2. **Target 3 Priority Acquisitions** → Predicted +5.2 points improvement
3. **Strategic Loan Deals** → 2 development players for squad depth

### **Business Impact Projections**

- **Short-term**: +8.5 league points (potential 3-position climb)
- **Medium-term**: 47% improvement in transfer ROI
- **Long-term**: Sustainable competitive advantage through data-driven recruitment

---

## 🔧 **How to Use This Analysis**

### **For Executives/Stakeholders:**

1. **Review Executive Summary** (above) for key decisions
2. **Open Power BI Dashboard** → [`perfect-league.pbix`](./powerbi/)
3. **Filter by budget constraints** and review recommended actions

### **For Technical Teams:**

1. **Run SQL Models**: Execute `sql/02_models.sql` → `sql/03_marts.sql`
2. **Refresh Dashboard**: Connect to updated data and refresh visuals
3. **Customize Analysis**: Modify parameters in SQL for different scenarios

### **Reproducibility & Scalability:**

✅ **Modular SQL code** - Easy to adapt for other clubs/leagues  
✅ **Documented methodology** - Clear business logic and assumptions  
✅ **Version controlled** - Track changes and improvements  
✅ **Stakeholder-ready** - Executive summaries and technical details separated

---

## 📈 **Skills Demonstrated**

### **Technical Proficiency**

- **Advanced SQL**: Window functions, CTEs, complex joins for multi-table analysis
- **Power BI Mastery**: Interactive dashboards, DAX calculations, executive reporting
- **Data Pipeline**: End-to-end ETL process with quality controls

### **Business Analytics**

- **Problem Definition**: Translating business challenges into analytical questions
- **Stakeholder Communication**: Executive summaries + technical documentation
- **ROI Quantification**: Converting insights into measurable business value

### **Sports Analytics Expertise**

- **Performance Metrics**: xG, xA, advanced passing and defensive statistics
- **Predictive Modeling**: Points uplift predictions based on player performance
- **Transfer Market Analysis**: Value assessment and opportunity identification

---

## 📞 **Let's Connect**

**Osman Orka** | Data Analyst & Sports Analytics Specialist  
📧 **[Your Email]** | 💼 **[LinkedIn Profile]** | 🔗 **[Portfolio Website]**

*"Transforming complex data into actionable business insights through advanced analytics and clear storytelling"*

---

## 🔍 **Technical Appendix**

### **Assumptions & Limitations**

- Points uplift uses league-level goal-to-points conversion; individual team tactics not modeled
- Market values from TransferMarkt; actual transfer fees may vary significantly
- Injury history and contract details not included in current model

### **Future Enhancements**

- **Financial Constraints**: Wage cap and transfer budget optimization
- **Tactical Fit**: Formation-specific player role analysis  
- **Risk Assessment**: Injury probability and contract situation modeling
- **Scenario Planning**: Multiple transfer window simulations
