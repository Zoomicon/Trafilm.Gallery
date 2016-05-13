//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: BaseMetadataPage.cs
//Version: 20160512

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

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

    #region --- Fields ---

    protected CXMLFragmentStorage<IFilm, Film> filmStorage;
    protected CXMLFragmentStorage<IScene, Scene> sceneStorage;
    protected CXMLFragmentStorage<IUtterance, Utterance> utteranceStorage;

    #endregion

    #region --- Methods ---

    public void UpdateRepeater(Repeater repeater, object data)
    {
      repeater.DataSource = data;
      repeater.DataBind();
    }

    public void UpdateList(ListControl list, ICollection<string> keys, string queryStringItem)
    {
      list.DataSource = new[] { "* Please select..." }.Concat(keys);
      list.DataBind(); //must call this

      if ((queryStringItem != null) && (Request.QueryString[queryStringItem] != null))
        list.SelectedValue = Request.QueryString[queryStringItem];
    }

    public void UpdateFilmsList(ListControl list, string queryStringItem = null)
    {
      UpdateList(list, filmStorage.Keys, queryStringItem);
    }

    public void UpdateScenesList(ListControl list, string queryStringItem = null)
    {
      UpdateList(list, sceneStorage.Keys, queryStringItem);
    }

    public void UpdateUtterancesList(ListControl list, string queryStringItem = null)
    {
      UpdateList(list, utteranceStorage.Keys, queryStringItem);
    }

    protected void SaveCollection(string cxmlFilename, string collectionTitle, IEnumerable<XElement> facetCategories, IEnumerable<ICXMLMetadata> metadataItems)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename))
        CXMLMetadata.Save(cxml, collectionTitle, facetCategories, metadataItems.ToArray());
    }

    #endregion
  }

}