//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: BaseMetadataPage.cs
//Version: 20160516

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
    protected CXMLFragmentStorage<IConversation, Conversation> conversationStorage;
    protected CXMLFragmentStorage<IL3occurence, L3occurence> L3occurenceStorage;

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

    public void CreateConversation(string filmId, string conversationId) //don't return IConversation to avoid loading a .CXML file if already exists
    {
      if (!conversationStorage.Keys.Contains(conversationId))
      {
        IConversation conversation = new Conversation();
        conversation.Clear();
        conversation.Title = conversationId;
        conversation.FilmReferenceId = filmId;
        conversation.ReferenceId = conversationId;

        conversationStorage[conversationId] = conversation;
      }
    }

    public void CreateL3occurence(string filmId, string conversationId, string L3occurenceId) //don't return IL3occurence to avoid loading a .CXML file if already exists
    {
      if (!L3occurenceStorage.Keys.Contains(L3occurenceId))
      {
        IL3occurence L3occurence = new L3occurence();
        L3occurence.Clear();
        L3occurence.Title = L3occurenceId;
        L3occurence.FilmReferenceId = filmId;
        L3occurence.ConversationReferenceId = conversationId;
        L3occurence.ReferenceId = L3occurenceId;

        L3occurenceStorage[L3occurenceId] = L3occurence;
      }
    }

    #endregion

    #region Update UI

    public void UpdateRepeater(Repeater repeater, object data)
    {
      repeater.DataSource = data;
      repeater.DataBind();
    }

    public void UpdateList(ListControl list, ICollection<string> keys, string selectedValue = null, bool isQueryStringItem = false)
    {
      list.DataSource = null;
      list.DataBind(); //this seems to be needed

      list.DataSource = new[] { "* Please select..." }.Concat(keys);
      list.SelectedIndex = 0;
      list.DataBind(); //must call this

      if (selectedValue != null)
        if (isQueryStringItem)
        {
          if (Request.QueryString[selectedValue] != null)
            list.SelectedValue = Request.QueryString[selectedValue];
        }
        else
          list.SelectedValue = selectedValue;
    }

    public void UpdateFilmsList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, filmStorage.Keys, selectedValue, isQueryStringItem);
    }

    public void UpdateConversationsList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, conversationStorage.Keys, selectedValue, isQueryStringItem);
    }

    public void UpdateL3occurencesList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, L3occurenceStorage.Keys, selectedValue, isQueryStringItem);
    }

    #endregion

    #region Save

    protected void SaveCollection(string cxmlFilename, string collectionTitle, IEnumerable<XElement> facetCategories, IEnumerable<ICXMLMetadata> metadataItems)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(cxmlFilename))); //create any parent directories needed
      using (XmlWriter cxml = XmlWriter.Create(cxmlFilename, CXMLFragmentStorage<ICXMLMetadata, FilmMetadata>.DEFAULT_XML_WRITER_SETTINGS)) //note: FilmMetadata is used there just to access the DEFAULT_XML_WRITER_SETTINGS constant, not instantiating the CXMLFragmentStorage 
        CXMLMetadata.Save(cxml, collectionTitle, facetCategories, metadataItems.ToArray());
    }

    #endregion

    #endregion
  }

}