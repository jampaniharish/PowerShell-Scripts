$users = Get-Content "C:\ISO\Users.txt"
$collection = "APPS0057_Sandyford_Terminal_Server_1.0_Users"

foreach($user in $users)
{
   try 
   {      Add-CMUserCollectionDirectMembershipRule  -CollectionName $collection -ResourceId $(Get-CMUser -Name $user).ResourceID       
 } 
  catch { "Invalid user or direct membership rule may already exist: $user" | Out-File "C:\ISO\User_error.log" -Append       
  }
 }
 