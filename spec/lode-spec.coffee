###
Your package should have tests, and if they're placed in the spec directory, they can be run by Atom.

Under the hood, [Jasmine] executes your tests, so you can assume that any DSL available there is also available to your package.
###

describe "lode snippets", ->
  editor = null
  editorElement = null

  simulateTabKeyEvent = ({shift}={}) ->
    event = atom.keymaps.constructor.buildKeydownEvent(
      'tab', {shift, target: editorElement}
      )
    atom.keymaps.handleKeyboardEvent(event)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open('sample.md')

    waitsForPromise ->
      atom.packages.activatePackage("snippets")

    waitsForPromise ->
      atom.packages.activatePackage("lode")

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)

  afterEach ->
    atom.packages.deactivatePackage('lode')

  it "should expand 'slabel' to a span@label.", ->
    editor.setText("")
    editor.insertText("slabel")
    simulateTabKeyEvent()
    expect(editor.lineTextForBufferRow(0)).toBe(
      "<span property=\"rdfs:label\"></span>"
      )
    expect(editor.getCursorScreenPosition()).toEqual [0, 28]
