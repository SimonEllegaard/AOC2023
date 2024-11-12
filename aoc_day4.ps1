cd 'C:\Users\sela\OneDrive\Dokumenter\AoC\2023'

$inputFile = ".\aoc_day4.txt"

$lines = Get-Content $inputFile

# Part 1
$values = @();
foreach($line in $lines) {
    $values += $line
}
write $values