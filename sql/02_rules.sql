USE WomenLeague;
GO

/*──────────────────────────────────────────────────────────────────────────────
  A) Yardımcı: Lig genelinde "puan / gol averajı" katsayısı (regresyon eğimi)
    Sonuç tek satır: pts_per_goal ≈ 0.529 (ekran görüntülerindeki değer)
──────────────────────────────────────────────────────────────────────────────*/
IF OBJECT_ID('dbo.wsl_v_points_per_goal','V') IS NOT NULL DROP VIEW dbo.wsl_v_points_per_goal;
GO
CREATE VIEW dbo.wsl_v_points_per_goal AS
WITH L AS (
    SELECT TRY_CONVERT(decimal(10,2), gd)   AS gd,
           TRY_CONVERT(decimal(10,2), points) AS pts
    FROM   dbo.wsl_v_league_all
    WHERE  gd IS NOT NULL AND points IS NOT NULL
),
S AS (
    SELECT AVG(gd)  AS avg_gd,
           AVG(pts) AS avg_pts
    FROM   L
),
V AS (
    SELECT
      cov_gp = SUM( (L.gd - S.avg_gd) * (L.pts - S.avg_pts) ),
      var_gd = SUM( (L.gd - S.avg_gd) * (L.gd - S.avg_gd) )
    FROM L CROSS JOIN S
)
SELECT CAST(cov_gp / NULLIF(var_gd,0) AS decimal(10,3)) AS pts_per_goal
FROM V;
GO

/*──────────────────────────────────────────────────────────────────────────────
  B) Satış Adayları: City içi oyuncular için bayraklar ve öncelik
     Kurallar:
       - minutes >= 600 ve comp_pct < 40        → r_low_comp
       - minutes >= 600 ve gls90 < 0.9*npxg90   → r_underfinish
       - role_imp < 0.80                        → r_low_role
       - age <= 21 ise satışa zorlama yok (koru/loan) → r_young
     Öncelik: 2*low_comp + 2*underfinish + 1*low_role
     Satış bayrağı: genç değilse ve (en az 2 kırmızı) ve minutes>=600
──────────────────────────────────────────────────────────────────────────────*/
IF OBJECT_ID('dbo.wsl_v_player_transfer_flags','V') IS NOT NULL DROP VIEW dbo.wsl_v_player_transfer_flags;
GO
CREATE VIEW dbo.wsl_v_player_transfer_flags AS
WITH base AS (
    SELECT
      player, team, position, season,
      age       = TRY_CONVERT(int,            age),
      minutes   = TRY_CONVERT(int,            minutes),
      comp_pct  = TRY_CONVERT(decimal(5,2),   composite_percentile_100),
      gls90     = TRY_CONVERT(decimal(6,3),   gls_per90),
      npxg90    = TRY_CONVERT(decimal(6,3),   npxg_per90),
      role_imp  = TRY_CONVERT(decimal(5,2),   role_impact_score)
    FROM dbo.wsl_v_player_percentiles
),
rules AS (
    SELECT *,
      r_low_comp    = CASE WHEN minutes >= 600 AND comp_pct < 40       THEN 1 ELSE 0 END,
      r_underfinish = CASE WHEN minutes >= 600 AND gls90 < 0.9*npxg90  THEN 1 ELSE 0 END,
      r_low_role    = CASE WHEN role_imp < 0.80                         THEN 1 ELSE 0 END,
      r_young       = CASE WHEN age <= 21                                THEN 1 ELSE 0 END
    FROM base
)
SELECT
  player, team, position, season, age, minutes, comp_pct, gls90, npxg90, role_imp,
  transfer_priority = 2*r_low_comp + 2*r_underfinish + r_low_role,
  transfer_out_flag = CASE
                        WHEN r_young = 1 THEN 0
                        WHEN (r_low_comp + r_underfinish + r_low_role) >= 2 AND minutes >= 600 THEN 1
                        ELSE 0
                      END,
  reasons = CONCAT(
              CASE WHEN r_low_comp=1    THEN 'low composite; '  ELSE '' END,
              CASE WHEN r_underfinish=1 THEN 'under xG; '       ELSE '' END,
              CASE WHEN r_low_role=1    THEN 'low role impact; 'ELSE '' END
            )
FROM rules;
GO

/*──────────────────────────────────────────────────────────────────────────────
  C) City için "sat" listesi (Top-5)
──────────────────────────────────────────────────────────────────────────────*/
IF OBJECT_ID('dbo.wsl_v_city_sell_top5','V') IS NOT NULL DROP VIEW dbo.wsl_v_city_sell_top5;
GO
CREATE VIEW dbo.wsl_v_city_sell_top5 AS
SELECT TOP (5)
  player, team, position, season, age, minutes,
  comp_pct, gls90, npxg90, role_imp,
  transfer_priority, reasons
FROM dbo.wsl_v_player_transfer_flags
WHERE UPPER(team) = 'MANCHESTER CITY'
  AND transfer_out_flag = 1
ORDER BY transfer_priority DESC, comp_pct ASC;
GO

