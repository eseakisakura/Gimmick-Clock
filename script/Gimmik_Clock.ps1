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

	$Watched.Color= $script:Color
	$Watched.Colour= $script:Colour

	$StopWatched.Color= $script:Color
	$StopWatched.Colour= $script:Colour

	$Timered.Color= $script:Color
	$Timered.Colour= $script:Colour

	$StopWatched_gimmick.Color= $script:Color
	$StopWatched_gimmick.Colour= $script:Colour

	$Watched_gimmick.Color= $script:Color
	$Watched_gimmick.Colour= $script:Colour

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
 
function Ellipse_pos([float]$num, [float]$width, [float]$height, [bool]$sw){ 

	$num+= $IMG[0]/ 4

	[float[]]$wid= ($IMG[0]* $width), ($IMG[1]* $width)

	[float]$rad= $num* $pi* 2/ $IMG[0]		# 全位相角をx座標の最大値で割っておく


	[float]$fx= $height* [Math]::Cos($rad)

	if($sw -eq $False){
		[float]$fy= $height* [Math]::Sin($rad)
	}else{
		[float]$fy= $height
	}

	[float]$gx= $center[0]- $fx* $center[0]
	[float]$gy= $center[1]- $fy* $center[1]

	[array]$xy= ($gx- $wid[0]/ 2), ($gy-$wid[1] / 2), $wid[0], $wid[1]

	return $xy

 } #func
 
# ------------ 
 
function XYinput([array]$rr, [int]$num){ 

	For([int]$i= 0; $i -lt $rr[0].Length; $i++){

		$script:pointed[$num][$i].X= $rr[0][$i]
		$script:pointed[$num][$i].Y= $rr[1][$i]
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
	XYinput $xy 0

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
	$False{
		switch($num){
		'0'{
			$menu0set.Text= "0 AlarmSet"
			$contxt0set.Text= "0 AlarmSet"
			break;
		}'1'{
			$menu1set.Text= "1 AlarmSet"
			$contxt1set.Text= "1 AlarmSet"
			break;
		}'2'{
			$menu2set.Text= "2 AlarmSet"
			$contxt2set.Text= "2 AlarmSet"
			break;
		}'3'{
			$menu3set.Text= "3 Jiho Set"
			$contxt3set.Text= "3 Jiho Set"
		}
		} #sw
	}$True{
		switch($num){
		'0'{
			$menu0set.Text= "0 AlarmReset"
			$contxt0set.Text= "0 AlarmReset"
			break;
		}'1'{
			$menu1set.Text= "1 AlarmReset"
			$contxt1set.Text= "1 AlarmReset"
			break;
		}'2'{
			$menu2set.Text= "2 AlarmReset"
			$contxt2set.Text= "2 AlarmReset"
			break;
		}'3'{
			$menu3set.Text= "3 Jiho Reset"
			$contxt3set.Text= "3 Jiho Reset"
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
 
function Moder([string]$sw, [string]$md){ 

	switch($sw){
	'Start'{
		switch($md){
		'Watched'{	$Watched.tmr.Start();	break;
		}'StopWatched'{	$StopWatched.tmr.Start();	break;
		}'Timered'{	$Timered.tmr.Start()
		}
		} #sw
	}'Stop'{
		switch($md){
		'Watched'{	$Watched.tmr.Stop();	break;
		}'StopWatched'{	$StopWatched.tmr.Stop();	break;
		}'Timered'{	$Timered.tmr.Stop()
		}
		} #sw
	}
	} #sw
 } #func
 
function DrawStopWatch([float[]]$elp, [string[]]$now, [float[]]$alm, [array]$triangle, [array]$cercle){ 

	$buff.Graphics.Clear($black)

# ----- $milsec
	$buff.Graphics.FillPie($Millisecond_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), -90, $elp[5])
	$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))

# ----- $alarm

	[int]$view= -1

	if($setalarm[0] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[0] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm0set.Hours/ 12)){ # am/pm
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

		[float[]]$ff= Ellipse_pos $alm[1] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm1set.Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($triangle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}
	if($setalarm[2] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[2] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm2set.Hours/ 12)){ # am/pm
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

	[array]$tt= "","",""
	[string[]]$tt[0]= $Alarm0set.Hours,$Alarm0set.Minutes,$Alarm0set.Seconds
	[string[]]$tt[1]= $Alarm1set.Hours,$Alarm1set.Minutes,$Alarm1set.Seconds
	[string[]]$tt[2]= $Alarm2set.Hours,$Alarm2set.Minutes,$Alarm2set.Seconds

	[string[]]$uu= "","",""
	$uu[0]= $tt[0][0].PadLeft(2,"0")+ ":"+ $tt[0][1].PadLeft(2,"0")+ ":"+ $tt[0][2].PadLeft(2,"0")
	$uu[1]= $tt[1][0].PadLeft(2,"0")+ ":"+ $tt[1][1].PadLeft(2,"0")+ ":"+ $tt[1][2].PadLeft(2,"0")
	$uu[2]= $tt[2][0].PadLeft(2,"0")+ ":"+ $tt[2][1].PadLeft(2,"0")+ ":"+ $tt[2][2].PadLeft(2,"0")

	if($view -ne -1){
	$buff.Graphics.DrawString($uu[$view], $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.11)))
	}

	[string]$ss= $now[0].PadLeft(2,"0")+ ":"+ $now[1].PadLeft(2,"0")+ ":"+ $now[2].PadLeft(2,"0")+ "."+ $now[3].PadLeft(3,"0")
	$buff.Graphics.DrawString($ss, $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.17)))

# ----- $hour

	XYpos $elp[0] 0.036 0.6
	$buff.Graphics.FillPolygon($triangle[0], $pointed[0])

	[array]$pos= STRpos $elp[0] -10 0.4
	$buff.Graphics.DrawString(($now[0]% 12), $Fona, $triangle[0], $pos[0],$pos[1])

# ----- $min

	XYpos $elp[1] 0.018 0.8
	$buff.Graphics.FillPolygon($triangle[1], $pointed[0])

	[array]$pos= STRpos $elp[1] -10 0.5
	$buff.Graphics.DrawString($now[1], $Fona, $triangle[1], $pos[0],$pos[1])

# ----- $sec

	XYpos $elp[2] 0.009 0.9
	$buff.Graphics.FillPolygon($triangle[2], $pointed[0])

	[array]$pos= STRpos $elp[2] -10 0.6
	$buff.Graphics.DrawString($now[2], $Fona, $triangle[2], $pos[0],$pos[1])


　　$buff.Render($graphics) # レンダリング
	$Pictbox.Refresh()

 } #func
 
function DrawTime([float[]]$elp, [string[]]$now, [float[]]$alm, [array]$triangle, [array]$cercle){ 

# ----- $milsec

	$buff.Graphics.Clear($black)
	# $buff.Graphics.DrawImage($crop_image, $Pictbox.ClientRectangle)

	if($setalarm[3] -eq $True){
		$buff.Graphics.FillEllipse($silver_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8))
		$buff.Graphics.FillPie($Millisecond_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), ($elp[5]- 90), 120)
	}else{ # jiho less
		$buff.Graphics.FillPie($silver_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), $elp[5], 270)
	}
	$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))
	# $buff.Graphics.DrawImage($crop2_image, $Pictbox.ClientRectangle)



	$color_pen= $silver_pen
	$color_brush= $silver_brush
	# DIApos ($IMG[0]/ 4) 0.004 0.67
	# $buff.Graphics.FillPolygon($silver_brush, $pointed[1])

