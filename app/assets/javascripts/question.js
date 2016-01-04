$(document).ready(function(){
    $('a.edit_question_link').click(function(){

        if ($(this).hasClass('cancel')){
            $(this).html('Edit question');
            $(this).removeClass('cancel');
        } else {
            $(this).html('Cancel');
            $(this).addClass('cancel');
        };
        $('form.edit_question').toggle();
        $('h2').toggle();
    });

    $('form.edit_question').bind('ajax:success',
        function(e, data, status, xhr){
            response = $.parseJSON(xhr.responseText);
            $('form.edit_question').toggle();
            $('h2').html(response.body).toggle();
            if ($('a.edit_question_link').hasClass('cancel')){
                $('a.edit_question_link').html('Edit question');
                $('a.edit_question_link').removeClass('cancel');
            } else {
                $('a.edit_question_link').html('Cancel');
                $('a.edit_question_link').addClass('cancel');
            };

        }).bind('ajax:error',
        function(e, xhr, status, error){

        }).bind('ajax:before',function(){
            $('.answer-errors').html('');
        });

    PrivatePub.subscribe('/questions',function(data,channel) {
        console.log(data);
        response = data['response'];
        question = response.question;
        $('.questions').append('<div class="question" id="question_' + question.id + '\"><h1><a href=\"/questions/' + question.id + '\">' + question.title + '</a></h1><p>'+ question.title + '</p></div>');
    });
});