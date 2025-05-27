#This is a function that will format any given array/arraylist into a List string (in Pythonic fashion).
Function Format-PyList {
    param ([Object]$InputObject) 
    
    #Create a clone of the Input Object so nothing is done to the original input.
    #If the .Clone() Method doesn't work, the object is probably a number, so return that instead.
    try {
        $InputObject = $InputObject.Clone()
    }
    catch {
        Return $InputObject
    }

    if ($InputObject.GetType().Name.Equals("Object[]")) {
        for ($i = 0; $i -lt $InputObject.Count; $i++) {

            #If the array is nested, recurse until all elements are unpacked.
            if ($InputObject[$i].GetType().Name.equals("Object[]")) {
                $InputObject[$i] = $("{0}" -f (Format-PyList -InputObject $InputObject[$i]))
            }
            #If the elements are 1-dimensional and a string, replace the current element with itself, wrapped in single-quotes.
            else {
                if ($InputObject[$i].GetType().Name.equals("String")) {
                    $InputObject[$i] = $("'{0}'" -f ($InputObject[$i]))
                }
            }
        }

        #Wrap all of the elements in brackets, joined together using the C-Class String 'join' method.
        return $("[{0}]" -f ([String]::Join(",",$InputObject)))
    }
    return $InputObject
}
