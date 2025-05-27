#Creates a object that accepts a string array; this allows the user to search strings via keywords via two methods: .getKeyword() and .containsKeyword().
#REQUIRES -Version 5.0
class KeywordList {
    [String[]]$Keywords

    KeywordList([String[]]$Keywords) {
        $this.Keywords = $Keywords
    }
    [Boolean]containsKeyword([String]$InputString) {
        try {
            if ($this.getKeyword($InputString)) {
                return $true
            }
            return $false
        }
        catch {
            return $false
        }
    }
    [Object]getKeyword([String]$InputString) {
        return ($this.Keywords | ? { $InputString -match $_ })
    }
}

#Create a KeywordList object; allows the user to access object initialization via cmdlet.
Function Create-KeywordList {
    param(
        [Parameter(Mandatory=$true)][String[]]$InputList
    )
    return [KeywordList]::new($InputList)
}
