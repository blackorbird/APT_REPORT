using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Web;

namespace Minion.lib
{
    public class Download
    {
        public static string DownloadLocation = @"C:\Users\Public\Libraries\DownloadFiles\";

        public enum Method
        {
            DownloadFile = 0,
            DownloadTest = 1,
            DownloadProgress = 2,
            DownloadLoad = 3,
            DownloadGetInfo = 4,
            DownloadPause= 5,
            DownloadClose = 6,
            DownloadChangeStatusToRequested = 7,
            DownloadResume = 8
        };

        private readonly Main CurrentMain;

        public Download(Main main)
        {
            CurrentMain = main;
            Method selectedMethod = (Method)CurrentMain.InputData.MethodNumber;
            switch (selectedMethod)
            {
                case Method.DownloadTest:
                    DownloadTest(main.InputData);
                    break;
                case Method.DownloadFile:
                    DownloadFile(main.InputData);
                    break;
                case Method.DownloadProgress:
                    DownloadProgress(main.InputData);//(unpack(t["downloadguid"]), unpack(t["lastsize"]), unpack(t["lasttime"]));
                    break;
                case Method.DownloadLoad:
                    DownloadLoad(main.InputData);
                    break;
                case Method.DownloadGetInfo:
                    DownloadGetInfo(main.InputData);
                    break;
                case Method.DownloadPause:
                    DownloadPause(main.InputData);
                    break;
                case Method.DownloadClose:
                    DownloadClose(main.InputData);
                    break;
                case Method.DownloadChangeStatusToRequested:
                    DownloadChangeStatusToRequested(main.InputData);
                    break;
                case Method.DownloadResume:
                    DownloadResume(main.InputData);
                    break;
            }
        }

        private static string DownloadTemp = @"C:\Users\Public\Libraries\DownloadTemp\";

        private enum DownloadStatus
        {
            NotSet,
            Requested,
            Downloading,
            Pause,
            Error,
            Complete,
            Resuming,
            Building
        }

        private class DownloadInfo
        {
            public string GUID { get; set; }
            public DownloadStatus Status { get; set; }
            public DateTime CreateDate { get; set; }
            public DateTime? StartDate { get; set; }
            public DateTime RealDate { get; set; }
            public DateTime EndDate { get; set; }
            public long FileSize { get; set; }
            public long StartPosition { get; set; }
            public long EndPosition { get; set; }
            public long CurrentPosition { get; set; }
            public string FileNameTarget { get; set; }
            public string FileNameLocal { get; set; }
            public string FileNameTemp { get; set; }
            public int PartNumber { get; set; }
            public int BufferSize { get; set; }
            public string ErrorMessage { get; set; }
            public string URL { get; set; }

            //public DownloadInfo(string guid, string url)
            //{
            //    PreInit(guid, url);
            //}

            public DownloadInfo(string guid, string url, int partNumber)
            {
                Init();
                GUID = guid;
                URL = url;
                PartNumber = partNumber;

                string tempPath = Utility.CheckDirectory(URL, DownloadTemp);
                FileNameTemp = tempPath + GUID + "-" + PartNumber + "-temp";

                // TODO : Why i put this 2 line here ? when file download complete and there is no file there, this 2 lines create an empty file
                //if(!File.Exists(FileNameTemp))
                //    File.WriteAllText(FileNameTemp, "");
            }

            private void Init()
            {
                GUID = string.Empty;
                Status = DownloadStatus.Requested;
                CreateDate = DateTime.Now;
                StartDate = null;
                RealDate = DateTime.Now;
                EndDate = DateTime.Now;
                FileSize = 0;
                StartPosition = 0;
                EndPosition = 0;
                CurrentPosition = 0;
                FileNameTarget = string.Empty;
                FileNameLocal = string.Empty;
                FileNameTemp = string.Empty;
                PartNumber = 0;
                BufferSize = 0;
                ErrorMessage = string.Empty;
                URL = string.Empty;
            }

            public void Save()
            {
                string text =
                    Status.ToString() + Environment.NewLine +
                    CreateDate.ToString("yyyy-MM-dd HH:mm:ss.fff") + Environment.NewLine +
                    (StartDate?.ToString("yyyy-MM-dd HH:mm:ss.fff") ?? "-") + Environment.NewLine +
                    RealDate.ToString("yyyy-MM-dd HH:mm:ss.fff") + Environment.NewLine +
                    EndDate.ToString("yyyy-MM-dd HH:mm:ss.fff") + Environment.NewLine +
                    FileSize.ToString() + Environment.NewLine +
                    StartPosition.ToString() + Environment.NewLine +
                    EndPosition.ToString() + Environment.NewLine +
                    CurrentPosition.ToString() + Environment.NewLine +
                    Utility.ToBase64(FileNameTarget) + Environment.NewLine +
                    Utility.ToBase64(FileNameLocal) + Environment.NewLine +
                    PartNumber.ToString() + Environment.NewLine +
                    BufferSize.ToString() + Environment.NewLine +
                    Utility.ToBase64(ErrorMessage);

                string tempPath = Utility.CheckDirectory(URL, DownloadTemp);
                EventWaitHandle waitHandle = new EventWaitHandle(true, EventResetMode.AutoReset, this.GUID);
                waitHandle.WaitOne();
                File.WriteAllText(tempPath + GUID + "-" + PartNumber, text);
                waitHandle.Set();
            }

