use [Mindx- BI]
--Check tables
select* from Uni_info
select* from locale
select* from metro_startup_ranking
--Create view for city in big city having LOCALE = 12,13,14
create or alter view city_info as select * from Uni_info where LOCALE =12 or LOCALE = 13 OR LOCALE = 14
--Create view from cte for percentile_rank of Startup rank and select city has percentile_rank >= 0.75
create or alter view rank_dup as
with percentile_table as
	( select *,
		round(percent_rank() over (order by Startup_Rank), 2) percentile_rank
		from metro_startup_ranking
	)
select LOCALE, percentile_rank,Metro_Area_Code,Metro_Area_Main_City,NAME,Metro_Area_Name, Metro_Area_States,Startup_Rank
FROM percentile_table a
JOIN city_info b on a.Metro_Area_Main_City = b.CITY
where percentile_rank >= 0.75
-- view rank_dup
SELECT * FROM dbo.rank_dup;
--Select top 1 University and remove duplicates (row_number)
with rank_order as
(select *,
	ROW_NUMBER() over (order by percentile_rank) as rank_uni
from rank_dup)
select * into final_conclusion from rank_order
where rank_uni = 1
order by Startup_Rank
-- University that fit requirement 
select * from final_conclusion

