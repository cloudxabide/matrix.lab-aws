
function ContentFragmentContainerCustomCallback(wrapperId, callbackFunction, authHeaderCookieName)
{
    var _wrapperElement = document.getElementById(wrapperId);
    var _callbackFunction = callbackFunction;
    var _authHeaderCookieName = authHeaderCookieName;

    var _isShowingEditShade = false;

    var EDIT_MESSAGE = 'contentfragmentcontainer.edit';

    $.telligent.evolution.messaging.subscribe(EDIT_MESSAGE, function (d) {
       if (!_isShowingEditShade) {
            _isShowingEditShade = true;

            $(_wrapperElement)
                .css('position', 'relative')
                .css('overflow', 'hidden')
                .css('max-height', Math.max($(_wrapperElement).outerHeight(), 100) + 'px')
                .prepend(
                    $('<div class="page-management-shade"></div>')
                );
        }
    });

    function _getAuthValue() {
        var nameEQ = this._authHeaderCookieName + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1, c.length);
            }
            if (c.indexOf(nameEQ) == 0) {
                return c.substring(nameEQ.length, c.length);
            }
        }
        return '';
    }

    return {
        isEditable: function () {
            return false;
        },
        customCallback: function (id, callbackControlId, callbackParameter, callbackContext, successFunction, errorFunction) {
            _callbackFunction('custom', 'id=' + encodeURIComponent(id) + '&renderFromCurrent=True&callback_control_id=' + encodeURIComponent(callbackControlId) + '&callback_argument=' + encodeURIComponent(callbackParameter), successFunction, errorFunction, callbackContext, this._getAuthValue());
        }
    };
}
