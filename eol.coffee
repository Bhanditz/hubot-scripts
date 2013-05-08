# Description:
#   various actions related to the Encyclopedia of Life (EOL) project
#
# Commands:
#   eol tag - get the tag EOL is running in production
#   eol staging tag <USER:PASSWORD> - get the tag EOL is running in staging
#   eol search <TERM> - search EOL and get the best image
#   eol search <TERM> in <FILTER SEARCH> - search EOL and get the best image within a clade
#
# Author:
#   Patrick Leary

url = require 'url'

module.exports = (robot) ->
  robot.respond /eol help/i, (msg) ->
    msg.send "Events:\n" +
      "eol tag - get the tag EOL is running in production\n" +
      "eol staging tag <USER:PASSWORD> - get the tag EOL is running in staging\n" +
      "eol search <TERM> - search EOL and get the best image\n" +
      "eol search <TERM> in <FILTER SEARCH> - search EOL and get the best image within a clade\n"

  robot.respond /eol tag/i, (msg) ->
    msg.http('http://eol.org/donate')
      .get() (err, res, body) ->
        response_from_tag_lookup msg, body

  robot.respond /eol staging tag (.*)/i, (msg) ->
    auth = msg.match[1]
    endpoint = url.format
      protocol: 'http'
      host: 'staging.eol.org'
      pathname: 'donate'
      auth: auth
    msg.http(endpoint)
      .get() (err, res, body) ->
        response_from_tag_lookup msg, body

  robot.respond /eol search (.*) in (.*)/i, (msg) ->
    search_term = escape(msg.match[1])
    filter = escape(msg.match[2])
    msg.http('http://eol.org/api/search/?format=json&cache_ttl=86400&q=' + search_term + '&filter_by_string=' + filter)
      .get() (err, res, body) ->
        result = JSON.parse(body)
        response_from_eol_search msg, search_term, result

  robot.respond /eol search (.*)/i, (msg) ->
    search_term = escape(msg.match[1])
    m = msg.match[1].match(/[ ]in /)
    if !m then msg.http('http://eol.org/api/search/?format=json&cache_ttl=86400&q=' + search_term)
      .get() (err, res, body) ->
        result = JSON.parse(body)
        response_from_eol_search msg, search_term, result

  robot.respond /eol (.*)/i, (msg) ->
    command = msg.match[1]
    m = command.match(/^(tag|staging tag .+|search .+)/)
    if !m then msg.send "/me does not know how to `" + command + "`. Try `eol help`"

response_from_tag_lookup = (msg, page_body) ->
  if m = page_body.match(/<meta content='v\. (.*)' name='app_version'>/)
    msg.send "We are running tag https://github.com/EOL/eol/tree/" + m[1]
  else
    msg.send "/me cannot determine the tag we are using"

response_from_eol_search = (msg, search_term, json) ->
  if json["results"][0] == undefined
    msg.send "/me found no results for " + search_term
  else
    taxon_concept_id = json["results"][0]["id"]
    msg.http('http://eol.org/api/pages/' + taxon_concept_id + '?format=json&images=1&text=0&details=1&cache_ttl=86400')
      .get() (err, res, body) ->
        result = JSON.parse(body)
        if result["dataObjects"][0] == undefined
          msg.send "/me found " + search_term + " but it doesn't have images"
        else
          msg.send result["dataObjects"][0]["mediaURL"]
        msg.send result["scientificName"] + " - http://eol.org/pages/" + taxon_concept_id + "/overview/"
