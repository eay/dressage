#!/usr/bin/env ruby
#
require_relative 'arena'

Arena.generate("pc_1.pdf") do
  big_letters :A, :X, :C
  text "\"A\"\nEnter working trot"
  text "\"X\"\nHalt, Salute, Proceed working trot"
  text "\"C\"\nTrack right"
  render_number(1)

  big_letters :M, :X, :K
  text "\"MXK\"\nChange rein over fence #1. Return to working trot after jump"
  render_number(2)

  big_letters :A
  text "\"A\"\n20m circle left"
  render_number(3)

  big_letters :F
  text "\"Before F\"\nTurn on line to jump #2. Return to working trot after jump and proceed toward M"
  render_number(4)

  big_letters :C
  text "\"C\"\nMedium Walk"
  render_number(5)

  big_letters :H, :B
  text "\"HB\"\nFree walk"
  text "\"B\"\nMedium walk"
  render_number(6)

  big_letters :F
  text "\"F\"\nWorking trot"
  render_number(7)

  big_letters :A, :K
  text "\"Between A&K\"\nWorking canter right lead"
  render_number(8)

  big_letters :K, :X, :M
  text "\"KXM\"\nChange rein over Jump #1, land in working canter"
  render_number(9)

  big_letters :M
  text "\"M\"\nWorking trot"
  render_number(10)

  big_letters :C, :H
  text "\"Between C&H\"\nWorking canter left lead"
  render_number(11)

  big_letters :E
  text "\"E\"\nCircle 1/2 circle left over Jump #2. After jump, proceed straight ahead"
  render_number(12)

  big_letters :M
  text "\"Opp. M\"\nWorking trot"
  render_number(13)

  big_letters :C
  text "\"C\"\nCircle 20m, leting the horse grtadually chew the reins out of the hand at working trot rising"
  text "\"Before C\"\nGradually take up the reins"
  text "\"C\"\nStraight ahead"
  render_number(14)

  big_letters :H, :X, :F
  text "\"HXF\"\nChange rein over Jump #3. Return to working trot before F"
  render_number(15)

  big_letters :A, :X
  text "\"A\"\nDown centerline"
  text "\"X\"\nHalt throughout the walk. Salute. Leave arena at free walk on a loose rein"
  render_number(16)

end


