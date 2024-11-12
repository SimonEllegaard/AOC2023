cd 'C:\Users\sela\OneDrive\Dokumenter\AoC\2023'

$inputFile = ".\aoc_day2.txt"

$lines = Get-Content $inputFile

# Part 1
$values = @();
foreach($line in $lines) {
    $line -match '(Game (\d+))' > $null
    $id = $matches[2]
    $setsString = $line.Substring(7+$id.Length)
    $sets = select-string '([^;]+;?\s?)' -input $setsString -AllMatches | % matches | % Value
    #write $id
    #write $sets
    $i = 0
    $possible = $true
    foreach($set in $sets) {
        $cubeCounts = select-string '([\d]+[\s\w]+)' -input $sets[$i] -AllMatches | % matches | % Value
        #write $cubes
        foreach($cubeCount in $cubeCounts) {
            $count = $cubeCount.split(' ')[0]
            $color = $cubeCount.split(' ')[1]
            if(
                ($color -eq 'red' -and [int]$count -gt 12) -or
                ($color -eq 'green' -and [int]$count -gt 13) -or 
                ($color -eq 'blue' -and [int]$count -gt 14)) {
                $possible = $false
            }
        }
        $i++
    }
    if($possible) {
        $values += $id
    }
}
write ($values | measure -Sum).Sum

# Part 2
$values = @();
foreach($line in $lines) {
    $line -match '(Game (\d+))' > $null
    $id = $matches[2]
    $setsString = $line.Substring(7+$id.Length)
    $sets = select-string '([^;]+;?\s?)' -input $setsString -AllMatches | % matches | % Value
    #write $id
    #write $sets
    $i = 0
    $minRed = 0
    $minGreen = 0
    $minBlue = 0
    foreach($set in $sets) {
        $cubeCounts = select-string '([\d]+[\s\w]+)' -input $sets[$i] -AllMatches | % matches | % Value
        #write $cubes
        foreach($cubeCount in $cubeCounts) {
            $count = $cubeCount.split(' ')[0]
            $color = $cubeCount.split(' ')[1]
            if($color -eq 'red' -and [int]$count -gt $minRed) {
                $minRed = $count
            }
            if($color -eq 'green' -and [int]$count -gt $minGreen) {
                $minGreen = $count
            }
            if($color -eq 'blue' -and [int]$count -gt $minBlue) {
                $minBlue = $count
            }
        }
        $i++
    }
    $values += [int]$minRed * [int]$minGreen * [int]$minBlue
}
write ($values | measure -Sum).Sum