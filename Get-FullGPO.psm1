Import-Module GroupPolicy

function Get-Gplink  { 
param ([string]$path,[boolean]$inheritance, $domain) 
    if ($inheritance) { 
        (Get-GPInheritance -Target $path -Domain $domain).inheritedgpolinks 
    } 
    else { 
        (Get-GPInheritance -Target $path -Domain $domain).gpolinks 
    } 
}

class GPType {
	[String]$Type
    [System.Collections.ArrayList]$Settings
    [Int32]$VersionDirectory
    [Int32]$VersionSysVol
    [Boolean]$isEnabled
	        
	GPType([String]$Type) {
		$this.Type = $Type
        $this.Settings = New-Object System.Collections.ArrayList
        $this.VersionDirectory = 0
        $this.VersionSysVol = 0
        $this.isEnabled = $false
	}
	addSetting([String]$Key,[Object[]]$Setting) {
        $tuple = [System.Tuple]::create($key,$Setting)
        $newSetting = [Setting]::new($tuple.item1,$tuple.item2)
        $this.settings.Add($newSetting)
	}
    setVersionDirectory([Int32]$int) {
        $this.VersionDirectory = $int
    }
    setVersionSysVol([Int32]$int) {
        $this.VersionSysVol = $int
    }
    setEnabled([Boolean]$ans) {
        $this.isEnabled = $ans
    }
    setInfo([Int32]$verDirectory,[Int32]$sysVol,[Boolean]$enabled) {
        $this.VersionDirectory = $verDirectory
        $this.VersionSysVol = $sysVol
        $this.isEnabled = $enabled
    }    
}
class Setting {
    [String]$Key
    [System.Collections.ArrayList] $PolicyInfo
    Setting([String]$Key,[System.Xml.XmlElement[]]$PolicyInfo) {
        $this.Key = $Key
        $this.PolicyInfo = $PolicyInfo
    }
}
class FullGPO {
	Hidden [Object]$GPO
    Hidden [GPType[]]$TypeList
    Hidden [String]$Name
	Hidden [String]$Domain
    Hidden [System.Collections.ArrayList]$Links
    Hidden [Object]$Path
    [Object]$DisplayName
    [Object]$DomainName
    [Object]$Owner
    [Object]$ID
    [Object]$GPOStatus
    [Object]$Description
    [Object]$CreationTime
    [Object]$ModificationTime
    [Object]$User
    [Object]$Computer
    [Object]$WmiFilter    
    [GPType]$ComputerSettings
    [GPType]$UserSettings
    [Boolean]$isLinked
    	
	FullGPO([String]$GPOName,[String]$Domain=$env:USERDNSDOMAIN) {
		#Class Constructor - Initialize all of the functions of the GPO to be accessible at the first level.
        #HIDDEN VARS
		$this.GPO = get-gpo $GPOName -Domain $domain
        $this.TypeList = [GPType]::new("Computer"),[GPType]::new("User")
        $this.Name = $GPOName
		$this.Domain = $Domain
        $this.Links = New-Object System.Collections.ArrayList
        $this.Path = $this.GPO.Path

        #PUBLIC VARS
        $this.DisplayName = $this.GPO.DisplayName
        $this.DomainName = $this.GPO.DomainName
        $this.Owner = $this.GPO.Owner
        $this.ID = $this.GPO.ID
        $this.GPOStatus = $this.GPO.GpoStatus
        $this.Description = $this.GPO.Description
        $this.CreationTime = $this.GPO.CreationTime
        $this.ModificationTime = $this.GPO.ModificationTime
        $this.User = $this.GPO.User
        $this.Computer = $this.GPO.Computer
        $this.WmiFilter = $this.GPO.WmiFilter
        $this.isLinked = $false

        <#Get the links of the GPO, if any.#>
        $pathList = $this.Path.split(",")
        $pathString = ""
        foreach ($item in $pathList) {
            if (($item.contains("DC=")) -or ($item.contains("OU="))) {
                $pathString += "{0}," -f ($item)
            }
        }
        $pathString = $pathString.remove($pathString.length-1)        
        $linkList = Get-Gplink -path $pathString -domain $this.domainName
        foreach ($link in $linkList) {
            $currentGUID = $link.gpoID
            if ($currentGUID -eq $this.ID) {
                $this.isLinked = $true
                $this.Links += $link
            }
        }
        
        <#Get the GPO report and cast it as an XML object in memory,
        Then, place it in an array, based on Computer and User Policies.#>
		[XML]$xmlReport = Get-GPOReport -Guid $this.GPO.ID -domain $this.DomainName -ReportType XML;
        $XMLInfo = @($xmlReport.FirstChild.NextSibling.Computer,$xmlReport.FirstChild.NextSibling.User)
        
        <#Select the Policy Type to work over, then complete the necessary info inside the TypeList.
        Then, for each setting, get the name of the setting and their child nodes (this is a linked list); which will
        pull every single policy attached to it. The issue with this is that information does not perculate at the top,
        and must be called as part of a method alotted to the object. Upon completion, add it to the typelist.#>   
        for ($i = 0; $i -lt 2; $i++) {
            $typeInfo = $XMLInfo[$i]
            $this.TypeList[$i].setInfo($typeInfo.VersionDirectory,$typeInfo.VersionSysVol,$typeInfo.Enabled)          
            forEach ($Setting in $typeInfo.ExtensionData) {
                $SettingName = $Setting.Name
                $SettingData = $setting.FirstChild
                $SettingData.Attributes.RemoveAll()
                $this.TypeList[$i].addSetting($SettingName,$SettingData)                
            }
        }
        $this.ComputerSettings = $this.TypeList[0]
        $this.UserSettings = $this.TypeList[1]                      
	}
    [String] getGPO() {
        $returnString = "`n"
		$returnString += "`nDisplayName       : {0}" -f $this.DisplayName
		$returnString += "`nDomainName        : {0}" -f $this.DomainName
		$returnString += "`nOwnerName         : {0}" -f $this.Owner
		$returnString += "`nId                : {0}" -f $this.ID
		$returnString += "`nGpoStatus         : {0}" -f $this.GpoStatus
		$returnString += "`nDescription       : {0}" -f $this.Description
		$returnString += "`nCreationTime      : {0}" -f $this.CreationTime
		$returnString += "`nModificationTime  : {0}" -f $this.ModificationTime
		$returnString += "`nUserVersion       : AD Version: {0}, SysVol Version: {1}" -f ($this.User.DSVersion, $this.User.SysVolVersion)
		$returnString += "`nComputerVersion   : AD Version: {0}, SysVol Version: {1}" -f ($this.Computer.DSVersion, $this.Computer.SysVolVersion)
		$returnString += "`nWmiFilter         : {0}" -f $this.WmiFilter
		$returnString += "`nComputer Settings : {0} Settings" -f $this.TypeList[0].Settings.get_Count()
        $returnString += "`nUser Settings     : {0} Settings" -f $this.TypeList[1].Settings.get_Count()
        $returnString += "`n"
		return $returnString
    }
    [GPType[]] getSettings(){ 
        return $this.TypeList
    }
    [Object] getLinks() {
        if ($this.isLinked -eq $false) {
            return "No Links!"
        }
        else {
            return $this.Links
        }
    }
}

Function Get-FullGPO {
    param(
        [Parameter(Mandatory=$true)][String]$GPOName,
        [Parameter(Mandatory=$false)][String]$Domain=$env:USERDNSDOMAIN
    )
    return [FullGPO]::new($GPOName,$Domain)
}
