comment_number = 1
main_comment = 1
search_comment = false
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
      main_comment = current_number
      save_comment_viewd($(go_down(current_number)))
#      update_hash(go_down(current_number))
  )
save_comment_viewd = (element) ->
  return if element == undefined
  comment_id = element.attr('id').split('-')[1]
  url = window.location.pathname.split('/')
  topic_id = url[url.length - 1]
  $.ajax({
      type: 'POST',
      url: '/api/comment_views',
      dataType: 'application/json',
      success: () ->
        console.log('success')
      data: {
        group_comment_views: {
          comment_id: comment_id,
          topic_id: topic_id
        }
      }
  }
  )

get_comment_viewed = () ->
  return if !search_comment || $('#topic-scroll').length == 0
  url = window.location.pathname.split('/')
  topic_id = url[url.length - 1]
  $.ajax({
    type: 'GET',
    url: "/api/comment_views?topic_id=#{topic_id}",
    dataType: 'json',
    success: (data) ->
      console.log(data)
      goto_anchor("#comment-#{data.comment_id}")
  })
goto_anchor = (selector) ->
  $('.current-comment').removeClass('current-comment')
  element = $(selector)
  return if element.length == 0
  main_comment = element.attr('data-element-nb')
  element_top = element.position().top
  element_height = element.outerHeight()
  scroll_amount = (element_top)
#  $('html body').animate({
#      scrollTop: scroll_amount
#    }, 1000, () ->
#    element.addClass('current-comment')
#  )
  element.get(0).scrollIntoView(false)
  element.addClass('current-comment')
anchor = () ->
  hash = window.location.hash
  hash = hash.substring(1, hash.length)
  search_comment = true
  if hash
    if hash == 'top'
      goto_anchor(go_down(1))
    else
      goto_anchor("#comment-#{hash}")
    search_comment = false
go_down = (nb) ->
  "[data-element-nb='#{nb}']"
update_hash = (selector) ->
  id = $(selector).attr('id')
  return if id == undefined
  id = id.split('-')
  window.location.hash = "##{id[id.length - 1]}"
navigation = () ->
  $('#comment-down').on('click', (e) ->
    e.preventDefault()
    nb = parseInt($('#comment-size').text())
#    update_hash(go_down(nb))
    goto_anchor(go_down(nb))
  )
  $('#comment-top').on('click', (e) ->
    e.preventDefault()
    goto_anchor(go_down(1))
  )
  $('#comment-plus').on('click', (e) ->
    e.preventDefault()
    console.log(main_comment)
#    update_hash(go_down(main_comment + 10))
    goto_anchor(go_down(main_comment + 10))
  )
  $('#comment-minus').on('click', (e) ->
    e.preventDefault()
    console.log(main_comment)
#    if main_comment - 10 == 1
#      window.location.hash = '#top'
#    else
#      update_hash(go_down(main_comment - 10))
    goto_anchor(go_down(main_comment - 10))
  )

$ ->
  $('#post-indicator').stickyJQuery({topSpacing: 0})
  appear()
  navigation()
window.onload = () ->
  anchor()
  get_comment_viewed()
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