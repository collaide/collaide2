appear = () ->
  $('.comment').appear()
  comment_number = 1
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
  )
$ ->
  $('#post-indicator').stickyJQuery({topSpacing: 30})
  appear()
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