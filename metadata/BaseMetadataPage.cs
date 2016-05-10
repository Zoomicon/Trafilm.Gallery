//Project: Trafilm.Gallery (http://trafilm.net)
//Filename: BaseMetadataPage.cs
//Version: 20140620

using Metadata.CXML;

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

namespace Trafilm.Gallery
{

  public abstract class BaseMetadataPage : System.Web.UI.Page
  {

    protected DropDownList _listItems;

    protected override void OnPreRenderComplete(EventArgs e)
    {
      base.OnPreRenderComplete(e);

      if (!IsPostBack)
      {
        if (Request.QueryString["report"] != null)
          Report();

        UpdateSelection();
      }
    }

    protected XmlReader CreateXmlReader(string inputUri)
    {
      try { return XmlReader.Create(inputUri);  }
      catch { return null; }
    }
    
    #region --- Select ---

    public void UpdateSelection(string key)
    {
      ShowMetadataUI(!key.StartsWith("*"));
      DisplayMetadata(key);
    }

    protected void UpdateSelection()
    {
      UpdateSelection(_listItems.SelectedValue);
    }

    #endregion

    #region --- Save ---

    protected void DoSave()
    {
      SaveMetadata();
      /**/
      Report();
      UpdateSelection(); //do to check that the metadata was saved OK
    }

    protected void SaveMetadata()
    {
      SaveMetadata(_listItems.SelectedValue);
    }

    protected void SaveMetadata(string key)
    {
      /*
      if (key.StartsWith("*")) return; //just for safety in case somebody manages to try saving the "* Please select..." item

      string cxmlFilename = GetMetadataFilepath(key);
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename))
        ExtractMetadata(key).Save(cxml);
        */
    }

    protected void Report(string cxmlFilename, string collectionTitle, IEnumerable<XElement> facetCategories, IEnumerable<ICXMLMetadata> metadataItems)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename))
        CXMLMetadata.Save(cxml, collectionTitle, facetCategories, metadataItems.ToArray());
    }

    #endregion

    #region --- Abstract methods ---

    public abstract void Report();
    public abstract void ShowMetadataUI(bool visible);
    public abstract void DisplayMetadata(string key);
    public abstract ICXMLMetadata ExtractMetadata(string key);

    #endregion

  }

}