# ----- $alarm

	[array]$tt= "","",""
	[string[]]$tt[0]= $Alarm0set.Hours,$Alarm0set.Minutes,$Alarm0set.Seconds
	[string[]]$tt[1]= $Alarm1set.Hours,$Alarm1set.Minutes,$Alarm1set.Seconds
	[string[]]$tt[2]= $Alarm2set.Hours,$Alarm2set.Minutes,$Alarm2set.Seconds

	[string[]]$uu= "","",""
	$uu[0]= $tt[0][0].PadLeft(2,"0")+ ":"+ $tt[0][1].PadLeft(2,"0")+ ":"+ $tt[0][2].PadLeft(2,"0")
	$uu[1]= $tt[1][0].PadLeft(2,"0")+ ":"+ $tt[1][1].PadLeft(2,"0")+ ":"+ $tt[1][2].PadLeft(2,"0")
	$uu[2]= $tt[2][0].PadLeft(2,"0")+ ":"+ $tt[2][1].PadLeft(2,"0")+ ":"+ $tt[2][2].PadLeft(2,"0")


	if($setalarm[0] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[0] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm0set.Hours/ 12)){ # am/pm
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

		[float[]]$ff= Ellipse_pos $alm[1] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm1set.Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($triangle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($cercle[1], $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}
	if($setalarm[2] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[2] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm2set.Hours/ 12)){ # am/pm
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
	## $buff.Graphics.FillPolygon($frame_brush, $pointed[0])


# ----- $hour

	XYpos $elp[0] 0.036 0.6
	$buff.Graphics.FillPolygon($triangle[0], $pointed[0])

	[int[]]$num= 12,1,2,3,4,5,6,7,8,9,10,11

	[array]$pos= STRpos $elp[0] -10 0.4
	$buff.Graphics.DrawString(($num[$now[0]% 12]), $Fona, $triangle[0], $pos[0],$pos[1])

# ----- $min

	XYpos $elp[1] 0.018 0.8
	$buff.Graphics.FillPolygon($triangle[1], $pointed[0])

	[array]$pos= STRpos $elp[1] -10 0.5
	$buff.Graphics.DrawString($now[1], $Fona, $triangle[1], $pos[0],$pos[1])

# ----- $sec

	XYpos $elp[2] 0.009 0.9
	$buff.Graphics.FillPolygon($triangle[2], $pointed[0])

	[array]$pos= STRpos $elp[2] -10 0.6
	$buff.Graphics.DrawString($now[2], $Fona, $triangle[2], $pos[0],$pos[1])


　　　　$buff.Render($graphics) # レンダリング
	# $image.MakeTransparent($black)
	$Pictbox.Refresh()

 } #func
  
# class 
	 
class from_Swipe{ 

	# 変数定義
	[int[]] $Fibonacci_num= 0,1,1,2, 3,5,8,13, 21,34,55,89, 144  # 233,377,610,987,
	[int] $j # Fibonacci count
	[string] $sw
	[bool] $toggle # insert ji err tame

	[int] $pos
	[int] $pix
	[object] $tmr

	from_Swipe([int] $imgy ){ # コンストラクタ
		$this.j= 12
		$this.sw= "insert"
		$this.toggle= $True

		$this.pos= $imgy
		$this.pix= [Math]::Floor($imgy/ 3)

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 16
		$this.tmr.Enabled= $False
	}

	Size([int] $imgy ){

		$this.j= 12
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
		$this.j= 12

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

	# フィールド
	[object] $tmr
	[int] $level
	[int] $count
	[int] $all
	[string[]] $sound_path= "",""
	[System.Diagnostics.Stopwatch] $swh
	[System.Media.SoundPlayer] $mda

	from_Short_signal(){ # コンストラクタ default化するとき

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

	from_Timer_alarm(){ # コンストラクタ default化するとき

		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 100
		$this.tmr.Enabled= $False

		$this.sound_path[0]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"
		$this.sound_path[1]= ""
		$this.sound_path[2]= ""
		$this.sound_path[3]= "C:\data\XP HD 22 3 28\データ\エムピースリー\All\Electronica\tATu\01-オールザシングスシーセッド(ラジオヴァージョン).wav"

		$this.level= 0
		$this.count= 0
		$this.all= 2
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

	[int[]] $IMG= $IMG
	[array] $Color= $Color
	[array] $Colour= $Colour
	[array] $elp= $elapsed[0]
	[array] $alm= $elapsed[1]

	[array] $SetAlarm= $SetAlarm
	[array] $AlarmTime= $AlarmTime

	[object] $tmr
	[object] $Short_signal= $Short_signal
	[object] $Timer_alarm= $Timer_alarm

	from_Watched(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 200
		$this.tmr.Enabled= $False
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

		$this.elp[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12) + $this.IMG[0]/ 12/ 60* $now[1])
		$this.elp[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1]+ $this.IMG[0]/ 60/ 60* $now[2])
		$this.elp[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2])

		$this.alm[0]= [Math]::Floor($this.IMG[0]/ 12* ($this.AlarmTime[0].Hours% 12) + $this.IMG[0]/ 12/ 60* $this.AlarmTime[0].Minutes)
		$this.alm[1]= [Math]::Floor($this.IMG[0]/ 12* ($this.AlarmTime[1].Hours% 12) + $this.IMG[0]/ 12/ 60* $this.AlarmTime[1].Minutes)
		$this.alm[2]= [Math]::Floor($this.IMG[0]/ 12* ($this.AlarmTime[2].Hours% 12) + $this.IMG[0]/ 12/ 60* $this.AlarmTime[2].Minutes)


		if($this.Timer_alarm.level -ne 0){
			$this.elp[5]= 360/ 1000* $now[3]	# 回転飾り
		}else{
			$this.elp[5]= 360/ 60* $now[2]+ 6/ 1000* $now[3]
		}

		DrawTime $this.elp $now $this.alm $this.color $this.colour

	}
 } #class
 
class from_StopWatched{ 

	[int[]] $IMG= $IMG
	[array] $Color= $Color
	[array] $Colour= $Colour
	[float[]] $elp= $elapsed[0]

	[object] $Timer_alarm= $Timer_alarm
	[object] $Short_signal= $Short_signal

	[object] $tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_StopWatched(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 64
		$this.tmr.Enabled= $False

		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.tmr.Start()
		$this.swh.Start()
	}

	Stop(){
		$this.Tmr.Stop()
		$this.swh.Stop()
	}

	Reset(){
		$this.Tmr.Stop()
		$this.swh.Reset()
	}

	[void] Timer(){

		[timespan] $Timspan= $this.Swh.Elapsed

		[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0


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

		$this.elp[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
		$this.elp[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
		$this.elp[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])


		if($now[0] -le 0 -and $now[1] -le 0 -and $now[2] -le 0 -and $now[3] -le 0){

			$date= [datetime]::Now

			if(($date.second% 4) -eq 0){
				$this.elp[5]= 360/ 1000* $date.Millisecond
			}else{
				$this.elp[5]= 360
			}

		}else{
			$this.elp[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]
		}

		DrawStopWatch $this.elp $now $now $this.color $this.colour
	}
 } #class
 
class from_Timered{ 

	[int[]] $IMG= $IMG
	[array] $Color= $Color
	[array] $Colour= $Colour
	[float[]] $elp= $elapsed[0]

	[object] $Timer_alarm= $Timer_alarm
	[object] $Short_signal= $Short_signal

	[Timespan] $TimerSet= $TimerSet

	[object] $tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_Timered(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 64
		$this.tmr.Enabled= $False

		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.tmr.Start()
		$this.swh.Start()
	}

	Stop(){
		$this.tmr.Stop()
		$this.swh.Stop()
	}

	Reset(){
		$this.Tmr.Stop()
		$this.swh.Reset()
	}

	[void] Timer(){

		[Timespan] $Timspan= -$this.swh.Elapsed
		$Timspan+= $this.TimerSet


		[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0


		if(($now[1]% 5) -eq 4 -and $now[2] -eq 59){

			if($this.Short_signal.level -eq 0){

				switch($now[1]% 10){
				4{		$this.Short_signal.Start(1,1)
				}9{		$this.Short_signal.Start(0,2)
				}
				} #sw
			}
		}

		if($now[0] -le 0 -and $now[1] -le 0 -and $now[2] -le 0 -and $now[3] -le 0){
		$this.Stop()

		$this.Timer_alarm.start(3)
write-host "check3"
		$this.elp= 0,0,0, 0,0,0
		$now= 0,0,0, 0,0,0


			# if($now[1] -le -1){ # -1min.

				# $this.elp[5]= 0

			# }else{

				# if(($now[2]% 4) -eq 0){ # 4sec.
					# $this.elp[5]= 360/ 1000* $now[3]
				# }else{
					# $this.elp[5]= 360
				# }

				# if($this.Timer_alarm.level -eq 0){	# one shot

				# }
			# }


		}else{

			$this.elp[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
			$this.elp[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
			$this.elp[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
			$this.elp[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]
		}

		DrawStopWatch $this.elp $now $now $this.color $this.colour
	}
 } #class
 
class from_Watched_gimmick{ 

	[int[]] $IMG= $IMG
	[array] $Color= $Color
	[array] $Colour= $Colour
	[int] $milsec= $milsec

	[float[]] $elap= $elapsed[0]
	[array] $mode_change= $mode_change

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
	}

	Stop(){
		$this.Tmr.Stop()
		$this.swh.Reset()
	}

	Timer(){

		if($this.swh.ElapsedMilliseconds -ge ($this.milsec+ $this.milsec/ 3)){ # + $this.milsec/ 2 safety

			$this.Stop()
			Moder  "Start" $this.mode_change[1]

			$this.mode_change[0]= $this.mode_change[1]
			$this.mode_change[2]= $False

# read-host "pause"

		}else{

			[float]$bai= $this.IMG[0]* $this.Swh.ElapsedMilliseconds/ $this.milsec
			[float]$baj= 360* $this.Swh.ElapsedMilliseconds/ $this.milsec

 if($this.mode_change[0] -eq "Watched" -and $this.mode_change[1] -eq "Watched"){
	$baj= -$baj # rev
 }
			[float[]]$elp= 0,0,0, 0,0,0
			$elp[0]= $bai+ $this.elap[0]
			$elp[1]= $bai+ $this.elap[1]
			$elp[2]= $bai+ $this.elap[2]
			$elp[5]= $baj+ $this.elap[5]


			$date= [datetime]::Now

			[float[]]$real= 0,0,0, 0,0,0
			$real[0]= [Math]::Floor($this.IMG[0]/ 12* ($date.Hour% 12) + $this.IMG[0]/ 12/ 60* $date.Minute)
			$real[1]= [Math]::Floor($this.IMG[0]/ 60* $date.Minute+ $this.IMG[0]/ 60/ 60* $date.Second)
			$real[2]= [Math]::Floor($this.IMG[0]/ 60* $date.Second)
			$real[5]= [Math]::Floor(360/ 60* $date.Second)


 if($this.mode_change[0] -ne "Watched"){
	if($real[0] -le $this.elap[0]){
		$real[0]+= $this.IMG[0]
	}
	if($real[1] -le $this.elap[1]){
		$real[1]+= $this.IMG[0]
	}
 }

 if($this.mode_change[0] -eq "Watched" -and $this.mode_change[1] -eq "Watched"){
	$real[2]+= $this.IMG[0]
	$real[5]-= 360
 }else{
	if($real[2] -le $this.elap[2]){
		$real[2]+= $this.IMG[0]
	}
	if($real[5] -le $this.elap[5]){
		$real[5]+= 360
	}
 }

			if($elp[0] -ge $real[0]){ $elp[0]= $real[0] }
			if($elp[1] -ge $real[1]){ $elp[1]= $real[1] }
			if($elp[2] -ge $real[2]){ $elp[2]= $real[2] }

 if($this.mode_change[0] -eq "Watched" -and $this.mode_change[1] -eq "Watched"){
	if($elp[5] -le $real[5]){ $elp[5]= $real[5] }
 }else{
	if($elp[5] -ge $real[5]){ $elp[5]= $real[5] }
 }

			# write-host ("Stopwth:"+ $Swh.ElapsedMilliseconds)
			# write-host ("elp:"+ $elp)
			# write-host ("thisIMG:"+ $this.IMG[0])

			[string[]]$now= 0,0,0, 0,0,0
			$now[0]= [Math]::Floor(600/ $this.IMG[0]* $elp[0]/ 50)% 12 # 600は固定値
			$now[1]= [Math]::Floor(600/ $this.IMG[0]* $elp[1]/ 10)% 60
			$now[2]= [Math]::Floor(600/ $this.IMG[0]* $elp[2]/ 10)% 60

			switch($this.mode_change[0]){ # wth -> wth / stopwth -> wth
			'Watched'{
				DrawTime $elp $now $now $this.color $this.colour
			}default{
				DrawStopWatch $elp $now $now $this.color $this.colour
			}
			} #sw
		}
	}
 } #class
 
class from_StopWatched_gimmick{ 

	[int[]] $IMG= $IMG
	[array] $Color= $Color
	[array] $Colour= $Colour
	[int] $milsec= $milsec

	[float[]] $elap= $elapsed[0]
	[array] $mode_change= $mode_change

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
			Moder  "Start" $this.mode_change[1]

			$this.mode_change[0]= $this.mode_change[1]
			$this.mode_change[2]= $False

		}else{

			$bai= $this.IMG[0]* $this.swh.ElapsedMilliseconds/ $this.milsec
			$baj= 360* $this.swh.ElapsedMilliseconds/ $this.milsec

			[float[]]$elp= 0,0,0, 0,0,0
			$elp[0]= $bai+ $this.elap[0]
			$elp[1]= $bai+ $this.elap[1]
			$elp[2]= $bai+ $this.elap[2]
			$elp[5]= $baj+ $this.elap[5]

			[timespan] $Timspan= New-Object TimeSpan

			switch($this.mode_change[1]){
			'StopWatched'{

				$Timspan= $script:StopWatched.Swh.Elapsed
				break;

			}'Timered'{

				$Timspan= -$script:Timered.swh.Elapsed
				$Timspan+= $script:TimerSet
			}
			} #sw

			[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0


			[float[]]$real= 0,0,0, 0,0,0
			$real[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
			$real[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
			$real[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
			$real[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]

			if($real[0] -le $this.elap[0]){ $real[0]+= $this.IMG[0] } # 1cycle追加
			if($real[1] -le $this.elap[1]){ $real[1]+= $this.IMG[0] }
			if($real[2] -le $this.elap[2]){ $real[2]+= $this.IMG[0] }
			if($real[5] -le $this.elap[5]){ $real[5]+= 360 }

			if($elp[0] -ge $real[0]){ $elp[0]= $real[0] } # hari stop
			if($elp[1] -ge $real[1]){ $elp[1]= $real[1] }
			if($elp[2] -ge $real[2]){ $elp[2]= $real[2] }
			if($elp[5] -ge $real[5]){ $elp[5]= $real[5] }


			[float[]] $now= 0,0,0, 0,0,0
			$now[0]= [Math]::Floor($this.IMG[0]/ $this.IMG[0]* $elp[0]/ 50)% 12 # 600px
			$now[1]= [Math]::Floor($this.IMG[0]/ $this.IMG[0]* $elp[1]/ 10)% 60
			$now[2]= [Math]::Floor($this.IMG[0]/ $this.IMG[0]* $elp[2]/ 10)% 60

			switch($this.mode_change[0]){
			'Watched'{
				DrawTime $elp $now $now $this.color $this.colour
			}default{
				DrawStopWatch $elp $now $now $this.color $this.colour
			}
			} #sw
		}
	}
 } #class
  
<# ------------ 
	
function Slider([string] $ss){ 
	switch($ss){
	'in'{
		$slide_Pictbox.Location= @(-10, 600) -join ","
		sleep 1
		$slide_Pictbox.Location= @(-10, 500) -join ","
		sleep 1
		$slide_Pictbox.Location= @(-10, 400) -join ","

	}'out'{
		$slide_Pictbox.Location= @(-10, 400) -join ","
		$slide_Pictbox.Location= @(-10, 500) -join ","
		$slide_Pictbox.Location= @(-10, 600) -join ","
	}
	} #sw
 } #
 
function TouchSlide(){ 

	[int]$pos= 600
	[int]$yy= 0


		for([int]$i= 0; $i -le 200; $i++){
			$yy= $pos- $i
sleep -m 1
# write-host $yy
	$slide_Pictbox.Location= @(-10, $yy) -join ","
		} #
	#}else{
		#$pos= $Slidein.eject()
	#}

 } #func
 
$mask_image= New-Object System.Drawing.Bitmap($IMG) 
$mask_graphics= [System.Drawing.Graphics]::FromImage($mask_image)

$crop_image= New-Object System.Drawing.Bitmap($IMG)
$crop_graphics= [System.Drawing.Graphics]::FromImage($crop_image)

$mask2_image= New-Object System.Drawing.Bitmap($IMG)
$mask2_graphics= [System.Drawing.Graphics]::FromImage($mask2_image)

$crop2_image= New-Object System.Drawing.Bitmap($IMG)
$crop2_graphics= [System.Drawing.Graphics]::FromImage($crop2_image)

# $load_image= New-Object System.Drawing.Bitmap(".\flashapr2b.jpg")
 
class from_Timered{ 

	[int[]] $IMG= $IMG
	[array] $Color= $Color
	[array] $Colour= $Colour
	[float[]] $elp= $elapsed[0]

	[object] $Timer_alarm= $Timer_alarm
	[object] $Short_signal= $Short_signal

	[Timespan] $TimerSet= $TimerSet

	[object] $tmr
	[System.Diagnostics.Stopwatch] $Swh

	from_Timered(){
		$this.tmr= New-Object System.Windows.Forms.Timer
		$this.tmr.Interval= 64
		$this.tmr.Enabled= $False

		$this.swh= New-Object System.Diagnostics.Stopwatch
	}

	Size([int]$nn){
		$this.IMG[0]= $nn
	}

	Start(){ # メソッド
		$this.swh.Start()
	}

	Stop(){
		$this.swh.Stop()
	}

	[void] Timer(){

		[Timespan] $Timspan= -$this.swh.Elapsed
		$Timspan+= $this.TimerSet


		[int[]] $now= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, 0, 0


		if(($now[1]% 5) -eq 4 -and $now[2] -eq 59){

			if($this.Short_signal.level -eq 0){

				switch($now[1]% 10){
				4{		$this.Short_signal.Start(1,1)
				}9{		$this.Short_signal.Start(0,2)
				}
				} #sw
			}
		}

		if($now[0] -le 0 -and $now[1] -le 0 -and $now[2] -le 0 -and $now[3] -le 0){

			if($now[1] -le -1){ # -1min.

				$this.elp[5]= 0
				$this.swh.Stop()

			}else{

				if(($now[2]% 4) -eq 0){ # 4sec.
					$this.elp[5]= 360/ 1000* $now[3]
				}else{
					$this.elp[5]= 360
				}

				if($this.Timer_alarm.level -eq 0){	# one shot

					$this.Timer_alarm.start(3)
				}
			}

			$this.elp[0]= 0
			$this.elp[1]= 0
			$this.elp[2]= 0

			$now= 0,0,0, 0,0,0

		}else{

			$this.elp[0]= [Math]::Floor($this.IMG[0]/ 12* ($now[0]% 12))
			$this.elp[1]= [Math]::Floor($this.IMG[0]/ 60* $now[1])
			$this.elp[2]= [Math]::Floor($this.IMG[0]/ 60* $now[2]+ $this.IMG[0]/ 60/ 1000* $now[3])
			$this.elp[5]= 360/ 60* $now[2]+ 360/ 60/ 1000* $now[3]
		}

		DrawStopWatch $this.elp $now $now $this.color $this.colour
	}
 } #class
 
class from_DrawTime{ 

	[array] $pointed= "" # hari

	from_DrawTime(){

		$this.pointed= Reso 9 # point obj
	}

	SlideIn(){
		$buff_slide.Graphics.Clear($silver)
		$buff_slide.Render($slide_graphics)
		$slide_Pictbox.Refresh()
	}

	Clear(){
		$buff.Graphics.Clear($black)
	}

	Milsec([float[]]$elp){

		if($setalarm[3] -eq $True){
			$buff.Graphics.FillEllipse($silver_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8))
			$buff.Graphics.FillPie($Millisecond_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), ($elp[5]- 90), 90)
		}else{
			$buff.Graphics.FillPie($silver_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), $elp[5], 270)
		}
		$buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))
	}

	Alarm0([float[]]$alm){

		if($setalarm[0] -eq $True){

			[float[]]$ff= Ellipse_pos $alm[0] 0.03 0.9 $mode_change[2]

			if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm0set.Hours/ 12)){ # am/pm
				$buff.Graphics.FillEllipse($Hour_brush, $ff[0],$ff[1], $ff[2],$ff[3])
			}else{
				$buff.Graphics.DrawEllipse($Hour_pen, $ff[0],$ff[1], $ff[2],$ff[3])
			}
		}
	}

	Alarm1([float[]]$alm){

		if($setalarm[1] -eq $True){

			[float[]]$ff= Ellipse_pos $alm[1] 0.03 0.9 $mode_change[2]

			if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm1set.Hours/ 12)){ # am/pm
				$buff.Graphics.FillEllipse($Minute_brush, $ff[0],$ff[1], $ff[2],$ff[3])
			}else{
				$buff.Graphics.DrawEllipse($Minute_pen, $ff[0],$ff[1], $ff[2],$ff[3])
			}
		}
	}

	Alarm2([float[]]$alm){

		if($setalarm[2] -eq $True){

			[float[]]$ff= Ellipse_pos $alm[2] 0.03 0.9 $mode_change[2]

			if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm2set.Hours/ 12)){ # am/pm
				$buff.Graphics.FillEllipse($Second_brush, $ff[0],$ff[1], $ff[2],$ff[3])
			}else{
				$buff.Graphics.DrawEllipse($Second_pen, $ff[0],$ff[1], $ff[2],$ff[3])
			}
		}
	}

	Plate(){

		$color_pen= $silver_pen
		$color_brush= $silver_brush

		[float[]]$ff= Ellipse_pos ($IMG[0]* 0) 0.015 0.632 $False
		$buff.Graphics.FillEllipse($color_brush, $ff[0],$ff[1], $ff[2],$ff[3])
		[float[]]$ff= Ellipse_pos ($IMG[0]* 0.5) 0.015 0.632 $False
		$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
		[float[]]$ff= Ellipse_pos ($IMG[0]* 0.25) 0.015 0.632 $False
		$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
		[float[]]$ff= Ellipse_pos ($IMG[0]* 0.75) 0.015 0.632 $False
		$buff.Graphics.DrawEllipse($color_pen, $ff[0],$ff[1], $ff[2],$ff[3])
	}

	StringTime([string[]]$now){

		[string]$ss= $now[0].PadLeft(2,"0")+ ":"+ $now[1].PadLeft(2,"0")+ ":"+ $now[2].PadLeft(2,"0")
		$buff.Graphics.DrawString($ss, $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.17)))
	}

	Hour([float[]]$elp, [string[]]$now){

		XYpos $elp[0] 0.036 0.6
		$buff.Graphics.FillPolygon($Hour_brush, $pointed[0])

		[int[]]$num= 12,1,2,3,4,5,6,7,8,9,10,11

		[array]$pos= STRpos $elp[0] -10 0.4
		$buff.Graphics.DrawString(($num[$now[0]% 12]), $Fona, $Hour_brush, $pos[0],$pos[1])
	}

	Min([float[]]$elp, [string[]]$now){

		XYpos $elp[1] 0.018 0.8
		$buff.Graphics.FillPolygon($Minute_brush, $pointed[0])

		[array]$pos= STRpos $elp[1] -10 0.5
		$buff.Graphics.DrawString($now[1], $Fona, $Minute_brush, $pos[0],$pos[1])
	}

	Sec([float[]]$elp, [string[]]$now){

		XYpos $elp[2] 0.009 0.9
		$buff.Graphics.FillPolygon($Second_brush, $pointed[0])

		[array]$pos= STRpos $elp[2] -10 0.6
		$buff.Graphics.DrawString($now[2], $Fona, $Second_brush, $pos[0],$pos[1])
	}

	Render(){

		$script:buff.Render($graphics) # レンダリング
　		$script:Pictbox.Refresh()
	}

 } #class
 
