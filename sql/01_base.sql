USE WomenLeague;
GO

-- 1) Lig düzeyinde: gol averajı ↔ puan ilişkisi (modelimizde kullanacağımız temel)
SELECT TOP (50) season, team, gd, points
FROM   dbo.wsl_v_league_all
ORDER BY season, team;

-- 2) Manchester City sezon trendi (Page-1 çizgisel grafiğe kaynak olabilecek veri)
SELECT season, team, points, wins, losses, draws, ga_per90 = TRY_CONVERT(decimal(6,3), ga) / 30.0
FROM   dbo.wsl_v_team_season_metrics
WHERE  UPPER(team) = 'MANCHESTER CITY'
ORDER BY season;

-- 3) Oyuncu metrikleri: dağılımı görmek (Page-1 scatter: GA/90 ↔ PPG analojisinin oyuncu versiyonu)
SELECT TOP (200) season, team, position, player,
       minutes, composite_percentile_100 AS comp_pct,
       gls_per90 AS gls90, npxg_per90 AS npxg90, role_impact_score AS role_imp
FROM   dbo.wsl_v_player_percentiles
ORDER BY minutes DESC;

-- 4) Bütçe görünümü (Page-1 donut’a paralel)
SELECT season, team, annual_budget_gbp = TRY_CONVERT(decimal(12,2), annual_budget_gbp)
FROM   dbo.wsl_v_team_budgets_norm
ORDER BY season, team;

---
SELECT 
  season,
  team,
  points,
  gf,
  ga,
  gd,
  xg,
  xga,
  ROUND(points_per_game, 2) as points_per_game,
  DENSE_RANK() OVER (PARTITION BY season ORDER BY points DESC, gd DESC, gf DESC) as rank_in_season
FROM (
  SELECT 
    '2022-2023' as season,
    Squad as team,
    Pts as points,
    GF as gf,
    GA as ga,
    GD as gd,
    xG as xg,
    xGA as xga,
    CAST(Pts AS FLOAT) / MP as points_per_game
  FROM [2022-2023 League overview]
  
  UNION ALL
  
  SELECT 
    '2023-2024' as season,
    Squad as team,
    Pts as points,
    GF as gf,
    GA as ga,
    GD as gd,
    xG as xg,
    xGA as xga,
    CAST(Pts AS FLOAT) / MP as points_per_game
  FROM [2023-2024 League overview]
  
  UNION ALL
  
  SELECT 
    '2024-2025' as season,
    Squad as team,
    Pts as points,
    GF as gf,
    GA as ga,
    GD as gd,
    xG as xg,
    xGA as xga,
    CAST(Pts AS FLOAT) / MP as points_per_game
  FROM [2024-2025 League overview (1)]
) combined_seasons
ORDER BY season, rank_in_season;
---
SELECT 
  lo.Squad as team,
  lo.Pts as points,
  lo.GD as gd,
  lo.xG as xg,
  lo.xGA as xga,
  ROUND(
    CASE 
      WHEN bu.annual_budget LIKE '%M' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'M', '') AS FLOAT) * 1000000 * 0.3
      WHEN bu.annual_budget LIKE '%K' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'K', '') AS FLOAT) * 1000 * 0.3
      ELSE CAST(REPLACE(bu.annual_budget, '£', '') AS FLOAT) * 0.3
    END, 0
  ) as transfer_budget,
  ROUND(
    CASE 
      WHEN bu.annual_budget LIKE '%M' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'M', '') AS FLOAT) * 1000000 * 0.7
      WHEN bu.annual_budget LIKE '%K' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'K', '') AS FLOAT) * 1000 * 0.7
      ELSE CAST(REPLACE(bu.annual_budget, '£', '') AS FLOAT) * 0.7
    END, 0
  ) as total_wage_bill,
  2.33 as wage_to_budget_ratio,
  RANK() OVER (ORDER BY 
    CASE 
      WHEN bu.annual_budget LIKE '%M' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'M', '') AS FLOAT) * 1000000
      WHEN bu.annual_budget LIKE '%K' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'K', '') AS FLOAT) * 1000
      ELSE CAST(REPLACE(bu.annual_budget, '£', '') AS FLOAT)
    END DESC
  ) as ratio_rank
FROM [2024-2025 League overview (1)] lo
LEFT JOIN WSL_2024_team_budgets bu ON 
  (CASE 
    WHEN bu.team = 'Arsenal WFC' THEN 'Arsenal'
    WHEN bu.team = 'Chelsea FC Women' THEN 'Chelsea'
    WHEN bu.team = 'Manchester City Women' THEN 'Manchester City'
    WHEN bu.team = 'Manchester United Women' THEN 'Manchester Utd'
    WHEN bu.team = 'Tottenham Hotspur Women' THEN 'Tottenham'
    WHEN bu.team = 'West Ham United Women' THEN 'West Ham'
    WHEN bu.team = 'Everton FC Women' THEN 'Everton'
    WHEN bu.team = 'Brighton & Hove Albion Women' THEN 'Brighton'
    WHEN bu.team = 'Aston Villa Women' THEN 'Aston Villa'
    WHEN bu.team = 'Liverpool FC Women' THEN 'Liverpool'
    WHEN bu.team = 'Leicester City Women' THEN 'Leicester City'
    ELSE bu.team
  END) = lo.Squad
WHERE bu.team IS NOT NULL
ORDER BY 
  CASE 
    WHEN bu.annual_budget LIKE '%M' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'M', '') AS FLOAT) * 1000000
    WHEN bu.annual_budget LIKE '%K' THEN CAST(REPLACE(REPLACE(bu.annual_budget, '£', ''), 'K', '') AS FLOAT) * 1000
    ELSE CAST(REPLACE(bu.annual_budget, '£', '') AS FLOAT)
  END DESC;

