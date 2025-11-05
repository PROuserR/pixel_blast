# frozen_string_literal: true

# Useful functions to consume
module Extras
  module_function

  ASSETS_DIR = File.join(__dir__, '..', '..', '/assets')

  def asset(name)
    File.join(ASSETS_DIR, name)
  end

  def random_file_from_subfolders
    # Define the path to the target folder (outside current directory)
    content = File.read('./config.txt')

    target_folder = ''
    if content
      target_folder = content # or use an absolute path like "/home/user/images"
      Dir.glob(File.join(target_folder, '*')).sample
    else
      target_folder = 'assets/Card_Sets' # or use an absolute path like "/home/user/images"
      # Get all files in that folder (adjust pattern as needed)
      folders = Dir.glob(File.join(target_folder, '*'))
      # Select one random file
      Dir.glob(File.join(folders.sample, '*')).sample
    end
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