class from_DrawStopWatch{ 

	[int[]] $IMG= $IMG
	[float[]] $elp
	[string[]] $now
	[float[]] $alm
	[object] $Millisecond_brush= $Millisecond_brush
	[object] $black_brush= $black_brush



	Size([int[]]$nn){
		$this.IMG[0]= $nn[0]
		$this.IMG[1]= $nn[1]
	}

	Timer(){
		$this.buff.Graphics.Clear($black)
		$this.milsec()
	}

	milsec(){
		$this.buff.Graphics.FillPie($Millisecond_brush, ($IMG[0]* 0.1),($IMG[1]* 0.1), ($IMG[0]* 0.8),($IMG[1]* 0.8), -90, $elp[5])
		$this.buff.Graphics.FillEllipse($black_brush, ($IMG[0]* 0.15),($IMG[1]* 0.15), ($IMG[0]* 0.7),($IMG[1]* 0.7))
	}

# ----- $alarm

	[int]$view= -1

	if($setalarm[0] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[0] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm0set.Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($Hour_brush, $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($Hour_pen, $ff[0],$ff[1], $ff[2],$ff[3])
		}

		# if($cpoint[0] -gt ($ff[0]-($IMG[0]* 0.03)) -and $cpoint[0] -lt ($ff[0]+ $ff[2]+($IMG[0]* 0.03))){
		# if($cpoint[1] -gt ($ff[1]-($IMG[0]* 0.03)) -and $cpoint[1] -lt ($ff[1]+ $ff[3]+($IMG[0]* 0.03))){
		# 	$view= 0
		# 	$buff.Graphics.DrawEllipse($White_pen, $ff[0],$ff[1], $ff[2],$ff[3])
		# }
		# }

	}
	if($setalarm[1] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[1] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm1set.Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($Minute_brush, $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($Minute_pen, $ff[0],$ff[1], $ff[2],$ff[3])
		}
	}
	if($setalarm[2] -eq $True){

		[float[]]$ff= Ellipse_pos $alm[2] 0.03 0.9 $mode_change[2]

		if([Math]::Floor($date.Hour/ 12) -eq [Math]::Floor($Alarm2set.Hours/ 12)){ # am/pm
			$buff.Graphics.FillEllipse($Second_brush, $ff[0],$ff[1], $ff[2],$ff[3])
		}else{
			$buff.Graphics.DrawEllipse($Second_pen, $ff[0],$ff[1], $ff[2],$ff[3])
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

	[array]$tt= "","",""
	[string[]]$tt[0]= $Alarm0set.Hours,$Alarm0set.Minutes,$Alarm0set.Seconds
	[string[]]$tt[1]= $Alarm1set.Hours,$Alarm1set.Minutes,$Alarm1set.Seconds
	[string[]]$tt[2]= $Alarm2set.Hours,$Alarm2set.Minutes,$Alarm2set.Seconds

	[string[]]$uu= "","",""
	$uu[0]= $tt[0][0].PadLeft(2,"0")+ ":"+ $tt[0][1].PadLeft(2,"0")+ ":"+ $tt[0][2].PadLeft(2,"0")
	$uu[1]= $tt[1][0].PadLeft(2,"0")+ ":"+ $tt[1][1].PadLeft(2,"0")+ ":"+ $tt[1][2].PadLeft(2,"0")
	$uu[2]= $tt[2][0].PadLeft(2,"0")+ ":"+ $tt[2][1].PadLeft(2,"0")+ ":"+ $tt[2][2].PadLeft(2,"0")

	if($view -ne -1){
	$buff.Graphics.DrawString($uu[$view], $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.11)))
	}

