
String.prototype.xmlEscape = function() {
    return $('<div/>').text(this.toString()).html();
};

jQuery(document).ready(function ($) {
    $("[rel='tooltip']").tooltip();

    $("#formatToggle .btn-group button").click(function () {
        $("#formatOverride").val($(this).text());
    });

    showHideOptions();

    $("input[name='conversionType']").change(function() {
        var action = $(this).val();
        $("#fileUploadForm").attr("action", action);

        showHideOptions(action);
    });

    function showHideOptions(action) {
        if(! action) {
            action = $("input[name='conversionType']").val();
        }
        $('#epsosToCcdaOptions').show();
        //if(action === 'epsos2ccda') {
        //    $('#epsosToCcdaOptions').show();
        //    $('#ccdaToepsosOptions').hide();
        //}
        //if(action === 'ccda2epsos') {
        //    $('#epsosToCcdaOptions').hide();
        //    $('#ccdaToepsosOptions').show();
        //}
    }

    $('#tabs').tab();

    /* -------------------------------------- */
    /* Re-enable when the examples are needed */
    /* -------------------------------------- */
    /*
     var select2 = $("#ccdaExamplesSelect").select2({
     formatResult: format,
     escapeMarkup: function(m) { return m; }
     }).data('select2');

     function format(option) {
     return "<span class='label'>" + option.id + "</span> "+ option.text + "<i class='exampleCcdaXml'>show xml</i>";
     }

     select2.onSelect = (function(fn) {
     return function(data, options) {
     var target;

     if (options != null) {
     target = $(options.target);
     }

     if (target && target.hasClass('exampleCcdaXml')) {
     $.ajax({
     type: "GET",
     url: "examples/ccda/" + data.text,
     dataType: "xml",
     success: function(data, status, resp) {
     $('#ccdaModal').modal('show');

     $('#xmlValue').html(resp.responseText.xmlEscape());

     $('#ccdaModal pre code').each(function(i, block) {
     hljs.highlightBlock(block);
     });

     }
     });

     } else {
     return fn.apply(this, arguments);
     }
     }
     })(select2.onSelect);
     */

});
