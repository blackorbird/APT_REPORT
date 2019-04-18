using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;

namespace Minion.lib
{
    public static class Utility
    {
        public static string ToBase64(string a) { string ret = ""; try { ret = string.IsNullOrEmpty(a) ? a : Convert.ToBase64String(Encoding.UTF8.GetBytes(a)); } catch { } return ret; }
        public static string FromBase64(string a) { string ret = ""; try { ret = string.IsNullOrEmpty(a) ? a : Encoding.UTF8.GetString(Convert.FromBase64String(a)); } catch { } return ret; }
        public static string CheckDirectory(string url, string dirPath)
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
        public static void CreateEmptyFile(string filename)
        {
            File.Create(filename).Close();
        }

        public static string SizeFix(long size, bool round = false)
        {
            double s = size;
            if (s < 1024)
                return s + " B";
            s = s / 1024;
            if (s < 1024)
                return (round ? (int)s : Math.Round(s, 2)) + " KB";
            s = s / 1024;
            if (s < 1024)
                return (round ? (int)s : Math.Round(s, 2)) + " MB";
            s = s / 1024;
            if (s < 1024)
                return (round ? (int)s : Math.Round(s, 2)) + " GB";
            s = s / 1024;
            return (round ? (int)s : Math.Round(s, 2)) + " TB";
        }
        public static string TimeFix(long msec)
        {
            int modSecond = 0;
            int modMinute = 0;
            int modHour = 0;
            int modDay = 0;
            double s = msec;
            if (s < 1000) return (int)s + " msec";
            s = s / 1000;
            modSecond = (int)s;
            if (s < 60) return modSecond + " sec";
            s = s / 60;
            modSecond = modSecond % 60;
            modMinute = (int)s;
            if (s < 60) return modMinute + " min" + (modSecond == 0 ? "" : " " + modSecond + " sec");
            s = s / 60;
            modMinute = modMinute % 60;
            modHour = (int)s;
            if (s < 24) return modHour + " hour" + (modMinute == 0 ? "" : " " + modMinute + " min")/*+ (modSecond == 0 ? "" : " " + modSecond + " sec")*/ ;
            s = s / 24;
            modHour = modHour % 24;
            modDay = (int)s;
            if (s < 365) return modDay + " day" + (modHour == 0 ? "" : " " + modHour + " hour")/*+ (modMinute == 0 ? "" : " " + modMinute + " min")+ (modSecond == 0 ? "" : " " + modSecond + " sec")*/;
            s = s / 365;
            modDay = modDay % 365;
            return (int)s + " year" + (modDay == 0 ? "" : " " + modDay + " day")/*+ (modHour == 0 ? "" : " " + modHour + " hour")+ (modMinute == 0 ? "" : " " + modMinute + " min")+ (modSecond == 0 ? "" : " " + modSecond + " sec")*/;
        }

        public static T GetObject<T>(Dictionary<string, object> dict)
        {
            Type type = typeof(T);
            var obj = Activator.CreateInstance(type);

            foreach (var kv in dict)
            {
                bool doIT = true;
                if (kv.Value != null)
                {
                    Type valueType = kv.Value.GetType();
                    if (valueType.IsArray)
                    {
                        doIT = false;



                        //PropertyInfo pi = type.GetProperty(kv.Key);
                        //Type typeCollection = pi.GetType();
                        //var objCollection = Activator.CreateInstance(typeCollection);
                        //objCollection.
                        //Type piItem = typeCollection.GetProperty("Item").PropertyType;


                        //Type infoType = pi.GetType();
                        //object[] array = (object[])kv.Value;
                        //var collection = pi.GetValue(infoType, null);

                        ////var collection = Activator.CreateInstance(type);
                        //for (int i = 0; i < ((object[])kv.Value).Length; i++)
                        //{
                        //    collection.GetType().GetProperty("Item").SetValue(collection, i);
                        //}
                    }
                }
                if (doIT)
                {
                    type.GetProperty(kv.Key).SetValue(obj, kv.Value);
                }

            }
            return (T)obj;
        }
    }
}