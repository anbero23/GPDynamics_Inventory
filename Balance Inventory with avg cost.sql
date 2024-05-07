--CANTIDAD AL IDTIEMPO DESEADO CRUZADO CON COSTO ACTUAL SEGÚN SISTEMA – por almacén
--Here it should have been better to assigned the cost per month solving the issue of avg cost code


with bd1 as (
	select año*100+mes IdTiempo from (select distinct año,mes from dbo.dim_fecha) a
	where año*100+mes>=201910
)

,movimientos as (
	select 
		z.IdTiempo,
		itemnmbr,
		sum(cantidad) Cantidad,
		locncode
	from
	(
		select 
			year(a.docdate)*100+month(a.docdate) IdTiempo,
			--case	when uofm = 'millar' then trxqtyinbase*1e3
			--		else trxqtyinbase
			--end cantidad,
			trxqtyinbase Cantidad,
			a.itemnmbr,
			locncode
			--,a.doctype
		from dbo.see30303 A
		--where doctype not in ('3') 
		--and ITEMNMBR='3050100-0002'
	) z
	group by z.IdTiempo,itemnmbr,locncode
)

,bd3 as (
	select * from bd1, (select distinct itemnmbr,locncode from movimientos) a
)

,bd4 as (
	select	
		a.idtiempo,
		a.itemnmbr,
		a.locncode,
		coalesce(b.cantidad,0) Cantidad 
	from bd3 a
	left join movimientos b on a.itemnmbr = b.itemnmbr and a.idtiempo = b.idtiempo and a.locncode=b.locncode
)

,bd5 as (
	select 
		IdTiempo,
		a.Itemnmbr,
		a.locncode,
		Cantidad,
		sum(a.cantidad) over(partition by a.itemnmbr,a.locncode order by IdTiempo asc rows between unbounded preceding and current row) as CantidadAcumulada
	from bd4 a
)


select distinct
	a.IdTiempo,
	a.Itemnmbr,
	a.locncode,
	b.itemdesc,
	a.Cantidad,
	a.CantidadAcumulada,
	x.Presentcost CostoActual,
	d.Pesokilos,
	e.actnumbr_1,
	left(c.itmclsdc,3) Linea,
	c.itmclsdc Nombre_clase
from bd5 a
left join 
(select distinct a.itemnmbr,b.presentcost from
(SELECT distinct ITEMNMBR,MAX(ord) OVER(PARTITION BY ITEMNMBR) ord
FROM DBO.IV00118 
--where itemnmbr='10500020001005'
) a
,DBO.IV00118 b
where a.itemnmbr=b.itemnmbr and a.ord=b.ord
--and a.itemnmbr='10500020001005'
) x 
on a.itemnmbr=x.itemnmbr COLLATE Latin1_General_CI_AS
LEFT JOIN dbo.iv00101 B
ON a.itemnmbr=b.itemnmbr COLLATE Latin1_General_CI_AS
left join dbo.iv40400 c
on c.itmclscd=b.itmclscd COLLATE Latin1_General_CI_AS
left join dbo.peru_maestro_articulos d
on d.codigo=a.itemnmbr COLLATE Latin1_General_CI_AS
left join dbo.gl00100 e
on e.actindx=b.ivivindx
--where a.itemnmbr like '10303041000201%'
