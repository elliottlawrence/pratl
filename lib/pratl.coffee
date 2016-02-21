PratlView = require './pratl-view'
{CompositeDisposable} = require 'atom'
PratlTwit = require './pratl-twit'

module.exports = Pratl =
  pratlView: null
  modalPanel: null
  subscriptions: null
  editorData: null
  pratlTwit: null

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

        @pratlTwit.tweet('I just wrote ' + (currentLineCount - oldLineCount) +
          ' lines of code!')

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pratlView.destroy()

  serialize: ->
    pratlViewState: @pratlView.serialize()

  emergency: ->
    @pratlTwit.tweet('I\'M WRITING CODEZ!!!!!!')

  whatever: ->
