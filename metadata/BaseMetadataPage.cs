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
    protected CXMLFragmentStorage<IL3occurrence, L3occurrence> l3occurrenceStorage;

    #endregion

    #region --- Methods ---

    #region Create

    public void CreateFilm(string filmId, IFilm metadata = null) //don't return IFilm to avoid loading a .CXML file if already exists
    {
      if (!filmStorage.Keys.Contains(filmId))
      {
        if (metadata == null)
        {
          metadata = new Film();
          metadata.Clear();
        }
        else
          metadata.ClearCalculated();

        metadata.Title = filmId;
        metadata.ReferenceId = filmId;

        filmStorage[filmId] = metadata;
      }
    }

    public void CreateConversation(string filmId, string conversationId, IConversation metadata = null) //don't return IConversation to avoid loading a .CXML file if already exists
    {
      if (!conversationStorage.Keys.Contains(conversationId))
      {
        if (metadata == null)
        {
          metadata = new Conversation();
          metadata.Clear();
          metadata.FilmReferenceId = filmId;
        }
        else
          metadata.ClearCalculated();

        metadata.Title = conversationId;
        metadata.ReferenceId = conversationId;

        conversationStorage[conversationId] = metadata;
      }
    }

    public void CreateL3occurrence(string filmId, string conversationId, string L3occurrenceId, IL3occurrence metadata = null) //don't return IL3occurrence to avoid loading a .CXML file if already exists
    {
      if (!l3occurrenceStorage.Keys.Contains(L3occurrenceId))
      {
        if (metadata == null)
        {
          metadata = new L3occurrence();
          metadata.Clear();
          metadata.FilmReferenceId = filmId;
          metadata.ConversationReferenceId = conversationId;
        }
        else
          metadata.ClearCalculated();

        metadata.Title = L3occurrenceId;
        metadata.ReferenceId = L3occurrenceId;

        l3occurrenceStorage[L3occurrenceId] = metadata;
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

    public void UpdateL3occurrencesList(ListControl list, string selectedValue = null, bool isQueryStringItem = false)
    {
      UpdateList(list, l3occurrenceStorage.Keys, selectedValue, isQueryStringItem);
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