	[string]$ss= $now[0].PadLeft(2,"0")+ ":"+ $now[1].PadLeft(2,"0")+ ":"+ $now[2].PadLeft(2,"0")+ "."+ $now[3].PadLeft(3,"0")
	$buff.Graphics.DrawString($ss, $Fonb, $silver_brush, ($center[0]- ($IMG[0]* 0.10)),($center[1]+ ($IMG[1]* 0.17)))

# ----- $hour

	XYpos $elp[0] 0.036 0.6
	$buff.Graphics.FillPolygon($Hour_brush, $pointed[0])

	[array]$pos= STRpos $elp[0] -10 0.4
	$buff.Graphics.DrawString(($now[0]% 12), $Fona, $Hour_brush, $pos[0],$pos[1])

# ----- $min

	XYpos $elp[1] 0.018 0.8
	$buff.Graphics.FillPolygon($Minute_brush, $pointed[0])

	[array]$pos= STRpos $elp[1] -10 0.5
	$buff.Graphics.DrawString($now[1], $Fona, $Minute_brush, $pos[0],$pos[1])

# ----- $sec

	XYpos $elp[2] 0.009 0.9
	$buff.Graphics.FillPolygon($Second_brush, $pointed[0])

	[array]$pos= STRpos $elp[2] -10 0.6
	$buff.Graphics.DrawString($now[2], $Fona, $Second_brush, $pos[0],$pos[1])


　　$buff.Render($graphics) # レンダリング
　　$Pictbox.Refresh()

 } #func
 
