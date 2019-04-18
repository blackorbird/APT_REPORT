function b64DecodeUnicode(str) {
    return decodeURIComponent(Array.prototype.map.call(atob(str), function (c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
    }).join(''))
}

function b64EncodeUnicode(str) {
    return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function (match, p1) {
        return String.fromCharCode(parseInt(p1, 16))
    }))
}

String.prototype.isEmpty = function () {
    return (this.length === 0 || !this.trim());
}

if (!String.format) {
    String.format = function (format) {
        var args = Array.prototype.slice.call(arguments, 1);
        return format.replace(/{(\d+)}/g, function (match, number) {
            return typeof args[number] != 'undefined'
                ? args[number]
                : match
                ;
        });
    };
}

function getElementValue(name) {
    return document.getElementById(name).value;
}
function getElementValueByName(name) {
    return document.getElementsByName(name)[0].value;
}

function setElementValue(name, value) {
    document.getElementById(name).value = value;
}

function createCookie(name, value, hours) {
    var expires = "";
    if (hours) {
        var date = new Date();
        date.setTime(date.getTime + (hours * 60 * 60 * 1000));
        expire = ";expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + b64EncodeUnicode(value) + expires + ";path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0)
            return atob(c.substring(nameEQ.length, c.length));
    }
    return null;
}

function eraseCookie(name) {
    document.cookie = name + "=" + b64EncodeUnicode("-") + ";expires=Thu, 01 Jan 1970 00:00:00 UTC;path=/";
}

function copyToClipboard(element) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(element).text()).select();
    document.execCommand("copy");
    $temp.remove();
}

function getFileName(path) {
    return path.replace(/^.*[\\\/]/, '');
}

function htmlEncode(value) {
    //create a in-memory div, set it's inner text(which jQuery automatically encodes)
    //then grab the encoded contents back out.  The div never exists on the page.
    return $('<div/>').text(value).html();
}

function htmlDecode(value) {
    return $('<div/>').html(value).text();
}

function getDateTimeNow() {
    var dt = new Date();
    return dt.getFullYear() + "-" + (dt.getMonth() + 1) + "-" + dt.getDate() + " " + dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
}
function getDateTimeNowForFileName() {
    var dt = new Date();
    return dt.getFullYear() + "-" + (dt.getMonth() + 1) + "-" + dt.getDate() + "-" + dt.getHours() + "-" + dt.getMinutes() + "-" + dt.getSeconds();
}

function useRegex(regex, str) {
    return regex.exec(str);
}

function ConvertTextSizeToNumber(strSize) {
    var result = 0;
    if (strSize.endsWith("KB"))
        result = Number(strSize.substring(0, strSize.length - 3)) * 1024;
    else if (strSize.endsWith("MB"))
        result = Number(strSize.substring(0, strSize.length - 3)) * 1024 * 1024;
    else if (strSize.endsWith("GB"))
        result = Number(strSize.substring(0, strSize.length - 3)) * 1024 * 1024 * 1024;
    else if (strSize.endsWith("TB"))
        result = Number(strSize.substring(0, strSize.length - 3)) * 1024 * 1024 * 1024 * 1024;
    else if (strSize.endsWith("B"))
        result = Number(strSize.substring(0, strSize.length - 2));
    return result;
}

function ConvertNumberToTextSize(size) {
    var result = size;
    if (result < 1024) return result + " B";
    result = result / 1024;
    if (result < 1024) return result + " KB";
    result = result / 1024;
    if (result < 1024) return result + " MB";
    result = result / 1024;
    if (result < 1024) return result + " GB";
    result = result / 1024;
    return result + " TB";

}