# 🎮 Mini Guide: Gosu Game Dev in Ruby

# Tech stack:
- **Ruby**: Ruby is a general-purpose programming language. It was designed with an emphasis on programming productivity and simplicity. 
- **Gosu**: Gosu is a 2D game development library for Ruby and C++ that provides a lightweight engine with features for creating 2D games.

## Intro 👋

## 1. Setup
- Install Ruby (2.7+ recommended).
- Install Gosu gem:
  ```bash
  gem install gosu
  ```

## 2. Basic Game Window
Every Gosu game starts with a `Gosu::Window` subclass.

```ruby
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "My First Gosu Game"
  end

  def update
    # Game logic goes here (movement, collisions, etc.)
  end

  def draw
    # Rendering goes here (sprites, text, shapes)
  end
end

GameWindow.new.show
```

---

## 3. Drawing Shapes & Text
```ruby
def draw
  Gosu.draw_rect(100, 100, 50, 50, Gosu::Color::RED)   # square
  font = Gosu::Font.new(20)
  font.draw_text("Hello Gosu!", 200, 200, 1, 1.0, 1.0, Gosu::Color::WHITE)
end
```

---

## 4. Sprites & Images
```ruby
def initialize
  super 640, 480
  @player = Gosu::Image.new("player.png")
  @x = @y = 200
end

def draw
  @player.draw(@x, @y, 1)
end
```

---

## 5. Input Handling
```ruby
def update
  @x -= 5 if Gosu.button_down?(Gosu::KB_LEFT)
  @x += 5 if Gosu.button_down?(Gosu::KB_RIGHT)
  @y -= 5 if Gosu.button_down?(Gosu::KB_UP)
  @y += 5 if Gosu.button_down?(Gosu::KB_DOWN)
end
```

---

## 6. Sounds & Music
```ruby
def initialize
  super 640, 480
  @beep = Gosu::Sample.new("beep.wav")
end

def button_down(id)
  @beep.play if id == Gosu::KB_SPACE
end
```

---

## 7. Structuring Your Game
- **Entities**: Make small classes for Player, Enemy, Bullet, etc.
- **Helpers**: Write parameterized methods for spawning, collisions, effects.
- **Update/Draw Loop**: Keep logic in `update`, visuals in `draw`.

⚡ **Pro tip for modularity**: Always expose parameters (speed, position, color, etc.) in your helpers so you can batch‑spawn and tweak without rewriting logic. That’s how you’ll scale from a toy demo to a flexible toolkit.

## Note
- **Images**: Put the full path to your own folder of images insead the stock imgaes
  Please note: the imgaes must be in 1:1 square ratio in order to function properly, otherwise the game is going to crash

## Documentation
I have generated a pdf file for code documentation, read it for more details.
