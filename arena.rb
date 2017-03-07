#!/usr/bin/env ruby
#
require 'prawn'
require 'prawn/measurement_extensions'

class Arena
  require_relative 'Arc'
#  include Arc

  PAGE_SIZE = "A4"

  module Color
    CREAM       = "ffffcc"
    CHESTNUT    = "954535"
    BLACK       = "000000"
    GRAY        = "888888"
    RED         = "c40233"
    DESERT_SAND = "edc9af"
    BUFF        = "f0dc82"
    LIGHT_YELLOW= "ffffe0"
    ORANGE      = "ff8c00"
    DARK_BLUE   = "0000ff"
    LIGHT_BLUE  = "a0a0ff"

    ARENA       = BUFF
    ARROW       = ORANGE
    LINE        = DARK_BLUE
    LINE2       = LIGHT_BLUE
  end

  BOX_WIDTH  = 44.mm
  BOX_HEIGHT = 54.mm
  BOX_CURVE  =  3.mm

  TOP  = [23.mm, -4.mm]
  WIDTH = 17.mm
  DEPTH = 46.mm

  TEXT_WIDTH  = 20.mm
  TEXT_HEIGHT = 44.mm

  ITOP  = [24.mm, -5.mm]
  IX    = ITOP[0]
  IY    = ITOP[1]
  IWIDTH = 15.mm
  IDEPTH = 44.mm

  C = [ IX + IWIDTH/2,  IY,                          :up, :bl ]
  G = [ IX + IWIDTH/2,  IY - 4.mm - 9.mm * 0,        :ct, :gr ]
  I = [ IX + IWIDTH/2,  IY - 4.mm - 9.mm * 1,        :ct, :gr ]
  X = [ IX + IWIDTH/2,  IY - 4.mm - 9.mm * 2,        :ct, :gr ]
  L = [ IX + IWIDTH/2,  IY - 4.mm - 9.mm * 3,        :ct, :gr ]
  D = [ IX + IWIDTH/2,  IY - 4.mm - 9.mm * 4,        :ct, :gr ]
  A = [ IX + IWIDTH/2,  IY - 4.mm - 9.mm * 4 - 4.mm, :dn, :bl ]

  H = [ IX,             IY - 4.mm - 9.mm * 0,        :lf, :br ]
  S = [ IX,             IY - 4.mm - 9.mm * 1,        :lf, :br ]
  E = [ IX,             IY - 4.mm - 9.mm * 2,        :lf, :br ]
  V = [ IX,             IY - 4.mm - 9.mm * 3,        :lf, :br ]
  K = [ IX,             IY - 4.mm - 9.mm * 4,        :lf, :br ]

  M = [ IX + IWIDTH,    IY - 4.mm - 9.mm * 0,        :rt, :br ]
  R = [ IX + IWIDTH,    IY - 4.mm - 9.mm * 1,        :rt, :br ]
  B = [ IX + IWIDTH,    IY - 4.mm - 9.mm * 2,        :rt, :br ]
  P = [ IX + IWIDTH,    IY - 4.mm - 9.mm * 3,        :rt, :br ]
  F = [ IX + IWIDTH,    IY - 4.mm - 9.mm * 4,        :rt, :br ]

  LETTERS = {
    :C => C, :G => G, :I => I, :X => X, :L => L, :D => D, :A => A,
    :H => H, :S => S, :E => E, :V => V, :K => K, :M => M, :R => R,
    :B => B, :P => P, :F => F,
  }

  CORNER = {
    :tl => [C, H, :m, :cc],
    :tr => [C, M, :m, :cw],
    :lt => [H, C, :cw, :m],
    :rt => [M, C, :cc, :m],
    :bl => [A, K, :m, :cw],
    :br => [A, F, :m, :cc],
    :lb => [K, A, :cc, :m],
    :rb => [F, A, :cw, :m],
  }

  attr_reader :pdf
  attr_accessor :number
  attr_accessor :big_leters

  def m_to_mm(num)
    IWIDTH/20 * num
  end

  def text(*a)
    @text << a
  end

  def big_letters(*a)
    @big_letters = a
  end

  def render_number(n = nil)
    @number = n if n
    xo, yo = 12.mm, 257.mm
    xo += ((@number-1) % 4) * (BOX_WIDTH + 1.mm)
    yo -= ((@number-1) / 4) * (BOX_HEIGHT + 1.mm)

    render(xo,yo)
  end

  def initialize(pdf)
    @pdf = pdf
    @text = []
    @tracks = []
  end

  def self.generate(name,&block)
    if Prawn::Document === name
      n = new(name)
      n.instance_eval(&block) if block
    else
      Prawn::Document.generate(name,
                               :page_size => PAGE_SIZE) do |pdf|
        n = new(pdf)
        n.instance_eval(&block) if block
      end
    end
  end

  def track(*a)
    @tracks << a
  end

  def draw_outer
    step = 0.8.mm
    step_in_gap = 0.20.mm
    @pdf.move_to A[0] - 0.5.mm, A[1]
    @pdf.line_to A[0] - 0.5.mm, A[1] - 1.mm
    # Bottom Right
    @pdf.line_to K[0] - 1.0.mm, A[1] - 1.mm
    [K, V, E, S, H].each do |x,y,t,c|
      @pdf.line_to x - 1.0.mm, y - step
      @pdf.line_to x - step_in_gap, y
      @pdf.line_to x - 1.0.mm, y + step
    end
    # Top Left
    @pdf.line_to H[0] - 1.mm, C[1] + 1.mm
    [C].each do |x,y,t,c|
      @pdf.line_to x - step, y + 1.mm
      @pdf.line_to x,          y + step_in_gap
      @pdf.line_to x + step, y + 1.mm
    end
    # Top Right
    @pdf.line_to M[0] + 1.mm, C[1] + 1.mm
    [M, R, B, P, F].each do |x,y,t,c|
      @pdf.line_to x + 1.mm, y + step
      @pdf.line_to x + step_in_gap, y
      @pdf.line_to x + 1.mm, y - step
    end

    # Bottom Right
    @pdf.line_to F[0] + 1.mm, A[1] - 1.mm
    @pdf.line_to A[0] + 0.5.mm, A[1] - 1.mm
    @pdf.line_to A[0] + 0.5.mm, A[1]
    @pdf.line_to A[0] - 0.5.mm, A[1]
  end

  # Draw the arrow
  def render_arrow(x, y, angle, y_off: 0)
    @pdf.line_width = 0.1.pt
    @pdf.undash
    @pdf.translate(x, y) do
      @pdf.rotate(angle - 90, :origin => [0,0]) do
        @pdf.move_to 0.mm, 0.mm + y_off
        @pdf.line_to 1.mm, -3.mm + y_off
        @pdf.line_to -1.mm, -3.mm + y_off
        @pdf.line_to 0.mm, 0.mm + y_off
        @pdf.fill_color Color::ARROW
        @pdf.fill

        @pdf.move_to 0.mm, 0.mm + y_off
        @pdf.line_to 1.mm, -3.mm + y_off
        @pdf.line_to -1.mm, -3.mm + y_off
        @pdf.line_to 0.mm, 0.mm + y_off
        @pdf.stroke_color Color::BLACK
        @pdf.stroke
      end
    end
  end

  def get_location(arg)
    ret = case arg
    when Array
      g = arg.map {|a| LETTERS[a]}
      raise "bad letter #{arg.inspect}" if g.find_index nil
      r = g.reduce {|a,b| [a[0]+b[0],a[1]+b[1]] }
      [r[0]/arg.length, r[1]/arg.length]
    when Symbol
      r = LETTERS[arg]
      raise "bad letter #{arg}" unless r
      r
    else
      raise "bad value"
    end
    ret
  end

  def render_tracks
    @tracks.reverse.each do |tr|
      line_color = Color::LINE
      t = tr.dup
      line = false
      curve = {r: 0, sa: 0, ea: 0, x: 0, y: 0}
      x, y = 0, 0

      t.each do |cmd|
        puts "<<#{cmd}>>"
        case
        when LETTERS[cmd] || Array === cmd
          lx, ly = x, y
          x, y = get_location(cmd)
          case line
          when :st
            @pdf.line_to x, y
          when :curve
            arc(pdf, curve[:x], curve[:y],
                     curve[:r],
                     curve[:sa], curve[:ea])
          else
            @pdf.move_to x, y
          end
        when m = cmd.to_s.match(/^c(c|w)(\d+)-(\d+)-(\d+)$/)
          clock_wise = m[1] == 'w'
          line = :curve
          curve[:r] = m_to_mm(m[2].to_i)/2.0
          curve[:sa] = m[3].to_i
          curve[:ea] = m[4].to_i
          curve[:sa], curve[:ea] = curve[:ea], curve[:sa] if clock_wise
