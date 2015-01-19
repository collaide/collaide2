headerOffCanvas = () ->
  $('#get-header-sign-up-panel').hide()
  $('#get-header-sign-in-panel').hide()
  canvas = false
  $('#header-sign-up-button').click (e) ->
    if canvas != 'sign-up'
      canvas = 'sign-up'
#      newCanvasContent = $('#get-header-sign-up-panel').html()
      $('aside.right-off-canvas-menu').css('background-color', '#3D5164')
#      $('aside.right-off-canvas-menu').empty()
#      $('aside.right-off-canvas-menu').html(newCanvasContent)
      $('#get-header-sign-in-panel').hide()
      $('#get-header-sign-up-panel').show()
      if isCanvasOpen()
        stop(e)
        $('aside.right-off-canvas-menu').hide()
        $('aside.right-off-canvas-menu').show('slow')
  $('#header-sign-in-button').click (e) ->
    if canvas != 'sign-in'
      canvas = 'sign-in'
      #newCanvasContent = $('#get-header-sign-in-panel').html()
      $('aside.right-off-canvas-menu').css('background-color', '#F6F6F7')
      #$('aside.right-off-canvas-menu').empty()
      #$('aside.right-off-canvas-menu').html(newCanvasContent)
      $('#get-header-sign-up-panel').hide()
      $('#get-header-sign-in-panel').show()
      if isCanvasOpen()
        stop(e)
        $('aside.right-off-canvas-menu').hide()
        $('aside.right-off-canvas-menu').show('slow')
  isCanvasOpen = () ->
    $('[data-offcanvas]').hasClass('move-left')
  stop = (event) ->
    event.stopImmediatePropagation()
    event.preventDefault()

$ -> headerOffCanvas()