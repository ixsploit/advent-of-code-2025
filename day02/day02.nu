#!/usr/bin/env nu


def parse_input [file: path]: nothing -> table {
  (open $file 
    | split row "," 
    | split column "-" 
    | rename start end
    | into int start end)
}

def check_invalid1 [id: string] {
  let chars = ($id | split chars)
  let len = ($chars | length)
  
  if ($len mod 2) != 0 {
    return false
  }
  let half = $len // 2
  let first_part = ($chars | first $half)
  let second_part = ($chars | last $half)
  $first_part == $second_part
}

def check_invalid2 [id: string] {
  let str_len = ($id | str length)

  for step in 0..(($str_len // 2) - 1) {
    #string needs to be dividable by the potential parts
    #otherwise it can't be a repetition
    let width = $step + 1
    if ($str_len mod $width) != 0 {
      continue
    }
    let start = ($id | str substring 0..$step)
    mut is_valid = true
    for y in ($width..$width..($str_len - 1)) {
      $is_valid = true
      let part = ($id | str substring $y..($y + $step))
      print $"Start: ($start) Part:  ($part)"
      print $"Width: ($width) Y: ($y) Step: ($step) Str_len: ($str_len)"
      if $part != $start {
        $is_valid = false
        break
      }
    }
    print $is_valid
    if $is_valid {
      return true
    }
  }
  return false
}

def count_invalid [input: table] {
  mut current = $input.start 
  let end = $input.end 
  mut total = 0
  for row in $input {
    mut current = $row.start 
    while $current <= $row.end {
      if (check_invalid2 ($current | into string)) {
        print $current
        $total += $current 
      }
      $current += 1
    }
  }
  $total
}


def star1 [file: path] {
  let input = parse_input $file
  print (count_invalid $input)
}

def star2 [file: path] {
  let input = parse_input $file
  print (count_invalid $input)
}

def main [file: path = input.txt] {
  check_invalid2 1010
  # star1 $file
  #star2 $file

}