function Mode(){ 


	# [object]$cpostion= $frm.PointToClient([Windows.Forms.Cursor]::Position)
	# [float[]]$cpoint= ($cpostion.X+ 20- ($IMG[0]* 0.03/2)), ($cpostion.Y- ($IMG[1]* 0.03/ 2))

	if($script:mode_change[2] -eq $True){

			switch($script:mode_change[1]){
			'Watched'{	$Watched_gimmick.Timer();	break;
			}'StopWatched'{	$StopWatched_gimmick.Timer();	break;	##StopWatch_gimmick;
			}'Timered'{	$StopWatched_gimmick.Timer()
			}
			} #sw

	}else{
			switch($script:mode_change[0]){
			'Watched'{	$Watched.Timer();	break;
			}'StopWatched'{	$StopWatched.Timer();	break;
			}'Timered'{	$Timered.Timer()	##Timered; break;
			}
			} #sw
	}
 } #func
 
Function StopWatched(){ 

	$Timspan= $Stopwth.Elapsed

	[int[]]$nowtime= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, "", ""


	if($nowtime[1] -ne 0 -and ($nowtime[1]% 5) -eq 0 -and $nowtime[2] -eq 0){

		if($short_count[0] -eq 0){

			$shorttmr.Start()
			$script:short_count[0]= 1	# one shot

			switch($nowtime[1]% 10){
			5{		$script:short_count[2]= 1
			}0{		$script:short_count[2]= 2
			}
			} #sw
		}
	}

	$elapsed[0][0]= [Math]::Floor($IMG[0]/ 12* ($nowtime[0]% 12))
	$elapsed[0][1]= [Math]::Floor($IMG[0]/ 60* $nowtime[1])
	$elapsed[0][2]= [Math]::Floor($IMG[0]/ 60* $nowtime[2]+ $IMG[0]/ 60/ 1000* $nowtime[3])


	if($nowtime[0] -le 0 -and $nowtime[1] -le 0 -and $nowtime[2] -le 0 -and $nowtime[3] -le 0){

		if(($date.second% 4) -eq 0){
			$elapsed[0][5]= 360/ 1000* $date.Millisecond
		}else{
			$elapsed[0][5]= 360
		}
	}else{

		$elapsed[0][5]= 360/ 60* $nowtime[2]+ 360/ 60/ 1000* $nowtime[3]
	}

	DrawStopWatch $elapsed[0] $nowtime $nowtime

 } #func
 
function Watch_gimmick(){ 

	if($Stopwth.ElapsedMilliseconds -ge ($milsec+ $milsec)){ # + $milsec safety

		$Tmr.Interval= 200
		$Stopwth.Reset()
		$script:mode_change[0]= $mode_change[1]
		$script:mode_change[2]= $False

# read-host "pause"

	}else{

		[float]$bai= $IMG[0]* $Stopwth.ElapsedMilliseconds/ $milsec
		[float]$bak= 360* $Stopwth.ElapsedMilliseconds/ $milsec

		[float[]]$num= 0,0,0, 0,0,0
		$num[0]= $bai+ $elapsed[0][0]
		$num[1]= $bai+ $elapsed[0][1]
		$num[2]= $bai+ $elapsed[0][2]
		$num[5]= $bak+ $elapsed[0][5]


		[float[]]$real= 0,0,0, 0,0,0
		$real[0]= [Math]::Floor($IMG[0]/ 12* ($date.Hour% 12) + $IMG[0]/ 12/ 60* $date.Minute)
		$real[1]= [Math]::Floor($IMG[0]/ 60* $date.Minute+ $IMG[0]/ 60/ 60* $date.Second)
		$real[2]= [Math]::Floor($IMG[0]/ 60* $date.Second)
		$real[5]= [Math]::Floor(360/ 60* $date.Second)

		if($real[0] -le $elapsed[0][0] -and $mode_change[0] -ne "Watched"){ $real[0]+= $IMG[0] }
		if($real[1] -le $elapsed[0][1] -and $mode_change[0] -ne "Watched"){ $real[1]+= $IMG[0] }
		if($real[2] -le $elapsed[0][2] -or $mode_change[0] -eq "Watched"){ $real[2]+= $IMG[0] }
		if($real[5] -le $elapsed[0][5] -or $mode_change[0] -eq "Watched"){ $real[5]+= 360 }

		if($num[0] -ge $real[0]){ $num[0]= $real[0] }
		if($num[1] -ge $real[1]){ $num[1]= $real[1] }
		if($num[2] -ge $real[2]){ $num[2]= $real[2] }
		if($num[5] -ge $real[5]){ $num[5]= $real[5] }

		# write-host ("Stopwth:"+ $Stopwth.ElapsedMilliseconds)
		# write-host ("num:"+ $num)

		[string[]]$nowtime= 0,0,0, 0,0,0
		$nowtime[0]= [Math]::Floor(600/ $IMG[0]* $num[0]/ 50)% 12
		$nowtime[1]= [Math]::Floor(600/ $IMG[0]* $num[1]/ 10)% 60
		$nowtime[2]= [Math]::Floor(600/ $IMG[0]* $num[2]/ 10)% 60
		# $nowtime[4]= [Math]::Floor(600/ $IMG[0]* $num[4]/ 10)% 60

		switch($mode_change[0]){
		'Watched'{
			DrawTime $num $nowtime $nowtime
		}default{
			DrawStopWatch $num $nowtime $nowtime
		}
		} #sw
	}
 } #func
 
Function Watched(){ 


	# $elapsed[0][4]= [Math]::Floor($IMG[0]/ 60* $date.Second+ $IMG[0]/ 60 / 1000* $date.Millisecond)


	# if($date.Millisecond -lt 500){
	# 	$elapsed[0][3]= $IMG[0]/ 2/ 500* $date.Millisecond
	# }else{
	# 	$elapsed[0][3]= $IMG[0]/ 2/ 500* $date.Millisecond
	# }
	# $elapsed[0][3]+= $IMG[0]/ 4


	[int[]]$nowtime= $date.Hour, $date.Minute, $date.Second, $date.Millisecond, "", ""

	if($setalarm[3] -eq $True){

		if(($nowtime[1]% 2) -eq 0){
		if($nowtime[2] -eq 0){

			if($Short_signal.level -eq 0){

				## $shorttmr.Start()

				switch($nowtime[1]){
				30{
					$Short_signal.Start(1,1)

				}0{
					$Short_signal.Start(0,($nowtime[0]% 12))
				}
				} #sw
			}
		}
		}
	}

	if($setalarm[0] -eq $True){

		if($nowtime[0] -eq $Alarm0set.Hours){
		if($nowtime[1] -eq $Alarm0set.Minutes){
		if($nowtime[2] -eq $Alarm0set.Seconds){

			if($Timer_alarm.level -eq 0){

				# $Player.SoundLocation= $sound_path[0]
				# $thirtytmr.Start()	# Timer_alarm
				$Timer_alarm.start(0)	# one shot
			}
		}
		}
		}
	}
	if($setalarm[1] -eq $True){

		if($nowtime[0] -eq $Alarm1set.Hours){
		if($nowtime[1] -eq $Alarm1set.Minutes){
		if($nowtime[2] -eq $Alarm1set.Seconds){

			if($Timer_alarm.level -eq 0){

				# $Player.SoundLocation= $sound_path[1]
				# $thirtytmr.Start()
				$Timer_alarm.start(1)
			}
		}
		}
		}
	}
	if($setalarm[2] -eq $True){

		if($nowtime[0] -eq $Alarm2set.Hours){
		if($nowtime[1] -eq $Alarm2set.Minutes){
		if($nowtime[2] -eq $Alarm2set.Seconds){

			if($Timer_alarm.level -eq 0){

				# $Player.SoundLocation= $sound_path[2]
				# $thirtytmr.Start()
				$Timer_alarm.start(2)
			}
		}
		}
		}
	}

	$elapsed[0][0]= [Math]::Floor($IMG[0]/ 12* ($nowtime[0]% 12) + $IMG[0]/ 12/ 60* $nowtime[1])
	$elapsed[0][1]= [Math]::Floor($IMG[0]/ 60* $nowtime[1]+ $IMG[0]/ 60/ 60* $nowtime[2])
	$elapsed[0][2]= [Math]::Floor($IMG[0]/ 60* $nowtime[2])

	$elapsed[1][0]= [Math]::Floor($IMG[0]/ 12* ($Alarm0set.Hours% 12) + $IMG[0]/ 12/ 60* $Alarm0set.Minutes)
	$elapsed[1][1]= [Math]::Floor($IMG[0]/ 12* ($Alarm1set.Hours% 12) + $IMG[0]/ 12/ 60* $Alarm1set.Minutes)
	$elapsed[1][2]= [Math]::Floor($IMG[0]/ 12* ($Alarm2set.Hours% 12) + $IMG[0]/ 12/ 60* $Alarm2set.Minutes)


	if($Timer_alarm.level -ne 0){
		$elapsed[0][5]= 360/ 1000* $nowtime[3]	# 飾り
	}else{
		$elapsed[0][5]= 360/ 60* $nowtime[2]+ 6/ 1000* $nowtime[3]
	}

	DrawTime $elapsed[0] $nowtime $elapsed[1]


 } #func
 
