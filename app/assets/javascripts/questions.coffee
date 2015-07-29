# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  ready_question = ->
    $(document).on 'click', '.edit-button-question', (e) ->
      e.preventDefault()
      $(this).hide()
      $('form.edit_question').show()

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append(HandlebarsTemplates['questions/question'](question))

  $(document).ready ready_question
  $(document).on('page:load', ready_question)
  $(document).on('page:update', ready_question)