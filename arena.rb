#!/usr/bin/env ruby
#
require 'pry'
require 'prawn'
require 'prawn/measurement_extensions'

class Arena

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

    ARENA       = BUFF
    ARROW       = ORANGE
    LINE        = DARK_BLUE
    LINE2       = DARK_BLUE
  end

  BOX_WIDTH  = 44.mm
  BOX_HEIGHT = 54.mm
  BOX_CURVE  =  3.mm

  TOP  = [21.mm, -4.mm]
  WIDTH = 17.mm
  DEPTH = 46.mm


  ITOP  = [22.mm, -5.mm]
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

  attr_reader :pdf
  attr_accessor :number
  attr_accessor :big_leters

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
      Prawn::Document.generate(name) do |pdf|
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
      @pdf.rotate(angle, :origin => [0,0]) do
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
    @tracks.each do |tr|
      t = tr.dup
      line = false
      x, y = 0, 0

      t.each do |cmd|
        case
        when LETTERS[cmd] || Array === cmd
          x, y = get_location(cmd)
          case line
          when :st
            @pdf.line_to x, y
          when :cc
          when :cw
          else
            @pdf.move_to x, y
          end
        when m = cmd.to_s.match(/^cc(\d+)$/)
          line = :cc
        when m = cmd.to_s.match(/^cw(\d+)$/)
          line = :cw
        when cmd == :st
          line = :st
        when m = cmd.to_s.match(/^arrow(\d+)([+-]\d)?$/)
          if line
            @pdf.line_width = 0.8.mm
            @pdf.dash [2.mm, 1.mm], :phase => 2.mm
            @pdf.stroke_color Color::LINE
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
        xo, yo = -2.mm, -1.mm
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
                        :width => 18.mm,:height => 44.mm,
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

        write_the_leters
        render_tracks

      end
    end
    @pdf.stroke_color = sc
  end
end

if __FILE__ == $0
  Prawn::Document.generate("/tmp/hello.pdf") do |pdf|
    a = Arena.generate(pdf) do
      big_letters :A, :X
      text << '"A" Enter in working trot'
      text << '"X" Halt, Salute'
      text << 'Proceed in working trot'
      render_number(1)
    end
  end
end
