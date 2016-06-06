<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Trafilm.Gallery.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
  <title>Trafilm Gallery login</title>
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
  </div>

</body>

</html>
