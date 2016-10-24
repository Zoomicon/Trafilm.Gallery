<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Trafilm.Gallery.login" %>

<!DOCTYPE html>

<%--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: login.aspx
Version: 20161024
--%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
  <title>Trafilm Gallery | Login</title>

  <meta name="viewport" content="width=400, user-scalable=yes, initial-scale=1" />
</head>

<body>

  <form id="form1" runat="server">
    <div>

      <asp:Login ID="loginControl" runat="server" OnLoggedIn="loginControl_LoggedIn">
        <LayoutTemplate>
          <table cellpadding="1" cellspacing="0" style="border-collapse: collapse;">
            <tr>
              <td>
                <table cellpadding="0">
                  <tr>
                    <td align="right">
                      <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label>
                    </td>
                    <td>
                      <asp:TextBox ID="UserName" runat="server" Columns="25" />
                      <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="loginControl" ForeColor="red">*</asp:RequiredFieldValidator>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                    </td>
                    <td>
                      <asp:TextBox ID="Password" runat="server" TextMode="Password" Columns="25" />
                      <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="loginControl" ForeColor="red">*</asp:RequiredFieldValidator>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2">
                      &nbsp;
                    </td>
                  </tr>
                  <tr>
                    <td align="center" colspan="2" style="color: Red;">
                      <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                    </td>
                  </tr>
                  <tr>
                    <td align="left" colspan="2">
                      <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time" />
                      &nbsp;&nbsp;
                      <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="loginControl" style="text-align: left" />
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </LayoutTemplate>
      </asp:Login>

    </div>

    <br />

    <div>
      You can register as new user or request password reset at <a href="http://trafilm.net/login.aspx" target="Trafilm">Trafilm main website</a>
      <br />
      <br />
      To edit metadata you also need to be given respective access rights by the Trafilm.net admins,
    <br />
      so after registering as a new user please <a href="http://www.trafilm.net/MonoX/Pages/Contact.aspx">contact us</a>, informing us of your user name and your request
    </div>

    <br />

    <div>
      Logged-in users:
      <asp:Label ID="lblUserCount" runat="server" />
    </div>

  </form>

</body>

</html>
