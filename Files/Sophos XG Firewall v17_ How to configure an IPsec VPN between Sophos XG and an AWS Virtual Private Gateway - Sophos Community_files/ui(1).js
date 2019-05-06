(function ($, global) {

    $.telligent = $.telligent || {};
    $.telligent.evolution = $.telligent.evolution || {};
    $.telligent.evolution.widgets = $.telligent.evolution.widgets || {};

    var speed = 100,
		locks = {};

    function handleTreeTraversal(context, hierarchy) {
        hierarchy.on('click', '.hierarchy-item.with-children .expand-collapse', function (e) {
            e.preventDefault();

            var expandCollapse = $(this);
            var currentItem = expandCollapse.closest('li');
            var children = currentItem.children('.hierarchy-children');

            if (children && children.length > 0) {
                if (!children.is(':visible'))
                    children.slideDown(speed, function () {
                        expandCollapse.html('-').removeClass('collapsed').addClass('expanded');
                    });
                else
                    children.slideUp(speed, function () {
                        expandCollapse.html('+').removeClass('expanded').addClass('collapsed');
                    });
            } else {
                loadChildren(context, currentItem);
            }
        });
    };

    function loadChildren(context, parent) {
        var parentTopicid = parent.data('topicid');

        if (locks[parentTopicid])
            return;

        locks[parentTopicid] = true;

        $.telligent.evolution.get({
            url: context.topicsUrl,
            data: {
                w_parentTopicId: parentTopicid
            }
        }).then(function (response) {
            $(response).hide()
				.appendTo(parent)
				.slideDown(speed, function () {
				    parent.find('.expand-collapse:first')
						.html('-').removeClass('collapsed').addClass('expanded');
				});
            locks[parentTopicid] = false;
        })
    };

    var maxHeight = 0,
		win = $(global),
		contextualBanner = $('.header-fragments .layout-region.content'),
		sideBar = $('.layout-region.right-sidebar, .layout-region.left-sidebar');

    function resize(context) {
        var availableContentHeight = getAvailableContentHeight();
        var nonTocSidebarHeight = sideBar.height() - context.wrapper.height();
        var measuredMaxHeight = (availableContentHeight - nonTocSidebarHeight);

        if (measuredMaxHeight != maxHeight) {
            maxHeight = measuredMaxHeight;
            context.wrapper.css({ 'overflow': 'auto' }).animate({ 'max-height': maxHeight }, 150);
        }
    }

    function getAvailableContentHeight() {
        return win.height() - contextualBanner.height() - contextualBanner.position().top;
    }

    function handleSizing(context) {
        context.wrapper = $(context.wrapper);

        resize(context);
        setTimeout(function () {
            resize(context);
        }, 250);
        //$.telligent.evolution.messaging.subscribe('window.scrollableheight', function (data) {
        //    resize(context);
        //});
    }

    $.telligent.evolution.widgets.wikiPageHierarchy = {
        register: function (context) {
            handleTreeTraversal(context, context.hierarchy);
            handleSizing(context);
        }
    };

})(jQuery, window);