Function Mode(){ 

	$date= [datetime]::Now

	$cpostion= $frm.PointToClient([Windows.Forms.Cursor]::Position)
	[float[]]$cpoint= ($cpostion.X+ 20- ($IMG[0]* 0.03/2)), ($cpostion.Y- ($IMG[1]* 0.03/ 2))

	if($mode_change[2] -eq $True){

		switch($mode_change[1]){
		'Watched'{		Watch_gimmick;	break;
		}'StopWatched'{	$StopWatch_gimmick.Start()##StopWatch_gimmick; break;
		}'Timered'{		StopWatch_gimmick; break;
		}
		} #sw

	}else{

		switch($mode_change[0]){
		'Watched'{		Watched; break;
		}'StopWatched'{	StopWatched; break;
		}'Timered'{		$Timered.Start()##Timered; break;
		}
		} #sw
	}
 } #func
 
function StopWatch_gimmick(){ 

	if($Stopwth.ElapsedMilliseconds -ge ($milsec+ $milsec/60)){ # $milsec/60 111.67%まで

		$Tmr.Interval= 64
		## $Tmr.Stop()
		$Stopwth.Reset()

		$script:mode_change[0]= $mode_change[1]
		$script:mode_change[2]= $False

		switch($mode_change[0]){
		'StopWatched'{		StopWatched;	break;
		}'Timered'{			Timered
		}
		} #sw

	}else{

		[float]$bai= $IMG[0]* $Stopwth.ElapsedMilliseconds/ $milsec
		[float]$bak=360* $Stopwth.ElapsedMilliseconds/ $milsec

		[float[]]$num= 0,0,0, 0,0,0
		$num[0]= $bai+ $elapsed[0][0]
		$num[1]= $bai+ $elapsed[0][1]
		$num[2]= $bai+ $elapsed[0][2]
		$num[5]= $bak+ $elapsed[0][5]

		[float[]]$real= 0,0,0, 0,0,0


		switch($mode_change[1]){
		'StopWatched'{

			$real[0]= $IMG[0]
			$real[1]= $IMG[0]
			$real[2]= $IMG[0]
			$real[5]= 360
			break;

		}'Timered'{

			$real[0]= [Math]::Floor($IMG[0]/ 12* ($Timer_set.Hours% 12))
			$real[1]= [Math]::Floor($IMG[0]/ 60* $Timer_set.Minutes)
			$real[2]= [Math]::Floor($IMG[0]/ 60* $Timer_set.Seconds)
			$real[5]= 360/ 60* $Timer_set.Seconds

			if($real[0] -le $elapsed[0][0]){ $real[0]+= $IMG[0] } # -le 1cycle
			if($real[1] -le $elapsed[0][1]){ $real[1]+= $IMG[0] }
			if($real[2] -le $elapsed[0][2]){ $real[2]+= $IMG[0] }
			if($real[5] -le $elapsed[0][5]){ $real[5]+= 360 }
		}
		} #sw

		if($num[0] -ge $real[0]){ $num[0]= $real[0] }
		if($num[1] -ge $real[1]){ $num[1]= $real[1] }
		if($num[2] -ge $real[2]){ $num[2]= $real[2] }
		if($num[5] -ge $real[5]){ $num[5]= $real[5] }


		# if($elapsed[3] -ge $IMG[0]/ 2){
		# 	$num[3]= $elapsed[3]/ $milsec* ($milsec- $Stopwth.ElapsedMilliseconds)
		# }else{
		# 	$num[3]= $elapsed[3]+ ($IMG[0]- $elapsed[3])/$milsec* $Stopwth.ElapsedMilliseconds
		# }
		# $num[4]= $elapsed[4]/ $milsec* ($milsec- $Stopwth.ElapsedMilliseconds)
		# $num[5]= $elapsed[0][5]+ ($elapsed[1][5]+ (360+ 360- $elapsed[0][5]))/$milsec* $Stopwth.ElapsedMilliseconds

		# write-host ("Stopwth:"+ $Stopwth.ElapsedMilliseconds)
		# write-host ("num:"+ $num)


		[string[]]$nowtime= 0,0,0, 0,0,0
		$nowtime[0]= [Math]::Floor(600/ $IMG[0]* $num[0]/ 50)% 12
		$nowtime[1]= [Math]::Floor(600/ $IMG[0]* $num[1]/ 10)% 60
		$nowtime[2]= [Math]::Floor(600/ $IMG[0]* $num[2]/ 10)% 60
		# $nowtime[4]= [Math]::Floor(600/ $IMG[0]* $num[4]/ 10)% 60

		switch($mode_change[0]){
		'Watched'{
			DrawTime $num $nowtime $nowtime
		}default{
			DrawStopWatch $num $nowtime $nowtime
		}
		} #sw
	}
 } #func
 
Function Timered(){ 

	$Timspan= -$Stopwth.Elapsed
	$Timspan+= $Timer_set


	[int[]]$nowtime= $Timspan.Hours, $Timspan.Minutes, $Timspan.Seconds, $Timspan.Milliseconds, "", ""


	if(($nowtime[1]% 5) -eq 4 -and $nowtime[2] -eq 59){

		if($short_count[0] -eq 0){

			$shorttmr.Start()
			$script:short_count[0]= 1	# one shot

			switch($nowtime[1]% 10){
			4{		$script:short_count[2]= 1
			}9{		$script:short_count[2]= 2
			}
			} #sw
		}
	}

	if($nowtime[0] -le 0 -and $nowtime[1] -le 0 -and $nowtime[2] -le 0 -and $nowtime[3] -le 0){

		if($nowtime[1] -le -1){ # -1min.

			$Tmr.Stop()
			## $thirtytmr.Stop()
			## $Timer_alarm.Stop()

			$elapsed[0][5]= 0
		}else{

			if(($nowtime[2]% 4) -eq 0){ # 4sec.
				$elapsed[0][5]= 360/ 1000* $nowtime[3]
			}else{
				$elapsed[0][5]= 360
			}

			if($Timer_alarm.level -eq 0){	# one shot

				## $Player.SoundLocation= $sound_path[3]
				## $thirtytmr.Start()
				$Timer_alarm.start(3)
			}
		}

		$elapsed[0][0]= 0
		$elapsed[0][1]= 0
		$elapsed[0][2]= 0

		$nowtime= 0,0,0, 0,0,0

	}else{

		$elapsed[0][0]= [Math]::Floor($IMG[0]/ 12* ($nowtime[0]% 12))
		$elapsed[0][1]= [Math]::Floor($IMG[0]/ 60* $nowtime[1])
		$elapsed[0][2]= [Math]::Floor($IMG[0]/ 60* $nowtime[2]+ $IMG[0]/ 60/ 1000* $nowtime[3])
		$elapsed[0][5]= 360/ 60* $nowtime[2]+ 360/ 60/ 1000* $nowtime[3]
	}

	DrawStopWatch $elapsed[0] $nowtime $nowtime

 } #func
 
