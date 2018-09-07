#This is a function that will format any given array/arraylist into a List string (in Pythonic fashion).
Function Format-PyList {
    param ([Object[]]$InputObject) 
    for ($i = 0; $i -lt $InputObject.Count; $i++) {

        #If the array is nested, recurse until all elements are unpacked.
        if ($InputObject[$i].GetType().Name.equals("Object[]")) {
            $InputObject[$i] = $("'{0}'" -f (Format-PyList -InputObject $InputObject[$i]))
        }
        #If the elements are 1-dimensional, replace the current element with itself, wrapped in single-quotes.
        else {
            $InputObject[$i] = $("'{0}'" -f ($InputObject[$i]))
        }
    }

    #Wrap all of the elements in brackets, joined together using the C-Class String 'join' method.
    return $("[{0}]" -f ([String]::Join(",",$InputObject)))
}
