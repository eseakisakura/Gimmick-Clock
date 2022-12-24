# 関数の静的メソッド化 

# 立方体の固定値へ
# 900px以上のスライド対応

#  stopwatch gimmik で0のち、マイナス値が表示される
# Ellipse_pos([bool]$sw)の問題
 
Add-Type -AssemblyName System.Windows.Forms > $null 
Add-Type -AssemblyName System.Drawing > $null

cd (Split-Path -Parent $MyInvocation.MyCommand.Path)
[Environment]::CurrentDirectory= pwd # working_dir set
 
# function 
	 
function Recolor_Set([int]$nn){ 

	switch($nn){
	0{	$script:Color= @($Hour_brush, $Minute_brush, $Second_brush)
		$script:Colour= @($Hour_pen, $Minute_pen, $Second_pen)
		break;
	}1{	$script:Color= @($Hour_brush1, $Minute_brush1, $Second_brush1)
		$script:Colour= @($Hour_pen1, $Minute_pen1, $Second_pen1)
		break;
	}2{	$script:Color= @($Hour_brush2, $Minute_brush2, $Second_brush2)
		$script:Colour= @($Hour_pen2, $Minute_pen2, $Second_pen2)
	}
	} #sw
 } #func
 
function Resize_Set(){ 

	$script:IMG= @($frm.Size.Width, ($frm.Size.Height- 40)) # グラフのサイズ

	$Watched.Size($IMG[0])
	$StopWatched.Size($IMG[0])
	$Timered.Size($IMG[0])
	$StopWatched_gimmick.Size($IMG[0])
	$Watched_gimmick.Size($IMG[0])

	[int[]]$script:buff_size= @(($IMG[0]+ 2), ($IMG[1]+ 2))
	[int[]]$script:center= (($buff_size[0]/ 2), ($buff_size[1]/ 2))


	$script:slide_image= New-Object System.Drawing.Bitmap($IMG[0], [Math]::Floor($IMG[1]/ 3))

	$script:slide_Pictbox.ClientSize= $slide_image.Size # Pictbox ha New-Object fuka
	$script:slide_Pictbox.Image= $slide_image

	$script:slide_graphics= [System.Drawing.Graphics]::FromImage($slide_image)

	$script:contxt_slide.MaximumBuffer= @($buff_size[0],$buff_size[1]) -join ","
	$script:buff_slide= $contxt_slide.Allocate($slide_graphics, $slide_Pictbox.ClientRectangle)


	$Swipe.Size($buff_size[1])


	$script:image= New-Object System.Drawing.Bitmap($buff_size) # 書き込む場所
	# $script:uraimage= New-Object System.Drawing.Bitmap($buff_size)

	$script:Pictbox.ClientSize= $image.Size # Pictbox ha New-Object fuka
	$script:Pictbox.Image= $image

	$script:graphics= [System.Drawing.Graphics]::FromImage($image)
	# $script:uragraphics= [System.Drawing.Graphics]::FromImage($uraimage)
	$script:contxtb.MaximumBuffer= @($buff_size[0],$buff_size[1]) -join "," # string出力
	$script:buff= $contxtb.Allocate($graphics, $Pictbox.ClientRectangle)

	$script:Fona= New-Object System.Drawing.Font("Georgia",(($IMG[0]+ $IMG[1])* 0.05/ 2)) # Lucida Console  Garamond  Verdana  Impact
	$script:Fonb= New-Object System.Drawing.Font("Verdana",(($IMG[0]+ $IMG[1])* 0.03/ 2)) # Lucida Console  Garamond  Georgia  Impact

 } #func
 
function Reso([int]$max){ 

	[array]$point= "";
	$point*= $max

	for([int]$i= 0; $i -lt $max; $i++){

		$point[$i]= New-Object System.Drawing.Point # loop obj nomika
	} #

	return $point
 } #func
 
function Ellipse_pos([float]$num, [float]$width, [float]$height){ # , [bool]$sw){ 

	$num+= $IMG[0]/ 4

	[float[]]$wid= ($IMG[0]* $width), ($IMG[1]* $width)

	[float]$rad= $num* $pi* 2/ $IMG[0]		# 全位相角をx座標の最大値で割っておく


	[float]$fx= $height* [Math]::Cos($rad)

	# if($sw -eq $False){
		[float]$fy= $height* [Math]::Sin($rad)
	# }else{
	# 	[float]$fy= $height # cosギミックのみの場合
	# }

	[float]$gx= $center[0]- $fx* $center[0]
	[float]$gy= $center[1]- $fy* $center[1]

	[array]$xy= ($gx- $wid[0]/ 2), ($gy-$wid[1] / 2), $wid[0], $wid[1]

	return $xy

 } #func
 
# ------------ 
 
function XYinput([array] $rr ){ 

	For([int]$i= 0; $i -lt $rr[0].Length; $i++){

		$script:pointed[$i].X= $rr[0][$i]
		$script:pointed[$i].Y= $rr[1][$i]
	} #
 } $func
 
function XYpos([float]$num, [float]$width, [float]$height){ 

	$num+= $IMG[0]/ 4

	$width= $IMG[0]* $width

	[float[]]$rad= 0,0,0, 0,0,0

	$rad[0]= ($num+ $width)* $pi* 2/ $IMG[0]
	$rad[1]= $num* $pi* 2/ $IMG[0]		# 全位相角をx座標の最大値で割っておく
	$rad[2]= ($num- $width)* $pi* 2/ $IMG[0]

	$rad[3]= ($num+ $IMG[0]/ 2- $width)* $pi* 2/ $IMG[0]
	$rad[4]= ($num+ $IMG[0]/ 2)* $pi* 2/ $IMG[0]
	$rad[5]= ($num+ $IMG[0]/ 2+ $width)* $pi* 2/ $IMG[0]

	[float[]]$fx= 0,0,0, 0,0,0
	[float[]]$fy= 0,0,0, 0,0,0

	$fx[0]= $height* 0.5 * [Math]::Cos($rad[0])
	$fx[1]= $height* [Math]::Cos($rad[1])
	$fx[2]= $height* 0.5* [Math]::Cos($rad[2])

	$fx[3]= $height* 0.125* [Math]::Cos($rad[3])
	$fx[4]= $height* 0.25* [Math]::Cos($rad[4])
	$fx[5]= $height* 0.125* [Math]::Cos($rad[5])

	$fy[0]= $height* 0.5 * [Math]::Sin($rad[0])
	$fy[1]= $height* [Math]::Sin($rad[1])
	$fy[2]= $height* 0.5* [Math]::Sin($rad[2])

	$fy[3]= $height* 0.125* [Math]::Sin($rad[3])
	$fy[4]= $height* 0.25* [Math]::Sin($rad[4])
	$fy[5]= $height* 0.125* [Math]::Sin($rad[5])


	[float[]]$gx= 0,0,0, 0,0,0, 0,0,0
	[float[]]$gy= 0,0,0, 0,0,0, 0,0,0

	$gx[0]= $center[0]
	$gx[1]= $center[0]- $fx[0]* $center[0]
	$gx[2]= $center[0]- $fx[1]* $center[0]
	$gx[3]= $center[0]- $fx[2]* $center[0]

	$gx[4]= $center[0]
	$gx[5]= $center[0]- $fx[3]* $center[0]
	$gx[6]= $center[0]- $fx[4]* $center[0]
	$gx[7]= $center[0]- $fx[5]* $center[0]
	$gx[8]= $center[0]

	$gy[0]= $center[1]
	$gy[1]= $center[1]- $fy[0]* $center[1]
	$gy[2]= $center[1]- $fy[1]* $center[1]
	$gy[3]= $center[1]- $fy[2]* $center[1]

	$gy[4]= $center[1]
	$gy[5]= $center[1]- $fy[3]* $center[1]
	$gy[6]= $center[1]- $fy[4]* $center[1]
	$gy[7]= $center[1]- $fy[5]* $center[1]
	$gy[8]= $center[1]

	[array]$xy= $gx, $gy
	XYinput $xy

 } #func
 
function STRpos([float]$num, [int]$uu, [float]$height){ 

	$num+= $IMG[0]/ 4
	$num+= $uu
	[float]$rad= $num* $pi* 2/ $IMG[0]

	[float[]]$pos= 0,0
	$pos[0]= $center[0]- $height* [Math]::Cos($rad)* $center[0]
	$pos[1]= $center[1]- $height* [Math]::Sin($rad)* $center[1]

	return $pos
 } #func
 
function Toggle([bool]$sw, [string]$num){ 

	switch($sw){
	$True{
		switch($num){
		'0'{
			$menu0set.Text= "[v] 0 Alarm"
			$contxt0set.Text= "[v] 0 Alarm"
			break;
		}'1'{
			$menu1set.Text= "[v] 1 Alarm"
			$contxt1set.Text= "[v] 1 Alarm"
			break;
		}'2'{
			$menu2set.Text= "[v] 2 Alarm"
			$contxt2set.Text= "[v] 2 Alarm"
			break;
		}'3'{
			$menu3set.Text= "[v] 3 Jiho"
			$contxt3set.Text= "[v] 3 Jiho"
		}
		} #sw
	}$False{
		switch($num){
		'0'{
			$menu0set.Text= "0 Alarm"
			$contxt0set.Text= "0 Alarm"
			break;
		}'1'{
			$menu1set.Text= "1 Alarm"
			$contxt1set.Text= "1 AlarmReset"
			break;
		}'2'{
			$menu2set.Text= "2 Alarm"
			$contxt2set.Text= "2 Alarm"
			break;
		}'3'{
			$menu3set.Text= "3 Jiho"
			$contxt3set.Text= "3 Jiho"
		}
		} #sw
	}
	} #sw

	return $sw
 } #func
 
