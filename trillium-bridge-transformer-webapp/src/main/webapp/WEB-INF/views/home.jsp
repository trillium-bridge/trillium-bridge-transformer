<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Trillium Bridge Transformer</title>

<script type="text/javascript" src="resources/include/jquery-ui-1.8.19.custom/js/jquery-1.7.2.min.js"></script>
<script src="resources/include/bootstrap/js/bootstrap.min.js"></script>
<script src="resources/include/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
<script src="resources/include/select2/select2.min.js"></script>
<script type="text/javascript" src="resources/include/syntaxhighlighter_3.0.83/scripts/shCore.js"></script>
<script type="text/javascript" src="resources/include/syntaxhighlighter_3.0.83/scripts/shBrushJava.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.1/highlight.min.js"></script>

<link rel="stylesheet" href="resources/include/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="resources/include/bootstrap-fileupload/bootstrap-fileupload.min.css">
<link rel="stylesheet" href="resources/include/select2/select2.css">
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.1/styles/default.min.css">

<link rel="stylesheet" href="resources/style.css" />

</head>
<body>

    <div class="navbar navbar-fixed-top">

        <div class="navbar-inner">

            <div class="container">
                <a href="https://github.com/SHARP-HTP/qdm-phenotyping"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png" alt="Fork me on GitHub"></a>

                <a class="brand" href="#">
                    Trillium Bridge Transformer
                </a>

                <ul class="nav">
                    <li class="divider-vertical"></li>
                    <li><a href="."><i class="icon-home"></i> Home</a></li>
                    <li class="divider-vertical"></li>
                    <li><a href="http://informatics.mayo.edu/maven/content/repositories/releases/edu/mayo/trillium-bridge-transformer-cli/${version}/trillium-bridge-transformer-cli-${version}-bin.zip"><i class="icon-download-alt"></i> Download</a></li>
                    <li class="divider-vertical"></li>
                    <li><a href="https://github.com/kevinpeterson/trillium-bridge-transformer/blob/master/README.md"> Documentation</a>
                    <li class="divider-vertical"></li>
                    <li><a href="api"> REST API</a>
                    <li class="divider-vertical"></li>
                </ul>

            </div>
        </div>
    </div>

    <div class="container">

        <div class="hero-unit">

            <span class="title"> Trillium Bridge Transformer</span>
            <img class="trillium-bridge-img" src="http://www.hl7italia.it/trillium/index_file/image308.png"/>

            <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                <li class="active"><a href="#fileUpload" data-toggle="tab">File Upload</a></li>
                <!-- <li><a href="#ccdaExamples" data-toggle="tab">Try an Example</a></li> -->
            </ul>

            <div id="my-tab-content" class="tab-content">

                <div class="tab-pane active" id="fileUpload">
                    <form action="ccda2epsos" enctype='multipart/form-data' name="fileUploadForm" id="fileUploadForm" method='post' class="form-inline well">
                        <div class="fileupload fileupload-new" data-provides="fileupload">
                            <div class="input-append">
                                <div class="uneditable-input span5"><i class="icon-file fileupload-exists"></i>
                                    <span class="fileupload-preview"></span></div>
                                    <span class="btn btn-file"><span class="fileupload-new">Select file</span><span class="fileupload-exists">Change</span>
                                    <input type="file" name="file"/></span><a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                            </div>

                            <button class="btn btn-primary fileupload-exists dropdown-toggle" type='submit'>Convert</button>

                            <div class="padTop">Conversion:
                                <label class="radio">
                                    <input type="radio" name="conversionType" value="ccda2epsos" checked>
                                    <span>CCDA to epSOS</span>
                                </label>
                                <span>&nbsp;</span>
                                <label class="radio">
                                    <input type="radio" name="conversionType" value="epsos2ccda">
                                    <span>epSOS to CCDA</span>
                                </label>
                            </div>

                            <div id="formatToggle" class="fileupload-exists padTop">Output Format:
                                <div class="btn-group" data-toggle="buttons-radio">
                                    <button type="button" class="btn active">XML</button>
                                    <button type="button" class="btn">HTML</button>
                                    <!-- PDF conversion currently disabled -->
                                    <button type="button" class="btn disabled" rel="tooltip" data-placement="right" title="PDF Currenlty Unavailable">PDF</button>
                                </div>
                            </div>
                            <input type="hidden" id="formatOverride" name="formatOverride" value="XML"/>

                        </div>
                    </form>
                </div>

                <!-- Only a no-op transfrom for now
                <div class="tab-pane" id="ccdaExamples">
                    <form action='qdm2drools' id="emeasureForm" method='get' class="form-inline well">
                        <select id="ccdaExamplesSelect" name="ccdaExamplesSelect" class="combobox" style="width:80%">
                            <c:forEach var="ccda" items="${exampleCcdas}">
                            <option value="${ccda.collectionName}"></span>${ccda.name}</option>
                            </c:forEach>
                        </select>
                        <button class="btn btn-primary dropdown-toggle" type='submit'>Convert!</button>
                    </form>
                </div>
                -->

            </div>

        </div>

        <p>
            <a class="btn btn-primary btn-large" href="docs">
                Learn more
            </a>
        </p>

        <script type="text/javascript">

            String.prototype.xmlEscape = function() {
                return $('<div/>').text(this.toString()).html();
            };

            jQuery(document).ready(function ($) {
                $("[rel='tooltip']").tooltip();

                $("#formatToggle .btn-group button").click(function () {
                    $("#formatOverride").val($(this).text());
                });

                $("input[name='conversionType']").change(function() {
                    var action = $(this).val();
                    $("#fileUploadForm").attr("action", action);
                });

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
        </script>

    </div>

</div>

<!-- Modal -->
<div id="ccdaModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="myModalLabel">CCDA XML</h3>
    </div>
    <div class="modal-body">
        <pre><code id="xmlValue" class="xml"></code></pre>
    </div>
    <div class="modal-footer">
        <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
    </div>
</div>

<footer class="navbar navbar-fixed-bottom">
    <div class="container">
        <p class="muted credit">
            For more information see
            <a href="http://www.trilliumbridge.eu">Trillium Bridge</a>.
        </p>
    </div>
</footer>
</body>

</html>