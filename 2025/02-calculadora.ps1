$min = "05:00"
$max = "14:40"
$startAt = New-TimeSpan -Days 0 -Hours 8 -Minutes 00
$PKs = @(
'0.4: Rotonda C/Mina - C/Catalina Castro',
'0.5: N432A',
'0.6: Rotonda acceso Cerro Muriano - Los Pinares (Ida)',
'2.7: Torreárboles',
'3.5: Tubo - Paso inferior N432',
'5.2: Los Villares Puente + Avituallamiento 1',
'6.3: Fuente Alcubilla',
'6.7: Desvio GR48 a Gaseoducto',
'13.5: Tunel paso bajo N432 - Paraiso Arenal + Avituallamiento 2',
'14.0: Carretera N432a tramo por arcen',
'14.5: Auxiliar entrada Av Doña Manuela',
'14.8: Rotonda N432a para coger carril bici',
'15.7: Rotonda Doña Manuela con Carretera Santuario Virgen de Linares',
'15.9: Entrada sendero',
'16.5: Entrada sendero hacia La Loma de Los Escalones',
'19.5: Avituallamiento 3 - Explanada mitad Loma de Escalones',
'21.1: Margen derecho 50m',
'22.1: Cruce N432a contenedores acceso Arrastraculos',
'22.5: Avituallamiento 4 - Arrastraculos',
'23.6: Rotonda acceso Cerro Muriano - Los Pinares (Vuelta)',
'23.7: N432A',
'23.9: Rotonda C/Mina - C/Catalina Castro',
'24.5: Avituallamiento 5 - META'
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