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

  addAnswer = (data) ->
    answer = data.answer

    if gon.current_user
      answer.isSigned = gon.current_user
      answer.isAnswerAuthor = gon.current_user == answer.user_id
      answer.isQuestionAuthor = gon.question_author == gon.current_user

    answer.attachments = data.attachments
    for attach in answer.attachments
      attach.name = attach.file.url.split('/').slice(-1)[0]
    $('.answers').append(HandlebarsTemplates['answers/answer'](answer))

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    response = $.parseJSON(data['response'])
    addAnswer(response)

  $('form.new_answer').on 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    addAnswer(response) if !$('#answer_'+ response.answer.id).get
    $('.new_answer #answer_body').val('')
    $('.notice').html('Your answer successfully added')
  .on 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.notice').html(HandlebarsTemplates['errors/error'](response))