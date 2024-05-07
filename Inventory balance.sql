--Para obtener saldo por cuenta contable a fecha actual

select b.actnumbr_1,sum(perdblnc) saldo
--b.actnumbr_1,a.* 
from dbo.gl10110 a
left join gppet.dbo.gl00100 b on a.actindx=b.actindx
where left(b.actnumbr_1,1) in ('2') or b.actnumbr_1='6952300'
group by b.actnumbr_1
