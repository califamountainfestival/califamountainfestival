$min = "05:00"
$max = "18:00"
$startAt = New-TimeSpan -Days 0 -Hours 8 -Minutes 30
$PKs = @(
'0.1: Cruce a nivel CO-3408 a la altura de la cadena del CREA desde Campo Golf',
'3.6: Avituallamiento 1 - Explanada cercana pistas IDA',
'5.5: Cruce superior por puente Villares IDA',
'6.7: Avituallamiento 2 - Pista Villares',
'8.0: Cruce superior por puente Villares VUELTA',
'8.6: Avituallamiento 3 - Explanada cercana pistas VUELTA',
'10.9: Cruce a nivel CO-3408 a la altura acceso Campo Golf desde GR48',
'11.7: Avituallamiento 4 - Meta'
)

$minSecs = ([int]($min.Split(":")[0]))*60 + ([int]($min.Split(":")[1]))
$maxSecs = ([int]($max.Split(":")[0]))*60 + ([int]($max.Split(":")[1]))

write "Punto;Tiempo primero;Tiempo corte;Hora primero;Hora corte" 
$PKs | Foreach-Object { 
	$km = [double]($_.Split(":")[0])
	$info = "PK" + $km + $_.Split(":")[1]
	$totalTimeMin = ("{0:hh\:mm\:ss}" -f [timespan]::fromseconds($km*$minSecs))
	$totalTimeMax = ("{0:hh\:mm\:ss}" -f [timespan]::fromseconds($km*$maxSecs))
	
	$hourMin = ("{0:hh\:mm\:ss}" -f ( $startAt + [timespan]::fromseconds($km*$minSecs) ))
	$hourMax = ("{0:hh\:mm\:ss}" -f ( $startAt + [timespan]::fromseconds($km*$maxSecs) ))
	
	write "$info;$totalTimeMin;$totalTimeMax;$hourMin;$hourMax" 
}