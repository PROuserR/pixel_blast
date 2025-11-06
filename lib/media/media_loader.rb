# frozen_string_literal: true

require_relative '../utils/random_generator'
require_relative '../graphics/gif_player'
# MediaLoader provides media like click sound and background
class MediaLoader
  attr_reader :super_frenzy, :block_blaster, :go_go_go, :way_to_go, :amazing, :perfect, :great, :awesome, :blast_em,
              :game_over, :blast, :double_blast, :click, :song, :intro, :font, :font_title, :font_subtitle

  attr_accessor :background, :super_frenzy_counter

  def initialize
    @background = Gosu::Image.new(RandomGenerator.random_file_from_subfolders)
    @super_frenzy_counter = 0

    @super_frenzy = Gosu::Sample.new(RandomGenerator.asset('super_frenzy.wav'))
    @block_blaster = Gosu::Sample.new(RandomGenerator.asset('block_blaster.wav'))
    @go_go_go = Gosu::Sample.new(RandomGenerator.asset('go_go_go.wav'))
    @way_to_go = Gosu::Sample.new(RandomGenerator.asset('way_to_go.wav'))
    @amazing = Gosu::Sample.new(RandomGenerator.asset('amazing.wav'))
    @perfect = Gosu::Sample.new(RandomGenerator.asset('perfect.wav'))
    @great = Gosu::Sample.new(RandomGenerator.asset('great.wav'))
    @awesome = Gosu::Sample.new(RandomGenerator.asset('awesome.wav'))
    @blast_em = Gosu::Sample.new(RandomGenerator.asset("blast'em.wav"))
    @game_over = Gosu::Sample.new(RandomGenerator.asset('game_over.wav'))
    @blast = Gosu::Sample.new(RandomGenerator.asset('blast.mp3'))
    @double_blast = Gosu::Sample.new(RandomGenerator.asset('double_blast.wav'))
    @click = Gosu::Sample.new(RandomGenerator.asset('click.mp3'))
    @intro = Gosu::Song.new(RandomGenerator.asset('intro.mp3'))

    @font = Gosu::Font.new(16, name: RandomGenerator.asset('font/ConnectionSerif-d20X.otf'))

    @font_title = Gosu::Font.new(30, name: RandomGenerator.asset('font/Bubble3D.ttf'))

    @font_subtitle = Gosu::Font.new(24, name: RandomGenerator.asset('font/ConnectionSerif-d20X.otf'))
    pick_a_song
  end

  def pick_a_song
    dice_roll = rand(3)
    case dice_roll
    when 0
      @song = Gosu::Song.new(RandomGenerator.asset('retro_synthwave.mp3'))
    when 1
      @song = Gosu::Song.new(RandomGenerator.asset('chill_synthwave.mp3'))
    when 2
      @song = Gosu::Song.new(RandomGenerator.asset('instrumental_synthwave.mp3'))
    when 3
      @song = Gosu::Song.new(RandomGenerator.asset('beats_synthwave.mp3'))
    end
  end
end
