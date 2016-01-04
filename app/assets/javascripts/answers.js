$(document).ready(function(){
    $('a.edit_answer_link').click(function(){
        var answer_id = $(this).data('answerId');
        var form = $('form#edit_answer_'+ answer_id);
        var title = $('#answer_'+answer_id);


        if ($(this).hasClass('cancel')){
            $(this).html('Изменить');
            $(this).removeClass('cancel');
        } else {
            $(this).html('Отмена');
            $(this).addClass('cancel');
        };
        form.toggle();
        title.toggle();
    });

    $('form.new_answer').bind('ajax:success',
        function(e, data, status, xhr){
            response = $.parseJSON(xhr.responseText);
            answer = response.answer;
            $('.answers-count').html('Answers count:'+response.answers_count);
            $('.answers').append('<div class="answer" id="answer_' + answer.id + '\"><p>' + answer.body + '</p></div>');
            $('#answer_body').val('');
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
            console.log(response);
            $('form#edit_answer_'+ response.id).toggle();
            $('#answer_'+response.id).html(response.body).toggle();
            $('a.edit_answer_link').function()
            {
                if ($(this).hasClass('cancel')){
                    $(this).html('Изменить');
                    $(this).removeClass('cancel');
                } else {
                    $(this).html('Отмена');
                    $(this).addClass('cancel');
                };
            };
        }).bind('ajax:error',
        function(e, xhr, status, error){

        }).bind('ajax:before',function(){
            $('.answer-errors').html('');
        });


});