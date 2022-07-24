

require 'io/console'

print "\e[1mFLAPPY BIRD\e[0m\n\r"
print "[espaço] - pular\n\r"
print "[s] - sair\n\r"
print "[p] - novo jogo\n\r"
print "\n\r\e[1mPreparado?...\e[0m \n\r\e[6m\e[2m[pressione qualquer tecla]"
STDIN.getch


ch = ''

screen_x = 36
screen_y = 10

print "\e[8;#{screen_y + 5};#{screen_x}t"

flappx = (screen_x / 2).floor
flappy = (screen_y / 2).floor
flappp = 3
fall_v = 0.5
fall_a = 0.5
fall_m = 0.5

pillars = []
pillar_gap = 3
pillar_size = 2
pillar_hole = 5
pillar_counter = 0
next_pillar_hole = rand( screen_y - 2 - pillar_hole )

points = 0
hit = false

play_v = 0.1
play_a = 0.01
play_i = 10

t1 = Thread.new {
  ch = ''

  while ch != 's'
    ch = STDIN.getch

    fall_v = - fall_m if ch == ' '

    if ch == 'p'
      hit = false
      flappy = (screen_y / 2).floor
      pillars = []
      points = 0
      play_v = 0.1
    end
  end

  print "\e[8;24;80t"
}

t2 = Thread.new {
  while ch != 's'
    system 'clear'

    if !hit
    if pillar_counter % (pillar_gap + pillar_size) < pillar_size
      pillars.unshift( next_pillar_hole )
    else
      pillars.unshift( -1 )
    end
    end

    pillars.pop if pillars.length > screen_x

    print "[espaço] - pular\n\r"
    print "[s] - sair\n\r"
    print "[p] - novo jogo\n\r"

    screen_y.times do |y|
      screen_x.times do |x|

	if flappx == x && flappy.floor == y
          print "\e[43m\e[34m\e[1m"
          print "¿"
        else

	  p = pillars[screen_x - x - 1]

          if ![nil, -1].include?(p)  && !( (p + 1)..(p + 1 + pillar_hole) ).include?(y) 
            print "\e[42m"
          else
            print "\e[40m"
          end

	  print " "
        end

        print "\e[0m"
      end
      print "\n\r"
    end

    p = pillars[screen_x - flappx - 1]
    
    if ![nil, -1].include?(p)  && !( (p + 1)..(p + 1 + pillar_hole) ).include?(flappy)
      hit = true
    end

    pillar_counter += 1 
    if pillar_counter == pillar_gap + pillar_size
      pillar_counter = 0
      next_pillar_hole = rand( screen_y - 2 - pillar_hole )

      if pillars.length > flappx && !hit
        points += 1
        play_v -= play_a if points > 0 && points % play_i == 0
      end
    end

    if !hit
    flappy += fall_v
    flappy = screen_y - 1 if flappy > screen_y - 1

    fall_v += fall_a if fall_v < fall_m
    end

    print "\e[1m#{points} \e[0mpontos\n\r"

    sleep(play_v)
  end
}

t1.join
t2.join
