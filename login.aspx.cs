//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: login.aspx.cs
//Version: 20160615

using System;
using System.Web.Security;

namespace Trafilm.Gallery
{
  public partial class login : System.Web.UI.Page
  {


    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      lblUserCount.Text = Membership.GetNumberOfUsersOnline().ToString();
    }

    #endregion

    protected void loginControl_LoggedIn(object sender, EventArgs e)
    {
      //note: following are not needed in normal scenaria

      //FormsAuthentication.SetAuthCookie(loginControl.UserName, loginControl.RememberMeSet);
      //FormsAuthentication.RedirectFromLoginPage(loginControl.UserName, loginControl.RememberMeSet);
    }

  }
}