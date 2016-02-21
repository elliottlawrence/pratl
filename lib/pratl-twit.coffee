Twit = require 'twit' # https://github.com/ttezel/twit
keys = require '../keys'
_ = require 'underscore'

module.exports =
  class PratlTwit
    constructor: ->
      keys.timeout_ms = 60*1000

      @T = new Twit keys

    tweet: (text) ->
      emojis = ['😀','😁','🙃','😝','🤗','🤘','🤓','😜','😅','🙌','👍','💩',
        '🖕','👋','🙌','🐳','🍀','🎃','🌝','🍕','🍫','🏋','🏆','🎯','🚔','💡',
        '💙','💯','🆒','🗯','📢']
      emojiString = _.flatten((_.sample(emojis, 5) for i in [1..8])).join('')

      friendsText = _.map(_.filter(atom.config.get 'pratl.twitterFriends', (s) -> s != ''),
                           (s) -> "@#{s}"
                      ).join(' ')
      statusText = "#{text} #{emojiString} #pratl #{friendsText}"

      @T.post 'statuses/update', status: statusText, (err, data, response) ->
        console.log(data)