function Img_wall(){ 

	$buff.Graphics.Clear($gg)
	$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8))
　　$buff.Render($mask_graphics) # レンダリング
	$mask_image.MakeTransparent($black)

	$buff.Graphics.Clear($gg)
	$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))
　　$buff.Render($mask2_graphics) # レンダリング
	$mask2_image.MakeTransparent($black)

	[float]$xy= $load_image.Width/ $load_image.Height
	[float[]]$resizer= 0,0,0,0
	if($load_image.Width -lt $load_image.Height){
		$resizer[0]= $center[0]- ($IMG[0]* 0.8)* $xy/ 2
		$resizer[1]= $center[1]- ($IMG[1]* 0.8)/ 2
		$resizer[2]= ($IMG[0]* 0.8)* $xy
		$resizer[3]= ($IMG[1]* 0.8)
	}else{
		$resizer[0]= $center[0]- ($IMG[0]* 0.8)/ 2
		$resizer[1]= $center[1]- ($IMG[1]* 0.8)/ $xy/ 2
		$resizer[2]= ($IMG[0]* 0.8)
		$resizer[3]= ($IMG[1]* 0.8)/ $xy
	}

	$buff.Graphics.DrawImage($load_image, $resizer[0],$resizer[1], $resizer[2],$resizer[3])
	$buff.Graphics.DrawImage($mask_image, $Pictbox.ClientRectangle)
　　$buff.Render($crop_graphics) # レンダリング
	$crop_image.MakeTransparent($gg)

	$buff.Graphics.DrawImage($load_image, $resizer[0],$resizer[1], $resizer[2],$resizer[3])
	$buff.Graphics.DrawImage($mask2_image, $Pictbox.ClientRectangle)
　　$buff.Render($crop2_graphics) # レンダリング
	$crop2_image.MakeTransparent($gg)

	# $buff.Graphics.DrawImage($crop_image, $Pictbox.ClientRectangle)
	# $buff.Graphics.DrawImage($crop2_image, $Pictbox.ClientRectangle)
　　# $buff.Render($graphics) # レンダリング
	# $Pictbox.Refresh()

 } #func
 
# ------------ 
 
function Chg_Moder([string]$sw, [string]$md){ 

	switch($sw){
	'Start'{
		switch($md){
		'Watched'{
				$Watched.Start();		break;
		}'StopWatched'{	$StopWatched.Load()
				$StopWatched.tmr.Start();	break;
		}'Timered'{	$Timered.Load()
				$Timered.tmr.Start()
		}
		} #sw
		break;
	}'Stop'{
		switch($md){
		'Watched'{	$Watched.Stop();		break;
		}'StopWatched'{	$StopWatched.tmr.Stop();	break;
		}'Timered'{	$Timered.tmr.Stop()
		}
		} #sw
	}
	} #sw
 } #func
 
function DrawStopWatch([float[]]$elp, [string[]]$now, [float[]]$alm){ 

	[array]$triangle=  $script:Color
	[array]$cercle= $script:Colour
	[array]$mode_change= $script:mode_change

	switch($mode_change[0]){
	'StopWatched'{
		[array]$setalarm= $Watched.setalarm
		[array]$alarmtime= $StopWatched.AlarmTime
		[bool] $sw_brush= $StopWatched.sw_brush

		break;
	}'Timered'{
		[array]$setalarm= $Watched.setalarm
		[array]$alarmtime= $Timered.AlarmTime
		[bool] $sw_brush= $Timered.sw_brush
	}
	} #sw

	if($sw_brush -eq $True ){
		[object] $brush_color= $Millisecond_brush
	}else{
		[object] $brush_color= $silver_brush
	}


	$buff.Graphics.Clear($black)

# ----- $milsec
	$buff.Graphics.FillPie($brush_color, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), -90, $elp[5])
	$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))

# ----- $alarm

	# [int]$view= -1

	if($setalarm[0] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[0] 0.03 0.9

		if($alarmtime[0].Hours -eq $now[0]){ # Hours
			$buff.Graphics.FillEllipse($triangle[0], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[0], $ff[0],$ff[1], $ff[2],$ff[3])
		}

		# if($cpoint[0] -gt ($ff[0]-($IMG[0]* 0.03)) -and $cpoint[0] -lt ($ff[0]+ $ff[2]+($IMG[0]* 0.03))){
		# if($cpoint[1] -gt ($ff[1]-($IMG[0]* 0.03)) -and $cpoint[1] -lt ($ff[1]+ $ff[3]+($IMG[0]* 0.03))){
		# 	$view= 0
		# 	$buff.Graphics.DrawEllipse($White_pen, $ff[0],$ff[1], $ff[2],$ff[3])
		# }
		# }

	}
	if($setalarm[1] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[1] 0.03 0.9

		if($alarmtime[1].Hours -eq $now[0]){
			$buff.Graphics.FillEllipse($triangle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}
	if($setalarm[2] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[2] 0.03 0.9

		if($alarmtime[2].Hours -eq $now[0]){
			$buff.Graphics.FillEllipse($triangle[2], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[2], $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}

# ----- Plate

	$color_pen= $Millisecond_pen
	$color_brush= $Millisecond_brush

	[float[]]$ff= Ellipse_pos ($IMG[0]* 0) 0.015 0.632 $False
	$buff.Graphics.FillEllipse($color_brush, $ff[0],$ff[1], $ff[2],$ff[3])
	[float[]]$ff= Ellipse_pos ($IMG[0]* 0.5) 0.015 0.632 $False
	$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
	[float[]]$ff= Ellipse_pos ($IMG[0]* 0.25) 0.015 0.632 $False
	$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
	[float[]]$ff= Ellipse_pos ($IMG[0]* 0.75) 0.015 0.632 $False
	$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])

# ----- $milstr

	# [array]$tt= "","",""
	# [string[]]$tt[0]= $Alarm0set.Hours,$Alarm0set.Minutes,$Alarm0set.Seconds
	# [string[]]$tt[1]= $Alarm1set.Hours,$Alarm1set.Minutes,$Alarm1set.Seconds
	# [string[]]$tt[2]= $Alarm2set.Hours,$Alarm2set.Minutes,$Alarm2set.Seconds

	# [string[]]$uu= "","",""
	# $uu[0]= $tt[0][0].PadLeft(2,"0")+ ":"+ $tt[0][1].PadLeft(2,"0")+ ":"+ $tt[0][2].PadLeft(2,"0")
	# $uu[1]= $tt[1][0].PadLeft(2,"0")+ ":"+ $tt[1][1].PadLeft(2,"0")+ ":"+ $tt[1][2].PadLeft(2,"0")
	# $uu[2]= $tt[2][0].PadLeft(2,"0")+ ":"+ $tt[2][1].PadLeft(2,"0")+ ":"+ $tt[2][2].PadLeft(2,"0")

	# if($view -ne -1){
	# $buff.Graphics.DrawString($uu[$view], $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.11)))
	# }

	[string]$ss= $now[0].PadLeft(2,"0")+ ":"+ $now[1].PadLeft(2,"0")+ ":"+ $now[2].PadLeft(2,"0")+ "."+ $now[3].PadLeft(3,"0")
	$buff.Graphics.DrawString($ss, $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.17)))

# ----- $hour

	XYpos $elp[0] 0.036 0.6
	$buff.Graphics.FillPolygon($triangle[0], $script:pointed)

	[array]$pos= STRpos $elp[0] -10 0.4
	$buff.Graphics.DrawString(($now[0]% 12), $Fona, $triangle[0], $pos[0],$pos[1])

# ----- $min

	XYpos $elp[1] 0.018 0.8
	$buff.Graphics.FillPolygon($triangle[1], $script:pointed)

	[array]$pos= STRpos $elp[1] -10 0.5
	$buff.Graphics.DrawString($now[1], $Fona, $triangle[1], $pos[0],$pos[1])

# ----- $sec

	XYpos $elp[2] 0.009 0.9
	$buff.Graphics.FillPolygon($triangle[2], $script:pointed)

	[array]$pos= STRpos $elp[2] -10 0.6
	$buff.Graphics.DrawString($now[2], $Fona, $triangle[2], $pos[0],$pos[1])


	$buff.Render($graphics) # レンダリング
	$Pictbox.Refresh()

 } #func
 
function DrawTime([float[]]$elp, [string[]]$now, [float[]]$alm){ 

	[array]$triangle=  $script:Color
	[array]$cercle= $script:Colour

	[array]$setalarm= $Watched.setalarm
	[array]$AlarmTime= $Watched.AlarmTime

	[array]$mode_change= $script:mode_change

# ----- $milsec

	$buff.Graphics.Clear($black)
	# $buff.Graphics.DrawImage($crop_image, $Pictbox.ClientRectangle)

	if($setalarm[3] -eq $True){
		$buff.Graphics.FillEllipse($silver_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8))
		$buff.Graphics.FillPie($Millisecond_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), ($elp[5]- 90), 120)
	}else{ # jiho less
		$buff.Graphics.FillPie($silver_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8),  ($elp[5]+ 30), 240)
	}
	$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))
	# $buff.Graphics.DrawImage($crop2_image, $Pictbox.ClientRectangle)



	$color_pen= $silver_pen
	$color_brush= $silver_brush
	# DIApos ($IMG[0]/ 4) 0.004 0.67
	# $buff.Graphics.FillPolygon($silver_brush, $pointed[1])