#          aangle = curve[:sa] + (clock_wise ? -90 : 90)
#          aangle = curve[:ea] + (clock_wise ? -90 : 90)
          aangle = curve[:sa]
          aangle += 180 unless clock_wise
          curve[:x], curve[:y] = Arc.centre(aangle, curve[:r])
          curve[:x] += x
          curve[:y] += y
        when cmd == :st
          line = :st
        when m = cmd.to_s.match(/^arrow(\d+)([+-]\d)?$/)
          if line
            @pdf.line_width = 0.8.mm
            @pdf.dash [2.mm, 1.mm], :phase => 2.mm
            @pdf.stroke_color line_color
            @pdf.stroke
            line = nil
          end

          if m[2]
            ao = m[2].to_i.mm
          else
            ao = 0
          end
          render_arrow(x, y, m[1].to_i, y_off: ao)
        when cmd == :light
          line_color = Color::LINE2
        when a = CORNER[cmd]
          puts "#{cmd.to_s}: #{a}"
          if a[2] == :m
            dx = (a[0][0] - a[1][0]) / 2
            mid = [a[0][0] - dx, a[0][1]]
            @pdf.line_to mid
            @pdf.curve_to a[1], :bounds => [
              [a[1][0], a[0][1]],
              [a[1][0], a[0][1]]]
          else
            dx = (a[0][0] - a[1][0]) / 2
            mid = [a[1][0] + dx, a[1][1]]
            @pdf.curve_to mid, :bounds => [
              [a[1][0], a[0][1]],
              [a[1][0], a[0][1]]]
            @pdf.line_to a[1]
          end

          x, y = a[1]
        when :cw90
        else
          raise "unknown track command: #{cmd}"
        end
      end
    end
    @tracks = []
  end

  def write_the_leters
    #  F = [ IX + IWIDTH,    IY - 4.mm - 9.mm * 4,        :lf, :br ]
    if @big_letters
      mod = @big_letters.map {|a| a.to_sym}.reduce({}) {|a,c| a[c] = true; a}
    else
      mod = {}
    end
    LETTERS.each_key do |k|
      x, y, loc, color = LETTERS[k]
      case color
      when :br
        @pdf.fill_color Color::CHESTNUT
        size = 7
      when :bl
        @pdf.fill_color Color::BLACK
        size = 10
      when :gr
        @pdf.fill_color Color::GRAY
        size = 5
      else
        raise "unknown color #{color}"
      end

      if mod[k]
        @pdf.fill_color Color::RED
        size = 12
      end

      case loc
      when :up
        xo, yo = -2.mm, 5.mm
      when :dn
        xo, yo = -2.mm, -0.75.mm
      when :lf
        xo, yo = -4.5.mm, 2.mm
        xo -= 0.5.mm if mod[k]
      when :rt
        xo, yo =  0.5.mm,    2.mm
        xo += 0.5.mm if mod[k]
      when :ct
        xo, yo = -2.mm, 2.mm
      else
        raise "unknown location: #{loc}"
      end
      @pdf.bounding_box([x + xo, y + yo], :width => 4.mm, :height => 4.mm) do
        @pdf.font_size(size) do
          @pdf.text k.to_s, :valign => :center, :align => :center
