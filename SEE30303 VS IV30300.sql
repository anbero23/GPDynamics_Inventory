--Comparación SEE30303 con IV30300
--A veces el sistema no registra bien todos los movimientos y no todo lo que está en la IV30300 está en la SEE30303 (a parte de las transferencias que de por sí no se incluyen en la IV)

with SEE as (
Select *
from [tango\gp2016].[GPUDL].dbo.see30303 a
)

,IV30 as (
Select *
from [tango\gp2016].[GPUDL].dbo.iv30300 b
)

--Select distinct docnumbr
--from SEE a
--where a.docnumbr not in (select distinct docnumbr from IV30 a)

Select distinct docnumbr
from iv30 a
where a.docnumbr not in (select distinct docnumbr from see a)