function Short_alarm(){ 

	switch($short_count[0]){
	2{
		if($secshort.ElapsedMilliseconds -ge 1000){

			$script:short_count[1]++;

			if($short_count[1] -ge $short_count[2]){

				if($secshort.ElapsedMilliseconds -ge 20000){

					$script:short_count[1]= 0
					$shorttmr.Stop()
					$Playshort.Stop()
				}

			}else{

				$script:short_count[0]= 1
				$Playshort.Stop()
			}
		}
	}1{
		$script:short_count[0]= 2
		$secshort.Restart()
		$Playshort.Play()
	}
	} #sw

 } #func
 
function Timer_alarm(){ 

	switch($alarmsec){
	5{
		if($thirtysec.ElapsedMilliseconds -ge 60000){
			$thirtytmr.Stop()
			$thirtysec.Reset()
			$script:alarmsec= 0
		}
	}4{
		if($thirtysec.ElapsedMilliseconds -ge 50000){
			$Player.Stop()
			$script:alarmsec++
		}
	}3{
		if($thirtysec.ElapsedMilliseconds -ge 30000){
			$Player.Play()
			$script:alarmsec++
		}
	}2{
		if($thirtysec.ElapsedMilliseconds -ge 20000){
			$Player.Stop()
			$script:alarmsec++
		}
	}1{
		$thirtysec.Start()
		$Player.Play()
		$script:alarmsec++
	}
	} #sw
 } #func
 
$menu_open= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_open.Text= "Open"
$menu_open.Add_Click({

	[string]$chk= $dia.ShowDialog()

	switch($chk){
	'OK'{
		$Player.SoundLocation= $dia.FileName

		## Mml_writer $new_set $path 0
		# $new_set | Out-File -Encoding oem -FilePath $path # shiftJIS

	#}'Cancel'{
	}
	} #sw
 })
 
$menu_tesplay= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_tesplay.Text= "AlarmTest"
$menu_tesplay.Add_Click({

	$script:setalarm[0]= Toggle $True
	$Player.Play()
})
 
function DIApos([float]$num, [float]$width, [float]$height){ 

	$width= $IMG[0]* $width

	[float[]]$rad= 0,0,0

	$rad[0]= ($num+ $width)* $pi* 2/ $IMG[0]
	$rad[1]= $num* $pi* 2/ $IMG[0]		# 全位相角をx座標の最大値で割っておく
	$rad[2]= ($num- $width)* $pi* 2/ $IMG[0]

	[float[]]$fx= 0,0,0, 0,0
	[float[]]$fy= 0,0,0, 0,0

	$fx[0]= $height* 0.6* [Math]::Cos($rad[1])
	$fx[1]= $height* 1.2* [Math]::Cos($rad[0])
	$fx[2]= $height* [Math]::Cos($rad[1])
	$fx[3]= $height* 1.2* [Math]::Cos($rad[2])
	$fx[4]= $height* 0.6* [Math]::Cos($rad[1])

	$fy[0]= $height* 0.7* [Math]::Sin($rad[1])
	$fy[1]= $height* 0.9* [Math]::Sin($rad[0])
	$fy[2]= $height* [Math]::Sin($rad[1])
	$fy[3]= $height* 0.9* [Math]::Sin($rad[2])
	$fy[4]= $height* 0.7* [Math]::Sin($rad[1])


	[float[]]$gx= 0,0,0, 0,0
	[float[]]$gy= 0,0,0, 0,0

	$gx[0]= $center[0]- $fx[0]* $center[0]
	$gx[1]= $center[0]- $fx[1]* $center[0]
	$gx[2]= $center[0]- $fx[2]* $center[0]
	$gx[3]= $center[0]- $fx[3]* $center[0]
	$gx[4]= $center[0]- $fx[4]* $center[0]

	$gy[0]= $center[1]- $fy[0]* $center[1]
	$gy[1]= $center[1]- $fy[1]* $center[1]
	$gy[2]= $center[1]- $fy[2]* $center[1]
	$gy[3]= $center[1]- $fy[3]* $center[1]
	$gy[4]= $center[1]- $fy[4]* $center[1]

	[array]$xy= $gx, $gy
	XYinput $xy 1

 } #func
 
function Alarm([int[]]$now){ 

	switch($alarmsec){
	1{
		$thirtysec.Start()
		$Player.Play()
		$script:alarmsec= 2

	}2{
		if($thirtysec.ElapsedMilliseconds -ge 20000){
			$script:alarmsec= 3
		}
	}3{
		$thirtysec.Restart()
		$Player.Stop()
		$script:alarmsec= 4

	}4{
		if($thirtysec.ElapsedMilliseconds -ge 10000){
			$script:alarmsec= 5
		}

	}5{
		$thirtysec.Reset()
		$script:alarmsec= 0

	}default{

		switch($mode_change[0]){
		'Watched'{

			if($now[0] -eq $Alarmset.Hours -and $now[1] -eq $Alarmset.Minutes){

				$script:alarmsec= 1
			}
			break;

		}'Timered'{

			if($now[1] -le -1){

				$Tmr.Stop()
			}else{
				$script:alarmsec= 1
			}
		}
		} #sw
	}
	} #sw
 } #func
 
function Plate($color){ 


	$buff.Graphics.Clear($black)
　　# $buff.Graphics.DrawLine($white_pen, $center[0],($IMG[1]* 0.2), $center[0],($IMG[1]* 0.8))
　　# $buff.Graphics.DrawLine($white_pen, ($IMG[0]*0.2),$center[1], ($IMG[0]*0.8),$center[1])

　　DIApos ($IMG[0]/ 4) 0.004 0.67
　　$buff.Graphics.FillPolygon($Millisecond_brush, $pointed[1])

	# [array]$posa= STRpos ($IMG[0]/ 12* 0) ($IMG[0]/ 4) 0.74
	# [array]$posb= STRpos ($IMG[0]/ 12* 6) ($IMG[0]/ 4) 0.74
	# $buff.Graphics.DrawLine($white_pen, $posa[0],$posa[1], $posb[0],$posb[1])

	# [array]$posa= STRpos ($IMG[0]/ 12* 1) ($IMG[0]/ 4) 0.78
	# [array]$posb= STRpos ($IMG[0]/ 12* 7) ($IMG[0]/ 4) 0.78
	# $buff.Graphics.DrawLine($white_pen, $posa[0],$posa[1], $posb[0],$posb[1])

	# [array]$posa= STRpos ($IMG[0]/ 12* 2) ($IMG[0]/ 4) 0.78
	# [array]$posb= STRpos ($IMG[0]/ 12* 8) ($IMG[0]/ 4) 0.78
	# $buff.Graphics.DrawLine($white_pen, $posa[0],$posa[1], $posb[0],$posb[1])

	# [array]$posa= STRpos ($IMG[0]/ 12* 3) ($IMG[0]/ 4) 0.74
	# [array]$posb= STRpos ($IMG[0]/ 12* 9) ($IMG[0]/ 4) 0.74
	# $buff.Graphics.DrawLine($white_pen, $posa[0],$posa[1], $posb[0],$posb[1])

	$buff.Render($uragraphics) # ura store
	# $buffc.Render($gpk)

	# $uraimage.MakeTransparent($black)

 } #func
 
$baloon= New-Object System.Windows.Forms.Tooltip 
$baloon.ShowAlways= $False
# $baloon.ToolTipIcon= "Info"
$baloon.ToolTipTitle= 'Alarm: '
$baloon.AutomaticDelay= 667
 
[int[]]$ALM= @(($IMG[0]* 0.3+ 2), ($IMG[0]* 0.03+ 2)) # アラームサイズ 
[int[]]$buff_alm= @(($ALM[0]+ 2), ($ALM[1]+ 2))

$alarm0image= New-Object System.Drawing.Bitmap($ALM)
$alarm1image= New-Object System.Drawing.Bitmap($ALM)
$alarm2image= New-Object System.Drawing.Bitmap($ALM)
$alarm0graphics= [System.Drawing.Graphics]::FromImage($alarm0image)
$alarm1graphics= [System.Drawing.Graphics]::FromImage($alarm1image)
$alarm2graphics= [System.Drawing.Graphics]::FromImage($alarm2image)

$Pica= New-Object System.Windows.Forms.PictureBox # 描画領域
$Pica.ClientSize= $alarm0image.Size
$Pica.Image= $alarm0image
$Pica.Location= @(-10, 10) -join ","
$Pica.Parent= $Pictbox # .AddRangeとなる
$Pica.BackColor= $trans

$Picb= New-Object System.Windows.Forms.PictureBox
$Picb.ClientSize= $alarm1image.Size
$Picb.Location= @(-10, 10) -join ","
$Picb.Image= $alarm1image
$Picb.Parent= $Pictbox
$Picb.BackColor= $trans
$Picb.Add_MouseDown({
 try{		$script:keyoff= 2
 }catch{	echo $_.exception
 }
 })
$Picb.Add_MouseLeave({
 try{		$script:keyoff= 0
 }catch{	echo $_.exception
 }
 })
$Picb.Add_MouseHover({
 try{		$script:keyoff= 1
 }catch{	echo $_.exception
 }
 })

