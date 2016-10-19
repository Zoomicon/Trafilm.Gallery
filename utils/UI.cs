//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: UI.cs
//Version: 20161019

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace Trafilm.Gallery
{
  public static class UI
  {

    public static string GetCommaSeparated(string[] values)
    {
      return (values != null)? string.Join(",", values) : "";
    }

    public static string[] GetCommaSeparated(TextBox txt)
    {
      return (string.IsNullOrWhiteSpace(txt.Text)) ? null : txt.Text.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
    }

    public static string[] GetSelected(ListControl list)
    {
      List<string> result = new List<string>();
      foreach (ListItem item in list.Items)
        if (item.Selected && !string.IsNullOrWhiteSpace(item.Value))
          result.Add(item.Value);
      return result.ToArray();
    }

    public static string[] GetContent(ListControl list)
    {
      List<string> result = new List<string>();
      foreach (ListItem item in list.Items)
        result.Add(item.Value);
      return result.ToArray();
    }

    //

    public static void LoadContent(ListControl list, string[] values)
    {
      list.DataSource = values;
      list.DataBind();
    }

    public static void Load(ListControl list, string[] values)
    {
      list.DataBind(); //load any items coming from a DataSource
      foreach (ListItem item in list.Items)
        item.Selected = values.Contains(item.Value);
    }

    public static void Load(ListControl list, string value)
    {
      list.DataBind(); //load any items coming from a DataSource
      list.SelectedValue = value;
    }

    public static void Load(CheckBox checkbox, bool value)
    {
      checkbox.Checked = value;
    }
    
    public static void Load(Label label, string value)
    {
      label.Text = value;
    }

    public static void Load(HyperLink hyperlink, Uri url)
    {
      string s = Uri.EscapeUriString(url.ToString());
      hyperlink.Text = s;
      hyperlink.NavigateUrl = s;
    }

    public static void Load(TextBox textbox, string value)
    {
      textbox.Text = value;
    }

    public static void Load(TextBox textbox, string[] values)
    {
      textbox.Text = GetCommaSeparated(values);
    }

    public static void AppendUserName(ListControl list)
    {
      string userName = Membership.GetUser().UserName;
      list.Items.RemoveAllCaseInsensitive(userName);
      list.Items.Add(userName);
    }

    public static void RemoveAllCaseInsensitive(this ListItemCollection list, string item)
    {
      while (RemoveCaseInsensitive(list, item)); //loop until all matching items are removed
    }

    public static bool RemoveCaseInsensitive(this ListItemCollection list, string item)
    {
      foreach (ListItem i in list)
        if (i.Value.Equals(item, StringComparison.InvariantCultureIgnoreCase))
        {
          list.Remove(i);
          return true;
        }

      return false;
    }

  }
  
}