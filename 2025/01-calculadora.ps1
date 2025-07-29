$min = "05:00"
$max = "14:00"
$startAt = New-TimeSpan -Days 0 -Hours 20 -Minutes 00
$PKs = @(
'0.4: Rotonda C/Mina C/Catalina Castro',
'0.5: N432A',
'0.6: Rotonda acceso Cerro Muriano Los Pinares (Ida)',
'2.0: Avituallamiento 1 Explanada GR48-Torreárboles',
'4.2: Tubo (Ida) Paso inferior N432',
'5.6: Avituallamiento 2 Cancela GR48-Finca',
'6.8: Tubo (Vuelta) Paso inferior N432',
'7.7: Torreárboles (Vuelta)',
'8.5: Avituallamiento 3 Explanada GR48-Torreárboles',
'9.8: C/Acera de la Via',
'10.0: C/Cervantes',
'10.1: Avituallamiento 4 Plaza de Andalucía Cerro Muriano',
'10.2: Calle paralela a C.Baena acceso al campo',
'14.2: C/Alfonso XIII',
'14.3:  C/Mina',
'15.0: Avituallamiento 5'
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