/*──────────────────────────────────────────────────────────────────────────────
  D) City'nin pozisyon bazlı bitiricilik ortalaması (gls90) ile
     aday oyuncuların karşılaştırılması → "global buy top10"
     Parametreler:
       - exp_minutes = 1500 (≈ 16–17 maç)
       - pts_per_goal = wsl_v_points_per_goal'dan
     Filtreler:
       - minutes >= 600, City dışı
       - kalite eşikleri: comp_pct >= 80, role_imp >= 0.60
──────────────────────────────────────────────────────────────────────────────*/
IF OBJECT_ID('dbo.wsl_v_global_buy_top10','V') IS NOT NULL DROP VIEW dbo.wsl_v_global_buy_top10;
GO
CREATE VIEW dbo.wsl_v_global_buy_top10 AS
WITH params AS (
    SELECT CAST(1500 AS int) AS exp_minutes,
           (SELECT TOP 1 pts_per_goal FROM dbo.wsl_v_points_per_goal) AS pts_per_goal
),
city_pos AS (
    SELECT position,
           city_gls90_avg = AVG(TRY_CONVERT(decimal(6,3), gls_per90))
    FROM dbo.wsl_v_player_percentiles
    WHERE UPPER(team) = 'MANCHESTER CITY'
    GROUP BY position
),
pool AS (
    SELECT
      player, team, position, season, age,
      minutes  = TRY_CONVERT(int,          minutes),
      gls90    = TRY_CONVERT(decimal(6,3),  gls_per90),
      npxg90   = TRY_CONVERT(decimal(6,3),  npxg_per90),
      comp_pct = TRY_CONVERT(decimal(5,2),  composite_percentile_100),
      role_imp = TRY_CONVERT(decimal(5,2),  role_impact_score)
    FROM dbo.wsl_v_player_percentiles
    WHERE minutes >= 600
      AND UPPER(team) <> 'MANCHESTER CITY'
),
joined AS (
    SELECT p.*, cp.city_gls90_avg, pr.exp_minutes, pr.pts_per_goal,
           expected_goals_added =
             CASE WHEN p.gls90 > cp.city_gls90_avg
                  THEN (p.gls90 - cp.city_gls90_avg) * (pr.exp_minutes/90.0)
                  ELSE 0 END
    FROM pool p
    JOIN city_pos cp ON cp.position = p.position
    CROSS JOIN params pr
),
scored AS (
    SELECT *,
           predicted_points_uplift = CAST(expected_goals_added * pts_per_goal AS decimal(8,2)),
           reasons_buy = CONCAT(
               'gls90 ', FORMAT(gls90, 'N2'), ' vs City avg ', FORMAT(city_gls90_avg, 'N2'),
               ' | comp ', FORMAT(comp_pct,'N0'),
               ' | role ', FORMAT(role_imp,'N2'),
               ' | +', FORMAT(expected_goals_added*pts_per_goal, 'N2'), ' pts'
           ),
           reasons_buy_owner = CONCAT(
               'Adds ~', FORMAT(expected_goals_added*pts_per_goal, 'N2'),
               ' pts if plays ', exp_minutes, ' mins (higher finisher than City ', position, ').'
           )
    FROM joined
    WHERE comp_pct >= 80 AND role_imp >= 0.60
)
SELECT TOP (10)
  player, team, position, season, age, minutes, gls90, npxg90, comp_pct, role_imp,
  expected_goals_added, pts_per_goal, predicted_points_uplift,
  reasons_buy_owner, reasons_buy
FROM scored
ORDER BY predicted_points_uplift DESC, comp_pct DESC;
GO

/*──────────────────────────────────────────────────────────────────────────────
  E) Dilim (Slicer) boyutları – Power BI için Season & Position
──────────────────────────────────────────────────────────────────────────────*/
IF OBJECT_ID('dbo.wsl_v_dim_season','V') IS NOT NULL DROP VIEW dbo.wsl_v_dim_season;
GO
CREATE VIEW dbo.wsl_v_dim_season AS
SELECT DISTINCT season FROM dbo.wsl_v_league_all
UNION
SELECT DISTINCT season FROM dbo.wsl_v_player_percentiles;
GO

IF OBJECT_ID('dbo.wsl_v_dim_position','V') IS NOT NULL DROP VIEW dbo.wsl_v_dim_position;
GO
CREATE VIEW dbo.wsl_v_dim_position AS
SELECT DISTINCT position FROM dbo.wsl_v_player_percentiles;
GO

/*──────────────────────────────────────────────────────────────────────────────
  F) Raporlama “tek gerçek” fact görünümü:
     BUY + SELL birleşik → tüm slicer/KPI/grafikler aynı kaynağa bakar
──────────────────────────────────────────────────────────────────────────────*/
IF OBJECT_ID('dbo.wsl_v_player_decision_fact','V') IS NOT NULL DROP VIEW dbo.wsl_v_player_decision_fact;
GO
CREATE VIEW dbo.wsl_v_player_decision_fact AS
SELECT
  scenario = 'BUY',
  season, team, player, position, age, minutes,
  comp_pct, role_imp, gls90, npxg90,
  expected_goals_added,
  pts_per_goal,
  predicted_points_uplift,
  reasons_owner = reasons_buy_owner,
  reasons       = reasons_buy
FROM dbo.wsl_v_global_buy_top10

UNION ALL

SELECT
  scenario = 'SELL',
  season, team, player, position, age, minutes,
  comp_pct, role_imp, gls90, npxg90,
  expected_goals_added = CAST(NULL AS decimal(8,2)),
  pts_per_goal         = CAST(NULL AS decimal(8,3)),
  predicted_points_uplift = CAST(NULL AS decimal(8,2)),
  reasons_owner = CAST(NULL AS varchar(300)),
  reasons
FROM dbo.wsl_v_city_sell_top5;
GO