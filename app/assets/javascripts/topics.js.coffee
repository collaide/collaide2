comment_number = 1
appear = () ->
  $('.comment').appear()
  comment_size = parseInt($('#comment-size').text())
  $(document).on('appear', '.comment', (e, $all_appeared_elements)->
    last_element = $all_appeared_elements[$all_appeared_elements.length - 1]
    current_number = parseInt($(last_element).attr('data-element-nb'))
    if comment_number != current_number
      percentage = (current_number / comment_size) * 100
      $('#comment-percent').width("#{percentage}%")
      $('#comment-number').html(current_number + ' /')
      $('#comment-input').attr('value', current_number)
      comment_number = current_number
      update_hash(go_down(current_number))
  )
goto_anchor = (selector) ->
  console.log(selector)
  element = $(selector)
  return if element.length == 0
  element_top = element.position().top
  element_height = element.outerHeight()
  scroll_amount = (element_top)
  console.log("should scroll to #{scroll_amount}")
  $('html body').animate({
      scrollTop: scroll_amount
    }, 1000, () ->
    element.addClass('current-comment')
  )
anchor = () ->
  hash = window.location.hash
  hash = hash.substring(1, hash.length)
  if hash
    if hash == 'top'
      goto_anchor(go_down(1))
    else
      goto_anchor("#comment-#{hash}")
go_down = (nb) ->
  "[data-element-nb='#{nb}']"
update_hash = (selector) ->
  id = $(selector).attr('id').split('-')
  window.location.hash = "##{id[id.length - 1]}"
navigation = () ->
  current_comment = 0
  if current_comment == 0
    current_comment = comment_number
  $('#comment-down').on('click', (e) ->
    e.preventDefault()
    nb = parseInt($('#comment-size').text())
    update_hash(go_down(nb))
    goto_anchor(go_down(nb))
  )
  $('#comment-top').on('click', (e) ->
    e.preventDefault()
    window.location.hash = '#top'
    goto_anchor(go_down(1))
  )
  $('#comment-plus').on('click', (e) ->
    e.preventDefault()
    current_comment = current_comment + 10
    update_hash(go_down(current_comment))
    goto_anchor(go_down(current_comment))
  )
  $('#comment-minus').on('click', (e) ->
    e.preventDefault()
    current_comment = current_comment - 10
    console.log(nb)
    update_hash(go_down(current_comment))
    goto_anchor(go_down(current_comment))
  )
$ ->
  $('#post-indicator').stickyJQuery({topSpacing: 30})
  appear()
  anchor()
  navigation()
#
#  // trigger Masonry as a callback
#  function( newElements ) {
#  // get new #page-nav
#var nexPageNav = $(this).find('.pagination-centered');
#
#  // substitute current #page-nav with new #page-nav from page loaded
#  $('.pagination-centered').replaceWith(nexPageNav);
#
#  // hide new items while they are loading
#  var $newElems = $( newElements ).css({ opacity: 0 });
#  // ensure that images load before adding to masonry layout
#  $newElems.imagesLoaded(function(){
#  // show elems now they're ready
#  $newElems.animate({ opacity: 1 });
#  $container.masonry( 'appended', $newElems, true );
#  });



#If you want to fire appear event for elements which are close to vieport but are not visible yet, you may add data attributes appear-top-offset and appear-left-offset to DOM nodes.
#
#<div class="postloader" data-appear-top-offset="600">...</div> # appear will be fired when an element is below browser viewport for 600 or less pixels