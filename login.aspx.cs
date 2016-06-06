using System;

namespace Trafilm.Gallery
{
  public partial class login : System.Web.UI.Page
  {

    protected void loginControl_LoggedIn(object sender, EventArgs e)
    {
      //note: following are not needed in normal scenaria

      //FormsAuthentication.SetAuthCookie(loginControl.UserName, loginControl.RememberMeSet);
      //FormsAuthentication.RedirectFromLoginPage(loginControl.UserName, loginControl.RememberMeSet);
    }

  }
}