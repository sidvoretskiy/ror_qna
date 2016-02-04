$(document).ready(function(){
    $('a.edit_answer_link').click(function(){
        var answer_id = $(this).data('answerId');
        var form = $('form#edit_answer_'+ answer_id);
        var title = $('#answer_'+answer_id).find('.title');


        if ($(this).hasClass('cancel')){
            $(this).html('Edit answer');
            $(this).removeClass('cancel');
        } else {
            $(this).html('Cancel');
            $(this).addClass('cancel');
        }
        form.toggle();
        title.toggle();
    });

    $('form.new_answer').bind('ajax:success',
        function(e, data, status, xhr){
            response = $.parseJSON(xhr.responseText);
            console.log(response);
            answer = response.answer;
            $('.answers-count').html('Answers count:'+response.answers_count);
            $('.answers').append('<div class="answer" id="answer_' + answer.id + '\"><p>' + answer.body + '</p></div>');
            $('input#answer_body').val('');
        }).bind('ajax:error',
        function(e, xhr, status, error){
            errors = $.parseJSON(xhr.responseText);
            $.each(errors, function(index, message){
                $('.answer-errors').append("<p>" + message + "</p>")
            });
        }).bind('ajax:before',function(){
            $('.answer-errors').html('');
        });

    $('form.edit_answer').bind('ajax:success',
        function(e, data, status, xhr){
            response = $.parseJSON(xhr.responseText);
            //console.log(response);
            $('form#edit_answer_'+ response.id).toggle();
            $('#answer_'+response.id).find('.title').html(response.body).toggle();


            if ($('a.edit_answer_link').hasClass('cancel')){
                $('a.edit_answer_link').html('Edit answer');
                $('a.edit_answer_link').removeClass('cancel');
            } else {
                $('a.edit_answer_link').html('Cancel');
                $('a.edit_answer_link').addClass('cancel');
            }

        }).bind('ajax:error',
        function(e, xhr, status, error){

        }).bind('ajax:before',function(){
            $('.answer-errors').html('');
        });
    questionId = $('.question').data('questionId');
    channel = '/questions/' + questionId + '/answers';

    PrivatePub.subscribe(channel,function(data,channel){
        console.log(data);
        response = data['response'];
        attachment_url = response.attachment_url;
        attachment_name = response.attachment_name;
        answer_count = response.answers_count;
        answer = response.answer;
        $('.answers-count').html('Answers count:'+response.answers_count);
        if (attachment_name != null){
            $('.answers').append('<div class="answer" id="answer_' + answer.id + '\"><p>' + answer.body + '</p><ul><li><a href="'+ attachment_url +'">'+ attachment_name +'</a></li></ul></div>');
        } else {
            $('.answers').append('<div class="answer" id="answer_' + answer.id + '\"><p>' + answer.body + '</p></div>');
        }



    })

});