$Picc= New-Object System.Windows.Forms.PictureBox
$Picc.ClientSize= $alarm2image.Size
$Picc.Image= $alarm2image
$Picc.Location= @(-10, 10) -join ","
$Picc.Parent= $Pictbox
$Picc.BackColor= $trans


$contxta= [System.Drawing.BufferedGraphicsManager]::Current # ダブルバッファ
$contxta.MaximumBuffer= @($buff_alm[0],$buff_alm[1]) -join "," # string出力
$buffa= $contxta.Allocate($alarm1graphics, $Picb.ClientRectangle)
 
 ------------ #> 
  
[double]$pi= [Math]::PI # 180度のラジアン値 


[array]$pointed= "","" # hari, dia

$pointed[0]= Reso 9 # point obj
# $pointed[1]= Reso 5

[array]$elapsed= 0,0
[float[]]$elapsed[0]= 0,0,0, 0,0,0 # -- position [hour,min,sec,,,milsec]
[float[]]$elapsed[1]= 0,0,0, 0,0,0 # -- alarm


[int]$milsec= 1080 # gimmik time


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

$silver= [System.Drawing.Color]::FromArgb(200,150,150,150)
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
$rr1= [System.Drawing.Color]::FromArgb(150,50,250,50)
$gb1= [System.Drawing.Color]::FromArgb(150,250,50,250)
$rb1= [System.Drawing.Color]::FromArgb(150,250,250,50)

$Hour_brush1= New-Object System.Drawing.SolidBrush($rr1)
$Minute_brush1= New-Object System.Drawing.SolidBrush($gb1)
$Second_brush1= New-Object System.Drawing.SolidBrush($rb1)

$Hour_pen1= New-Object System.Drawing.Pen($rr1, 1)
$Minute_pen1= New-Object System.Drawing.Pen($gb1, 1)
$Second_pen1= New-Object System.Drawing.Pen($rb1, 1)

 
# third 
$rr2= [System.Drawing.Color]::FromArgb(150,50,50,250)
$gb2= [System.Drawing.Color]::FromArgb(150,250,250,50)
$rb2= [System.Drawing.Color]::FromArgb(150,50,250,250)

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
	$True{		$script:setalarm[0]= Toggle $False 0
	}$False{	$script:setalarm[0]= Toggle $True 0
	}
	} #sw
 })
$contxt1set= New-Object System.Windows.Forms.ToolStripMenuItem
# $contxt1set.Text= "1 AlarmReset"
$contxt1set.Add_Click({

	switch($setalarm[1]){
	$True{		$script:setalarm[1]= Toggle $False 1
	}$False{	$script:setalarm[1]= Toggle $True 1
	}
	} #sw
 })
$contxt2set= New-Object System.Windows.Forms.ToolStripMenuItem
# $contxt2set.Text= "2 AlarmReset"
$contxt2set.Add_Click({

	switch($setalarm[2]){
	$True{		$script:setalarm[2]= Toggle $False 2
	}$False{	$script:setalarm[2]= Toggle $True 2
	}
	} #sw
 })
$contxt3set= New-Object System.Windows.Forms.ToolStripMenuItem
# $contxt3set.Text= "3 Jiho Reset"
$contxt3set.Add_Click({

	switch($setalarm[3]){
	$True{		$script:setalarm[3]= Toggle $False 3
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

  if($script:mode_change[2] -eq $False){ # gimmik ji cancel

	Moder "Stop" $script:mode_change[0]
	$Watched_gimmick.Start()

	$script:mode_change[1]= "Watched"
	$script:mode_change[2]= $True

	$Timer_alarm.Stop()
  }
 })
 
$menu_sw= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_sw.Text= "StopWatch"
$menu_sw.Add_Click({

  if($script:mode_change[2] -eq $False){

	Moder "Stop" $script:mode_change[0]
	$StopWatched_gimmick.Start()

	$script:mode_change[1]= "StopWatched"
	$script:mode_change[2]= $True

	$Timer_alarm.Stop()
  }

	# $Tmr.Interval= 64
	# $Tmr.Start()
	# $Swh.Restart() # gimic
 })
 
$menu_tr= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_tr.Text= "Timer"
$menu_tr.Add_Click({

  if($script:mode_change[2] -eq $False){

	Moder "Stop" $script:mode_change[0]
	$StopWatched_gimmick.Start()

	$script:mode_change[1]= "Timered"
	$script:mode_change[2]= $True

	$Timer_alarm.Stop() # nattetara tomeru
  }

	# $Tmr.Interval= 64
	# $Tmr.Start()
	# $Swh.Restart() # gimic
 })
 
$menu_f.DropDownItems.AddRange(@($menu_wh,$menu_sw,$menu_tr)) 
  
$menu_t= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_t.Text= "Time"
	
$menu_start= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_start.Text= "Start"
$menu_start.Add_Click({

  if($mode_change[2] -eq $False){

	switch($mode_change[0]){
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

	switch($mode_change[0]){
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

	$script:mode_change[1]= $mode_change[0]

	$Timer_alarm.Stop()
	$Tmr.Interval= 64
	$Tmr.Start()

	$Stopwth.Restart() # gimic
	$script:mode_change[2]= $True

 })
 
$menu_t.DropDownItems.AddRange(@($menu_start,$menu_stop,$menu_reset)) 
  
$menu_a= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_a.Text= "Alarm"
	
$menu_set= New-Object System.Windows.Forms.ToolStripMenuItem 
$menu_set.Text= "Alarm Set"
	
$menu0set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu0set.Text= "0 AlarmReset"
$menu0set.Add_Click({

	switch($setalarm[0]){
	$True{		$script:setalarm[0]= Toggle $False 0
	}$False{	$script:setalarm[0]= Toggle $True 0
	}
	} #sw
 })
 
$menu1set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu1set.Text= "1 AlarmReset"
$menu1set.Add_Click({

	switch($setalarm[1]){
	$True{		$script:setalarm[1]= Toggle $False 1
	}$False{	$script:setalarm[1]= Toggle $True 1
	}
	} #sw
 })
 
$menu2set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu2set.Text= "2 AlarmReset"
$menu2set.Add_Click({

	switch($setalarm[2]){
	$True{		$script:setalarm[2]= Toggle $False 2
	}$False{	$script:setalarm[2]= Toggle $True 2
	}
	} #sw
 })
 
$menu3set= New-Object System.Windows.Forms.ToolStripMenuItem 
# $menu3set.Text= "3 Jiho Reset"
$menu3set.Add_Click({

	switch($setalarm[3]){
	$True{		$script:setalarm[3]= Toggle $False 3
	}$False{	$script:setalarm[3]= Toggle $True 3
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

	Moder "Stop" $script:mode_change[0]
	$Timer_alarm.Stop()
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
 
$frm.Add_ResizeEnd({ 
	if($frm.Width -ne $sizer[0]){
		$script:sizer[2]= "width"
	}else{
		$script:sizer[2]= "height"
	}


	switch($sizer[2]){
	'height'{
		$frm.Height= $frm.Width+ 40
	}'width'{
		$frm.Width= $frm.Height- 40
	}
	} #sw
	$script:sizer= $frm.Width, $frm.Height, $sizer[2]
 })
 	
$frm.Add_SizeChanged({ 
	$Pictbox.SuspendLayout()
	Resize_Set
	$Pictbox.ResumeLayout()
 })
 
<# 
 
#> 
 
$frm.Controls.AddRange(@($mnu,$slide_Pictbox,$Pictbox)) #下は後ろ側 
  
$cpostion= New-Object System.Drawing.Point 
 
# メインルーチン ====== 

[array]$Color= @($Hour_brush, $Minute_brush, $Second_brush)
[array]$Colour= @($Hour_pen, $Minute_pen, $Second_pen)

[bool[]]$setalarm= $False,$False,$False,$False
$setalarm[0]= Toggle $True 0
$setalarm[1]= Toggle $True 1
$setalarm[2]= Toggle $True 2
$setalarm[3]= Toggle $True 3 # jiho


[array]$AlarmTime= "","",""
$AlarmTime[0]= New-Object TimeSpan(7,1,0)
$AlarmTime[1]= New-Object TimeSpan(10,15,0)
$AlarmTime[2]= New-Object TimeSpan(15,15,0)

$TimerSet= New-Object TimeSpan(0,0,5)

$Short_signal= New-Object from_Short_signal
$Short_signal.tmr.Add_Tick({
	$Short_signal.Timer()
})
$Timer_alarm= New-Object from_Timer_alarm
$Timer_alarm.tmr.Add_Tick({
	$Timer_alarm.Timer()
})

$Swipe= New-Object from_Swipe($buff_size[1])
$Swipe.tmr.Add_Tick({
	$Swipe.slide()
})

[array]$mode_change= "Watched","Watched",$False  # now, next, alarm position sw


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

$Watched.tmr.Start()

$frm.ShowDialog() > $null

$graphics.Dispose()
$buff.Dispose()
 
# read-host "pause" 
exit
 
