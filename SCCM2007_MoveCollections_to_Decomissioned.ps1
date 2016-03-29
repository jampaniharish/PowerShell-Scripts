function Link-SccmCollection { 
    [CmdletBinding()] 
    param ( 
        [Parameter(Mandatory = $true)] [string] $SccmServer 
        , [Parameter(Mandatory = $true)] [string] $SiteCode 
        , [Parameter(Mandatory = $true)] [string] $CollectionID 
        , [Parameter(Mandatory = $true)] [string] $ParentCollectionID 
    ) 
 
    if (-not (Test-Connection -ComputerName $SccmServer -Count 1)) { 
        return; 
    } 
 
    $CollectionRelationship = @(Get-WmiObject -ComputerName $SccmServer -Namespace root\sms\site_$SiteCode -Class SMS_CollectToSubCollect -Filter "subCollectionID = '$CollectionID'")[0]; 
    $Collection = @([wmi]("\\{0}\root\sms\site_{1}:SMS_Collection.CollectionID='{2}'" -f $SccmServer, $SiteCode, $CollectionID))[0]; 
    $ParentCollection = @([wmi]("\\{0}\root\sms\site_{1}:SMS_Collection.CollectionID='{2}'" -f $SccmServer, $SiteCode, $ParentCollectionID))[0]; 
         
     
    if ($Collection -and $ParentCollection) { 
        Write-Verbose -Message ('Setting parent collection for {0}:{1} to {2}:{3}' -f ` 
            $Collection.CollectionID,  
            $Collection.Name,  
            $ParentCollection.CollectionID,  
            $ParentCollection.Name); 
            $CollectionRelationship.parentCollectionID = $ParentCollection.CollectionID; 
            $CollectionRelationship.Put(); 
    } 
    else { 
        Write-Warning -Message 'Please ensure that you have entered a valid collection ID'; 
    } 
} 
 
$CollectionID = Get-content C:\ISO\CollectionID.txt 
 
Foreach ($item in $CollectionID){ 
    #Link-SccmCollection -SccmServer xggc-sccm-01 -SiteCode C01 -CollectionID $item -ParentCollectionID C0100B73 #Decomissioned Coll ID
    
    Link-SccmCollection -SccmServer xggc-sccm-01 -SiteCode C01 -CollectionID $item -ParentCollectionID C0100088 #Application Deployment Coll ID
}