# ----- $alarm

	# [array]$tt= "","",""
	# [string[]]$tt[0]= $Alarm0set.Hours,$Alarm0set.Minutes,$Alarm0set.Seconds
	# [string[]]$tt[1]= $Alarm1set.Hours,$Alarm1set.Minutes,$Alarm1set.Seconds
	# [string[]]$tt[2]= $Alarm2set.Hours,$Alarm2set.Minutes,$Alarm2set.Seconds

	# [string[]]$uu= "","",""
	# $uu[0]= $tt[0][0].PadLeft(2,"0")+ ":"+ $tt[0][1].PadLeft(2,"0")+ ":"+ $tt[0][2].PadLeft(2,"0")
	# $uu[1]= $tt[1][0].PadLeft(2,"0")+ ":"+ $tt[1][1].PadLeft(2,"0")+ ":"+ $tt[1][2].PadLeft(2,"0")
	# $uu[2]= $tt[2][0].PadLeft(2,"0")+ ":"+ $tt[2][1].PadLeft(2,"0")+ ":"+ $tt[2][2].PadLeft(2,"0")


	if($setalarm[0] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[0] 0.03 0.9

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($AlarmTime[0].Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($triangle[0], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[0], $ff[0],$ff[1], $ff[2],$ff[3])
		}

		# if($cpoint[0] -gt ($ff[0]- $IMG[0]* 0.03)){
		# if($cpoint[0] -lt ($ff[0]+ $ff[2]+ $IMG[0]* 0.03)){
		# 	if($cpoint[1] -gt ($ff[1]- $IMG[0]* 0.03)){
		# 	if($cpoint[1] -lt ($ff[1]+ $ff[3]+ $IMG[0]* 0.03)){
		# 		$buff.Graphics.FillEllipse($silver_brush, $ff[0],$ff[1], $ff[2],$ff[3])
		# 		$buff.Graphics.DrawString($uu[0], $Fonb, $silver_brush, $cpoint[0],$cpoint[1])
		# 	}
		# 	}
		# }
		# }
	}
	if($setalarm[1] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[1] 0.03 0.9

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($AlarmTime[1].Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($triangle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}
	if($setalarm[2] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[2] 0.03 0.9

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($AlarmTime[2].Hours/ 12)){ # am/pm

			$buff.Graphics.FillEllipse($triangle[2], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[2], $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}

# ----- $Plate

	[float[]]$ff= Ellipse_pos ($IMG[0]* 0) 0.015 0.632 $False
	$buff.Graphics.FillEllipse($color_brush, $ff[0],$ff[1], $ff[2],$ff[3])
	[float[]]$ff= Ellipse_pos ($IMG[0]* 0.5) 0.015 0.632 $False
	$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
	[float[]]$ff= Ellipse_pos ($IMG[0]* 0.25) 0.015 0.632 $False
	$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
	[float[]]$ff= Ellipse_pos ($IMG[0]* 0.75) 0.015 0.632 $False
	$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])

	## $buff.Graphics.DrawImage($uraimage, $Pictbox.ClientRectangle) # ura read
	# $buffc.Graphics.DrawImage($image5, $Pictbox1.ClientRectangle)

# ----- $milstr

	# [array]$pos= STRpos $elp[4] -10 0.7
	# $buff.Graphics.DrawString($now[4], $Fona, $white_brush, $pos[0],$pos[1])


	[string]$ss= $now[0].PadLeft(2,"0")+ ":"+ $now[1].PadLeft(2,"0")+ ":"+ $now[2].PadLeft(2,"0")
	$buff.Graphics.DrawString($ss, $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.17)))
	# $buff.Graphics.DrawString($uu[$view], $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.11)))


## ----- $pend

	## XYpos $elp[4] 0.060 0.4
	## $buff.Graphics.FillPolygon($frame_brush, $pointed[1])


# ----- $hour

	XYpos $elp[0] 0.036 0.6
	$buff.Graphics.FillPolygon($triangle[0], $script:pointed)

	[int[]]$num= 12,1,2,3,4,5,6,7,8,9,10,11

	[array]$pos= STRpos $elp[0] -10 0.4
	$buff.Graphics.DrawString(($num[$now[0]% 12]), $Fona, $triangle[0], $pos[0],$pos[1])

# ----- $min

	XYpos $elp[1] 0.018 0.8
	$buff.Graphics.FillPolygon($triangle[1], $script:pointed)

	[array]$pos= STRpos $elp[1] -10 0.5
	$buff.Graphics.DrawString($now[1], $Fona, $triangle[1], $pos[0],$pos[1])

# ----- $sec

	XYpos $elp[2] 0.009 0.9
	$buff.Graphics.FillPolygon($triangle[2], $script:pointed)

	[array]$pos= STRpos $elp[2] -10 0.6
	$buff.Graphics.DrawString($now[2], $Fona, $triangle[2], $pos[0],$pos[1])


　　　　$buff.Render($graphics) # レンダリング
	# $image.MakeTransparent($black)
	$Pictbox.Refresh()

 } #func
  
# class 
	 
class from_Swipe{ 

	[int[]]  $Fibonacci_num= 0,1,1,2, 3,5,8,13, 21,34,55,89, 144,233,377,610, 987,1597,2584,4181  #
	[int] $count # Fibonacci count
	[int] $j
	[string] $sw
	[bool] $toggle # insert ji err tame

	[int] $pos
	[int] $pix
	[object] $tmr

	from_Swipe([int] $imgy ){

		$this.count= $this.Counter($imgy)
		$this.sw= "insert"
		$this.toggle= $True

		$this.pos= $imgy
		$this.pix= [Math]::Floor($imgy/ 3)

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 16
		$this.tmr.Enabled= $False
	}

	[int] Counter([int] $imgy ){ # [int] <- returnため クラス スコープ メソッド
		for([int] $i= 0; $i -lt $this.Fibonacci_num.Length; $i++){
			if($this.Fibonacci_num[$i] -ge $imgy/ 3){ break; }
		} #
		$i= $i- 1
		return $i
	}

	Size([int] $imgy ){

		$this.count= $this.Counter($imgy)
		$this.pos= $imgy
		$this.pix= [Math]::Floor($imgy/ 3)

		[int] $nn= 0
		switch($this.sw){
		'eject'{
			$nn= $this.pos- $this.pix
			break;
		}'insert'{
			$nn= $this.pos
		}
		} #sw

		$script:slide_Pictbox.Location= @(-10, $nn) -join ","
	}

	Start(){ # メソッド oneshot

		$this.j= $this.count

		$this.tmr.Start()
		$this.toggle= $False

		switch($this.sw){
		'insert'{	$script:slide_Pictbox.Show()
		}
		} #sw
	}

	Stop(){
		$this.Tmr.Stop()
		$this.toggle= $True

		switch($this.sw){
		'insert'{	$this.sw= "eject";
			break;
		}'eject'{	$this.sw= "insert"
			$script:slide_Pictbox.Hide()
		}
		} #sw
	}

	slide(){
		[int] $nn= 0

		switch($this.sw){
		'insert'{
			$nn= $this.pos- ($this.pix- $this.Fibonacci_num[$this.j] ) # 600- (200- 144)
			break;
		}'eject'{
			$nn= $this.pos- $this.Fibonacci_num[$this.j] # 600- 144
		}
		} #sw

		$script:slide_Pictbox.Location= @(-10, $nn) -join ","

		if($this.j -le 0){
			$this.Stop()
		}else{
			$this.j--;
		}
	}
 } #class
 
class from_Short_signal{ 

	# フィールド、# [内部データ(プロパティ)]
	[object] $tmr
	[int] $level
	[int] $count
	[int] $all
	[string[]] $sound_path= "",""
	[System.Diagnostics.Stopwatch] $swh
	[System.Media.SoundPlayer] $mda

	from_Short_signal(){ # コンストラクタ 初期化するとき

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 100
		$this.tmr.Enabled= $False

		$this.level= 0
		$this.count= 0
		$this.all= 12
		$this.sound_path[0]= "C:\Windows\Media\Windows Foreground.wav"
		$this.sound_path[1]= "C:\Windows\Media\Windows Background.wav"
		$this.swh= New-Object System.Diagnostics.Stopwatch
		$this.mda= New-Object System.Media.SoundPlayer
	}

	Start([int]$nn,[int]$aa){ # メソッド
		$this.level= 1
		$this.mda.SoundLocation= $this.sound_path[$nn]
		$this.all= $aa
		$this.tmr.Start()
	}

	Stop(){
		$this.level= 0
		$this.count= 0
		$this.swh.Reset()
		$this.mda.Stop()
		$this.tmr.Stop()
	}

	[void] Timer(){

		switch($this.level){
		2{
			if($this.swh.ElapsedMilliseconds -ge 1000){

				$this.count++;

				if($this.count -ge $this.all){

					if($this.swh.ElapsedMilliseconds -ge 20000){
						$this.Stop()
					}

				}else{

					$this.level= 1
					$this.mda.Stop()
				}
			}
		}1{
			$this.level= 2
			$this.swh.Restart()
			$this.mda.Play()
		}
		} #sw
	}
 } #class
 
class from_Timer_alarm{ 

	# フィールド
	[object] $tmr
	[int] $level
	[int] $count
	[int] $all
	[string[]] $sound_path= "","","",""
	[System.Diagnostics.Stopwatch] $swh
	[System.Media.SoundPlayer] $mda

	from_Timer_alarm(){ # コンストラクタ

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 100
		$this.tmr.Enabled= $False

		$this.sound_path[0]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"
		$this.sound_path[1]= ""
		$this.sound_path[2]= ""
		$this.sound_path[3]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"

		$this.level= 0
		$this.count= 0
		$this.all= 1
		$this.swh= New-Object System.Diagnostics.Stopwatch
		$this.mda= New-Object System.Media.SoundPlayer
	}

	Start([int]$nn){ # メソッド
		$this.level= 1
		$this.mda.SoundLocation= $this.sound_path[$nn]
		$this.tmr.Start()

	}

