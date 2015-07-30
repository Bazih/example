# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('a.add-comment').on 'click', (e) ->
    e.preventDefault()
    $(this).siblings('.new_comment').show()
    $(this).hide()

  $('a.cancel-comment').on 'click', (e) ->
    e.preventDefault()
    $(this).siblings('.comment_body').find('#comment_body').val('')
    $commentForm = $(this).closest('form')
    $commentForm.siblings('a.add-comment').show()
    $commentForm.hide()

  addComment = (data, commentable) ->
    $commentable =
      commentable || $('#' + data.commentable_type.toLowerCase() + '_' + data.commentable_id)
    $commentable.find('.comments').append ->
      HandlebarsTemplates['comments/comment'](data)

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    addComment(comment)

  $('form.new_comment').on 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)

    $(this).find('#comment_body').val('')
    $(this).hide()
    $commentable = $('#' + comment.commentable_type.toLowerCase() + '_' + comment.commentable_id)
    $commentable.find('.comment a.add-comment').show()
    addComment(comment, $commentable) if !$('#comment-' + comment.id).length

  .on 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)

    $form = $(this).closest('form')
    $errors = $form.children('.error_explanation')
    errorsHtml = HandlebarsTemplates['errors/error'](response)

    if $errors.length
      $errors.html(errorsHtml)
    else
      $form.prepend(errorsHtml)
      $errors = $form.children('.error_explanation')

    $errors.stop().css( {opacity: 1} ).fadeOut 5000, ->
      $(this).remove()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)