<!DOCTYPE HTML>
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
<script src="resources/js/home.js"></script>

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
                <a href="https://github.com/trillium-bridge/trillium-bridge-transformer"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png" alt="Fork me on GitHub"></a>

                <a class="brand" href="#">
                    Trillium Bridge Transformer
                </a>

                <ul class="nav">
                    <li class="divider-vertical"></li>
                    <li><a href="."><i class="icon-home"></i> Home</a></li>
                    <li class="divider-vertical"></li>
                    <li><a href="http://informatics.mayo.edu/maven/content/repositories/releases/edu/mayo/trillium-bridge-transformer-cli/${version}/trillium-bridge-transformer-cli-${version}-bin.zip"><i class="icon-download-alt"></i> Download</a></li>
                    <li class="divider-vertical"></li>
                    <li><a href="https://github.com/trillium-bridge/trillium-bridge-transformer/blob/master/README.md"> Documentation</a>
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
                    <form autocomplete="off" action="ccda2epsos" enctype='multipart/form-data' name="fileUploadForm" id="fileUploadForm" method='post' class="form-inline well">
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
                                    <button type="button" class="btn disabled" rel="tooltip" data-placement="right" title="PDF Currently Unavailable">PDF</button>
                                </div>
                            </div>
                            <input type="hidden" id="formatOverride" name="formatOverride" value="XML"/>

                            <div class="padTop">
                                <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#transformOptions" aria-expanded="false" aria-controls="collapseExample">
                                    Transformation Parameters
                                </button>
                                <div id="transformOptions" class="collapse">
                                    <div class="well">

                                        <c:forEach var="tuple" items="${options}">

                                            <div id="${tuple.name}">
                                                <c:forEach var="option" items="${tuple.options}">
                                                    <div>
                                                        <label>
                                                            <span>${option.description}: </span>
                                                            <c:if test="${option.optionType == 'BOOLEAN'}">
                                                                <input class="transformOptionCheckBox"
                                                                       type="checkbox"
                                                                       name="${option.optionName}"
                                                                       rel="tooltip" data-placement="right" title="${option.description}"
                                                                       value="true"
                                                                       ${option.defaultValue == 'true' ? 'checked' : ''}>
                                                            </c:if>
                                                            <c:if test="${option.optionType == 'STRING'}">
                                                                <input class="input"
                                                                       type="text"
                                                                       name="${option.optionName}"
                                                                       rel="tooltip" data-placement="right" title="${option.description}"
                                                                       value="${option.defaultValue}">
                                                            </c:if>
                                                            <c:if test="${option.optionType == 'ENUM'}">
                                                                <select name="${option.optionName}"
                                                                        rel="tooltip" data-placement="right" title="${option.description}">
                                                                    <c:forEach var="value" items="${option.allowedValues}">
                                                                        <option value="${value}" ${value == option.defaultValue ? 'selected' : ''}>${value}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </c:if>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </div>

                                        </c:forEach>

                                    </div>
                                </div>
                            </div>

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
            <a class="btn btn-primary btn-large" href="https://github.com/trillium-bridge/trillium-bridge-transformer/blob/master/README.md">
                Learn more
            </a>
        </p>

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