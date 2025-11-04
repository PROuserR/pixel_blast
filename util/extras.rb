# frozen_string_literal: true

# Useful functions to consume
module Extras
  module_function

  ASSETS_DIR = File.join(__dir__, '../assets')

  def asset(name)
    File.join(ASSETS_DIR, name)
  end

  def random_file_from_subfolders(base_path = './assets/Card_Sets')
    all_files = Dir.glob("#{base_path}/**/*").select { |f| File.file?(f) }
    all_files.sample
  end

  def random_vivid_color
    hue = rand(360) # Full spectrum
    saturation = rand(60..99)         # 60–100%
    value = rand(70..99)              # 70–100%
    Gosu::Color.from_hsv(hue, saturation / 100.0, value / 100.0)
  end

  def generate_unique_random(avoided_number, range)
    random_number = rand(range)
    loop do
      break if random_number != avoided_number

      random_number = rand(range)
    end
    random_number
  end
end
