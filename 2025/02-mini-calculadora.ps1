$min = "05:00"
$max = "14:45"
$startAt = New-TimeSpan -Days 0 -Hours 8 -Minutes 45
$PKs = @(
'0.4: Rotonda C/Mina - C/Catalina Castro',
'0.5: N432A',
'0.6: Rotonda acceso Cerro Muriano - Los Pinares (Ida)',
'2.7: Torreárboles (ida)',
'3.5: Tubo - Paso inferior N432 (ida)',
'5.8: Los Villares Puente + Avituallamiento 1',
'6.3: Desvio para pistas Villares',
'9.1: tubo - Paso inferior N432 (vuelta)',
'10.0: Torreárboles (vuelta)',
'11.0: Desvio GR48 para Arrastraculos',
'11.3: Avituallamiento 2 ARRASTRACULOS + FAN ZONE',
'12.5: Rotonda acceso Cerro Muriano - Los Pinares (vuelta)',
'12.6: N432A',
'12.8: Rotonda C/Mina - C/Catalina Castro',
'13.2: Avituallamiento 3 - META'
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