# frozen_string_literal: true

# Shows a bunch of stars with flickering effect
class Starfield
  Star = Struct.new(:x, :y, :color, :size, :flicker_phase)
  Blast = Struct.new(:x, :y, :vx, :vy, :life, :color, :trail)

  attr_accessor :stars, :blasts, :blast_chance, :flicker_speed, :max_size

  def initialize(num_stars:, width:, height:, max_size: 3, flicker_speed: 0.1, blast_chance: 0.00005)
    @width = width
    @height = height
    @max_size = max_size
    @flicker_speed = flicker_speed
    @blast_chance = blast_chance
    @stars = Array.new(num_stars) { random_star }
    @blasts = []
  end

  def update
    # Flicker stars
    @stars.each do |star|
      star.flicker_phase += @flicker_speed
      # Random chance to spawn a blast from this star
      if rand < @blast_chance
        spawn_blast_from(star)
      end
    end

    # Update blasts
    @blasts.each do |blast|
      blast.trail.unshift([blast.x, blast.y])
      blast.trail.pop if blast.trail.size > 10
      blast.x += blast.vx
      blast.y += blast.vy
      blast.life -= 1
    end

    # Remove dead blasts
    @blasts.reject! { |b| b.life <= 0 }
  end

  def draw
    # Draw stars with flicker
    @stars.each do |star|
      brightness = (Math.sin(star.flicker_phase) * 0.5 + 0.5)
      color = Gosu::Color.rgb(
        (star.color.red   * brightness).to_i,
        (star.color.green * brightness).to_i,
        (star.color.blue  * brightness).to_i
      )
      Gosu.draw_rect(star.x, star.y, star.size, star.size, color, 0)
    end

    # Draw blasts with fading trails
    @blasts.each do |blast|
      blast.trail.each_with_index do |(tx, ty), i|
        alpha = 255 - (i * 25)
        trail_color = Gosu::Color.rgba(blast.color.red, blast.color.green, blast.color.blue, alpha)
        Gosu.draw_rect(tx, ty, 2, 2, trail_color, 0)
      end
    end
  end

  private

  def random_star
    Star.new(
      rand(@width),
      rand(@height),
      Gosu::Color.rgb(rand(256), rand(256), rand(256)),
      1 + rand(@max_size),
      rand * Math::PI * 2
    )
  end

  def spawn_blast_from(star)
    angle = rand * Math::PI * 2
    speed = 6 + rand * 4
    @blasts << Blast.new(
      star.x, star.y,
      Math.cos(angle) * speed,
      Math.sin(angle) * speed,
      30 + rand(20), # life in frames
      star.color.dup,
      []
    )
  end
end
