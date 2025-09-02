-- İsteyenler için uyumluluk alias'ları
IF OBJECT_ID('[wsl v_city_sell_top5]','V') IS NOT NULL DROP VIEW [wsl v_city_sell_top5];
GO
CREATE VIEW [wsl v_city_sell_top5] AS SELECT * FROM dbo.wsl_v_city_sell_top5;
GO

IF OBJECT_ID('[wsl v_global_buy_top10]','V') IS NOT NULL DROP VIEW [wsl v_global_buy_top10];
GO
CREATE VIEW [wsl v_global_buy_top10] AS SELECT * FROM dbo.wsl_v_global_buy_top10;
GO

IF OBJECT_ID('[wsl v_player_transfer_flags]','V') IS NOT NULL DROP VIEW [wsl v_player_transfer_flags];
GO
CREATE VIEW [wsl v_player_transfer_flags] AS SELECT * FROM dbo.wsl_v_player_transfer_flags;
GO