#          @pdf.stroke_bounds
        end
      end
    end
  end

  def render(x = 0, y = BOX_HEIGHT)
    sc = @pdf.stroke_color
    @pdf.translate(x, y) do
      @pdf.float do
        @pdf.line_width = 0.01.pt
        @pdf.rounded_rectangle [0, 0], BOX_WIDTH, BOX_HEIGHT, BOX_CURVE
        @pdf.stroke

        if @number
          @pdf.rectangle [5.mm, -1.mm], 6.mm, 5.mm
          @pdf.fill_color Color::DESERT_SAND
          @pdf.fill

          @pdf.fill_color Color::BLACK
          @pdf.bounding_box([5.mm, -1.mm], :width => 6.mm, :height => 5.mm) do
            @pdf.font_size(12) do
              @pdf.text @number.to_s, :valign => :center, :align => :center
              @pdf.stroke_color Color::RED
              @pdf.stroke_bounds
            end
          end
        end

        t = [@text].flatten
        if t.length > 0
          @pdf.fill_color Color::BLACK
          @pdf.font_size 10
          @pdf.text_box t.join("\n\n"),
                        :at => [0.5.mm, -7.mm],
                        :width => TEXT_WIDTH, :height => TEXT_HEIGHT,
                        :valign => :center,
                        :align => :center,
                        :overflow => :shrink_to_fit
          @text = []
        end

      end
      @pdf.float do
        tl = ITOP
        width = WIDTH
        depth = DEPTH
        @pdf.line_width = 0.01.pt

        # Draw the fences
        draw_outer
        @pdf.fill_color Color::DESERT_SAND
        @pdf.fill
        draw_outer
        @pdf.stroke_color Color::BLACK
        @pdf.stroke

        # Draw the arena
        @pdf.rectangle ITOP, IWIDTH, IDEPTH 
        @pdf.fill_color Color::ARENA
        @pdf.fill

        @pdf.rectangle ITOP, IWIDTH, IDEPTH 
        @pdf.stroke_color Color::RED
        @pdf.stroke

        @pdf.move_to C
        @pdf.line_to A
        @pdf.stroke

        @pdf.dash [1.pt,1.pt]
        [[H,M], [S,R], [E,B], [V,P], [K,F]].each do |a,b|
          @pdf.move_to a
          @pdf.line_to b
          @pdf.stroke
        end

        render_tracks
        write_the_leters

      end
    end
    @pdf.stroke_color = sc
  end

  def self.circle(pdf, x, y, radius, direction)
    pdf.move_to x, y
    pdf.curve_to [x + radius, y + radius],
                 :bounds => [[x + radius * Arc::MAGIC, y],
                             [x + radius, y + radius * (1-Arc::MAGIC)]]
    pdf.curve_to [x, y + radius*2],
                 :bounds => [[x + radius, y + radius * (1+Arc::MAGIC)],
                             [x + radius * Arc::MAGIC, y + radius*2]]
    pdf.curve_to [x - radius, y + radius],
                 :bounds => [[x - radius * Arc::MAGIC, y + radius*2],
                             [x - radius, y + radius * (1+Arc::MAGIC)]]
    pdf.curve_to [x, y],
                 :bounds => [[x - radius, y + radius * (1-Arc::MAGIC)],
                             [x - radius * Arc::MAGIC, y]]
    pdf.stroke

    pdf.stroke_color "ff0000"
    pdf.circle [x, y+radius], 50.mm
    pdf.stroke
  end

  def arc(pdf, x, y, r, start_angle, end_angle)
    a = Arc.arc_points(r, start_angle, end_angle, :offset => [x, y])
    a.each_with_index do |c,i|
      pdf.move_to c[0] if i == 0
      pdf.curve_to c[3], :bounds => [c[1], c[2]]
    end
  end

