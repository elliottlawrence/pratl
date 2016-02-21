PratlView = require './pratl-view'
{CompositeDisposable} = require 'atom'
PratlTwit = require './pratl-twit'
_ = require 'underscore'

module.exports = Pratl =
  pratlView: null
  modalPanel: null
  subscriptions: null
  editorData: null
  pratlTwit: null

  config:
    twitterFriends:
      title: 'Twitter Friends'
      description: 'List of friends to mention in tweets'
      type: 'array'
      default: ['']
      items:
        type: 'string'

  activate: (state) ->
    @editorData = {}
    @pratlView = new PratlView(state.pratlViewState)
    @modalPanel = atom.workspace.addModalPanel(
      item: @pratlView.getElement(),
      visible: false)

    # Initialize twitter shit
    @pratlTwit = new PratlTwit

    # Events subscribed to in atom's system can be easily cleaned up with a
    # CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pratl:emergency': => @emergency()
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>

      # Set initial line count
      key = editor.getPath()
      originalLineCount = editor.getLineCount()
      @editorData[key] = originalCount: originalLineCount, count: originalLineCount

      editor.onDidDestroy =>
        delete @editorData[key]
      editor.onDidSave =>
        oldLineCount = @editorData[key].count
        currentLineCount = editor.getLineCount()
        @editorData[key].count = currentLineCount

        linesWritten = currentLineCount - oldLineCount

        texts = ['I just wrote ' + linesWritten + ' lines of code!',
                 'I wrote ' + linesWritten + ' LOC. What did you do today?',
                 'Rockstar coder over here!' + linesWritten + ' LOC written. #holla',
                 'BAM!! ' + linesWritten + ' lines of code written!',
                 'ATTENTION: I wrote ' + linesWritten + ' lines of code.',
                 'There are now ' + linesWritten + ' more lines of code in the world thanks to me :)',
                 'Just wrote some sweet codez! ' + linesWritten + ' lines #yolo #swag #code']

        @pratlTwit.tweet(_.sample(texts,1)[0])

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pratlView.destroy()

  serialize: ->
    pratlViewState: @pratlView.serialize()

  emergency: ->
    @pratlTwit.tweet('I\'M WRITING CODEZ!!!!!!')

  whatever: ->
