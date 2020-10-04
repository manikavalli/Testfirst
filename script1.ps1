$location=$env:bamboo_location
$Mailfrom=$env:bamboo_Mailfrom
$MailCC=$env:bamboo_MailCC
Set-Location "$location"
$REP_NAME=$env:bamboo_REP_NAME
$net_use_path=$env:bamboo_net_use_path
$username=$env:bamboo_username
$password=$env:bamboo_password
$temp_file_path=$env:bamboo_temp_file_path
$staging_file_path=$env:bamboo_staging_file_path
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
$count=0
$i3=0
$str1=""
$set_1 = New-Object System.Collections.Generic.HashSet[System.Object]
$set_2 = New-Object System.Collections.Generic.HashSet[System.Object]
git checkout -b bamboo_poc
#git pull 
$a_10=git log --merges -1
#Write-Host $a_10.Length
$m1=$a_10.Length
$m2=$m1-8
Write-Host 'm2 waala h'
Write-Host $m2
$branch_1= $a_10[5].Split(' ')[-3]
Write-Host $branch_1
git checkout  $branch_1
git pull
git branch --set-upstream-to=origin/$branch_1
git pull
$b_10=git whatchanged -$m2
Write-Host 'changes'
Write-Host $b_10
$commit_ids = New-Object System.Collections.Generic.List[System.Object]
foreach($i in $b_10)
{
    if($i -match 'commit*')
    {
        $commit_ids.Add($i.Split(' ')[1])
    }
}
Write-Host $commit_ids
if(Test-Path $temp_file_path\File_generated.txt)
{
   Remove-Item $temp_file_path\File_generated.txt
}
if(Test-Path $temp_file_path\Details.txt)
{
   Remove-Item $temp_file_path\Details.txt
}
if(Test-Path $temp_file_path\Details_1.txt)
{
   Remove-Item $temp_file_path\Details_1.txt
}
if(Test-Path $temp_file_path\Details_2.txt)
{
   Remove-Item $temp_file_path\Details_2.txt
}
if(Test-Path $temp_file_path\mail_details.txt)
{
   Remove-Item $temp_file_path\mail_details.txt
}
if(Test-Path $temp_file_path\time.txt)
{
   Remove-Item $temp_file_path\time.txt
}
if(Test-Path $temp_file_path\feature_name.txt)
{
   Remove-Item $temp_file_path\feature_name.txt
}
$b=(Get-Date).ToString('MMddyyyyhhmmsstt')
Add-Content -Path $temp_file_path\time.txt $b
Add-Content -Path $temp_file_path\feature_name.txt $branch_1
#Write-Host ("List of IDs    $commit_ids")
foreach($i in $commit_ids)
{
    $str1=""
    Write-Host $i
    $a1=git whatchanged $i -1
    Write-Host $a1.Length
    $fulling_length=$a1.Length-1
    foreach ($i3 in 6..$fulling_length)
    {
        Write-Host $i3
        $str1=$a1[$i3]+"`t"+$a1[1]+"`t"+$a1[2]
        Add-Content -Path "$temp_file_path\Details.txt" $str1
    }
}
##############File Reading Context#####################
$a_9=Get-Content $temp_file_path\Details.txt
#Write-Host $a_9
foreach ($i in $a_9)
{
    Add-Content -Path "$temp_file_path\Details_1.txt" $i.Substring(37)
}
########################Starting creating folder#######
$outItems_status = New-Object System.Collections.Generic.List[System.Object]
$outItems_status_10 = New-Object System.Collections.Generic.List[System.Object]
$a_8=Get-Content $temp_file_path\Details_1.txt
foreach($i4 in $a_8)
{
    if( !($i4.Split("`t")[1] -match 'CONFIG_INPUT*'))
    {
    Write-Host $i4.Split("`t")[1]
    $outItems_status.Add($i4.Split("`t")[1])
    $outItems_status_10.Add($i4)
    }
}
Remove-Item $temp_file_path\Details_1.txt
Write-Host 'writing details to details_1.txt'

