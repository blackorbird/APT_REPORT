using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SQLite;
using System.Data;
using System.Text.RegularExpressions;
using System.IO;

namespace HyperShell
{
    public partial class Lap1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            #region [ Test System.IO.Path ]
           
            #endregion

            #region [ Regex nbt ]
           
            #endregion
        }

        public static List<string> GetImportedFileList()
        {
            List<string> ImportedFiles = new List<string>();
            using (SQLiteConnection connect = new SQLiteConnection(@"Data Source=C:\Documents and Settings\js91162\Desktop\CMMData.db3"))
            {
                connect.Open();
                using (SQLiteCommand fmd = connect.CreateCommand())
                {
                    fmd.CommandText = @"SELECT DISTINCT FileName FROM Import";
                    fmd.CommandType = CommandType.Text;
                    SQLiteDataReader r = fmd.ExecuteReader();
                    while (r.Read())
                    {
                        ImportedFiles.Add(Convert.ToString(r["FileName"]));
                    }
                }
            }
            return ImportedFiles;
        }
    }
}
