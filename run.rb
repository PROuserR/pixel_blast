# frozen_string_literal: true

require './block_blast_window'

# run
window = BlockblastWindow.new(400, 600)
window.random_block_id = rand(8)
window.caption = 'Pixel Blast'
window.show
