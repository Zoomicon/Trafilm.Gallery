//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: BaseMetadataPage.cs
//Version: 20160513

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

    #region Create

    public void CreateFilm(string filmId) //don't return IFilm to avoid loading a .CXML file if already exists
    {
      if (!filmStorage.Keys.Contains(filmId))
      {
        IFilm film = new Film();
        film.Clear();
        film.Title = filmId;
        film.ReferenceId = filmId;

        filmStorage[filmId] = film;
      }
    }

    public void CreateScene(string filmId, string sceneId) //don't return IScene to avoid loading a .CXML file if already exists
    {
      if (!sceneStorage.Keys.Contains(sceneId))
      {
        IScene scene = new Scene();
        scene.Clear();
        scene.Title = sceneId;
        scene.FilmReferenceId = filmId;
        scene.ReferenceId = sceneId;

        sceneStorage[sceneId] = scene;
      }
    }

    public void CreateUtterance(string filmId, string sceneId, string utteranceId) //don't return IUtterance to avoid loading a .CXML file if already exists
    {
      if (!utteranceStorage.Keys.Contains(utteranceId))
      {
        IUtterance utterance = new Utterance();
        utterance.Clear();
        utterance.Title = utteranceId;
        utterance.FilmReferenceId = filmId;
        utterance.SceneReferenceId = sceneId;
        utterance.ReferenceId = utteranceId;

        utteranceStorage[utteranceId] = utterance;
      }
    }

    #endregion

    #region Update UI

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

    #endregion

    #region Save

    protected void SaveCollection(string cxmlFilename, string collectionTitle, IEnumerable<XElement> facetCategories, IEnumerable<ICXMLMetadata> metadataItems)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename))
        CXMLMetadata.Save(cxml, collectionTitle, facetCategories, metadataItems.ToArray());
    }

    #endregion

    #endregion
  }

}