---
SELECT TOP 20
  Player as player_name,
  Squad as team,
  Pos as position,
  ROUND(TRY_CAST(_90s AS FLOAT) * 90, 0) as minutes,
  ROUND(TRY_CAST(Gls AS FLOAT) / TRY_CAST(_90s AS FLOAT), 2) as goals_per_90,
  ROUND(TRY_CAST(xG AS FLOAT) / TRY_CAST(_90s AS FLOAT), 2) as xg_per_90,
  ROUND(
    (TRY_CAST(Gls AS FLOAT) / TRY_CAST(_90s AS FLOAT)) - (TRY_CAST(xG AS FLOAT) / TRY_CAST(_90s AS FLOAT)), 
    2
  ) as delta_g_xg
FROM [Player Stats]
WHERE year = '2024-2025' 
  AND TRY_CAST(_90s AS FLOAT) >= 10
  AND TRY_CAST(_90s AS FLOAT) IS NOT NULL
  AND TRY_CAST(Gls AS FLOAT) IS NOT NULL
  AND TRY_CAST(xG AS FLOAT) IS NOT NULL
ORDER BY (TRY_CAST(Gls AS FLOAT) / TRY_CAST(_90s AS FLOAT)) - (TRY_CAST(xG AS FLOAT) / TRY_CAST(_90s AS FLOAT)) ASC;

--- 
SELECT TOP 15
  ps.Player as player_name,
  TRY_CAST(ps.Age AS INT) as age,
  ps.Squad as team,
  ROUND(TRY_CAST(ps._90s AS FLOAT) * 90, 0) as minutes,
  ROUND(TRY_CAST(ps.Gls AS FLOAT) / TRY_CAST(ps._90s AS FLOAT), 2) as goals_per_90,
  0.00 as assists_per_90,
  ROUND(TRY_CAST(pv.market_value AS FLOAT) / 1000000, 2) as market_value_millions,
  ROUND(
    (TRY_CAST(ps.Gls AS FLOAT) / TRY_CAST(ps._90s AS FLOAT)) / 
    NULLIF(TRY_CAST(pv.market_value AS FLOAT) / 1000000, 0), 
    2
  ) as contribution_per_million
FROM [Player Stats] ps
LEFT JOIN [player-values] pv ON 
  ps.Player = pv.player_name 
  AND (
    (ps.Squad = 'Arsenal' AND pv.team = 'Arsenal WFC') OR
    (ps.Squad = 'Chelsea' AND pv.team = 'Chelsea FC Women') OR
    (ps.Squad = 'Manchester City' AND pv.team = 'Manchester City Women') OR
    (ps.Squad = 'Manchester Utd' AND pv.team = 'Manchester United Women') OR
    (ps.Squad = 'Tottenham' AND pv.team = 'Tottenham Hotspur Women') OR
    (ps.Squad = 'West Ham' AND pv.team = 'West Ham United Women') OR
    (ps.Squad = 'Everton' AND pv.team = 'Everton FC Women') OR
    (ps.Squad = 'Brighton' AND pv.team = 'Brighton & Hove Albion Women') OR
    (ps.Squad = 'Aston Villa' AND pv.team = 'Aston Villa Women') OR
    (ps.Squad = 'Liverpool' AND pv.team = 'Liverpool FC Women')
  )
WHERE ps.year = '2024-2025'
  AND TRY_CAST(ps._90s AS FLOAT) >= 10
  AND ps.Pos LIKE 'FW%'
  AND pv.market_value IS NOT NULL
  AND TRY_CAST(pv.market_value AS FLOAT) > 0
ORDER BY contribution_per_million DESC;

-- 
SELECT 
  Squad as team,
  Pos as position,
  COUNT(*) as players_count,
  ROUND(AVG(TRY_CAST(_90s AS FLOAT) * 90), 0) as avg_minutes,
  ROUND(AVG(TRY_CAST(Gls AS FLOAT) / TRY_CAST(_90s AS FLOAT)), 2) as avg_goals_per_90,
  0.00 as avg_assists_per_90
FROM [Player Stats]
WHERE year = '2024-2025'
  AND TRY_CAST(_90s AS FLOAT) > 0
  AND TRY_CAST(Gls AS FLOAT) IS NOT NULL
  AND _90s IS NOT NULL
  AND Gls IS NOT NULL
GROUP BY Squad, Pos
ORDER BY team, position;


---

SELECT 
  current_season.team,
  current_season.season,
  current_season.points,
  CASE 
    WHEN prev_season.points IS NULL OR prev_season.points = 0 THEN NULL
    ELSE ROUND(((CAST(current_season.points AS FLOAT) - CAST(prev_season.points AS FLOAT)) / CAST(prev_season.points AS FLOAT)) * 100, 1)
  END as points_yoy_pct,
  current_season.xg,
  CASE 
    WHEN prev_season.xg IS NULL OR prev_season.xg = 0 THEN NULL
    ELSE ROUND(((CAST(current_season.xg AS FLOAT) - CAST(prev_season.xg AS FLOAT)) / CAST(prev_season.xg AS FLOAT)) * 100, 1)
  END as xg_yoy_pct,
  current_season.xga
FROM (
  SELECT '2024-2025' as season, Squad as team, Pts as points, xG as xg, xGA as xga
  FROM [2024-2025 League overview (1)]
) current_season
LEFT JOIN (
  SELECT '2023-2024' as season, Squad as team, Pts as points, xG as xg, xGA as xga
  FROM [2023-2024 League overview]
) prev_season ON current_season.team = prev_season.team
ORDER BY current_season.points DESC