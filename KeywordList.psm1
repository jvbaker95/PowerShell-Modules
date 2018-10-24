#Creates a object that accepts a string array; this allows the user to search strings via keywords via two methods: .getKeyword() and .containsKeyword().
#REQUIRES -Version 5.0
class KeywordList {
    [String[]]$Keywords

    KeywordList([String[]]$Keywords) {
        $this.Keywords = $Keywords
    }
    [Boolean]containsKeyword([String]$InputString) {
        return $null -ne ($this.Keywords | ? {$InputString -match $this._})
    }
    [String]getKeyword([String]$InputString) {
        return ($this.Keywords | ? { $InputString -match $_ })  # returns $true
    }
}

#Create a KeywordList object; allows the user to access object initialization via cmdlet.
Function Create-KeywordList {
    param(
        [Parameter(Mandatory=$true)][String[]]$InputList
    )
    return [KeywordList]::new($InputList)
}
