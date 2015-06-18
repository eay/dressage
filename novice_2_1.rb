#!/usr/bin/env ruby
#
require_relative 'arena'

Arena.generate("n_2_1.pdf") do
  big_letters :A, :X
  text "\"A\"\nEnter in working trot"
  text "\"X\"\nHalt, Salute"
  text 'Proceed in working trot'

  track :A, :st, [:X, :L], :"arrow90+2"
  track :X, :st, :G, :"arrow90+2"
  render_number(1)

  big_letters :E, :B, :C, :X
  text "\"C\"\nTrack left"
  text "\"EX\"\nHalf circle left 10m"
  text "\"XB\"\nHalf circle right 10m"
  track [:G, :C], :tl, :H, :st, :E, :"cc10-180-0", :X, "cw10-180-0", :B, :"arrow270+3"
  track :light, :B, :st, :F, :rb, :A, :bl, :K, :"arrow90+1"
  render_number(2)

  big_letters :C, :M, :X, :K
  text "\"KXM\" Lengthen stride in trot"
  text "\"MC\" Working trot'"
  track :K, :st, :M, :rt, :arrow180
  render_number(3)

  big_letters :C
  text "\"C\"\nCircle left 20m rising trot, allowing the horse to stretch forward and downward"
  text "\"Before C\"\nShorten the reins"
  text "\"C\"\nWorking trot"
  # [:cc, radius, direction to centre, start_angle, finish_angle
  track :C, :"cc20-90-70", :C, :"arrow160-1"
  render_number(4)

  big_letters :C, :H
  text "\"Between C&H\"\nMedium Walk"
  render_number(5)

  big_letters :H, :P, :F
  text "\"HP\"\nFree walk on a long rein"
  text "\"PF\"\nMedium walk"
  track :H, :st, :P, :st, [:P, :F], :"arrow180+4"
  render_number(6)

  big_letters :F, :A
  text "\"F\"\nWorking trot"
  text "\"A\"\nWorking canter right lead"
  render_number(7)

  big_letters :E
  text "\"E\"\nCircle right 15m"
  render_number(8)

  big_letters :M, :P, :A
  text "\"MP\"\nLengthen stride in canter"
  text "\"Between P&A\"\nDevelop working canter"
  render_number(9)

  big_letters :K, :X, :M
  text "\"KXM\"\nChange rein"
  text "\"X\"\nWorking trot"
  render_number(10)

  big_letters :C
  text "\"C\"\nWorking canter left lead"
  render_number(11)

  big_letters :E
  text "\"E\"\nCircle left 15m"
  render_number(12)

  big_letters :C, :R, :F
  text "\"FR\"\nLength stride in canter"
  text "\"Between R&C\"\nDevelop working canter"
  render_number(13)

  big_letters :C
  text "\"C\"\nWorking trot"
  render_number(14)

  big_letters :H, :X, :F, :A
  text "\"HXF\"\nLengthen stride in trot"
  text "\"FA\"\nWorking trot"
  render_number(15)

  big_letters :X, :A
  text "\"A\"\nDown centreline"
  text "\"X\"\nHalt, Salute"
  render_number(16)
end


