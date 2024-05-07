--Query costo de producto por mes
--Here it was not possible to get the cost for every itemnmbr for every month without having an input or output this month...it is supposed that it still needs to have a cost from the previous month if the current month there is no Kardex


with bd1 as (
	select año*100+mes IdTiempo from (select distinct año,mes from gestion.dbo.dim_fecha) a
	where año*100+mes<=202112 and año*100+mes>=201812
)

,bd2 as (
	select * from bd1, (select distinct itemnmbr from DBO.IV00101) a 
)


,costos as (
	select distinct	 a.IdTiempo
					,a.itemnmbr
					,b.presentcost 
	from
	(SELECT distinct ITEMNMBR
					,IdTiempo
					,MAX(ord) OVER(PARTITION BY ITEMNMBR,IdTiempo order by IdTiempo) ord
	from 
	(select			year(changedate_i)*100+month(changedate_i) IdTiempo
					,itemnmbr
					,ord 
	FROM DBO.IV00118 
	) a
	-----
	) a
	,DBO.IV00118 b
	where a.itemnmbr=b.itemnmbr and a.ord=b.ord
	--and a.itemnmbr='10500020001005'
	)


,bd4 as (
	select	
		a.idtiempo,
		a.itemnmbr,
		coalesce(b.presentcost,0) Costo 
	from bd2 a
	left join costos b on a.itemnmbr = b.itemnmbr and a.idtiempo = b.idtiempo
)


select * 

from bd4
ORDER BY IDTIEMPO