end

if __FILE__ == $0
  Prawn::Document.generate("hello.pdf",
                           :page_size => Arena::PAGE_SIZE) do |pdf|
    a = Arena.generate(pdf) do
      big_letters :A, :X
      text << '"A" Enter in working trot'
      text << '"X" Halt, Salute'
      text << 'Proceed in working trot'
      render_number(1)
    end
    pdf.move_to 10.mm, 100.mm
    pdf.curve_to [60.mm, 50.mm], :bounds => [[10.mm, 50.mm], [10.mm, 50.mm]]
    pdf.move_to 10.mm, 100.mm
    pdf.curve_to [60.mm, 50.mm], :bounds => [[60.mm, 100.mm], [60.mm, 100.mm]]

    pdf.move_to 10.mm, 100.mm
    pdf.curve_to [60.mm, 50.mm], :bounds => [[35.mm, 100.mm], [60.mm, 75.mm]]

    pdf.rectangle [10.mm, 100.mm], 50.mm, 50.mm
    pdf.stroke

    pdf.rectangle [100.mm, 150.mm], 50.mm, 50.mm
    pdf.stroke

    pdf.stroke_color "0000ff"
    Arena.circle pdf, 100.mm, 100.mm, 50.mm, 0
    pdf.stroke

    pdf.circle [75.mm, 75.mm], 71.mm
    pdf.stroke
    pdf.stroke_color "00f0f0"
    a = Arc.arc_points(70.mm, 0, 90+45, :offset => [75.mm, 75.mm])
    a.each do |c|
      pdf.move_to [75.mm,75.mm]
      pdf.line_to c[0]
      pdf.line_to c[3]
      pdf.line_to [75.mm,75.mm]
#      pdf.move_to c[0]
#      pdf.curve_to c[3], :bounds => [c[1], c[2]]
    end
    pdf.stroke
    pdf.stroke_color "000ff0"

    first = true
    a.each_with_index do |c,i|
      pdf.move_to c[0] if i == 0
      pdf.curve_to c[3], :bounds => [c[1], c[2]]
    end
    pdf.stroke

  end
end
