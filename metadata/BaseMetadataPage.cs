//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: BaseMetadataPage.cs
//Version: 20160511

using Metadata.CXML;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

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

    public void UpdateList(ListControl list, ICollection<string> keys)
    {
      list.DataSource = new[] { "* Please select..." }.Concat(keys);
      list.DataBind(); //must call this
    }

    public void UpdateFilmsList(ListControl list)
    {
      UpdateList(list, filmStorage.Keys);
    }

    public void UpdateScenesList(ListControl list)
    {
      UpdateList(list, sceneStorage.Keys);
    }

    public void UpdateUtterancesList(ListControl list)
    {
      UpdateList(list, utteranceStorage.Keys);
    }

    public void SelectFromQueryString(ListControl listFilms, ListControl listScenes, ListControl listUtterances) //must do after DataBind
    {
      if (listFilms != null && Request.QueryString["film"] != null)
        listFilms.SelectedValue = Request.QueryString["film"];

      if (listScenes != null && Request.QueryString["scenes"] != null)
        listScenes.SelectedValue = Request.QueryString["scenes"];

      if (listUtterances != null && Request.QueryString["utterance"] != null)
        listUtterances.SelectedValue = Request.QueryString["utterances"];
    }

    protected void Report(string cxmlFilename, string collectionTitle, IEnumerable<XElement> facetCategories, IEnumerable<ICXMLMetadata> metadataItems)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename))
        CXMLMetadata.Save(cxml, collectionTitle, facetCategories, metadataItems.ToArray());
    }

    #endregion
  }

}