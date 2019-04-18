<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PicMaker.aspx.cs" Inherits="HyperShell.Shell.PicMaker" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        body{background-color:#7b7b7b}
        .LeftPanel{height:100%;width:50%;float:left}
        .RightPanel{height:100%;width:50%;float:right}
        .Maker{position:relative;float:left}
        .Maker div{position:absolute;width:3px;height:3px}
        ._s1g{background-color:#ffd700}
        ._s2g{background-color:#d8b600}
        ._s3g{background-color:#ffe662}
        ._s7g{background-color:#ff2c53}
        ._s0{background-color:#e0e0e0}
        ._s1{background-color:#a0c0e0}
        ._s2{background-color:#80a0e0}
        ._s3{background-color:#c0e0e0}
        ._s4{background-color:#a06040}
        ._s5{background-color:#e0a080}
        ._s6{background-color:#a0a0c0}
        ._s7{background-color:#008000}
        ._s8{background-color:#606080}
        ._s9{background-color:#202020}
        ._s10{background-color:#c0c0e0}
        ._s11{background-color:#800000}
        ._s12{background-color:#e00000}

        ._b0{background-color:#000}
        ._b2{background-color:#c1b126}
        ._b3{background-color:#f1fa53}
        ._b4{background-color:#fefcff}
        ._b5{background-color:#41e5e6}
        ._b6{background-color:#05aaea}
        ._b7{background-color:#1565d6}

        #BillCypher{
width: 701px;
height: 701px;
border-top: 1px solid;
border-left: 1px solid;
position: absolute;
left: 25px;
top: 47px;
        }
        #BillCypher div{
            position:absolute;width:10px;height:10px;
                border-right: 1px solid;
    border-bottom: 1px solid;
        }

        #color {
        }

        #result {
            position: absolute;
    left: 788px;
    top: 247px;
        }
    </style>
    <script>
        
            //var colorNum = ['e0e0e0', 'a0c0e0', '80a0e0', 'c0e0e0', 'a06040', 'e0a080', 'a0a0c0', '008000', '606080', '202020', 'c0c0e0', '800000', 'e00000'];
            var a = -1;
            var color = [
            //   0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 1, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a], // 0
                [a, a, 1, 1, 1, 1, 1, 1, 1, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 3, a, a, a, a, a, a, a, a, a, a, a, a, a, a], // 1
                [a, a, a, a, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, a, a, a, a, a, a, a, 2, 1, 3, a, a, a, a, a, a, a, a, a, a, a, a, a], // 2
                [a, a, a, a, a, a, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, a, a, a, a, a, a, 2, 1, 3, a, a, a, a, a, a, a, a, a, a, a, a], // 3
                [a, a, a, a, a, a, a, a, 2, 1, 1, 1, 3, 3, 3, 3, 3, 1, 1, 1, a, a, a, 2, 2, 1, 3, a, a, a, a, a, a, a, a, a, a, a], // 4
                [a, a, a, a, a, a, a, a, a, 2, 2, 1, 1, 1, 3, 3, 3, 3, 3, 1, 1, a, a, 2, 2, 2, 1, 3, a, a, a, a, a, a, a, a, a, a], // 5
                [1, 1, 1, 1, 1, a, a, a, a, a, 2, 2, 2, 1, 1, 1, 3, 3, 3, 3, 3, 1, 2, 2, 2, 2, 1, 3, a, a, a, a, a, a, a, a, a, a], // 6
                [a, 2, 1, 3, 3, 1, 1, 1, a, a, a, 2, 2, 2, 1, 1, 1, 3, 3, 3, 3, 1, 1, 2, 2, 2, 2, 1, a, a, a, a, a, a, a, a, a, a], // 7
                [a, a, 2, 1, 3, 3, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3, 3, 3, 3, 1, 2, 2, 2, 3, 1, a, a, a, a, a, a, a, a, a], // 8
                [a, a, a, 2, 1, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 5, 5, 2, 1, 2, 1, 1, 1, 1, 1, 2, 2, 3, 1, a, a, a, a, a, a, a, a, a], // 9
                [a, a, a, a, 2, 1, 1, 3, 3, 3, 3, 1, 1, 2, 2, 2, 5, 5, 5, 2, 2, 1, 3, 1, 1, 1, 2, 1, 1, a, a, a, a, a, a, a, a, a], // 10
                [a, a, a, a, 2, 2, 1, 1, 1, 3, 3, 3, 1, 2, 1, 2, 4, 5, 5, 5, 1, 1, 1, 3, 3, 1, 1, 1, 1, a, a, a, a, a, a, a, a, a], // 11
                [a, a, a, a, a, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 4, 1, 1, 3, 3, 3, 3, 3, 3, 1, 1, 2, a, a, a, a, a, a, a, a, a], // 12
                [2, 2, 1, 1, a, a, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 3, 3, 3, 3, 1, 1, a, a, a, a, a, a, a, a, a], // 13
                [a, 2, 2, 1, 1, 1, a, 2, 2, 2, 2, 2, 1, 1, 1, 3, 3, 3, 3, 3, 2, 2, 1, 1, 3, 3, 3, 3, 1, a, a, a, a, a, a, a, a, a], // 14
                [a, a, 2, 2, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0, 3, 1, 2, 6, 6, 2, 1, 1, 3, 3, 1, 2, a, a, a, a, a, a, a, a, a], // 15
                [a, a, a, 2, 2, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 2, 6, 0, 6, 2, 2, 1, 1, 2, 6, a, a, a, a, a, a, a, a, a], // 16
                [a, a, a, 2, 2, 2, 1, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 2, 6, 0, 0, 6, 6, 2, 2, 2, 6, a, a, a, a, a, a, a, a, a], // 17
                [a, a, a, a, 2, 2, 2, 1, 1, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 0, 0, 0, 6, 7, 0, 7, 6, a, a, a, a, a, a, a, a, a], // 18
                [a, a, a, a, a, 2, 2, 2, 1, 1, 1, 1, 1, 1, 2, 1, 4, 4, 4, 1, 3, 3, 0, 0, 6, 7, 0, 7, 6, a, a, a, a, a, a, a, a, a], // 19
                [a, a, a, a, a, a, a, 2, 2, 2, 1, 1, 1, 1, 2, 2, 4, 5, 5, 5, 5, 6, 6, 0, 0, 0, 4, 6, 9, 9, a, a, a, a, a, a, a, a], // 20
                [a, a, a, a, a, a, a, a, a, 2, 2, 1, 1, 2, 1, 2, 2, 2, 4, 5, 3, 5, 5, 5, 6, 6, 5, 5, 9, 9, 8, a, a, a, a, a, a, a], // 21
                [a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 2, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, a, a, a, a, a, a, a, a, a], // 22
                [a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 5, 5, 5, 5, 5, 4, 4, 8, a, a, a, a, a, a, a, a, a], // 23
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 2, 2, 2, 8, 6, 8, a, a, a, a, a, a], // 24
                [a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 1, 4, 5, 4, 4, 4, 6, 6, 6, 6, 2, 8,10, 6, 6, 8, a, a, a, a, a], // 25
                [a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 4, 4, 5, 5, 6, 0, 0, 0, 0, 0, 8,10,10, 6, 6, 8, a, a, a, a], // 26
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 4, 4, 6, 0, 0, 8, 0, 0, 0, 0, 8, 0,10, 6, 8, a, a, a, a], // 27
                [a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 2, 4, 8, 6, 6, 0, 0, 8, 0, 6, 8,10,10, 6, 8, a, a, a, a], // 28
                [a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 4, 4, 8, 8, 8, 6, 0, 6, 8, 8, 8, 8, 6, 8, a, a, a, a], // 29
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 4, 4, 4, 8, 6, 6, 8, 8, 4, 4, a, a, a, a, a, a, a], // 30
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 1, 1, 1, 2, 8, 8, 8, 8, a, a, a, a, a, a, a, a, a, a], // 31
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 2, 1, 2, 1, 2, a, a, a, a, a, a, a, a, a, a, a, a, a], // 32
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 1, a, 2, 1, 1, a, a, a, a, a, a, a, a, a, a, a, a], // 33
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 1, a, a, 2, 1, a, a, a, a, a, a, a, a, a, a, a, a], // 34
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 1, a, a, 2, 1, 1, a, a, a, a, a, a, a, a, a, a, a], // 35
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 8, 6, 2, 1, a, 8, 8, 2, 1, 6, a, a, a, a, a, a, a, a, a, a], // 36
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 8, 6, 6, 0, 0, 6, 8, 6, 0, 6, 8, a, a, a, a, a, a, a, a, a, a], // 37
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 8, 8, 8, 6, 6, 8, 8, 8, 8, 6, 6, 8, a, a, a, a, a, a, a, a, a], // 38
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 9,11,12,12,11, 9, 8, 8, 6, 6, 8,11,12,12, a, a, a, a, a, a, a], // 39
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 9,11, 6, 0, 0, 0, 0, 9,11,11,11,11,12,12,10, 0, 0,12, a, a, a, a], // 40
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 9, 6,12,12,12,12,11, 6,11,11,11,11,11, 6, 6,10,12,12, 0,12, a, a], // 41
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 9,11,11,12,12, 0,12,11, 9,11,11,11, 8, 8, 6,11,12,12,12,12,12, a], // 42
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 9,11,11,11,12,12,12,11, 9,11,11,11, 8, 8, 8,11,11,11,11,12,12,12], // 43
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9]  // 44
            ];

            var colorBill = [
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, 7, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, 0, 0, 0, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, 7, a, a, a, a, a],
                [a, a, a, a, 7, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 7, a, a, a, a],
                [a, a, a, 7, 7, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 7, 7, a, a, a],
                [a, a, a, 7, 7, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 3, 2, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 7, 7, a, a, a],
                [7, a, a, 7, 7, 7, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, a, a, a, 7, 7, 7, a, a, 7],
                [7, a, 7, 7, 7, 6, 6, a, a, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, a, a, 6, 6, 7, 7, 7, a, 7],
                [a, 5, 6, 6, 6, 6, 5, a, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, a, 5, 6, 6, 6, 6, 5, a],
                [a, 5, 5, 6, 6, 5, 5, a, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, a, 5, 5, 6, 6, 5, 5, a],
                [a, 5, 5, 5, 5, 5, 5, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, 5, 5, 5, 5, 5, 5, a],
                [a, a, 5, 5, 5, 5, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 2, 3, 3, 2, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, 5, 5, 5, 5, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 2, 2, 3, 2, 2, 2, 2, 2, 3, 2, 2, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, 0, a, a, a, 0, a, a, a, a, a, a, a, a, 2, 3, 3, 2, 4, 4, 4, 0, 0, 2, 3, 3, 2, a, a, a, a, a, a, a, a, 0, a, a, a, 0, a, a],
                [a, a, a, 0, 0, 0, a, a, a, a, a, a, a, a, 2, 3, 3, 2, 4, 4, 4, 4, 0, 0, 4, 2, 3, 3, 2, a, a, a, a, a, a, a, a, 0, 0, 0, a, a, a],
                [a, a, 0, 0, 0, 0, 0, a, a, a, a, a, a, a, 2, 3, 2, 4, 4, 4, 4, 4, 0, 0, 4, 4, 2, 3, 2, a, a, a, a, a, a, a, 0, 0, 0, 0, 0, a, a],
                [a, a, a, a, a, a, 0, a, a, a, a, a, a, 2, 3, 3, 2, 4, 4, 4, 4, 4, 0, 0, 4, 4, 2, 3, 3, 2, a, a, a, a, a, a, 0, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, 0, a, a, a, a, a, 2, 3, 3, 2, 4, 4, 4, 4, 4, 0, 0, 4, 4, 2, 3, 3, 2, a, a, a, a, a, 0, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, 0, a, a, a, a, 2, 3, 3, 3, 3, 2, 4, 4, 4, 4, 4, 4, 4, 2, 3, 3, 3, 3, 2, a, a, a, a, 0, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, 0, 0, 0, 2, 3, 3, 3, 3, 3, 3, 2, 4, 4, 4, 4, 4, 2, 3, 3, 3, 3, 3, 3, 2, 0, 0, 0, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 2, 3, 2, 2, 2, 2, 2, 3, 2, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, 2, 3, 2, 3, 3, 3, 3, 3, 3, 2, 3, 0, 0, 3, 0, 0, 3, 2, 3, 3, 3, 3, 3, 3, 2, 3, 2, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, 2, 3, 2, 3, 3, 3, 3, 3, 3, 2, 3, 0, 0, 0, 0, 0, 3, 2, 3, 3, 3, 3, 3, 3, 2, 3, 2, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 2, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 0, 3, 2, 3, 0, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a],
                [a, a, a, a, a, a, 2, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 2, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, a, a, a, a, a, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, a, a, a, a, a, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, 0, a, a, a, a, a, 0, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a],
                [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, 0, a, a, a, a, a, 0, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a]
            ];

        var size = 3;
        var heightBlock = color.length;
        var withBlock = color[0].length;
        function hyperSonic(id)
        {
            
            var maker = document.getElementById(id);
            maker.style.width = (size * withBlock) + "px";
            maker.style.height = (size * heightBlock) + "px";

            for (var i = 0; i < heightBlock; i++) {
                for (var j = 0; j < withBlock; j++) {
                    if (color[i][j] != -1) {
                        var temp = document.createElement("div");
                        //temp.style.backgroundColor = '#' + colorNum[color[i][j]];
                        temp.style.top = (i * size) + "px";
                        temp.style.left = (j * size) + "px";
                        temp.className = '_' + color[i][j];
                        temp.id = i + "-" + j;
                        //if (color[i][j] < 4 && color[i][j] > 0)
                        //    temp.className += g;
                        maker.appendChild(temp);
                    }
                }
            }

            if (g == 'g')
            {
                document.getElementsByTagName('body')[0].style.backgroundColor = 'white';
                setTimeout(DoG, 1500);
            }

            setTimeout(animeFunc, 3000);
        }

        function pixDraw(elID, colorMatrix, colorPerfix)
        {
            var blockH = colorMatrix.length;
            var blockW = colorMatrix[0].length;

            var maker = document.getElementById(elID);
            maker.style.width = (size * blockW) + "px";
            maker.style.height = (size * blockH) + "px";

            for (var i = 0; i < blockH; i++) {
                for (var j = 0; j < blockW; j++) {
                    if (colorMatrix[i][j] != -1) {
                        var temp = document.createElement("div");
                        //temp.style.backgroundColor = '#' + colorNum[color[i][j]];
                        temp.style.top = (i * size) + "px";
                        temp.style.left = (j * size) + "px";
                        temp.className = '_' + colorPerfix + colorMatrix[i][j];
                        temp.id = i + "-" + j;
                        //if (color[i][j] < 4 && color[i][j] > 0)
                        //    temp.className += g;
                        maker.appendChild(temp);
                    }
                }
            }

            //if (g == 'g') {
            //    document.getElementsByTagName('body')[0].style.backgroundColor = 'white';
            //    setTimeout(DoG, 1500);
            //}

            //setTimeout(animeFunc, 3000);
        }

        var GoldCount = 211 + 190 + 100 + 2 + 4;
        function DoG()
        {
            var isOk = false;
            var idList = [];
            if(GoldCount > 0)
            {
                var o = Math.floor(GoldCount / 14);
                //console.log('o = ' + o);
                var idTemp = getRand(o - 10, heightBlock - 1) + "-" + getRand(0, withBlock - 1);
                var temp = document.getElementById(idTemp);
                if (temp) {
                    if (temp.className == '_1' || temp.className == '_2' || temp.className == '_3' || temp.className == '_7') {
                        if (idList.indexOf(idTemp) == -1) {
                            isOk = true;
                            GoldCount--;
                            idList.push(idTemp);
                            temp.className = temp.className + 'g';
                            var i1 = document.getElementsByClassName('_1');
                            var i2 = document.getElementsByClassName('_2');
                            var i3 = document.getElementsByClassName('_3');
                            var i7 = document.getElementsByClassName('_7');
                            console.log('real  = ' + (i1.length + i2.length + i3.length));
                            var ii = (i1.length + i2.length + i3.length + i7.length);
                            if (ii <= 5)
                            {
                                GoldCount = 0;
                                var c1 = i1.length;
                                var c2 = i2.length;
                                var c3 = i3.length;
                                var c7 = i7.length;
                                for (var f = 0; f < c1; f++)
                                    i1[0].className = '_1g';
                                for (var i = 0; i < c2; i++)
                                    i2[0].className = '_2g';
                                for (var i = 0; i < c3; i++)
                                    i3[0].className = '_3g';
                                for (var i = 0; i < c7; i++)
                                    i7[0].className = '_7g';
                                console.log('real  = ' + (i1.length + i2.length + i3.length))
                            }
                        }
                    }
                }

                if (isOk)
                    setTimeout(DoG, Math.round(GoldCount / 130) + 1);
                else
                    DoG();
            }
        }

        var EyeBlink = true;
        var NextDoubleBlink = 2;
        var EyeBlinkCount = 0;
        var g = 'g';
        function animeFunc() {
            var anime = [
                [15, 20, 5],
                [15, 21, 5],
                [16, 20, 5],
                [16, 21, 5],
                [16, 22, 5],
                [16, 28, 5],
                [17, 20, 5],
                [17, 21, 5],
                [17, 22, 5],
                [17, 23, 5],
                [17, 24, 5],
                [17, 28, 5],
                [18, 21, 5],
                [18, 22, 5],
                [18, 23, 5],
                [18, 24, 5],
                [18, 25, 5],
                [18, 26, 5],
                [18, 27, 5],
                [18, 28, 5],
                [19, 22, 5],
                [19, 23, 5],
                [19, 24, 5],
                [19, 25, 5],
                [19, 26, 5],
                [19, 27, 5],
                [19, 28, 5],
                [20, 23, 6],
                [20, 24, 5],
                [20, 25, 5]
            ];

            if (EyeBlink) {
                EyeBlinkCount++;
                EyeBlink = false;
                for (var i = 0; i < anime.length; i++) {
                    var item = document.getElementById(anime[i][0] + "-" + anime[i][1]);
                    item.className = "_" + anime[i][2];
                }
                setTimeout(animeFunc, 200);
            } else {
                EyeBlink = true;
                for (var i = 0; i < anime.length; i++) {
                    var item = document.getElementById(anime[i][0] + "-" + anime[i][1]);
                    item.className = "_" + color[anime[i][0]][anime[i][1]];
                    if (color[anime[i][0]][anime[i][1]] == 7)
                        item.className = item.className + g;
                }
                if (EyeBlinkCount == NextDoubleBlink)
                {
                    EyeBlinkCount = 0;
                    NextDoubleBlink = getRand(4, 7);
                    setTimeout(animeFunc, 200);
                }
                else
                    setTimeout(animeFunc, 3500);
            }
        }

        function getRand(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        var newColorW = 70;
        var newColorH = 70;

        var colorCount = 0;
        var strClasses;
        var ResultMatrix = [];
        function setColor(a)
        {
            var SelectedColorNumber = 0;
            console.log(a.id);
            var itemColor = document.getElementById('color');
            var result = document.getElementById('result');
            var SelectedColor = itemColor.value;

            if (document.getElementById(SelectedColor))
            {
                var temp = document.getElementById(SelectedColor);
                SelectedColorNumber = temp.innerHTML;
            }
            else
            {
                var temp = document.createElement("div");
                strClasses += '<br>._a' + colorCount + '{background-color:#' + SelectedColor + '}';
                temp.id = SelectedColor;
                temp.innerHTML = colorCount;
                SelectedColorNumber = colorCount;
                colorCount++;
                temp.setAttribute('style', 'display:none');
                document.getElementById('body').appendChild(temp);
            }

            
            if (a.getAttribute('ch') == 't')
            {
                a.setAttribute('ch', '');
                a.style.borderRight = '1px solid';
                a.style.borderBottom = '1px solid';
                a.style.backgroundColor = '';
                SelectedColorNumber = 'a';
            }
            else
            {
                a.setAttribute('ch', 't');
                a.style.borderRight = '1px solid #' + SelectedColor;
                a.style.borderBottom = '1px solid #' + SelectedColor;
                a.style.backgroundColor = '#' + SelectedColor;
            }


            var indx = a.id.split('-');

            var str = 'new color = [<br>';

            for (var i = 0; i < newColorH; i++) {
                str += '[';
                for (var j = 0; j < newColorW; j++) {
                    if (i == parseInt(indx[0], 10) && j == parseInt(indx[1], 10))
                        ResultMatrix[i][j] = SelectedColorNumber;
                    str += ResultMatrix[i][j] + ', ';
                }
                str += '],<br>';
            }

            str += '];<br>';

            result.innerHTML = strClasses + '<br>' + str;
        }

        function maker()
        {
            var mysize = 10;
            var maker = document.getElementById("BillCypher");
            maker.setAttribute('style', 'display:')

            for (var i = 0; i < newColorH; i++) {
                var newNode = [];
                for (var j = 0; j < newColorW; j++) {
                    newNode.push('a');
                    var temp = document.createElement("div");
                    //temp.style.backgroundColor = '#' + colorNum[color[i][j]];
                    temp.style.top = (i * mysize) + "px";
                    temp.style.left = (j * mysize) + "px";
                    //temp.className = '_' + colorPerfix + color[i][j];
                    temp.id = i + "-" + j;
                    temp.setAttribute('onclick', 'setColor(this)');
                    //if (color[i][j] < 4 && color[i][j] > 0)
                    //    temp.className += g;
                    maker.appendChild(temp);
                }
                ResultMatrix.push(newNode);
            }
        }

        window.onload = function () {
            g = 'g'
            //hyperSonic('Maker2');
            pixDraw('Maker2', color, 's');
            //maker();
            //pixDraw('Maker2', colorBill, 'b');
            
        }
    </script>
</head>
<body id="body">
    <form id="form1" runat="server">
    <div>
    <div class="LeftPanel">
        <div id="Maker" class="Maker"></div>
        <div id="Maker2" class="Maker"></div>
        <div id="BillCypher" style="display:none"></div>
        <input id="color" />
        <div id="result"></div>
    </div>
    <div class="RightPanel">
        <%--<div style="background-image:url(/Image/hyper.png);width:448px;height:529px;background-position:-178px -263px"></div>--%>
        <div style="background-image:url(/Image/s-l300.jpg);width:171px;height:180px;background-position:-51px -36px"></div>
    </div>
    </div>
    </form>
</body>
</html>
