var SendDataMethod = "POST";
var SendDataLocation = location.pathname;
function sendData(info) {
    var url = getElementValue(varNames.url);
    var p = readCookie(varNames.password);

    if (url.isEmpty() || p.isEmpty())
    {
        info.onSuccess("Error : url or password is empty");
        return false;
    }

    var data = "";
    //if (info.isLocal) {
        //data = varNames.password + "=" + p;
        //for (var i = 0; i < info.data.length; i++) {
        //    data += "&" + info.data[i].name + "=" + info.data[i].value;
        //}
    //} else {
        data = varNames.password + "=" + encodeURIComponent(btoa(p));
        data += "&isajax=1";
        for (var i = 0; i < info.data.length; i++) {
            data += "&" + info.data[i].name + "=" + encodeURIComponent(b64EncodeUnicode(info.data[i].value));
        }
    //}

    var xh = new XMLHttpRequest();
    xh.onreadystatechange = function () {
        
        if (this.readyState == 4)
            if (this.status == 200) {
                console.log({"data": data, "info": info, "response": this});
                if (info.dataIsBinary)
                    info.onSuccess(this, xh);
                else
                    info.onSuccess(b64DecodeUnicode(this.responseText));
            } else {
                info.onSuccess("ErrorResponse : status=" + this.status);
            }
    };

    xh.open(SendDataMethod, SendDataLocation, true);
    xh.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xh.send(data);
}

function SendDataInfo(data, sender, methodName, methodNumber, isPrint, isAppendPrint, callback) {

    var url = getElementValue(varNames.url);
    var p = readCookie(varNames.password);
    if (url.isEmpty() || p.isEmpty()) {
        info.onSuccess("Error : url or password is empty");
        return false;
    }
    var adminU = document.getElementsByName("adminU")[0].value;
    var adminP = document.getElementsByName("adminP")[0].value;

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

        var ldr = null;
        if (sender != null)
            loadingElement.addClass(loadingClassName);
        var info = {
            MethodName: methodName,
            Input: {
                Url: b64EncodeUnicode(url),
                Password: b64EncodeUnicode(p),
                AdminUsername: b64EncodeUnicode(adminU),
                AdminPassword: b64EncodeUnicode(adminP),
                MethodNumber: methodNumber,
                MethodInput: data
            },
            onSuccess: function (res) {

                if (isPrint && res.JustPrint)
                    print(res.JustPrint, isAppendPrint);
                if (callback)
                    callback(res);
                if (sender != null)
                    loadingElement.removeClass(loadingClassName);
            }
        };

        SendDataAjax(info);
    }
    else
        console.log("sender are in loading state");
}

function SendDataAjax(info) {
    $.ajax({
        type: 'POST',
        url: window.location + '/' + info.MethodName,
        contentType: 'application/json; charset=utf-8',
        dataType: 'text',
        data: JSON.stringify({ input: info.Input }),
        success: function (result, status, xhr) {
            var response = JSON.parse(b64DecodeUnicode(result));
            console.log(response);
            info.onSuccess(response);
        },
        error: function (xhr, status, error) {
            console.log('xhr :');
            console.log(xhr);
            console.log('status :');
            console.log(status);
            console.log('error :');
            console.log(error);
            info.onSuccess({ Error: "ErrorResponse : status = " + error });
        }
    });
}
