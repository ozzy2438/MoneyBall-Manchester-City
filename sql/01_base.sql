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

