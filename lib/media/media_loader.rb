# frozen_string_literal: true

require_relative '../utils/extras'
require_relative '../graphics/gif_player'
# MediaLoader provides media like click sound and background
class MediaLoader
  attr_reader :super_frenzy, :block_blaster, :go_go_go, :way_to_go, :amazing, :perfect, :great, :awesome, :blast_em,
              :game_over, :blast, :double_blast, :click, :song, :intro, :font, :font_title, :font_subtitle

  attr_accessor :background, :super_frenzy_counter, :cover_art

  def initialize
    @background = Gosu::Image.new(Extras.random_file_from_subfolders)
    @super_frenzy_counter = 0

    @super_frenzy = Gosu::Sample.new(Extras.asset('super_frenzy.wav'))
    @block_blaster = Gosu::Sample.new(Extras.asset('block_blaster.wav'))
    @go_go_go = Gosu::Sample.new(Extras.asset('go_go_go.wav'))
    @way_to_go = Gosu::Sample.new(Extras.asset('way_to_go.wav'))
    @amazing = Gosu::Sample.new(Extras.asset('amazing.wav'))
    @perfect = Gosu::Sample.new(Extras.asset('perfect.wav'))
    @great = Gosu::Sample.new(Extras.asset('great.wav'))
    @awesome = Gosu::Sample.new(Extras.asset('awesome.wav'))
    @blast_em = Gosu::Sample.new(Extras.asset("blast'em.wav"))
    @game_over = Gosu::Sample.new(Extras.asset('game_over.wav'))
    @blast = Gosu::Sample.new(Extras.asset('blast.mp3'))
    @double_blast = Gosu::Sample.new(Extras.asset('double_blast.wav'))
    @click = Gosu::Sample.new(Extras.asset('click.mp3'))
    @intro = Gosu::Song.new(Extras.asset('intro.mp3'))

    @font = Gosu::Font.new(16, name: Extras.asset('font/ConnectionSerif-d20X.otf'))

    @font_title = Gosu::Font.new(30, name: Extras.asset('font/Bubble3D.ttf'))

    @font_subtitle = Gosu::Font.new(24, name: Extras.asset('font/ConnectionSerif-d20X.otf'))
    # uniform 50ms per frame
    @cover_art = GifPlayer.new(Extras.asset('frames/frame_*.gif'),
                               tint_color: Gosu::Color::WHITE,
                               scale_x: 1.27,
                               scale_y: 1.25,
                               delays: 50)
    pick_a_song
  end

  def pick_a_song
    dice_roll = rand(3)
    case dice_roll
    when 0
      @song = Gosu::Song.new(Extras.asset('retro_synthwave.mp3'))
    when 1
      @song = Gosu::Song.new(Extras.asset('chill_synthwave.mp3'))
    when 2
      @song = Gosu::Song.new(Extras.asset('instrumental_synthwave.mp3'))
    when 3
      @song = Gosu::Song.new(Extras.asset('beats_synthwave.mp3'))
    end
  end
end
