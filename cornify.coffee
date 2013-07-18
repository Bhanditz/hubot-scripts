# Description:
#   Cornifications for your pleasure.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   cornify me - receive glittery things
#   cornify me xN - receive xN glittery things

unicorns = [
  'http://image.blingee.com/images19/content/output/000/000/000/7ca/785303048_889725.gif',
  'http://s2.favim.com/orig/28/glitter-rainbow-unicorn-Favim.com-237329.gif',
  'http://media2.giphy.com/media/43dIDceHBa5Es/original.gif',
  'http://yoursmiles.org/gsmile/unicorn/g3103.gif',
  'http://yoursmiles.org/gsmile/unicorn/g3101.gif',
  'http://yoursmiles.org/gsmile/unicorn/g3108.gif',
  'http://yoursmiles.org/gsmile/animals/g02209.gif',
  'http://yoursmiles.org/gsmile/horse/g5301.gif',
  'http://yoursmiles.org/gsmile/horse/g5307.gif',
  'https://s3.amazonaws.com/uploads.hipchat.com/42908/286315/mjkmmphra6mzkkf/upload.png'
]

rainbows = [
  'http://images.crystalscomments.com/6/10728.gif',
  'http://2.bp.blogspot.com/-Ummm40Mgzmw/Ty6USuCP0zI/AAAAAAAAEbg/0YMVVoNPBis/s1600/Rainbow_Spiral_Animation_Animated_Gif.gif',
  'http://yoursmiles.org/gsmile/nature/g2503.gif',
  'http://yoursmiles.org/gsmile/nature/g2504.gif'
]

dolphins = [
  'http://yoursmiles.org/gsmile/dolphin/g55004.gif',
  'http://yoursmiles.org/gsmile/dolphin/g55006.gif',
  'http://yoursmiles.org/gsmile/dolphin/g55007.gif',
  'http://yoursmiles.org/gsmile/dolphin/g55008.gif',
  'http://yoursmiles.org/gsmile/dolphin/g55015.gif',
]

cornifications = unicorns.concat rainbows.concat dolphins


module.exports = (robot) ->

  robot.respond /cornify me( x(\d+))?/i, (msg) ->
    count = msg.match[2] || 0
    for i in [0..count]
      msg.send msg.random cornifications

  robot.hear /unicorn/i, (msg) ->
    msg.send msg.random unicorns

  robot.hear /rainbow/i, (msg) ->
    msg.send msg.random rainbows

  robot.hear /dolphin|ryan|schenk/i, (msg) ->
    msg.send msg.random dolphins

