// override pager UI component
(function ($, global, undef) {

    function showLoadingIndicator(container, mask) {
        var containerOffset = container.offset();
        mask.hide().appendTo('body').css({
            width: container.width(),
            height: container.height(),
            top: containerOffset.top,
            left: containerOffset.left
        }).show();
    }

    function hideLoadingIndicator(container, mask) {
        mask.hide();
    }

    function buildMask() {
        return $('<div></div>').css({
            backgroundColor: '#fff',
            position: 'absolute',
            opacity: .75,
            zIndex: 1
        });
    }

    var ajaxPagerContexts = {};
    $.telligent.evolution.ui.components.page = {
        setup: function () {

        },
        add: function (elm, options) {
            // general settings
            var settings = {
                currentPage: parseInt(options.currentpage, 10),
                pageSize: parseInt(options.pagesize, 10),
                totalItems: parseInt(options.totalitems, 10),
                showPrevious: true,
                showNext: true,
                showFirst: true,
                showLast: true,
                showIndividualPages: true,
                numberOfPagesToDisplay: 5,
                pageKey: options.pagekey,
                hash: options.configuration.Target,
                baseUrl: options.configuration.BaseUrl || window.location.href,
                template: typeof options.configuration.Template !== 'undefined' ? options.configuration.Template : '' +
					' <% if(links && links.length > 0) { %> ' +
					'   <% if($.grep(links, function(l){ return l.type === "previous"; }).length > 0) { %> ' +
					' 	  <a class="previous" data-type="previous" data-page="<%= $.grep(links, function(l){ return l.type === "previous"; })[0].page %>" href="<%: $.grep(links, function(l){ return l.type === "previous"; })[0].url %>">&lt;</a> ' +
                    '   <% } else { %> ' +
                    ' 	  <a class="previous disabled" data-type="previous">&lt;</a> ' +
                    '   <% } %> ' +
                    '   <div class="pages"> ' +
                    ' 	  <div> ' +
                    '   <% if($.grep(links, function(l){ return l.type === "first"; }).length > 0) { %> ' +
					' 	  <a class="first page" data-type="first" data-page="<%= $.grep(links, function(l){ return l.type === "first"; })[0].page %>" href="<%: $.grep(links, function(l){ return l.type === "first"; })[0].url %>"><%= $.grep(links, function(l){ return l.type === "first"; })[0].page %></a> ' +
                    '       <% if($.grep(links, function(l){ return l.selected; })[0].page == 5) { %>' +
                    '           <a href="#" class="page" data-type="page" data-page="2" data-selected="false"><span>2</span></a> ' +
                    '       <% } if ($.grep(links, function(l){ return l.selected; })[0].page > 5 ){ %>' +
                    ' 	        <span class="page more" href="#">...</span> ' +
                    '       <% } %>' +
                    '   <% } %> ' +
					'   	<% if($.grep(links, function(l){ return l.type === "page"; }).length > 0) { %> ' +
					'           <% foreach($.grep(links, function(l){ return l.type === "page"; }), function(link, i) { %> ' +
                    '               <a href="<%: link.url %>" class="page<%= link.selected ? " selected" : "" %>" data-type="page" data-page="<%= link.page %>" data-selected="<%= link.selected ? "true" : "false" %>"><span><%= link.page %></span></a> ' +
                    '           <% }); %> ' +
					'   	<% } %> ' +
					'   <% if($.grep(links, function(l){ return l.type === "last"; }).length > 0) { %> ' +
                    ' 	  <span class="page more" href="#">...</span> ' +
					' 	  <a class="last page" data-type="first" data-page="<%= $.grep(links, function(l){ return l.type === "last"; })[0].page %>" href="<%: $.grep(links, function(l){ return l.type === "last"; })[0].url %>"><%= $.grep(links, function(l){ return l.type === "last"; })[0].page %></a> ' +
                    '   <% } %> ' +
                    '   </div> ' +
                    '     </div> ' +
                    '   <% if($.grep(links, function(l){ return l.type === "next"; }).length > 0) { %> ' +
					'   	<a class="next" data-type="next" data-page="<%= $.grep(links, function(l){ return l.type === "next"; })[0].page %>" href="<%: $.grep(links, function(l){ return l.type === "next"; })[0].url %>">&gt;</a> ' +
                    '   <% } else { %> ' +
                    ' 	  <a class="next disabled" data-type="next">&gt;</a> ' +
                    '   <% } %> ' +
					' <% } %> '

            };
            // ajax-specific options
            if (options.pagedcontenturl) {
                ajaxPagerContexts[options.pagedcontentpagingevent] = {
                    onPage: function (pageIndex, complete, hash) {
                        var contentContainer = $('#' + options.pagedcontentwrapperid),
							body = $('html,body');

                        var data = hash || {};
                        data[options.pagekey] = pageIndex;
                        // modify the url instead of passing as data, as the url might have this in the querystring already
                        var url = $.telligent.evolution.url.modify({ url: options.pagedcontenturl, query: data });
                        $.telligent.evolution.get({
                            url: url,
                            cache: false,
                            success: function (response) {
                                complete(response);
                                // scroll to top of paging area after page if out of view
                                var top = contentContainer.offset().top - 160;
                                var scrollTop = 0;
                                body.each(function (i, e) {
                                    if (e.scrollTop && e.scrollTop > scrollTop) {
                                        scrollTop = e.scrollTop;
                                    }
                                });
                                if (scrollTop > top) {
                                    body.animate({
                                        scrollTop: top
                                    }, 250);
                                }
                            }
                        });
                    }
                };
                $.extend(settings, {
                    onPage: function (pageIndex, complete, hash) {
                        ajaxPagerContexts[options.pagedcontentpagingevent].onPage(pageIndex, complete, hash);
                    },
                    refreshOnAnyHashChange: (options.loadonanyhashchange === 'true'),
                    pagedContentContainer: '#' + options.pagedcontentwrapperid,
                    pagedContentPagingEvent: options.pagedcontentpagingevent,
                    pagedContentPagedEvent: options.pagedcontentpagedevent,
                    transition: options.configuration.Transition,
                    transitionDuration: typeof options.configuration.TransitionDuration === 'undefined' ? 200 : parseInt(options.configuration.TransitionDuration, 10)
                });
            }
            $(elm).evolutionPager(settings);

            if (options.loadingindicator === 'true') {
                var container = $('#' + options.pagedcontentwrapperid), mask = buildMask();
                $.telligent.evolution.messaging.subscribe(options.pagedcontentpagingevent, function () {
                    showLoadingIndicator(container, mask);
                });
                $.telligent.evolution.messaging.subscribe(options.pagedcontentpagedevent, function () {
                    hideLoadingIndicator(container, mask);
                });
            }
        }
    };

})(jQuery, window);