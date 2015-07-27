# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  ready_answer = ->
    $(document).on 'click', '.edit-button-answer', (e) ->
      e.preventDefault()
      $(this).hide()
      answer_id = $(this).data('answerId')
      $('form#edit-answer-' + answer_id).show()

  $(document).ready ready_answer
  $(document).on 'page:load', ready_answer
  $(document).on('page:update', ready_answer)

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    response = $.parseJSON(data['response'])
    answer = response.answer
    answer.isAuthor = answer.user_id == gon.current_user
    answer.attachments = response.attachments
    for attach in answer.attachments
      attach.name = attach.file.url.split('/').slice(-1)[0]
    $('.answers').after(HandlebarsTemplates['answers/answer'](answer)) unless answer.user_id == gon.current_user
    $('.new_answer #answer_body').val('')



