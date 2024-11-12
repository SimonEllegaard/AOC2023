cd 'C:\Users\sela\OneDrive\Dokumenter\AoC\2023'

$inputFile = ".\aoc_day1.txt"

$lines = Get-Content $inputFile

# Part 1
$values = @(0);
foreach($line in $lines) {
    $numbers = select-string '(\d)' -input $line -AllMatches | % matches | % Value
    $first = $numbers[0]
    $last = $numbers[$numbers.Count - 1]
    $values += ($first + $last)
}
write ($values | measure -Sum).Sum


# Part 2
$values = @(0);
foreach($line in $lines) {
    #write ('line: ' + $line)
    $numbers = select-string '(\d|oneight|twone|threeight|fiveight|sevenine|eightwo|eighthree|nineight|one|two|three|four|five|six|seven|eight|nine)' -input $line -AllMatches | % matches | % Value
    #write ('numbers (raw):')
    #write $numbers
    $i = 0
    foreach($number in $numbers) {
        if($number -notmatch '(\d)') {
            switch($number) {
                'one' {$numbers[$i] = 1} 
                'two' {$numbers[$i] = 2}
                'three' {$numbers[$i] = 3}
                'four' {$numbers[$i] = 4}
                'five' {$numbers[$i] = 5}
                'six' {$numbers[$i] = 6}
                'seven' {$numbers[$i] = 7}
                'eight' {$numbers[$i] = 8}
                'nine' {$numbers[$i] = 9}
            }
            if($i -eq 0) {
                switch($number) {
                    'oneight' {$numbers[$i] = 1} 
                    'twone' {$numbers[$i] = 2} 
                    'threeight' {$numbers[$i] = 3} 
                    'fiveight' {$numbers[$i] = 5} 
                    'sevenine' {$numbers[$i] = 7} 
                    'eightwo' {$numbers[$i] = 8} 
                    'eighthree' {$numbers[$i] = 8} 
                    'nineight' {$numbers[$i] = 9} 
                }
            }
            else {
                switch($number) {
                    'oneight' {$numbers[$i] = 8} 
                    'twone' {$numbers[$i] = 1} 
                    'threeight' {$numbers[$i] = 8} 
                    'fiveight' {$numbers[$i] = 8} 
                    'sevenine' {$numbers[$i] = 9} 
                    'eightwo' {$numbers[$i] = 2} 
                    'eighthree' {$numbers[$i] = 3} 
                    'nineight' {$numbers[$i] = 8} 
                }
            }
        }
        $i++
    }
    #write ('numbers (converted):')
    #write $numbers
    $first = $numbers[0]
    $last = $numbers[$numbers.Count - 1]
    $values += ([string]$first +[string]$last)
    #write ('first: ' + $first)
    #write ('last: ' + $last)
    #write ('values' + $values)
}write ($values[1..$values.Length] | measure -Sum).Sum