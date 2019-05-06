(function ($) {
    var createFeedback = function (context) {
        context.submitInput.addClass('disabled');

        $.telligent.evolution.post({
            url: context.createUrl,
            data: {
                articleId: context.articleId,
                language: context.language,
                yesNo: $("input[type=radio][name='YesNo']:checked").val() == "Yes",
                body: $(context.bodyInput).val(),
                userName: context.userName
            }
        })
			.then(function (response) {
			    $.telligent.evolution.messaging.publish('comment.created');
			    $.telligent.evolution.notifications.show(context.successMessage, { duration: 5 * 1000 });

			    $(context.bodyInput).val('');
                $("input[type=radio][name='YesNo']:checked").attr('checked', false);
			    context.submitInput.evolutionValidation('reset');
			    context.submitInput.removeClass('disabled');
			    $('.processing', context.submitInput.parent()).css("visibility", "hidden");
			    $(context.bodyInput).blur();

			    $(context.wrapper).fadeOut();
            },
				function () {
				    $('.processing', context.save.parent()).css("visibility", "hidden");
				    $(context.bodyInput).blur();
				    context.submitInput.disable();
				});
    };
    var api = {
        register: function (context) {
            context.submitInput
				.evolutionValidation({
				    onValidated: function (isValid, buttonClicked, c) { },
				    onSuccessfulClick: function (e) {
				        e.preventDefault();
				        context.submitInput.addClass('disabled');
				        $('.processing', context.submitInput.parent()).css("visibility", "visible");
				        createFeedback(context);
				        return false;
				    }
				})
				.evolutionValidation('addCustomValidation', 'yesNoSelected', function () {
				    return $("input[type=radio][name='YesNo']:checked").val() != undefined;
				}, context.errorMessage, $(context.bodyInput).closest('.field-item').find('.field-item-validation'), null);
        }
    };

    if (typeof $.sophos === 'undefined') { $.sophos = {}; }
    if (typeof $.sophos.widgets === 'undefined') { $.sophos.widgets = {}; }
    $.sophos.widgets.feedback = api;
}(jQuery));
