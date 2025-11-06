# frozen_string_literal: true

require './lib/ui/window'

# run
window = PixelblastWindow.new(400, 600)
window.random_block_id = rand(8)
window.caption = 'Pixel Blast'
window.show