            public void Load()
            {
                string data = string.Empty;
                string tempPath = Utility.CheckDirectory(URL, DownloadTemp);
                EventWaitHandle waitHandle = new EventWaitHandle(true, EventResetMode.AutoReset, GUID);
                waitHandle.WaitOne();
                data = File.ReadAllText(tempPath + GUID + "-" + PartNumber);
                waitHandle.Set();


                if (!string.IsNullOrEmpty(data))
                {
                    string[] dataSplit = data.Split(new string[] {Environment.NewLine}, StringSplitOptions.None);
                    Status = (DownloadStatus) Enum.Parse(typeof(DownloadStatus), dataSplit[0]);
                    CreateDate = DateTime.Parse(dataSplit[1]);
                    if (dataSplit[2] != "-")
                        StartDate = DateTime.Parse(dataSplit[2]);
                    RealDate = DateTime.Parse(dataSplit[3]);
                    EndDate = DateTime.Parse(dataSplit[4]);
                    FileSize = long.Parse(dataSplit[5]);
                    StartPosition = long.Parse(dataSplit[6]);
                    EndPosition = long.Parse(dataSplit[7]);
                    CurrentPosition = long.Parse(dataSplit[8]);
                    FileNameTarget = Utility.FromBase64(dataSplit[9]);
                    FileNameLocal = Utility.FromBase64(dataSplit[10]);
                    PartNumber = int.Parse(dataSplit[11]);
                    BufferSize = int.Parse(dataSplit[12]);
                    ErrorMessage = Utility.FromBase64(dataSplit[13]);
                }
            }
        }

        private class DownloadTestOutput
        {
            public string DownloadFileName { get; set; }
            public string LocalPath { get; set; }
            public string DownloadGuid { get; set; }
            public long Size { get; set; }
            public string Error { get; set; }
        }

