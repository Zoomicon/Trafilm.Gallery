<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Trafilm.Gallery.login" %>

<!DOCTYPE html>

<%--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: login.aspx
Version: 20160608
--%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
  <title>Trafilm Gallery | Login</title>
</head>

<body>

  <form id="form1" runat="server">
    <div>
      <asp:Login ID="loginControl" runat="server" OnLoggedIn="loginControl_LoggedIn"/>
    </div>
  </form>

  &nbsp;

  <div>
    You can register as new user or request password reset at <a href="http://trafilm.net/login.aspx" target="Trafilm">Trafilm main website</a>
    <br />
    <br />
    To edit metadata you also need to be given respective access rights by the Trafilm.net admins,
    <br /> 
    so after registering as a new user please <a href="http://www.trafilm.net/MonoX/Pages/Contact.aspx">contact us</a>, informing us of your user name and your request
  </div>

</body>

</html>
