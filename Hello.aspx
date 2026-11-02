<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Hello.aspx.vb" Inherits="FirstWebapp.Hello" %> 
<%-- Gives ASP.NET settings, including the language and code-behind file. --%>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <h1>My first dynamic page</h1>
                <%-- A fixed heading on the page --%>
             <asp:Label ID="lblDate" runat="server" />
                <%-- asp:Label -> creates the text control that your VB code can update. --%>
             <br>
            <asp:Label ID="lblTime" runat="server" />
        </div>
    </form>
</body>
</html>