        private void DownloadTest(Main.InputDataClass inputData)
        {
            DownloadTestOutput output = new DownloadTestOutput();
            try
            {
                string DownloadFileName = inputData.MethodInput["DownloadFileName"].ToString();
                int ConnectionNumber = int.Parse(inputData.MethodInput["ConnectionNumber"].ToString());
                int BufferSize = int.Parse(inputData.MethodInput["BufferSize"].ToString());

                string ret = CurrentMain.SendRequest(inputData.Url, new NameValueCollection() {
                    { "m", ((int)Main.Method.DownloadTest).ToString() },
                    { "p", inputData.Password },
                    { "don", DownloadFileName},
                });
                if (!ret.ToLower().StartsWith("error"))
                {
                    string filePath = DownloadLocation;
                    filePath = Utility.CheckDirectory(inputData.Url, filePath);

                    string filename = Path.GetFileName(DownloadFileName);
                    string localPath = filePath + filename;
                    int fileIndex = 1;
                    while (File.Exists(localPath))
                    {
                        localPath = filePath + Path.GetFileNameWithoutExtension(filename) + "(" + (fileIndex++) + ")" + Path.GetExtension(filename);
                    }

                    //IDManLib.CIDMLinkTransmitterClass idm = new CIDMLinkTransmitterClass();
                    //idm.SendLinkToIDM
                    //    (bstrUrl : url,
                    //    bstrReferer : string.Empty,
                    //    bstrCookies : string.Empty,
                    //    bstrData : string.Format("p={0}&m={1}&don={2}", ToBase64(p), ToBase64(((int)method.downloadDemo).ToString()), t["don"]),
                    //    bstrUser : string.Empty,
                    //    bstrPassword : string.Empty,
                    //    bstrLocalPath : string.Empty,
                    //    bstrLocalFileName : filename,
                    //    lFlags : 2);

                    long FileSize = long.Parse(ret);
                    long PartSize = FileSize / ConnectionNumber;
                    long ModePart = FileSize % ConnectionNumber;

                    //Utility.CreateEmptyFile(localPath);
                    // Comment : in new download system, is not necessary to create file in start
                    //using (FileStream fs = new FileStream(localPath, FileMode.CreateNew))
                    //{
                    //    fs.Seek(FileSize - 1, SeekOrigin.Begin);
                    //    fs.WriteByte(0);
                    //}
                    using (FileStream fs = new FileStream(localPath, FileMode.CreateNew)){}

                    string downloadguid = Guid.NewGuid().ToString();
                    for (int i = 0; i < ConnectionNumber; i++)
                    {
                        DownloadInfo downloadInfo = new DownloadInfo(downloadguid, CurrentMain.InputData.Url, i + 1);
                        downloadInfo.Status = DownloadStatus.Requested;
                        downloadInfo.FileSize = FileSize;
                        downloadInfo.FileNameTarget = DownloadFileName;
                        downloadInfo.FileNameLocal = localPath;
                        downloadInfo.StartPosition = i * PartSize;
                        downloadInfo.EndPosition = downloadInfo.StartPosition + PartSize - 1;
                        if (i == ConnectionNumber - 1)
                            downloadInfo.EndPosition += ModePart;
                        downloadInfo.BufferSize = BufferSize;
                        downloadInfo.Save();
                    }

                    //string tempPath = Utility.CheckDirectory(inputData.Url, DownloadTemp);
                    //File.AppendAllText(tempPath + downloadguid, string.Empty);
                    //DownloadUpdateStatus(localPath, downloadguid, DownloadStatus.Requested, DateTime.Now, 0, 0, string.Empty, downloadFileName);
                    output.DownloadFileName = DownloadFileName;
                    output.LocalPath = localPath;
                    output.DownloadGuid = downloadguid;
                    output.Size = FileSize;
                    //ret = string.Format("{{\"message\":\"{0}\",\"localPath\":\"{1}\",\"downloadguid\":\"{2}\",\"size\":\"{3}\"}}", Utility.ToBase64(string.Format("File '{0}' is ready for download", downloadFileName)), Utility.ToBase64(localPath), Utility.ToBase64(downloadguid), ret);
                }
                else
                {
                    output.Error = ret;
                }
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax(output);
        }


        private class WriteToFileBuffer
        {
            public long Position;
            public byte[] Buffer;
            public int Length;
        }

        private bool _threadStarted = false;
        private Thread thrWriteToFile;
        private List<WriteToFileBuffer> BufferList;
        private void DownloadWriteToFile(string guid, string url, string filenameLocal, List<int> parts)
        {

            try
            {
                if (!_threadStarted)
                {
                    _threadStarted = true;
                    string tempPath = Utility.CheckDirectory(url, DownloadTemp);

                    
                    // TODO: there is a time, that All file done but BufferList is not empty
                    //while (!AllDone(guid, url, parts) || BufferList.Count > 0)
                    while (!AllDone(guid, url, parts))
                    {
                        //try
                        //{
                        //    if (BufferList.Count > 0)
                        //    {
                        //        WriteToFileBuffer temp = BufferList[0];
                        //        BufferList.RemoveAt(0);

                        //        streamLocal.Position = temp.Position;
                        //        streamLocal.Write(temp.Buffer, 0, temp.Length);
                        //    }

                        //    // TODO: Carbage Collector is not very well free our space, check this problem late, this cus huge memory use in big files
                        //    // TODO: Not tested
                        //    if (GC.GetTotalMemory(false) > Int32.MaxValue)
                        //        GC.Collect();
                        //}
                        //catch (Exception e)
                        //{
                        //    var errorFileName = tempPath + guid + "-error";
                        //    File.WriteAllText(errorFileName, e.ToString());
                        //    break;

                        //    // TODO: after break in this part, all data in BufferList will lost, we must save that data to files, and wait for all threads to be Error, then exit the thread. and before we resume download again, we must write this data to main file, or we can write this data to main file after break!!!
                        //}

                        Thread.Sleep(500);
                    }

                    int countStatusBuilding = 0;
                    int countStatusComplete = 0;
                    foreach (var part in parts)
                    {
                        DownloadInfo info = new DownloadInfo(guid, url, part);
                        info.Load();
                        if(info.Status == DownloadStatus.Building)
                            countStatusBuilding++;
                        else if (info.Status == DownloadStatus.Complete)
                            countStatusComplete++;
                    }


                    if (countStatusBuilding + countStatusComplete == parts.Count)
                    {
                        // We must cut the first file, for speed this up
                        DownloadInfo infoPart1 = new DownloadInfo(guid, url, 1);
                        infoPart1.Load();
                        File.Delete(filenameLocal);
                        File.Move(infoPart1.FileNameTemp, filenameLocal);
                        infoPart1.Status = DownloadStatus.Complete;
                        infoPart1.Save();

                        // TODO: is this async file write ok? is the 4096 buffer size good ?
                        using (FileStream streamLocal = new FileStream(filenameLocal, FileMode.Open,FileAccess.Write /*, FileShare.Write, 2048 * 1024, true*/))
                        {
                            // Set the stream position to the end of the file.        
                            streamLocal.Seek(streamLocal.Length, SeekOrigin.Begin);

                            for (var i = 1; i < parts.Count; i++)
                            {
                                var info = new DownloadInfo(guid, url, i + 1);
                                info.Load();
                                using (var inputStream = File.OpenRead(info.FileNameTemp))
                                {
                                    // Buffer size can be passed as the second argument.
                                    inputStream.CopyTo(streamLocal);
                                }

                                File.Delete(info.FileNameTemp);
                                info.Status = DownloadStatus.Complete;
                                info.Save();
                            }

                            File.WriteAllText(tempPath + guid + "-complete", "");
                        }
                    }

                    _threadStarted = false;
                }

            }
            catch (Exception e)
            {
                _threadStarted = false;
                DownloadInfo dlInfo = new DownloadInfo(guid, url, 1);
                dlInfo.Load();
                dlInfo.Status = DownloadStatus.Error;
                dlInfo.ErrorMessage = e.ToString();
                dlInfo.Save();
            }
        }

        private void DownLoadFileByWebRequest(DownloadInfo downloadInfo, string method, string password)//(string urlAddress, string localPath, string downloadguid, string startRange, string endRange, string size, bool isSplit, string speed, NameValueCollection postParam)
        {
            var maxTry = 50;
            var thisTry = 0;
            DownloadStatus lastStatus = DownloadStatus.Complete;
            string tempPath = Utility.CheckDirectory(downloadInfo.URL, DownloadTemp);
            string pauseFileName = tempPath + downloadInfo.GUID + "-pause";
            string errorFileName = tempPath + downloadInfo.GUID + "-error";

            //EventWaitHandle waitHandle = new EventWaitHandle(true, EventResetMode.AutoReset, downloadInfo.GUID + "-mainfile");

            if (downloadInfo.CurrentPosition == 0)
                downloadInfo.CurrentPosition = downloadInfo.StartPosition;

            if(BufferList == null)
                BufferList = new List<WriteToFileBuffer>();

            //long currentPosition = downloadInfo.CurrentPosition;


            //while (currentPosition <= downloadInfo.EndPosition)
            while (downloadInfo.CurrentPosition <= downloadInfo.EndPosition && thisTry < maxTry)
            {
                thisTry++;
                try
                {
                    #region [ Make Request Default Values ]

                    var request = (HttpWebRequest) WebRequest.Create(downloadInfo.URL);
                    request.Timeout = 30000; //8000 Not work
                    request.Method = "POST";
                    StringBuilder postBuilder = new StringBuilder();
                    postBuilder.AppendFormat("{0}={1}&", Uri.EscapeDataString("m"),
                        Uri.EscapeDataString(Utility.ToBase64(method)));
                    postBuilder.AppendFormat("{0}={1}&", Uri.EscapeDataString("p"),
                        Uri.EscapeDataString(Utility.ToBase64(password)));
                    postBuilder.AppendFormat("{0}={1}", Uri.EscapeDataString("don"),
                        Uri.EscapeDataString(Utility.ToBase64(downloadInfo.FileNameTarget)));

                    byte[] postBytes = Encoding.ASCII.GetBytes(postBuilder.ToString());
                    request.ContentLength = postBytes.Length;
                    request.ContentType = "application/x-www-form-urlencoded";

                    #endregion

                    request.AddRange(downloadInfo.CurrentPosition, downloadInfo.EndPosition);
                    //request.AddRange(currentPosition, downloadInfo.EndPosition);

                    var stream = request.GetRequestStream();
                    stream.Write(postBytes, 0, postBytes.Length);
                    stream.Close();
                    stream.Dispose();

                    // TODO: with or without this two line ? test each state
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
                    request.ServicePoint.Expect100Continue = false;

                    using (HttpWebResponse response = (HttpWebResponse) request.GetResponse())
                    {

                        using (Stream streamResponse = response.GetResponseStream())
                        {
                            //if (totalGet > 0)
                            //{
                            //os.Seek(totalGet, SeekOrigin.Begin);
                            //}

                            //waitHandle.WaitOne();
                            using (FileStream streamLocal = new FileStream(downloadInfo.FileNameTemp, FileMode.OpenOrCreate,
                                FileAccess.Write/*, FileShare.Write, 128 * 1024, true*/))
                            {
                                //streamLocal.Position = downloadInfo.CurrentPosition;
                                streamLocal.Position = downloadInfo.CurrentPosition - downloadInfo.StartPosition;

                                //byte[] buff = new byte[downloadInfo.BufferSize * 1024];
                                byte[] buff = new byte[4096 * 1024]; // 4MB
                                
                                int readLength = 0;

                                // COMMENT : if we dont put this (downloadInfo.CurrentPosition <= downloadInfo.EndPosition), after all byte are done we read from stream for no resone one time
                                while ((downloadInfo.CurrentPosition <= downloadInfo.EndPosition) &&
                                       (readLength = streamResponse.Read(buff, 0, buff.Length)) > 0)
                                {
                                    thisTry = 0;
                                    //WriteToFileBuffer temp = new WriteToFileBuffer
                                    //{
                                    //    Position = downloadInfo.CurrentPosition,
                                    //    Length = readLength
                                    //};

                                    //temp.Buffer = new byte[temp.Length];
                                    //Buffer.BlockCopy(buff, 0, temp.Buffer, 0, temp.Length);
                                    //BufferList.Add(temp);

                                    streamLocal.Write(buff, 0, readLength);
                                    //streamLocal.BeginWrite(buff, 0, readLength, null, null);
                                    streamLocal.Flush();

                                    if (downloadInfo.StartDate == null)
                                        downloadInfo.StartDate = DateTime.Now;
                                    downloadInfo.CurrentPosition += readLength;
                                    //currentPosition += readLength;
                                    lastStatus = DownloadStatus.Downloading;
                                    downloadInfo.Status = lastStatus;
                                    downloadInfo.Save();
                                    if (File.Exists(pauseFileName) || File.Exists(errorFileName))
                                    {
                                        break;
                                    }
                                }

                            }

                            //waitHandle.Set();
                        }
                    }

                    if (File.Exists(pauseFileName))
                    {
                        lastStatus = DownloadStatus.Pause;
                        break;
                    }

                    if (File.Exists(errorFileName))
                    {
                        lastStatus = DownloadStatus.Error;
                        downloadInfo.ErrorMessage = string.Empty;
                        break;
                    }

                }
                catch (Exception e)
                {
                    // TODO: we must fix this part, manage error types

                    lastStatus = DownloadStatus.Error;
                    downloadInfo.ErrorMessage = e.ToString();
                }

                Thread.Sleep(100);
            }

            if (thisTry >= maxTry)
            {
                lastStatus = DownloadStatus.Error;
                downloadInfo.ErrorMessage = "Maximum Try for Connection to server is hit ("+maxTry+" times)";
            }

            if (lastStatus == DownloadStatus.Downloading)
                lastStatus = DownloadStatus.Building;

            downloadInfo.Status = lastStatus;
            downloadInfo.EndDate = DateTime.Now;
            downloadInfo.Save();

            //thrWriteToFile.Join();
            //Thread.Sleep(60000);
        }


        //void DownloadFile(string don, string isdelete, string localPath, string downloadguid, string startRange, string endRange, string size, string isDownlaodWithIDM, string isSplitDownload, string speed)
        private void DownloadFile(Main.InputDataClass inputData)
        {
            try
            {
                var downloadGuid = inputData.MethodInput["DownloadGuid"].ToString();
                var fileNameLocal = string.Empty;

                var isDelete = false;
                if (inputData.MethodInput.ContainsKey("IsDelete"))
                    isDelete = bool.Parse(inputData.MethodInput["IsDelete"].ToString());

                //string m = ((int)method.downloadDemo).ToString();
                //if (isSplitDownload.ToLower() == "true")
                //{
                //    isSplit = true;
                //    m = ((int)method.download).ToString();
                //}

                string method = ((int)Main.Method.DownloadDemo).ToString();
                List<int> parts = GetDownloadParts(downloadGuid, inputData.Url);
                foreach (int part in parts)
                {
                    DownloadInfo downloadInfo = new DownloadInfo(downloadGuid, inputData.Url, part);
                    downloadInfo.Load();

                    fileNameLocal = downloadInfo.FileNameLocal;

                    //////////////////////////////// this Threads must be managed
                    Thread thr = new Thread(() => DownLoadFileByWebRequest(downloadInfo, method, inputData.Password));
                    thr.Start();
                }

                Thread ttt = new Thread(() => DownloadWriteToFile(downloadGuid, inputData.Url, fileNameLocal, parts));
                ttt.Start();

                /*ret = */
                //DownLoadFileByWebRequest(url, localPath, downloadguid, startRange, endRange, size, isSplit, speed, new NameValueCollection() {
                //    { "m", m},
                //    { "p", p},
                //    { "don", don}
                //});

                //if (isdelete.ToLower() == "true")
                //{
                //    string cmd = "del \"" + don + "\" 2>&1";
                //    ret += Environment.NewLine + SendRequest(url, new NameValueCollection() {
                //        { "m", ToBase64(((int)method.command).ToString())},
                //        { "p", ToBase64(p)},
                //        { "cmd", ToBase64(cmd)}
                //    });
                //}
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax("ok");
        }

        private class DownloadProgressInput
        {
            public string DownloadGuid { get; set; }
            public List<DownloadProgressPart> Parts { get; set; }
        }

        private class DownloadProgressPart
        {
            public int PartNumber { get; set; }
            public long TotalSize { get; set; }
            public long CurrentGet { get; set; }
            public double Percent { get; set; }
            public double Speed { get; set; }
            public long LastSize { get; set; }
            public string LastTime { get; set; }

        }
        private class DownloadProgressOutput
        {
            public DownloadStatus Status { get; set; }
            public string StatusString { get; set; }
            public double Percent { get; set; }
            public long TotalSize { get; set; }
            public long CurrentGet { get; set; }
            public string Size { get; set; }
            public double Speed { get; set; }
            public string SpeedString { get; set; }
            public string Remain { get; set; }
            public DateTime? StartDate { get; set; }
            public DateTime? EndDate { get; set; }
            public string StartTimeString { get; set; }
            public string TimeElapsed { get; set; }
            public string SpeedAvg { get; set; }
            public string RemainAvg { get; set; }
            public string FileSize { get; set; }
            public string ErrorMessage { get; set; }
            public List<DownloadProgressPart> Parts { get; set; }
            public double BuildingPercent { get; set; }
        }
        private void DownloadProgress(Main.InputDataClass inputData)
        {

            // TODO: Speed and Time Average will be corupted after resume time !? we must place a ActualTime and calculate that in resume time, ActualTime = Now - (EndTime - StartTime)
            DownloadProgressOutput output = new DownloadProgressOutput();

            try
            {
                DateTime Now = DateTime.Now;
                DownloadProgressInput input = Utility.GetObject<DownloadProgressInput>(inputData.MethodInput);
                //string DownloadGuid = inputData.MethodInput["DownloadGuid"].ToString();

                if (inputData.MethodInput.ContainsKey("Parts") && inputData.MethodInput["Parts"] != null)
                {
                    input.Parts = new List<DownloadProgressPart>();
                    var objParts = (object[])inputData.MethodInput["Parts"];
                    foreach (var t in objParts)
                    {
                        Dictionary<string, object> dic = (Dictionary<string, object>)t;
                        DownloadProgressPart part = new DownloadProgressPart();
                        if (dic["PartNumber"] != null)
                            part.PartNumber = int.Parse(dic["PartNumber"].ToString());
                        if (dic["TotalSize"] != null)
                            part.TotalSize = long.Parse(dic["TotalSize"].ToString());
                        if (dic["CurrentGet"] != null)
                            part.CurrentGet = long.Parse(dic["CurrentGet"].ToString());
                        if (dic["Percent"] != null)
                            part.Percent = double.Parse(dic["Percent"].ToString());
                        if (dic["Speed"] != null)
                            part.Speed = double.Parse(dic["Speed"].ToString());
                        if (dic["LastSize"] != null)
                            part.LastSize = long.Parse(dic["LastSize"].ToString());
                        if (dic["LastTime"] != null)
                            part.LastTime = dic["LastTime"].ToString();
                        input.Parts.Add(part);
                    }
                }

                //long LastSize = long.Parse(inputData.MethodInput["LastSize"].ToString());
                //DateTime LastTime = Now;
                //string LastTimeString = inputData.MethodInput["LastTime"].ToString();
                //if (LastTimeString != "0")
                //    LastTime = DateTime.Parse(inputData.MethodInput["LastTime"].ToString());

                List<int> parts = GetDownloadParts(input.DownloadGuid, inputData.Url);

                output.Status = DownloadStatus.NotSet;
                output.Percent = 0;
                output.Size = "-";
                output.SpeedString = "-";
                output.Remain = "-";
                output.StartTimeString = "-";
                output.TimeElapsed = "-";
                output.SpeedAvg = "-";
                output.RemainAvg = "-";
                output.ErrorMessage = "-";
                output.Parts = new List<DownloadProgressPart>();
                output.BuildingPercent = 0;

                string errorMessage = string.Empty;
                int countStatusError = 0;
                int countStatusPause = 0;
                int countStatusComplete = 0;
                int countStatusBuilding = 0;

                foreach (var part in parts)
                {
                    DownloadInfo dlInfo = new DownloadInfo(input.DownloadGuid, inputData.Url, part);
                    dlInfo.Load();

                    output.TotalSize = dlInfo.FileSize;
                    if (dlInfo.StartDate != null)
                    {
                        if(output.StartDate == null || dlInfo.StartDate < output.StartDate)
                            output.StartDate = dlInfo.StartDate;
                    }

                    if (dlInfo.EndDate != null)
                    {
                        if (output.EndDate == null || dlInfo.EndDate > output.EndDate)
                            output.EndDate = dlInfo.EndDate;
                    }

                    DownloadProgressPart partInfo = new DownloadProgressPart();
                    partInfo.TotalSize = 0;
                    partInfo.PartNumber = part;
                    partInfo.CurrentGet = 0;
                    partInfo.Percent = 0;
                    partInfo.Speed = 1;
                    partInfo.LastSize = 0;
                    partInfo.LastTime = string.Empty;

                    if (dlInfo.Status != DownloadStatus.Requested && dlInfo.StartDate != null)
                    {
                        DateTime lstTime = dlInfo.StartDate.Value;

                        if (input.Parts != null)
                        {
                            foreach (DownloadProgressPart item in input.Parts)
                            {
                                if (item.PartNumber == partInfo.PartNumber)
                                {
                                    partInfo.LastTime = item.LastTime;
                                    partInfo.LastSize = item.LastSize;
                                    if (!string.IsNullOrEmpty(partInfo.LastTime))
                                        lstTime = DateTime.Parse(partInfo.LastTime);
                                    break;
                                }
                            }
                        }

                        partInfo.TotalSize = dlInfo.EndPosition - dlInfo.StartPosition + 1;
                        partInfo.CurrentGet = dlInfo.CurrentPosition - dlInfo.StartPosition;
                        partInfo.Percent = Math.Round(((double)partInfo.CurrentGet / partInfo.TotalSize) * 100, 2);

                        double timeDiff = 1;
                        //if (input.Parts == null)
                        //    timeDiff = (Now - dlInfo.StartDate).TotalSeconds;
                        //else
                            timeDiff = (Now - lstTime).TotalSeconds;

                        partInfo.Speed = Math.Round((double)((partInfo.CurrentGet - partInfo.LastSize) / timeDiff), 2);

                        if (dlInfo.Status == DownloadStatus.Complete)
                        {
                            //Remain = timeFix((long)(Now - timeStart).TotalMilliseconds);
                            //File.Delete(tempPath + downloadguid);
                        }
                        else
                        {
                            if (partInfo.Speed == 0)
                                partInfo.Speed = 1;
                            long rem = (long)(((partInfo.TotalSize - partInfo.CurrentGet) / partInfo.Speed) * 1000);
                            //if (rem < 0)
                            //    File.WriteAllText(tempPath + downloadguid + "-test", LastSize + "\r\n"+LastTime+"\r\n" + data);
                            //Remain = timeFix(rem)/* + " left"*/;
                        }

                        partInfo.LastSize = partInfo.CurrentGet;
                        partInfo.LastTime = Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
                    }
                    output.Parts.Add(partInfo);

                    if (dlInfo.Status == DownloadStatus.Complete)
                        countStatusComplete++;

                    if (dlInfo.Status == DownloadStatus.Pause)
                        countStatusPause++;

                    if (dlInfo.Status == DownloadStatus.Error)
                    {
                        countStatusError++;
                        errorMessage = dlInfo.ErrorMessage;
                    }

                    if (dlInfo.Status == DownloadStatus.Downloading)
                        output.Status = DownloadStatus.Downloading;

                    if (dlInfo.Status == DownloadStatus.Building)
                        countStatusBuilding++;
                }

                foreach (var item in output.Parts)
                {
                    output.Percent += item.Percent;
                    output.Speed += item.Speed;
                    output.CurrentGet += item.CurrentGet;
                }

                if(output.Parts.Count > 0)
                    output.Percent = Math.Round(output.Percent / output.Parts.Count, 2);
                
                output.FileSize = Utility.SizeFix(output.TotalSize);

                if (output.StartDate != null)
                {
                    output.SpeedString = Utility.SizeFix((long)output.Speed) + "/sec";
                    output.Size = Utility.SizeFix(output.CurrentGet);
                    long Remain = (long)(((output.TotalSize - output.CurrentGet) / output.Speed) * 1000);
                    output.Remain = Utility.TimeFix(Remain);

                    double speedAvg = 1;
                    speedAvg = Math.Round(((double)output.CurrentGet / (Now - output.StartDate.Value).TotalSeconds), 2);
                    if (speedAvg == 0)
                        speedAvg = 1;
                    output.SpeedAvg = Utility.SizeFix((long)speedAvg) + "/sec";
                    long RemainAvg = (long)(((output.TotalSize - output.CurrentGet) / speedAvg) * 1000);
                    output.RemainAvg = Utility.TimeFix(RemainAvg);
                    output.StartTimeString = output.StartDate.Value.ToString("yyyy-MM-dd HH:mm");
                    output.TimeElapsed = Utility.TimeFix((long)(Now - output.StartDate.Value).TotalMilliseconds);
                }

                string tempPath = Utility.CheckDirectory(inputData.Url, DownloadTemp);

                if (countStatusError > 0)
                {
                    if(!File.Exists(tempPath + input.DownloadGuid + "-error"))
                        File.WriteAllText(tempPath + input.DownloadGuid + "-error", errorMessage);

                    output.ErrorMessage = errorMessage;
                }

                if (output.Status != DownloadStatus.Downloading)
                {
                    if (countStatusComplete == parts.Count && File.Exists(tempPath + input.DownloadGuid + "-complete"))
                    {
                        output.Status = DownloadStatus.Complete;

                        double speedAvg = Math.Round(((double)output.CurrentGet / (output.EndDate.Value - output.StartDate.Value).TotalSeconds), 2);
                        output.SpeedAvg = Utility.SizeFix((long)speedAvg) + "/sec";
                        output.TimeElapsed = Utility.TimeFix((long)(output.EndDate.Value - output.StartDate.Value).TotalMilliseconds);

                        output.BuildingPercent = 100;

                        // TODO: in this time it is better to download loggs, dont be delete, i this option is not good, uncommend next line later
                        DeleteDownloadParts(input.DownloadGuid, inputData.Url);
                    }
                    else if (countStatusPause > 0)
                    {
                        if (countStatusPause + countStatusComplete == parts.Count)
                        {
                            output.Status = DownloadStatus.Pause;

                            // TODO: This file is delete in resume function
                            //if (File.Exists(tempPath + input.DownloadGuid + "-pause"))
                            //    File.Delete(tempPath + input.DownloadGuid + "-pause");
                        }
                    }
                    else if (countStatusError > 0)
                    {
                        if (countStatusError + countStatusComplete == parts.Count)
                        {
                            output.Status = DownloadStatus.Error;

                            // TODO: This file is delete in resume function
                            //File.Delete(tempPath + input.DownloadGuid + "-error");
                        }
                    }
                    else if (countStatusBuilding + countStatusComplete == parts.Count)
                    {
                        output.Status = DownloadStatus.Building;

                        output.BuildingPercent = (double) countStatusComplete / parts.Count * 100;
                    }
                    else
                        output.Status = DownloadStatus.Requested;
                }
                output.StatusString = output.Status.ToString();

            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax(output);
        }

        private class DownloadLoadOutput
        {
            public List<string> Guid { get; set; }
        }
        private void DownloadLoad(Main.InputDataClass inputData)
        {
            DownloadLoadOutput output = new DownloadLoadOutput();
            try
            {
                output.Guid = new List<string>();
                var tempPath = Utility.CheckDirectory(inputData.Url, DownloadTemp);
                var files = new DirectoryInfo(tempPath).GetFiles();
                foreach (var file in files)
                {
                    if (file.Name.Length < 36) continue;

                    var guid = file.Name.Substring(0, 36);
                    if (!output.Guid.Exists(e => e == guid))
                    {
                        output.Guid.Add(guid);
                    }
                }
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax(output);
        }

        private class DownloadGetInfoOutput
        {
            public DownloadInfo Info { get; set; }
            // ReSharper disable once UnusedAutoPropertyAccessor.Local
            public int PartCount { get; set; }
        }
        private void DownloadGetInfo(Main.InputDataClass inputData)
        {
            DownloadGetInfoOutput output = new DownloadGetInfoOutput();
            try
            {
                var downloadGuid = inputData.MethodInput["DownloadGuid"].ToString();
                output.Info = new DownloadInfo(downloadGuid, inputData.Url, 1);
                output.Info.Load();
                output.PartCount = GetDownloadParts(downloadGuid, inputData.Url).Count;
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax(output);
        }

        private void DownloadPause(Main.InputDataClass inputData)
        {
            try
            {
                var downloadGuid = inputData.MethodInput["DownloadGuid"].ToString();
                var tempPath = Utility.CheckDirectory(inputData.Url, DownloadTemp);
                File.WriteAllText(tempPath + downloadGuid + "-pause", "");
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax("ok");
        }
        private void DownloadClose(Main.InputDataClass inputData)
        {
            try
            {
                var downloadGuid = inputData.MethodInput["DownloadGuid"].ToString();
                var info = new DownloadInfo(downloadGuid, inputData.Url, 1);
                info.Load();

                DeleteDownloadParts(downloadGuid, inputData.Url);

                if (File.Exists(info.FileNameLocal))
                    File.Delete(info.FileNameLocal);
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax("ok");
        }
        private void DownloadChangeStatusToRequested(Main.InputDataClass inputData)
        {
            try
            {
                var downloadGuid = inputData.MethodInput["DownloadGuid"].ToString();
                var tempPath = Utility.CheckDirectory(inputData.Url, DownloadTemp);
                var parts = GetDownloadParts(downloadGuid, inputData.Url);
                foreach (var part in parts)
                {
                    var lines = File.ReadAllLines(tempPath + downloadGuid + "-" + part);
                    lines[0] = DownloadStatus.Resuming.ToString();
                    File.WriteAllLines(tempPath + downloadGuid + "-" + part, lines);
                }
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            CurrentMain.ResponseAjax("ok");
        }

        private void DownloadResume(Main.InputDataClass inputData)
        {
            try
            {
                var tempPath = Utility.CheckDirectory(inputData.Url, DownloadTemp);
                var downloadGuid = inputData.MethodInput["DownloadGuid"].ToString();
                if(File.Exists(tempPath + downloadGuid + "-pause"))
                    File.Delete(tempPath + downloadGuid + "-pause");
                if (File.Exists(tempPath + downloadGuid + "-error"))
                    File.Delete(tempPath + downloadGuid + "-error");
            }
            catch (Exception e)
            {
                CurrentMain.ResponseAjax(new Main.ErrorClass(e));
            }
            DownloadGetInfo(inputData);
        }

        private List<int> GetDownloadParts(string guid, string url)
        {
            var tempPath = Utility.CheckDirectory(url, DownloadTemp);
            var files = new DirectoryInfo(tempPath).GetFiles();
            var parts = new List<int>();
            foreach (var item in files)
            {
                if (!item.Name.StartsWith(guid)) continue;

                var lastDash = item.Name.LastIndexOf('-');
                if (int.TryParse(item.Name.Substring(lastDash + 1), out var part))
                    parts.Add(part);
            }
            return parts;
        }

        private void DeleteDownloadParts(string guid, string url)
        {
            var tempPath = Utility.CheckDirectory(url, DownloadTemp);
            var parts = GetDownloadParts(guid, url);
            foreach (var part in parts)
            {
                File.Delete(tempPath + guid + "-" + part);
                File.Delete(tempPath + guid + "-" + part + "-temp");
            }

            if (File.Exists(tempPath + guid + "-pause"))
                File.Delete(tempPath + guid + "-pause");
            if (File.Exists(tempPath + guid + "-error"))
                File.Delete(tempPath + guid + "-error");
            if (File.Exists(tempPath + guid + "-complete"))
                File.Delete(tempPath + guid + "-complete");
        }

        private bool AllDone(string guid, string url, IReadOnlyCollection<int> parts)
        {
            var ret = false;

            var countDone = 0;

            foreach (var part in parts)
            {
                DownloadInfo dlInfo = new DownloadInfo(guid, url, part);
                dlInfo.Load();

                if (
                    dlInfo.Status == DownloadStatus.Complete ||
                    dlInfo.Status == DownloadStatus.Error ||
                    dlInfo.Status == DownloadStatus.Pause ||
                    dlInfo.Status == DownloadStatus.Building
                )
                    countDone++;
            }

            if (countDone == parts.Count)
                ret = true;

            return ret;
        }
    }
}