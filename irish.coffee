# Description:
#   Cheers you up with a lovely irish toast
#
# Commands:
#   toast me - reply with an irish toast
#
# Author:
#   Anthony Goddard

url = require 'url'

module.exports = (robot) ->

  robot.respond /toast me/i, (msg) ->
    msg.http('http://irish-toast.herokuapp.com')
      .get() (err, res, body) ->
        result = JSON.parse(body)
        msg.send result["toast"]
