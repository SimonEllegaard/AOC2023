cd 'C:\Users\sela\OneDrive\Dokumenter\AoC\2023'

$inputFile = ".\aoc_day3.txt"

$lines = Get-Content $inputFile

# Part 1
$lineNumber = 0
$values = @();

#function to check for symbols
function checkSymbol($symbol) {
    return ($symbol -ne $null -and $symbol -ne '.')
}

#function to check for stars
function checkStar($symbol) {
    return ($symbol -eq '*')
}

#go through each line
foreach($line in $lines) {
    $id = 0
    #find all numbers
    $numbers = select-string '([\d]+)' -input $line -AllMatches | % matches | % Value
    
    #look up each index
    $indeces = @{}
    
    $remainder = $line
    foreach($number in $numbers) {
        $remainderStartIndex = $remainder.IndexOf($number)
        $remainderEndIndex = $remainderStartIndex + $number.Length
                
        $lineStartIndex = $remainderStartIndex + ($line.Length - $remainder.Length)
        $lineEndIndex = $lineStartIndex + $number.Length - 1

        #remove first part of line to find next occurence of number
        $remainder = $remainder.Substring($remainderEndIndex)
        $indeces.$id = @($lineStartIndex, $lineEndIndex, $number)
        $id += 1
    }
    #check any symbols adjacent to each number in line
    foreach($index in $indeces.GetEnumerator()) {
        $isNextToSymbol = $false
        #check above
        if($lineNumber -gt 0) {
            for($i = $index.Value[0]-1; $i -le $index.Value[1]+1; $i++) {
                if (checkSymbol $lines[$lineNumber-1][$i]) {
                    $isNextToSymbol = $true
                }
            }
        }
        #check below
        if($lineNumber -lt $lines.Count -1) {
            for($i = $index.Value[0]-1; $i -le $index.Value[1]+1; $i++) {
                if (checkSymbol $lines[$lineNumber+1][$i]) {
                    $isNextToSymbol = $true
                }
            }
        }
        #check left
        if (checkSymbol $line[$index.Value[0]-1]) {
            $isNextToSymbol = $true
        }
        #check right
        if (checkSymbol $line[$index.Value[1]+1]) {
            $isNextToSymbol = $true
        }
        if ($isNextToSymbol -eq $true) {
            $values += $index.Value[2]
        }
    }
    $lineNumber += 1
}
#Part 1
write ($values | measure -Sum).Sum


# Part 2
$lineNumber = 0
$values = @();
$starLocations = @{}

foreach($line in $lines) {
    $id = 0
    #find all numbers
    $numbers = select-string '([\d]+)' -input $line -AllMatches | % matches | % Value
    
    #look up each index
    $indeces = @{}
    
    $remainder = $line
    foreach($number in $numbers) {
        $remainderStartIndex = $remainder.IndexOf($number)
        $remainderEndIndex = $remainderStartIndex + $number.Length
                
        $lineStartIndex = $remainderStartIndex + ($line.Length - $remainder.Length)
        $lineEndIndex = $lineStartIndex + $number.Length - 1

        #remove first part of line to find next occurence of number
        $remainder = $remainder.Substring($remainderEndIndex)
        $indeces.$id = @($lineStartIndex, $lineEndIndex, $number)
        $id += 1
    }
    #check for stars adjacent to each number in line
    foreach($index in $indeces.GetEnumerator()) {
        
        #check above
        if($lineNumber -gt 0) {
            for($i = $index.Value[0]-1; $i -le $index.Value[1]+1; $i++) {
                if (checkStar $lines[$lineNumber-1][$i]) {
                    $starLine = $lineNumber-1
                    if($starLocations."$starLine,$i" -eq $null) {
                        $starLocations."$starLine,$i" = @($index.Value[2], $null)
                    }
                    else {
                        $otherNumber = $starLocations."$starLine,$i"[0]
                        $starLocations."$starLine,$i" = @($index.Value[2], $otherNumber)
                    }
                }
            }
        }
        #check below
        if($lineNumber -lt $lines.Count -1) {
            for($i = $index.Value[0]-1; $i -le $index.Value[1]+1; $i++) {
                if (checkStar $lines[$lineNumber+1][$i]) {
                    $starLine = $lineNumber+1
                    if($starLocations."$starLine,$i" -eq $null) {
                        $starLocations."$starLine,$i" = @($index.Value[2], $null)
                    }
                    else {
                        $otherNumber = $starLocations."$starLine,$i"[0]
                        $starLocations."$starLine,$i" = @($index.Value[2], $otherNumber)
                    }
                }
            }
        }
        #check left
        if (checkStar $line[$index.Value[0]-1]) {
            $starPosition = $index.Value[0]-1
            if($starLocations."$lineNumber,$starPosition" -eq $null) {
                $starLocations."$lineNumber,$starPosition" = @($index.Value[2], $null)
            }
            else {
                $otherNumber = $starLocations."$lineNumber,$starPosition"[0]
                $starLocations."$lineNumber,$starPosition" = @($index.Value[2], $otherNumber)
            }
        }
        #check right
        if (checkStar $line[$index.Value[1]+1]) {
            $starPosition = $index.Value[1]+1
            if($starLocations."$lineNumber,$starPosition" -eq $null) {
                $starLocations."$lineNumber,$starPosition" = @($index.Value[2], $null)
            }
            else {
                $otherNumber = $starLocations."$lineNumber,$starPosition"[0]
                $starLocations."$lineNumber,$starPosition" = @($index.Value[2], $otherNumber)
            }
        }
        #if next to star, store star location for later
    }
    $lineNumber += 1
}
#Part 2
$pairs = $starLocations.GetEnumerator() | where {$_.Value[1] -ne $null}
$gearRatios = $pairs | foreach {[int]$_.Value[0] * [int]$_.Value[1]}
write ($gearRatios | measure -Sum).Sum