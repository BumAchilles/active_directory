param( [Parameter(Mandatory=$true)] $JSONfile)

function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupobject)

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}
function CreateADUSer(){
    param( [Parameter(Mandatory=$true)] $userobject)

    # Pull out the name from the Json object
    $name = $userobject.name
    $password = $userObject.password

    # Generate a "first intial, last name " structure for username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samaccountname = $username
    $principalname = $username

    # Actually create the AD user object
   New-AdUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-AdAccount 


   # Add the user to its appropaite group
   foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name NOT added to group $group_name because it does not exisit"
        }
   }
   
   
    echo $userobject
}



$json = (Get-Content $JSONfile | Convertfrom-JSON)

$Global:Domain = $json.domain

foreach( $group in $json.groups ){
    CreateADGroup $group
}


foreach( $user in $json.users ){
    CreateADUser $user
}
