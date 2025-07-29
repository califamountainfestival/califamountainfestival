$min = "15:00"
$max = "20:00"
$startAt = New-TimeSpan -Days 0 -Hours 8 -Minutes 30
$PKs = @(
'5.0: Cruce Arrastraculos',
'9.5: Rotonda',
'10.5: Meta'
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