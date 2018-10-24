class KeywordList {
    [String[]]$Keywords

    KeywordList([String[]]$Keywords) {
        $this.Keywords = $Keywords
    }
    [Boolean]containsKeyword([String]$InputString) {
        return $null -ne ($this.Keywords | ? {$InputString -match $this._})
    }
    [Object]getKeyword([String]$InputString) {
        return ($this.Keywords | ? { $InputString -match $_ })  # returns $true
    }
}

Function Create-KeywordList {
    param(
        [Parameter(Mandatory=$true)][String[]]$InputList
    )
    return [KeywordList]::new($InputList)
}
