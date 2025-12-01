#!/usr/bin/env nu

# make a table out of the input file
# columns are: direction (R or L), steps (integer)
def parse_input [file: path] {
  open $file
    | lines
    | wrap raw
    | insert direction { |r| $r.raw | str substring 0..0}
    | insert steps { |r| $r.raw | str substring 1..-1 | into int }
    | reject raw
   
}
# calculates circular position given a value and limit
def circ [val: int, --limit (-l): int = 100] {
    (($val mod $limit) + $limit) mod $limit
}

# move the dial from start position by steps in given direction
# return new position and number of times zero was crossed
def move_dial [start: int, steps: int, direction: string, --limit (-l): int = 100] {
    let reminder = $steps mod $limit
    let full_loops = $steps // $limit
    
    let sign = if $direction == "R" { 1 } else { -1 }
    let new_pos = circ ($start + ($reminder * $sign)) --limit $limit

    let boundary_crossed = if $direction == "R" {
        ($start + $reminder) >= $limit
    } else {
        ($start - $reminder) <= 0 and $start > 0
    }
    {
        pos: $new_pos
        crossings: ($full_loops + (if $boundary_crossed { 1 } else { 0 }))
    }
}

def star2 [file] {
  let input = parse_input $file
  let result = ($input | reduce --fold {pos: 50, zeros: 0} { |r, acc|
      let res = move_dial $acc.pos $r.steps $r.direction --limit 100
      {
          pos: $res.pos
          zeros: ($res.crossings + $acc.zeros)
      }
  })
  print $result
}

def star1 [file] {
  let input = parse_input $file
  let result = ($input | reduce --fold {pos: 50, zeros: 0} { |r, acc|
    let new_pos = if $r.direction == "R" {
      circ ($acc.pos + $r.steps) --limit 100
    } else {
      circ ($acc.pos - $r.steps) --limit 100
    }
    {
      pos: $new_pos
      zeros: (if $new_pos == 0 { $acc.zeros + 1 } else { $acc.zeros })
    }
  })
  print $result
}

def main [file = "input.txt"] {
  star1 $file
  star2 $file
}

