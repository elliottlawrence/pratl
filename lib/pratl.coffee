PratlView = require './pratl-view'
{CompositeDisposable} = require 'atom'

module.exports = Pratl =
  pratlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @pratlView = new PratlView(state.pratlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @pratlView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pratl:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @pratlView.destroy()

  serialize: ->
    pratlViewState: @pratlView.serialize()

  toggle: ->
    console.log 'Pratl was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
