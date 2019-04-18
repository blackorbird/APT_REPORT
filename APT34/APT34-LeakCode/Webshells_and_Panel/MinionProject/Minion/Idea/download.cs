public void Download(int id)
{
    // **************************************************
    string strFileName =
        string.Format("{0}.zip", id);

    string strRootRelativePathName =
        string.Format("~/App_Data/Files/{0}", strFileName);

    string strPathName =
        Server.MapPath(strRootRelativePathName);

    if (System.IO.File.Exists(strPathName) == false)
    {
        return;
    }
    // **************************************************

    System.IO.Stream oStream = null;

    try
    {
        // Open the file
        oStream =
            new System.IO.FileStream
                (path: strPathName,
                mode: System.IO.FileMode.Open,
                share: System.IO.FileShare.Read,
                access: System.IO.FileAccess.Read);

        // **************************************************
        Response.Buffer = false;

        // Setting the unknown [ContentType]
        // will display the saving dialog for the user
        Response.ContentType = "application/octet-stream";

        // With setting the file name,
        // in the saving dialog, user will see
        // the [strFileName] name instead of [download]!
        //Response.AddHeader("Content-Disposition", "attachment; filename=" + strFileName);
        Response.AppendHeader("Content-Disposition", "attachment;size=" + new System.IO.FileInfo(strPathName).Length + ";filename=" + strFileName);

        long lngFileLength = oStream.Length;

        // Notify user (client) the total file length
        Response.AddHeader("Content-Length", lngFileLength.ToString());
        // **************************************************

        // Total bytes that should be read
        long lngDataToRead = lngFileLength;

        // Read the bytes of file
        while (lngDataToRead > 0)
        {
            // The below code is just for testing! So we commented it!
            //System.Threading.Thread.Sleep(200);

            // Verify that the client is connected or not?
            if (Response.IsClientConnected)
            {
                // 8KB
                int intBufferSize = 8 * 1024;

                // Create buffer for reading [intBufferSize] bytes from file
                byte[] bytBuffers =
                    new System.Byte[intBufferSize];

                // Read the data and put it in the buffer.
                int intTheBytesThatReallyHasBeenReadFromTheStream =
                    oStream.Read(buffer: bytBuffers, offset: 0, count: intBufferSize);

                // Write the data from buffer to the current output stream.
                Response.OutputStream.Write
                    (buffer: bytBuffers, offset: 0,
                    count: intTheBytesThatReallyHasBeenReadFromTheStream);

                // Flush (Send) the data to output
                // (Don't buffer in server's RAM!)
                Response.Flush();

                lngDataToRead =
                    lngDataToRead - intTheBytesThatReallyHasBeenReadFromTheStream;
            }
            else
            {
                // Prevent infinite loop if user disconnected!
                lngDataToRead = -1;
            }
        }
    }
    catch { }
    finally
    {
        if (oStream != null)
        {
            //Close the file.
            oStream.Close();
            oStream.Dispose();
            oStream = null;
        }
        Response.Close();
    }
}