#Write-Host $outItems_status
foreach($i in $outItems_status_10)
{
   Write-Host $i 
   Add-Content -Path "$temp_file_path\Details_1.txt" $i
}
#######################################################
foreach ($j in $outItems_status)
{
$m=$j
$m=$m=$m.Replace('/','\')
Write-Host $m
$x1=$m.LastIndexOf('\')
Write-Host $x1
$x2=$m.IndexOf('\')
Write-Host $x2
$start_1=$m.Substring(0,$x2)
Write-Host "start_1"
Write-Host $start_1
$start_2=$m.Substring($x2+1,$x1-$x2)
Write-Host "start_2"
Write-Host $start_2
$start_3=$m.Substring($x1+1)
Write-Host "start_3"
Write-Host $start_3
Write-Host "m"
Write-Host $m
if (-not ([string]::IsNullOrEmpty($start_2)))
{
C:\WINDOWS\system32\net use * /delete /y
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
if(!(test-path "$staging_file_path\$start_1$b\$start_2"))
{
C:\WINDOWS\system32\net use * /delete /y
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
New-Item -Path "$staging_file_path\$start_1$b\$start_2" -ItemType Directory
C:\WINDOWS\system32\net use * /delete /y
}
if(test-path "$staging_file_path\$start_1$b\$start_2")
{
#net use * /delete /y
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
Copy-Item (Get-Item $j) -Destination "$staging_file_path\$start_1$b\$start_2" -Recurse -Force
C:\WINDOWS\system32\net use * /delete /y
}
$Path_list="$staging_file_path\$start_1$b\$start_2$start_3"
#$outItems_to_be_diplayed.Add(($Path_list,$j))
#$outItems_status_1.Add($Path_list)
$set_2.Add($Path_list)
}

if (([string]::IsNullOrEmpty($start_2)))
{
C:\WINDOWS\system32\net use $staging_file_path /user:us\$username $password
if(!(test-path "$staging_file_path\$start_1$b"))
{
C:\WINDOWS\system32\net use * /delete /y
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
New-Item -Path "$staging_file_path\$start_1$b" -ItemType Directory
Write-Host "Inside First If"
#net use * /delete /y
}
if(test-path "$staging_file_path\$start_1$b")
{
C:\WINDOWS\system32\net use * /delete /y
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
Copy-Item (Get-Item $j) -Destination "$staging_file_path\$start_1$b" -Recurse -Force
Write-Host "Inside Second If"
C:\WINDOWS\system32\net use * /delete /y
}
$Path_list="$staging_file_path\$start_1$b\$start_3"
#$outItems_to_be_diplayed.Add(($Path_list,$j))
#$outItems_status_1.Add($Path_list)
$set_2.Add($Path_list)
}
}
##########################################
####handling_dups#########################
##########################################
C:\WINDOWS\system32\net use * /delete /y
C:\WINDOWS\system32\net use $net_use_path /user:us\$username $password
$m=Get-Content "$temp_file_path\Details_1.txt"
$set_1 = New-Object System.Collections.Generic.HashSet[System.Object]
Write-Host $m
foreach($j in $m)
{
    $set_1.Add($j.Split("`t")[1])
}
Write-Host $set_1
foreach($j1 in $set_1)
{
    foreach($i1 in $m)
    {
        if($j1 -eq $i1.Split("`t")[1])
        {
            Add-Content -Path "$temp_file_path\Details_2.txt" $i1
            break
        }
    }
}
#####################################################
###Getting email ID
#####################################################
$set_mail = New-Object System.Collections.Generic.HashSet[System.Object] 
$mail_1=Get-Content $temp_file_path\Details_1.txt       
Write-Host $mail_1
foreach($i in $mail_1)
{
    Write-Host $i.Split("`t")[2].Split('<')[1].Replace('>','')
    $set_mail.Add($i.Split("`t")[2].Split('<')[1].Replace('>',''))
}
#Write-Host $set_mail
$str1_mail=""
foreach ($i in $set_mail)
{
    $str1_mail=$str1_mail+ $i+","
    Add-Content -Path $temp_file_path\mail_details.txt $str1_mail
}
Write-Host $str1_mail
$l1_mail=$str1_mail.Length
$str2_mail=$str1_mail.Substring(0,$l1_mail-1)
Write-Host $str2_mail
#$str2_mail=$str1_mail.Replace(',','","')
#Write-Host $str2_mail
#$str3_mail='"'+$str2_mail
##Write-Host $str3_mail
#$l1_mail=$str3_mail.Length
#$str4_mail=$str3_mail.Substring(0,$l1_mail-2)
##Write-Host $str4_mail
#$emailto=@($str4_mail)
$recipients = $str2_mail
[string[]]$To_1 = $recipients.Split(',')

#####################################################
############Commented email thing###################
####################################################
foreach ($i in $set_2)
{
    Add-Content -Path $temp_file_path\File_generated.txt $i
}
C:\WINDOWS\system32\net use * /delete /y