	Stop(){
		$this.level= 0
		$this.count= 0
		$this.swh.Reset()
		$this.mda.Stop()
		$this.tmr.Stop()
	}

	[void] Timer(){ # voidは出力の指定

		switch($this.level){
		3{
			if($this.swh.ElapsedMilliseconds -ge 30000){

				$this.count++;

				if($this.count -ge $this.all){
						$this.Stop()
				}else{
						$this.level= 1
				}
			}
		}2{
			if($this.swh.ElapsedMilliseconds -ge 20000){

				$this.level= 3
				$this.mda.Stop()
			}
		}1{
			$this.level= 2
			$this.swh.Restart()
			$this.mda.Play()
		}
		} #sw
	}
 } #class
 
class from_Watched{ 

	# フィールド
	[int[]] $IMG= $IMG

	[bool[]]$setalarm= "","","",""
	[array]$AlarmTime= "","",""
	[float[]] $scaller= 0,0,0, 0,0,0

	[object] $tmr
	[object] $Short_signal= $Short_signal
	[object] $Timer_alarm= $Timer_alarm

	from_Watched(){

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 200
		$this.tmr.Enabled= $False

		$this.setalarm[0]= Toggle $True 0
		$this.setalarm[1]= Toggle $True 1
		$this.setalarm[2]= Toggle $True 2
		$this.setalarm[3]= Toggle $True 3 # jiho

		$this.AlarmTime[0]= New-Object TimeSpan(12,24,0)
		$this.AlarmTime[1]= New-Object TimeSpan(10,15,0)
		$this.AlarmTime[2]= New-Object TimeSpan(15,15,0)

		$this.scaller[0]= [Math]::Floor($this.IMG[0]/ 12* ($this.AlarmTime[0].Hours% 12) + $this.IMG[0]/ 12/ 60* $this.AlarmTime[0].Minutes)
		$this.scaller[1]= [Math]::Floor($this.IMG[0]/ 12* ($this.AlarmTime[1].Hours% 12) + $this.IMG[0]/ 12/ 60* $this.AlarmTime[1].Minutes)
		$this.scaller[2]= [Math]::Floor($this.IMG[0]/ 12* ($this.AlarmTime[2].Hours% 12) + $this.IMG[0]/ 12/ 60* $this.AlarmTime[2].Minutes)
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.Tmr.Start()
	}

	Stop(){
		$this.Tmr.Stop()
	}

	Reset(){
		$this.Tmr.Start()
	}

	[void] Timer(){

		$date= [datetime]::Now

		[int[]]$now= $date.Hour, $date.Minute, $date.Second, $date.Millisecond, "", ""

		if($this.SetAlarm[3] -eq $True){

			if(($now[1]% 2) -eq 0){
			if($now[2] -eq 0){

				if($this.Short_signal.level -eq 0){

					switch($now[1]){
					30{
						$this.Short_signal.Start(1,1)

					}0{
						$this.Short_signal.Start(0,($now[0]% 12))
					}
					} #sw
				}
			}
			}
		}

		if($this.SetAlarm[0] -eq $True){

			if($now[0] -eq $this.AlarmTime[0].Hours){
			if($now[1] -eq $this.AlarmTime[0].Minutes){
			if($now[2] -eq $this.AlarmTime[0].Seconds){

				if($this.Timer_alarm.level -eq 0){

					$this.Timer_alarm.start(0)	# one shot
				}
			}
			}
			}
		}
		if($this.SetAlarm[1] -eq $True){

			if($now[0] -eq $this.AlarmTime[1].Hours){
			if($now[1] -eq $this.AlarmTime[1].Minutes){
			if($now[2] -eq $this.AlarmTime[1].Seconds){

				if($this.Timer_alarm.level -eq 0){

					$this.Timer_alarm.start(1)
				}
			}
			}
			}
		}
		if($this.SetAlarm[2] -eq $True){

			if($now[0] -eq $this.AlarmTime[2].Hours){
			if($now[1] -eq $this.AlarmTime[2].Minutes){
			if($now[2] -eq $this.AlarmTime[2].Seconds){

				if($this.Timer_alarm.level -eq 0){

					$this.Timer_alarm.start(2)
				}
			}
			}
			}
		}

		$script:elapsing[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12) + $this.IMG[0]/ 12/ 60* $now[1])
		$script:elapsing[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1]+ $this.IMG[0]/ 60/ 60* $now[2])
		$script:elapsing[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2])

		if($this.Timer_alarm.level -ne 0){
			$script:elapsing[5]= 360/ 1000* $now[3]	# 回転飾り
		}else{
			$script:elapsing[5]= 360/ 60* $now[2]+ 6/ 1000* $now[3]
		}

		$script:alarming[0]= $this.scaller[0] # 配列代入は丸ごと行わない <- 謎の加算エラーため
		$script:alarming[1]= $this.scaller[1]
		$script:alarming[2]= $this.scaller[2]

		DrawTime $script:elapsing $now $this.scaller

	}
 } #class
 
class from_StopWatched{ 

	[int[]] $IMG= $IMG

	[bool[]]$setalarm= "","","",""
	[array]$AlarmTime= "","",""
	[float[]] $scaller= 0,0,0, 0,0,0

	[int] $time_adj
	[bool] $sw_brush
	[Timespan] $StopWatchSet

	[object] $Timer_alarm= $Timer_alarm
	[object] $Short_signal= $Short_signal

	[object] $tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_StopWatched(){
		$this.time_adj= -1
		$this.sw_brush= $False

		$this.setalarm[0]= Toggle $True 0
		$this.setalarm[1]= Toggle $True 1
		$this.setalarm[2]= Toggle $True 2

		$this.AlarmTime[0]= New-Object TimeSpan(0,1,0)
		$this.AlarmTime[1]= New-Object TimeSpan(0,25,0)
		$this.AlarmTime[2]= New-Object TimeSpan(2,15,0)

		$this.scaller[0]= [Math]::Floor($this.IMG[0]/ 60* $this.AlarmTime[0].Minutes + $this.IMG[0]/ 60/ 60* $this.AlarmTime[0].Seconds)
		$this.scaller[1]= [Math]::Floor($this.IMG[0]/ 60* $this.AlarmTime[1].Minutes + $this.IMG[0]/ 60/ 60* $this.AlarmTime[1].Seconds)
		$this.scaller[2]= [Math]::Floor($this.IMG[0]/ 60* $this.AlarmTime[2].Minutes + $this.IMG[0]/ 60/ 60* $this.AlarmTime[2].Seconds)

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 64
		$this.tmr.Enabled= $False

		$this.StopWatchSet= New-Object TimeSpan(0,0,55)
		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.tmr.Start()
		$this.swh.Start()
		$this.sw_brush= $True
	}

	Stop(){
		$this.swh.Stop()
	}

	Reset(){
		$this.Tmr.Stop()
		$this.swh.Reset()
		$this.sw_brush= $False
		$this.time_adj= -1
	}

	Load(){ # oneshot
		if($this.sw_brush -eq $False){
			$this.time_adj= -1
		}
	}

