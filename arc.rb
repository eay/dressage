module Arc

# Generate the bezier points needed to draw a cicle arc, taken from
# http://hansmuller-flex.blogspot.com.au/2011/04/approximating-circular-arc-with-cubic.html

  # Works for 90 degrees
  MAGIC = 4.0/3.0 * (Math::sqrt(2) -1)

  # transform the points around the origin by the angle
  def self.rotate(angle, points)
    a = Math::PI * angle / 180.0
    c = Math::cos(a)
    s = Math::sin(a)

    points = [points] unless Array === points[0]
    points.map do |x,y|
      [c * x + -s * y, s * x + c * y]
    end
  end

  # Return an array of 4 point pairs, the radius is the origin.
  # They will be suitable for putting into bezier curve algorithms
  def self.arc_points(radius, start_angle, end_angle, offset: [0,0])
    curves = []
    quarter = [[radius,         0],
               [radius,         radius * MAGIC],
               [radius * MAGIC, radius],
               [0,              radius]]

    end_angle += 360 while start_angle > end_angle
    angle = end_angle - start_angle

    # The < 90 degree arc
    arc = (angle % 90)
    a = Math::PI * arc / 180.0
    c = Math.cos(a/2)
    s = Math.sin(a/2)
    t = 4.0/3.0 * (1 - c)/s
    x4 = radius * c
    y4 = radius * s
    x1 = x4
    y1 = -y4

    x2 = x1 + t * y4
    y2 = y1 + t * x4
    x3 = x2
    y3 = -y2
    arc_points = [[x1,y1], [x2,y2], [x3,y3], [x4,y4]]
    # arc_points needs to be rotated arc/2 to get it onto the origin

    curves << rotate(start_angle + arc * 0.5, arc_points)
    rot = start_angle + arc
    (angle / 90).floor.times do
      curves << rotate(rot, quarter)
      rot += 90
    end

    curves.map do |c|
      c.map do |x,y|
        [x + offset[0], y + offset[1]]
      end
    end
  end

end
