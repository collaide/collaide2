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
infinite = ->
  $("#infinite-scroll .page").infinitescroll
    navSelector: "ul.pagination"
    nextSelector: "ul.pagination a[rel=next]"
    itemSelector: "#infinite-scroll .item"
    loading: {
      finishedMsg: "<em>Il n'y a pas d'autres eléments à afficher</em>",
      msgText: "<em>Chargement des prochains eléments</em>",
    }

show_hidden = () ->
  toggled_element = $('.toggled-element')
  toggled_element.hide()
  toggled_element.removeClass('hide')
  $(document).on('click', '.show-hidden', (e) ->
    e.preventDefault()
    sticker = $('.sticky-wrapper')
    sticker.removeAttr('style')
    id = $(this).attr('data-show-element')
    element = $("##{id}")
    return if element == undefined
    element.toggle('slow')
    actor = $(this)
    current_text = actor.html()
    actor.html(actor.attr('data-other-text'))
    actor.attr('data-other-text', current_text)
  )
$ ->
  headerOffCanvas()
  infinite()
  show_hidden()
