# Get Service Details  
$service = get-service smstsmgr 
  
# Check ServiceDependedOn Array  
if (($service.ServicesDependedOn).name -notcontains "ccmexec")  
{  
 write-host "Not present...Configuring Service"  
 start-process sc.exe -ArgumentList "config smstsmgr depend= winmgmt/ccmexec" -wait  
}  
else  
{  
 write-host "Present..Taking no action"  
} 