ready_vote = ->

#  if $('.vote-cancel').hasClass('hidden')
#    $('.vote-link ').addClass('hidden')


  $('.vote-link').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#rating-value-' + response.id).html("Rating: #{response.rating}")
    $('#vote_up_' + response.id).hide()
    $('#vote_down_' + response.id).hide()
    $('#vote_cancel_' + response.id).show()
    $('.notice').text(response.message)
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.notice').text(response.error)

  $('.vote-cancel').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#rating-value-' + response.id).html("Rating: #{response.rating}")
    $('#vote_up_' + response.id).show()
    $('#vote_down_' + response.id).show()
    $('#vote_cancel_' + response.id).hide()
    $('.notice').text(response.message)
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.notice').text(response.error)

$(document).ready(ready_vote)
$(document).on('page:load', ready_vote)
$(document).on('page:update', ready_vote)