--QUERY PARA VER MOVIMIENTOS DE INVENTARIO QUE MOVIERON COSTO

select
JRNENTRY,IVIVINDX,B.ACTNUMBR_1,IVIVOFIX,C.ACTNUMBR_1,doctype,sum(extdcost)
from dbo.SEE30303 A
LEFT join GL00100 B on A.IVIVINDX=B.ACTINDX
LEFT join GL00100 C on A.IVIVOFIX=C.ACTINDX
where VARIANCEQTY <>0
and GLPOSTDT >'20230101'
group by JRNENTRY,IVIVINDX,IVIVOFIX,DOCTYPE,B.ACTNUMBR_1,C.ACTNUMBR_1
order by sum(A.EXTDCOST) DESC
