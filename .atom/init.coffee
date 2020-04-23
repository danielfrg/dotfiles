# atom.commands.add 'atom-text-editor', 'exit-insert-mode-if-preceded-by-j': (e) ->
#     editor = @getModel()
#     pos = editor.getCursorBufferPosition()
#     range = [pos.traverse([0,-1]), pos]
#     console.log(range)
#     lastChar = editor.getTextInBufferRange(range)
#     if lastChar != "j"
#         e.abortKeyBinding()
#     else
#         editor.backspace()
#         atom.commands.dispatch(e.currentTarget, 'vim-mode:activate-normal-mode')