	[void] Timer(){

		[timespan] $Timspan= $this.Swh.Elapsed
		$Timspan+= $this.StopWatchSet

		[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0


		if($this.SetAlarm[0] -eq $True){

			if($now[0] -eq $this.AlarmTime[0].Hours){
			if($now[1] -eq $this.AlarmTime[0].Minutes){
			if($now[2] -eq $this.AlarmTime[0].Seconds){

				if($this.Timer_alarm.level -eq 0){

					$this.Timer_alarm.start(0)	# one shot
				}
			}
			}
			}
		}

		if($now[1] -ne 0 -and ($now[1]% 5) -eq 0 -and $now[2] -eq 0){

			if($this.Short_signal.level -eq 0){

				switch($now[1]% 10){
				5{
					$this.Short_signal.Start(1,1)
				}0{
					$this.Short_signal.Start(0,2)
				}
				} #sw
			}
		}



		if($now[0] -le 0 -and $now[1] -le 0 -and $now[2] -le 0 -and $now[3] -le 0){

			$script:elapsing= 0,0,0, 0,0,0

			$date= [datetime]::Now

			if($this.time_adj -eq -1){
				$this.time_adj= $date.second% 4
			}

			switch(($date.second- $this.time_adj+ 4 )% 4){
			1{
				if($date.Millisecond -lt 500){
					$script:elapsing[5]= 360/ 500* $date.Millisecond
				}else{
					$script:elapsing[5]= 360
				}
				break;
			}default{
				$script:elapsing[5]= 0
			}
			} #sw

		}else{
			$script:elapsing[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
			$script:elapsing[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
			$script:elapsing[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
			$script:elapsing[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]
		}

		$script:alarming[0]= $this.scaller[0]
		$script:alarming[1]= $this.scaller[1]
		$script:alarming[2]= $this.scaller[2]

		DrawStopWatch $script:elapsing $now $script:alarming
	}
 } #class
 
class from_Timered{ 

	[int[]] $IMG= $IMG

	[bool[]]$setalarm= "","","",""
	[array]$AlarmTime= "","",""
	[float[]] $scaller= 0,0,0, 0,0,0

	[int] $time_adj
	[bool] $sw_brush
	[Timespan] $TimerSet

	[object] $Timer_alarm= $Timer_alarm
	[object] $Short_signal= $Short_signal

	[object] $tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_Timered(){
		$this.time_adj= -1
		$this.sw_brush= $False

		$this.setalarm[0]= Toggle $True 0
		$this.setalarm[1]= Toggle $True 1
		$this.setalarm[2]= Toggle $True 2

		$this.AlarmTime[0]= New-Object TimeSpan(0,2,0)
		$this.AlarmTime[1]= New-Object TimeSpan(5,5,0)
		$this.AlarmTime[2]= New-Object TimeSpan(0,15,0)

		$this.scaller[0]= [Math]::Floor($this.IMG[0]/ 60* $this.AlarmTime[0].Minutes + $this.IMG[0]/ 60/ 60* $this.AlarmTime[0].Seconds)
		$this.scaller[1]= [Math]::Floor($this.IMG[0]/ 60* $this.AlarmTime[1].Minutes + $this.IMG[0]/ 60/ 60* $this.AlarmTime[1].Seconds)
		$this.scaller[2]= [Math]::Floor($this.IMG[0]/ 60* $this.AlarmTime[2].Minutes + $this.IMG[0]/ 60/ 60* $this.AlarmTime[2].Seconds)

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 64
		$this.tmr.Enabled= $False

		$this.TimerSet= New-Object TimeSpan(0,0,5)
		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.tmr.Start()
		$this.swh.Start()
		$this.sw_brush= $True
	}

	Stop(){
		$this.swh.Stop()
	}

	Reset(){
		$this.Tmr.Stop()
		$this.swh.Reset()
		$this.sw_brush= $False
		$this.time_adj= -1
	}

	Load(){ # oneshot
		if($this.sw_brush -eq $False){
			$this.Reset()
		}
	}

	AutoLoad(){
		if($this.sw_brush -eq $True){

			$this.swh.Stop()
			$this.sw_brush= $False

			$this.Timer_alarm.start(3)
		}
	}

	[void] Timer(){

		[Timespan] $Timspan= -$this.swh.Elapsed
		$Timspan+= $this.TimerSet


		[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0


		if($this.SetAlarm[0] -eq $True){

			if($now[0] -eq $this.AlarmTime[0].Hours){
			if($now[1] -eq $this.AlarmTime[0].Minutes){
			if($now[2] -eq $this.AlarmTime[0].Seconds){

				if($this.Timer_alarm.level -eq 0){

					$this.Timer_alarm.start(0)	# one shot
				}
			}
			}
			}
		}

		if(($now[1]% 5) -eq 4 -and $now[2] -eq 59){

			if($this.Short_signal.level -eq 0){

				switch($now[1]% 10){
				4{		$this.Short_signal.Start(1,1); break;
				}9{		$this.Short_signal.Start(0,2)
				}
				} #sw
			}
		}

		if($now[0] -le 0 -and $now[1] -le 0 -and $now[2] -le 0 -and $now[3] -le 0){

			$this.AutoLoad()
			$script:elapsing= 0,0,0, 0,0,0
			$now= 0,0,0, 0,0,0

			$date= [datetime]::Now

			if($this.time_adj -eq -1){
				$this.time_adj= $date.second% 4
			}

			switch(($date.second- $this.time_adj+ 4 )% 4){
			1{
				# $script:elapsing[5]= -360/ 500* $date.Millisecond
				if($date.Millisecond% 500 -lt 250){
					$script:elapsing[5]= -360
				}else{
					$script:elapsing[5]= 0
				}
				break;
			}2{
				if($date.Millisecond -lt 500){
					$script:elapsing[5]= -360
				}else{
					$script:elapsing[5]= 0
				}
				break;
			}default{
				$script:elapsing[5]= 0
			}
			} #sw

		}else{
			$script:elapsing[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
			$script:elapsing[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
			$script:elapsing[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
			$script:elapsing[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]
		}

		$script:alarming[0]= $this.scaller[0]
		$script:alarming[1]= $this.scaller[1]
		$script:alarming[2]= $this.scaller[2]

		DrawStopWatch $script:elapsing $now $script:alarming
	}
 } #class
 
class from_Watched_gimmick{ 

	[int[]] $IMG= $IMG
	[int] $milsec= $milsec

	[float[]] $real= 0,0,0, 0,0,0
	[float[]] $realer= 0,0,0, 0,0,0

	[object] $Tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_Watched_gimmick(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 32
		$this.tmr.Enabled= $False

		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.Tmr.Start()
		$this.swh.Start()

		$this.ComWatch()
		if($script:mode_change[0] -eq $script:mode_change[1]){

			$this.RetWatch()
		}else{
			$this.NexWatch()
		}
	}

	Stop(){
		$this.Tmr.Stop()
		$this.swh.Reset()
	}

	ComWatch(){
		[array] $date= [datetime]::Now
		[int[]] $now= $date.Hour, $date.Minute, $date.Second, $date.Millisecond, 0, 0
		$now[2]+= $this.milsec/ 1000

		$this.real[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12) + $this.IMG[0]/ 12/ 60* $now[1])
		$this.real[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1]+ $this.IMG[0]/ 60/ 60* $now[2])
		$this.real[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2])
		$this.real[5]= 360/ 60* $now[2]

		$this.realer[0]= $script:Watched.scaller[0]
		$this.realer[1]= $script:Watched.scaller[1]
		$this.realer[2]= $script:Watched.scaller[2]
	}

	NexWatch(){
		if($this.real[0] -le $script:elapsing[0]){ $this.real[0]+= $this.IMG[0] } # -le 同時刻でも1cycle追加
		if($this.real[1] -ge $script:elapsing[1]){ $this.real[1]-= $this.IMG[0] }
		if($this.real[2] -le $script:elapsing[2]){ $this.real[2]+= $this.IMG[0] }
		if($this.real[5] -ge $script:elapsing[5]){ $this.real[5]-= 360 }

		if($this.realer[0] -le $script:alarming[0]){ $this.realer[0]+= $this.IMG[0] }
		if($this.realer[1] -le $script:alarming[1]){ $this.realer[1]+= $this.IMG[0] }
		if($this.realer[2] -le $script:alarming[2]){ $this.realer[2]+= $this.IMG[0] }
	}

	RetWatch(){
		$this.real[0]+= $this.IMG[0] # 単に1cycle追加
		$this.real[1]-= $this.IMG[0]
		$this.real[2]+= $this.IMG[0]
		$this.real[5]-= 360

		$this.realer[0]+= $this.IMG[0]
		$this.realer[1]+= $this.IMG[0]
		$this.realer[2]+= $this.IMG[0]
	}

	Timer(){
		if($this.swh.ElapsedMilliseconds -ge ($this.milsec+ $this.milsec/ 3)){ # + $this.milsec/ 3 safety delay

			$this.Stop()
			Chg_Moder  "Start" $script:mode_change[1]

			$script:mode_change[0]= $script:mode_change[1]
			$script:mode_change[2]= $True

		}else{

			[float] $bai= $this.IMG[0]* $this.Swh.ElapsedMilliseconds/ $this.milsec
			[float] $bah= $bai*1.5
			[float] $baj= 360* $this.Swh.ElapsedMilliseconds/ $this.milsec

			[float[]] $elp= 0,0,0, 0,0,0
			[float[]] $alm= 0,0,0, 0,0,0

			$elp[0]= $bai+ $script:elapsing[0] # 最後の針の位置へ加算
			$elp[1]= -$bai+ $script:elapsing[1]
			$elp[2]= $bai+ $script:elapsing[2]
			$elp[5]= -$baj+ $script:elapsing[5]

			$alm[0]= $bah+ $script:alarming[0]
			$alm[1]= $bah+ $script:alarming[1]
			$alm[2]= $bah+ $script:alarming[2]


			# write-host ("Stopwth:"+ $Swh.ElapsedMilliseconds)
			# write-host ("thisIMG:"+ $this.IMG[0])
			# write-host ("script:elapsing:"+ $script:elapsing)
			# write-host ("elp:"+ $elp)
			# write-host ("real:"+ $real)
			# read-host "pause"


			if($elp[0] -ge $this.real[0]){ $elp[0]= $this.real[0] }
			if($elp[1] -le $this.real[1]){ $elp[1]= $this.real[1] }
			if($elp[2] -ge $this.real[2]){ $elp[2]= $this.real[2] }
			if($elp[5] -le $this.real[5]){ $elp[5]= $this.real[5] }

			if($alm[0] -ge $this.realer[0]){ $alm[0]= $this.realer[0] }
			if($alm[1] -ge $this.realer[1]){ $alm[1]= $this.realer[1] }
			if($alm[2] -ge $this.realer[2]){ $alm[2]= $this.realer[2] }


			[float[]]$ren= 0,0,0, 0,0,0
			$ren[0]= [Math]::Floor(600/ $this.IMG[0]* $elp[0]/ 50)% 12 # タイムの割り出し # 600は固定値
			if($ren[0] -eq 0){ $ren[0]= 12 }
			if($this.real[0] -gt 300){ $ren[0]+= 12 }
			$ren[1]= [Math]::Floor(600/ $this.IMG[0]* $elp[1]/ 10)% 60
			if($ren[1] -lt 0){ $ren[1]= 60+ $ren[1] }
			$ren[2]= [Math]::Floor(600/ $this.IMG[0]* $elp[2]/ 10)% 60


			switch($script:mode_change[0]){ # wth -> wth / stopwth -> wth
			'Watched'{
				DrawTime $elp $ren $alm
				break;
			}default{
				DrawStopWatch $elp $ren $alm
			}
			} #sw
		}
	}
 } #class
 	
class from_StopWatched_gimmick{ 

	[int[]] $IMG= $IMG
	[int] $milsec= $milsec

	[float[]] $real= 0,0,0, 0,0,0
	[float[]] $realer= 0,0,0, 0,0,0

	[object] $Tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_StopWatched_gimmick(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 32
		$this.tmr.Enabled= $False

		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG= $nn
	}

	Start(){ # メソッド
		$this.tmr.Start()
		$this.swh.Start()

		$this.ComWatch()
		if($script:mode_change[0] -eq $script:mode_change[1]){
			$this.RetWatch()
		}else{
			$this.NexWatch()
		}
	}

	Stop(){
		$this.tmr.Stop()
		$this.swh.Reset()
	}

	ComWatch(){
		[timespan] $Timspan= New-Object TimeSpan
		[int[]] $now= 0,0,0, 0,0,0

		switch($script:mode_change[1]){
		'StopWatched'{

			$Timspan= $script:StopWatched.Swh.Elapsed
			$Timspan+= $script:StopWatched.StopWatchSet

			$now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0

			if($script:StopWatched.sw_brush -eq $True){
				$now[2]+= $this.milsec/ 1000
			}

			$this.realer[0]= $script:StopWatched.scaller[0]
			$this.realer[1]= $script:StopWatched.scaller[1]
			$this.realer[2]= $script:StopWatched.scaller[2]
			break;

		}'Timered'{

			$Timspan= -$script:Timered.swh.Elapsed
			$Timspan+= $script:Timered.TimerSet

			$now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0

			if($script:Timered.sw_brush -eq $True){
				$now[2]-= $this.milsec/ 1000
			}

			$this.realer[0]= $script:Timered.scaller[0]
			$this.realer[1]= $script:Timered.scaller[1]
			$this.realer[2]= $script:Timered.scaller[2]
		}
		} #sw

		$this.real[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
		$this.real[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
		$this.real[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
		$this.real[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]

	}

	NexWatch(){
		if($this.real[0] -le $script:elapsing[0]){ $this.real[0]+= $this.IMG[0] } # 1cycle追加
		if($this.real[1] -ge $script:elapsing[1]){ $this.real[1]-= $this.IMG[0] }
		if($this.real[2] -le $script:elapsing[2]){ $this.real[2]+= $this.IMG[0] }
		if($this.real[5] -ge $script:elapsing[5]){ $this.real[5]-= 360 }

		if($this.realer[0] -le $script:alarming[0]){ $this.realer[0]+= $this.IMG[0] }
		if($this.realer[1] -le $script:alarming[1]){ $this.realer[1]+= $this.IMG[0] }
		if($this.realer[2] -le $script:alarming[2]){ $this.realer[2]+= $this.IMG[0] }
	}

	RetWatch(){
		$this.real[0]+= $this.IMG[0] # 単に1cycle追加
		$this.real[1]-= $this.IMG[0]
		$this.real[2]+= $this.IMG[0]
		$this.real[5]-= 360

		$this.realer[0]+= $this.IMG[0]
		$this.realer[1]+= $this.IMG[0]
		$this.realer[2]+= $this.IMG[0]
	}

	Timer(){

		if($this.swh.ElapsedMilliseconds -ge ($this.milsec+ $this.milsec/ 3)){ # + $this.milsec/ 2 safety

			$this.Stop()
			Chg_Moder  "Start" $script:mode_change[1]

			$script:mode_change[0]= $script:mode_change[1]
			$script:mode_change[2]= $True

		}else{

			[float] $bai= $this.IMG[0] * $this.swh.ElapsedMilliseconds/ $this.milsec
			[float] $bah= $bai*1.5
			[float] $baj= 360* $this.swh.ElapsedMilliseconds/ $this.milsec

			[float[]] $elp= 0,0,0, 0,0,0
			[float[]] $alm= 0,0,0, 0,0,0
			$elp[0]= $bai+ $script:elapsing[0]
			$elp[1]= -$bai+ $script:elapsing[1]
			$elp[2]= $bai+ $script:elapsing[2]
			$elp[5]= -$baj+ $script:elapsing[5]

			$alm[0]= $bah+ $script:alarming[0]
			$alm[1]= $bah+ $script:alarming[1]
			$alm[2]= $bah+ $script:alarming[2]



			if($elp[0] -ge $this.real[0]){ $elp[0]= $this.real[0] } # hari stop
			if($elp[1] -le $this.real[1]){ $elp[1]= $this.real[1] }
			if($elp[2] -ge $this.real[2]){ $elp[2]= $this.real[2] }
			if($elp[5] -le $this.real[5]){ $elp[5]= $this.real[5] }

			if($alm[0] -ge $this.realer[0]){ $alm[0]= $this.realer[0] }
			if($alm[1] -ge $this.realer[1]){ $alm[1]= $this.realer[1] }
			if($alm[2] -ge $this.realer[2]){ $alm[2]= $this.realer[2] }


			[float[]] $ren= 0,0,0, 0,0,0
			$ren[0]= [Math]::Floor(600/ $this.IMG[0]* $elp[0]/ 50)% 12 # 600px
			$ren[1]= [Math]::Floor(600/ $this.IMG[0]* $elp[1]/ 10)% 60
			if($ren[1] -eq -0){ $ren[1]= 0 }
			if($ren[1] -lt 0){ $ren[1]= 60+ $ren[1] }
			$ren[2]= [Math]::Floor(600/ $this.IMG[0]* $elp[2]/ 10)% 60


			switch($script:mode_change[0]){
			'Watched'{
				DrawTime $elp $ren $alm
			}default{
				DrawStopWatch $elp $ren $alm
			}
			} #sw
		}
	}
 } #class
 
<# 
 
class from_StopWatched_gimmick{ 

	[int[]] $IMG= $IMG
	[int] $milsec= $milsec

	[object] $Tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_StopWatched_gimmick(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 32
		$this.tmr.Enabled= $False

		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG= $nn
	}

	Start(){ # メソッド
		$this.tmr.Start()
		$this.swh.Start()
	}

	Stop(){
		$this.tmr.Stop()
		$this.swh.Reset()
	}

	Timer(){

		if($this.swh.ElapsedMilliseconds -ge ($this.milsec+ $this.milsec/ 3)){ # + $this.milsec/ 2 safety

			$this.Stop()
			Chg_Moder  "Start" $script:mode_change[1]

			$script:mode_change[0]= $script:mode_change[1]
			$script:mode_change[2]= $True

		}else{

			$bai= $this.IMG[0]* $this.swh.ElapsedMilliseconds/ $this.milsec
			$baj= 360* $this.swh.ElapsedMilliseconds/ $this.milsec

			[float[]] $elp= 0,0,0, 0,0,0
			$elp[0]= $bai+ $script:elapsing[0]
			$elp[1]= $bai+ $script:elapsing[1]
			$elp[2]= $bai+ $script:elapsing[2]
			$elp[5]= $baj+ $script:elapsing[5]

			[timespan] $Timspan= New-Object TimeSpan

			switch($script:mode_change[1]){
			'StopWatched'{

				$Timspan= $script:StopWatched.Swh.Elapsed
				break;

			}'Timered'{

				$Timspan= -$script:Timered.swh.Elapsed
				$Timspan+= $script:Timered.TimerSet
			}
			} #sw

			[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0

			[float[]] $real= 0,0,0, 0,0,0
			$real[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
			$real[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
			$real[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
			$real[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]


			if($real[0] -le $script:elapsing[0]){ $real[0]+= $this.IMG[0] } # 1cycle追加
			if($real[1] -le $script:elapsing[1]){ $real[1]+= $this.IMG[0] }
			if($real[2] -le $script:elapsing[2]){ $real[2]+= $this.IMG[0] }
			if($real[5] -le $script:elapsing[5]){ $real[5]+= 360 }


			if($elp[0] -ge $real[0]){ $elp[0]= $real[0] } # hari stop
			if($elp[1] -ge $real[1]){ $elp[1]= $real[1] }
			if($elp[2] -ge $real[2]){ $elp[2]= $real[2] }
			if($elp[5] -ge $real[5]){ $elp[5]= $real[5] }


			[float[]] $ren= 0,0,0, 0,0,0
			$ren[0]= [Math]::Floor($this.IMG[0]/ $this.IMG[0]* $elp[0]/ 50)% 12 # 600px
			$ren[1]= [Math]::Floor($this.IMG[0]/ $this.IMG[0]* $elp[1]/ 10)% 60
			$ren[2]= [Math]::Floor($this.IMG[0]/ $this.IMG[0]* $elp[2]/ 10)% 60

			switch($script:mode_change[0]){
			'Watched'{
				DrawTime $elp $ren $ren
			}default{
				DrawStopWatch $elp $ren $ren
			}
			} #sw
		}
	}
 } #class
 
#> 
  
[double]$pi= [Math]::PI # 180度のラジアン値 

[array] $pointed= Reso 9 # point obj

[float[]]$elapsing= 0,0,0, 0,0,0 # -- position [hour,min,sec,,,milsec]
[float[]]$alarming= 0,0,0, 0,0,0 #


[int]$milsec= 1100 # gimmik time


# [int]$alarmsec= 0
# [int[]]$short_count= 0,0,0 # on/off count times
# [int]$keyoff= 0
 
# $Timspan= New-Object TimeSpan 
 
# $Stopwth= New-Object System.Diagnostics.Stopwatch 
## $thirtysec= New-Object System.Diagnostics.Stopwatch
# $secshort= New-Object System.Diagnostics.Stopwatch
 
# $thirtytmr= New-Object System.Windows.Forms.Timer 
# $thirtytmr.Interval= 100 #
# $thirtytmr.Enabled= $False

# $thirtytmr.Add_Tick({

# 	$Timer_alarm.Timer()
#  })

# $shorttmr= New-Object System.Windows.Forms.Timer
# $shorttmr.Interval= 100 #
# $shorttmr.Enabled= $False

# $shorttmr.Add_Tick({

# 	$Short_signal.Timer()
#  })
 
# [string[]]$sound_path= "","","", "","","" 
# $sound_path[0]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"
# $sound_path[1]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"
# $sound_path[2]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"
# $sound_path[3]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"
# $sound_path[4]= "C:\Windows\Media\Windows Foreground.wav"
# $sound_path[5]= "C:\Windows\Media\Windows Background.wav"

# $Player= New-Object System.Media.SoundPlayer
# $Player.SoundLocation= ""
# full path
# $Player.Load()

# $Playshort= New-Object System.Media.SoundPlayer
# $Playshort.SoundLocation= ""
 
# 色指定、色オブジェクト 
	
# $purple= [System.Drawing.Color]::FromName("blueviolet") 
# $magenta= [System.Drawing.Color]::FromName("orchid")
# $red= [System.Drawing.Color]::FromName("red")
# $pink= [System.Drawing.Color]::FromName("deeppink")
# $green= [System.Drawing.Color]::FromName("green")
# $lime= [System.Drawing.Color]::FromName("greenyellow")
# $blue= [System.Drawing.Color]::FromName("blue")
# $aqua= [System.Drawing.Color]::FromName("turquoise")
 
# $trans= [System.Drawing.Color]::FromName($transparent)	# 透明色 
# $trans_brush= New-Object System.Drawing.SolidBrush($trans)

# $gray= [System.Drawing.Color]::FromArgb(166,60,60,60)
# $gray_brush= New-Object System.Drawing.SolidBrush($gray)

# $frame_brush= New-Object System.Drawing.SolidBrush($rg)
# $gray_pen= New-Object System.Drawing.Pen($gray, 2)
# $blue_pen= New-Object System.Drawing.Pen($blue, 2)
 
$black= [System.Drawing.Color]::FromArgb(248,24,39,61) # 59,71)	# 暗黒色改 Aは高級感 236,34,62,68 
$black_brush= New-Object System.Drawing.SolidBrush($black)

$white= [System.Drawing.Color]::FromArgb(255,251,250,245)	# 生成り色 A:254
$white_brush= New-Object System.Drawing.SolidBrush($white)
$white_pen= New-Object System.Drawing.Pen($white, 1)

$silver= [System.Drawing.Color]::FromArgb(200,200,200,200)
$silver_brush= New-Object System.Drawing.SolidBrush($silver)
$silver_pen= New-Object System.Drawing.Pen($silver, 1)

$rgb= [System.Drawing.Color]::FromArgb(200,250,250,250)
$Millisecond_brush= New-Object System.Drawing.SolidBrush($rgb)
$Millisecond_pen= New-Object System.Drawing.Pen($rgb, 1)
 
# first 
$rr= [System.Drawing.Color]::FromArgb(150,250,50,50)
$gb= [System.Drawing.Color]::FromArgb(150,50,250,250)
$rb= [System.Drawing.Color]::FromArgb(150,250,50,250)

# $rg= [System.Drawing.Color]::FromArgb(150,250,250,50)
# $gg= [System.Drawing.Color]::FromArgb(250,50,250,50)

$Hour_brush= New-Object System.Drawing.SolidBrush($rr)
$Minute_brush= New-Object System.Drawing.SolidBrush($gb)
$Second_brush= New-Object System.Drawing.SolidBrush($rb)

$Hour_pen= New-Object System.Drawing.Pen($rr, 1)
$Minute_pen= New-Object System.Drawing.Pen($gb, 1)
$Second_pen= New-Object System.Drawing.Pen($rb, 1)

 
# second 
$rr1= [System.Drawing.Color]::FromArgb(150,50,50,250)
$gb1= [System.Drawing.Color]::FromArgb(150,250,250,50)
$rb1= [System.Drawing.Color]::FromArgb(150,50,250,250)

$Hour_brush1= New-Object System.Drawing.SolidBrush($rr1)
$Minute_brush1= New-Object System.Drawing.SolidBrush($gb1)
$Second_brush1= New-Object System.Drawing.SolidBrush($rb1)

$Hour_pen1= New-Object System.Drawing.Pen($rr1, 1)
$Minute_pen1= New-Object System.Drawing.Pen($gb1, 1)
$Second_pen1= New-Object System.Drawing.Pen($rb1, 1)

 
# third 
$rr2= [System.Drawing.Color]::FromArgb(150,50,250,50)
$gb2= [System.Drawing.Color]::FromArgb(150,250,50,250)
$rb2= [System.Drawing.Color]::FromArgb(150,250,250,50)

$Hour_brush2= New-Object System.Drawing.SolidBrush($rr2)
$Minute_brush2= New-Object System.Drawing.SolidBrush($gb2)
$Second_brush2= New-Object System.Drawing.SolidBrush($rb2)

$Hour_pen2= New-Object System.Drawing.Pen($rr2, 1)
$Minute_pen2= New-Object System.Drawing.Pen($gb2, 1)
$Second_pen2= New-Object System.Drawing.Pen($rb2, 1)
  
# グラフィックス領域の確保 
	
[int[]]$IMG= @(600, 600) # グラフのサイズ 
[int[]]$buff_size= @(($IMG[0]+ 2), ($IMG[1]+ 2))
[int[]]$center= (($buff_size[0]/ 2), ($buff_size[1]/ 2)) # センター

 
$image= New-Object System.Drawing.Bitmap($IMG) # 書き込む場所 

# $image5= New-Object System.Drawing.Bitmap(162,102)
# $gpk= [System.Drawing.Graphics]::FromImage($image5)

$graphics= [System.Drawing.Graphics]::FromImage($image)
$graphics.CompositingQuality= "HighQuality"
$graphics.SmoothingMode= "HighQuality"

$Pictbox= New-Object System.Windows.Forms.PictureBox # 描画領域
$Pictbox.ClientSize= $image.Size
$Pictbox.Image= $image
$Pictbox.Location= @(-10, 15) -join ","
# $Pictbox.BackColor= $trans

$Pictbox.Add_MouseDown({
 try{
	switch([string]$_.Button){
	'Right'{
		$contxt.Show([Windows.Forms.Cursor]::Position)
	}'Left'{
		if($Swipe.toggle -eq $True){

			$Swipe.Start()
		}
	}
	} #sw
 }catch{
	echo $_.exception
 }
 })

$contxtb= [System.Drawing.BufferedGraphicsManager]::Current # ダブルバッファ
$contxtb.MaximumBuffer= @($buff_size[0],$buff_size[1]) -join "," # string出力
$buff= $contxtb.Allocate($graphics, $Pictbox.ClientRectangle)
 
$slide_image= New-Object System.Drawing.Bitmap($IMG[0], [Math]::Floor($IMG[1]/ 3)) 

$slide_graphics= [System.Drawing.Graphics]::FromImage($slide_image)

$slide_Pictbox= New-Object System.Windows.Forms.PictureBox
$slide_Pictbox.ClientSize= $slide_image.Size
$slide_Pictbox.Image= $slide_image
$slide_Pictbox.Location= @(-10, $buff_size[1]) -join ","
$slide_Pictbox.Visible= $False

$contxt_slide= [System.Drawing.BufferedGraphicsManager]::Current
$contxt_slide.MaximumBuffer= @($buff_size[0],$buff_size[1]) -join ","
$buff_slide= $contxt_slide.Allocate($slide_graphics, $slide_Pictbox.ClientRectangle)
  
# イベント登録 ------ 

# $Mode.Watched.Timer_alarm.tmr.Add_Tick({ $Watched.Timer_alarm.Timer() })
# $Mode.Watched.Short_signal.tmr.Add_Tick({ $Watched.Short_signal.Timer() })

# $Mode.StopWatched.Timer_alarm.tmr.Add_Tick({ $StopWatched.Timer_alarm.Timer() })
# $Mode.StopWatched.Short_signal.tmr.Add_Tick({ $StopWatched.Short_signal.Timer() })


# $Mode.StopWatched_gimmick.Tmr.Add_Tick({ $StopWatched_gimmick.Timer() })

# ------
 
$Fona= New-Object System.Drawing.Font("Georgia",(($IMG[0]+ $IMG[1])* 0.05/ 2)) # Lucida Console  Garamond  Verdana  Impact 
$Fonb= New-Object System.Drawing.Font("Verdana",(($IMG[0]+ $IMG[1])* 0.03/ 2)) # Lucida Console  Garamond  Georgia  Impact
 
$dia= New-Object System.Windows.Forms.OpenFileDialog 
# ファイル選択ダイアログ

$dia.Filter= "wav files (*.wav)|*.wav" # spaceを入れないこと!
$dia.Title= "ファイル名を入力してください"
$dia.RestoreDirectory= "True"

# $dia.FileName
 
# ------------ 
 
# ------------ 
 
#コンテキストメニュー 
	
$menu_c= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_c.Text= "ChangeColor"
	
$menu_color0= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_color0.Text= "color 0"
$menu_color0.Add_Click({
	Recolor_Set 0
 })
 
$menu_color1= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_color1.Text= "color 1"
$menu_color1.Add_Click({
	Recolor_Set 1
 })
 
$menu_color2= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_color2.Text= "color 2"
$menu_color2.Add_Click({
	Recolor_Set 2
 })
 
$menu_c.DropDownItems.AddRange(@($menu_color0,$menu_color1,$menu_color2)) 
  
$contxt_size= New-Object System.Windows.Forms.ToolStripMenuItem 
$contxt_size.Text= "Size"
	 
$contxt_3= New-Object System.Windows.Forms.ToolStripMenuItem 
$contxt_3.Text= "300px"
$contxt_3.Add_Click({ $frm.Size= @(300, 340) -join "," })

$contxt_6= New-Object System.Windows.Forms.ToolStripMenuItem
$contxt_6.Text= "600px"
$contxt_6.Add_Click({ $frm.Size= @(600, 640) -join "," })

$contxt_9= New-Object System.Windows.Forms.ToolStripMenuItem
$contxt_9.Text= "900px"
$contxt_9.Add_Click({ $frm.Size= @(900, 940) -join "," })


 
$contxt_size.DropDownItems.AddRange(@($contxt_3,$contxt_6,$contxt_9)) 
  
$contxt_aset= New-Object System.Windows.Forms.ToolStripMenuItem 
$contxt_aset.Text= "Alarm Set"
	 
$contxt0set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $contxt0set.Text= "0 AlarmReset"
$contxt0set.Add_Click({

	switch($setalarm[0]){
	$True{	$script:setalarm[0]= Toggle $False 0
	}$False{	$script:setalarm[0]= Toggle $True 0
	}
	} #sw
 })
$contxt1set= New-Object System.Windows.Forms.ToolStripMenuItem
# $contxt1set.Text= "1 AlarmReset"
$contxt1set.Add_Click({

	switch($setalarm[1]){
	$True{	$script:setalarm[1]= Toggle $False 1
	}$False{	$script:setalarm[1]= Toggle $True 1
	}
	} #sw
 })
$contxt2set= New-Object System.Windows.Forms.ToolStripMenuItem
# $contxt2set.Text= "2 AlarmReset"
$contxt2set.Add_Click({

	switch($setalarm[2]){
	$True{	$script:setalarm[2]= Toggle $False 2
	}$False{	$script:setalarm[2]= Toggle $True 2
	}
	} #sw
 })
$contxt3set= New-Object System.Windows.Forms.ToolStripMenuItem
# $contxt3set.Text= "3 Jiho Reset"
$contxt3set.Add_Click({

	switch($setalarm[3]){
	$True{	$script:setalarm[3]= Toggle $False 3
	}$False{	$script:setalarm[3]= Toggle $True 3
	}
	} #sw
 })

 
$contxt_aset.DropDownItems.AddRange(@($contxt0set,$contxt1set,$contxt2set,$contxt3set)) 
  
$contxt= New-Object System.Windows.Forms.ContextMenuStrip 
$contxt.Items.AddRange(@($contxt_size, $menu_c, $contxt_aset))
  
# ------------ 
 
# ------------ 
 
# メニュー 
	 
$menu_f= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_f.Text= "Mode"

	 
$menu_wh= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_wh.Text= "Watch"
$menu_wh.Add_Click({

  if($script:mode_change[2] -eq $True){ # gimmik ji  start cancel

	Chg_Moder "Stop" $script:mode_change[0]

	$script:mode_change[1]= "Watched"
	$script:mode_change[2]= $False

	$Timer_alarm.Stop()
	$Watched_gimmick.Start()
  }
 })
 
$menu_sw= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_sw.Text= "StopWatch"
$menu_sw.Add_Click({

  if($script:mode_change[2] -eq $True){

	Chg_Moder "Stop" $script:mode_change[0]

	$script:mode_change[1]= "StopWatched"
	$script:mode_change[2]= $False

	$Timer_alarm.Stop()
	$StopWatched_gimmick.Start()
  }
 })
 
$menu_tr= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_tr.Text= "Timer"
$menu_tr.Add_Click({

  if($script:mode_change[2] -eq $True){

	Chg_Moder "Stop" $script:mode_change[0]

	$script:mode_change[1]= "Timered"
	$script:mode_change[2]= $False

	$Timer_alarm.Stop() # nattetara tomeru
	$StopWatched_gimmick.Start()
  }
 })
 
$menu_f.DropDownItems.AddRange(@($menu_wh,$menu_sw,$menu_tr)) 
  
$menu_t= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_t.Text= "Time"
	 
$menu_start= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_start.Text= "Start"
$menu_start.Add_Click({

  if($script:mode_change[2] -eq $True){

	switch($script:mode_change[0]){
	"Watched"{
		$Watched.Start()
	}"StopWatched"{
		$StopWatched.Start()
	}"Timered"{
		$Timered.Start()
	}
	} #sw
  }
 })
 
$menu_stop= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_stop.Text= "Stop"
$menu_stop.Add_Click({

	switch($script:mode_change[0]){
	"Watched"{
		$Watched.Stop()
	}"StopWatched"{
		$StopWatched.Stop()
	}"Timered"{
		$Timered.Stop()
	}
	} #sw
 })
 
$menu_reset= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_reset.Text= "Reset"
$menu_reset.Add_Click({

	switch($script:mode_change[0]){
	"Watched"{
		$Watched.Reset()
		$menu_wh.PerformClick()
	}"StopWatched"{
		$StopWatched.Reset()
		$menu_sw.PerformClick()
	}"Timered"{
		$Timered.Reset()
		$menu_tr.PerformClick()
	}
	} #sw
 })
 
$menu_t.DropDownItems.AddRange(@($menu_start,$menu_stop,$menu_reset)) 
  
$menu_a= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_a.Text= "Alarm"
	 
$menu_set= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_set.Text= "Alarm Set"
	 
$menu0set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu0set.Text= "0 AlarmReset"
$menu0set.Add_Click({

	switch($Watched.setalarm[0]){
	$True{	$Watched.setalarm[0]= Toggle $False 0
	}$False{	$Watched.setalarm[0]= Toggle $True 0
	}
	} #sw
 })
 
$menu1set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu1set.Text= "1 AlarmReset"
$menu1set.Add_Click({

	switch($Watched.setalarm[1]){
	$True{	$Watched.setalarm[1]= Toggle $False 1
	}$False{	$Watched.setalarm[1]= Toggle $True 1
	}
	} #sw
 })
 
$menu2set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu2set.Text= "2 AlarmReset"
$menu2set.Add_Click({

	switch($Watched.setalarm[2]){
	$True{	$Watched.setalarm[2]= Toggle $False 2
	}$False{	$Watched.setalarm[2]= Toggle $True 2
	}
	} #sw
 })
 
$menu3set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu3set.Text= "3 Jiho Reset"
$menu3set.Add_Click({

	switch($Watched.setalarm[3]){
	$True{	$Watched.setalarm[3]= Toggle $False 3
	}$False{	$Watched.setalarm[3]= Toggle $True 3
	}
	} #sw
 })
 
$menu_set.DropDownItems.AddRange(@($menu0set,$menu1set,$menu2set,$menu3set)) 
  
$menu_test= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_test.Text= "Alarm Test"
 
$menu_setting= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_setting.Text= "Alarm Setting"
 
$menu_a.DropDownItems.AddRange(@($menu_set,$menu_test,$menu_setting)) 
  
$menu_alarmstop= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_alarmstop.Text= "AlarmStop"
$menu_alarmstop.Add_Click({
	$Timered.Timer_alarm.Stop()
 })
 
$mnu= New-Object System.Windows.Forms.MenuStrip 
$mnu.Items.AddRange(@($menu_f,$menu_t,$menu_a,$menu_alarmstop))
  
#フォーム 
	
$frm= New-Object System.Windows.Forms.Form 
$frm.Size= @(600, 640) -join "," # string出力
$frm.MinimumSize= @(200, 240) -join "," # string出力
$frm.Text= "Gimmik Clock"
$frm.FormBorderStyle= "Sizable"
$frm.StartPosition= "WindowsDefaultLocation"
$frm.MaximizeBox= $True
$frm.MinimizeBox= $True
$frm.TopLevel= $True
# $frm.TransparencyKey= $frm.BackColor

# $frm.FormBorderStyle= "None"
# $frm.TransparencyKey= $black
# $frm.AllowTransparency= $True
# $frm.Opacity = 0.5
$frm.Add_Load({
 })
 
[array] $sizer= $frm.Width,$frm.Height,"width" 
 
$frm.Add_SizeChanged({ 
	$Pictbox.SuspendLayout()
	Resize_Set
	$Pictbox.ResumeLayout()
 })
 
$frm.Add_ResizeEnd({ 
	if($frm.Width -ne $sizer[0]){
		$script:sizer[2]= "width"
	}else{
		$script:sizer[2]= "height"
	}


	switch($sizer[2]){
	'height'{
		$frm.Width= $frm.Height- 40
	}'width'{
		$frm.Height= $frm.Width+ 40
	}
	} #sw
	$script:sizer= $frm.Width, $frm.Height, $sizer[2]
 })
 
<# 
 
#> 
 
$frm.Controls.AddRange(@($mnu,$slide_Pictbox,$Pictbox)) #下は後ろ側 
  
$cpostion= New-Object System.Drawing.Point 
 
# メインルーチン ====== 
[array]$mode_change= "Watched","Watched",$True  # now, next, alarm position sw

[array]$Color= @($Hour_brush, $Minute_brush, $Second_brush)
[array]$Colour= @($Hour_pen, $Minute_pen, $Second_pen)


$Swipe= New-Object from_Swipe($buff_size[1])
$Swipe.tmr.Add_Tick({
	$Swipe.slide()
})

$Short_signal= New-Object from_Short_signal
$Short_signal.tmr.Add_Tick({
	$Short_signal.Timer()
})

$Timer_alarm= New-Object from_Timer_alarm
$Timer_alarm.tmr.Add_Tick({
	$Timer_alarm.Timer()
})

$StopWatched_gimmick= New-Object from_StopWatched_gimmick
$StopWatched_gimmick.tmr.Add_Tick({
	$StopWatched_gimmick.Timer()
})
$Watched_gimmick= New-Object from_Watched_gimmick
$Watched_gimmick.tmr.Add_Tick({
	$Watched_gimmick.Timer()
})

$Timered= New-Object from_Timered
$Timered.tmr.Add_Tick({
	$Timered.Timer()
})
$StopWatched= New-Object from_StopWatched
$StopWatched.tmr.Add_Tick({
	$StopWatched.Timer()
})
$Watched= New-Object from_Watched
$Watched.tmr.Add_Tick({
	$Watched.Timer()
})

Chg_Moder  "Start" $script:mode_change[0]

$frm.ShowDialog() > $null

$graphics.Dispose()
$buff.Dispose()
 
# read-host "pause" 
exit
 
