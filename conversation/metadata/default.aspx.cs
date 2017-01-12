//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: conversation\metadata\default.aspx.cs
//Version: 20170113

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Trafilm.Metadata.Utils;

using System;
using System.Globalization;
using System.IO;
using System.Linq;

namespace Trafilm.Gallery
{
  public partial class ConversationMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Server.MapPath("~/film/films.cxml"), Server.MapPath("~/film/metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Server.MapPath("~/conversation/conversations.cxml"), Server.MapPath("~/conversation/metadata"), listFilms.SelectedValue + ".*.cxml");
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Server.MapPath("~/L3STinstance/L3STinstances.cxml"), Server.MapPath("~/L3STinstance/metadata"), listConversations.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);
      }

      bool canSave = IsUserAllowedToSave("Conversation");
      panelMetadata.Enabled = canSave;
      panelAdd.Visible = canSave;
      panelSave.Visible = canSave; //stays hidden if its parent panelMetadata is not visible (i.e. nothing is selected)

      btnRename.Visible = IsUserAllowedToRename("Conversation") && (listConversations.SelectedIndex > 0);
    }

    #endregion

    #region --- Methods ---

    #region Add

    public void AddConversation()
    {
      string conversationPartialId = txtConversation.Text.Trim().Replace(".", "");
      if (conversationPartialId.Length == 0) return;

      string filmId = listFilms.SelectedValue;
      string conversationId = filmId + "." + conversationPartialId;

      txtConversation.Text = "";

      CreateConversation(filmId, conversationId, ((listConversations.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectConversation(conversationId);

      //initialize Title//
      if (!cbClone.Checked)
        txtTitle.Text = conversationPartialId.Replace("_", ", "); //not using conversationId here, using the partial one instead (note that dots have already been removed above)
    }

    #endregion

    public void Rename()
    {
      //TODO
    }

    #region Selection

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    #endregion

    #region Linked Data

    public void LinkData(IConversation metadata)
    {
      string key = metadata.ReferenceId;

      metadata.Film = filmStorage[metadata.FilmReferenceId]; //this updates calculated properties

      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\L3STinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\metadata"), key + ".*.cxml");
      metadata.L3STinstances = l3STinstanceStorage.Values; //this updates calculated properties //assumes "l3STinstanceStorage" has been updated
    }

    #endregion

    #region Load

    public void DisplayMetadata(string conversationId)
    {
      IConversation metadata = conversationStorage[conversationId];
      LinkData(metadata);
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IConversation metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      /*
      UI.Load(txtImageUrl, metadata.Image);
      */
      UI.Load(linkUrl, GetConversationUri(metadata.FilmReferenceId, key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show conversation.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list

      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));

      UI.LoadContent(listMetadataEditors, metadata.MetadataEditors);

      /*
      UI.Load(txtTranscription, metadata.Transcription);
      */

      UI.Load(txtTags, metadata.Tags);

      UI.Load(txtRemarks, metadata.Remarks);

      //IConversation//

      UI.Load(listFilms, metadata.FilmReferenceId);

      UI.Load(lblFilmOrSeasonTitle, metadata.FilmOrSeasonTitle);
      UI.Load(txtSeasonEpisodeName, metadata.SeasonEpisodeName);

      UI.Load(txtStartTime, metadata.StartTime.ToString());
      UI.Load(listDuration, metadata.Duration);

      /*
      UI.Load(listLanguageSources, metadata.LanguageSources);
      */

      //Calculated properties//

      UI.Load(lblL3languagesCount, metadata.L3STlanguagesCount.ToString()); //don't need to display the count since there list of items is also shown
      UI.LoadContent(listL3languages, metadata.L3STlanguages); //do not use Load, use LoadContent to add values, not select them

      UI.Load(lblL3languageTypesCount, metadata.L3STlanguageTypesCount.ToString()); //don't need to display the count since there list of items is also shown
      UI.LoadContent(listL3languageTypes, metadata.L3STlanguageTypes); //do not use Load, use LoadContent to add values, not select them

      UI.Load(lblL3STinstanceCount, metadata.L3STinstanceCount.ToString());
    }

    #endregion

    #region Save

    public IConversation GetMetadataFromUI()
    {
      IConversation metadata = new Conversation();
      metadata.Clear(); /* using this since we have removed UI elements (needed for facets to get default values) */

      string key = listConversations.SelectedValue;
      string filmReferenceId = listFilms.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      /*
      metadata.Image = txtImageUrl.Text;
      */
      metadata.Url = GetConversationUri(filmReferenceId, key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;

      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.MetadataEditors = UI.GetContent(listMetadataEditors);

      /*
      metadata.Transcription = txtTranscription.Text;
      */

      metadata.Tags = UI.GetCommaSeparated(txtTags);

      metadata.Remarks = txtRemarks.Text;

      //IConversation//

      metadata.FilmReferenceId = filmReferenceId;

      metadata.SeasonEpisodeName = txtSeasonEpisodeName.Text;

      metadata.StartTime = txtStartTime.Text.ToNullableInt();
      metadata.Duration = listDuration.SelectedValue;
      
      /*
      metadata.LanguageSources = listLanguageSources.SelectedValue;
      */

      //Calculated properties//

      LinkData(metadata);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      UI.AppendUserName(listMetadataEditors);
      conversationStorage[listConversations.SelectedValue] = GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      ICXMLMetadataStorage<IConversation> allConversationsStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), "*.cxml");
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), "Trafilm Gallery: Conversations", ConversationMetadataFacets.GetCXMLFacetCategories(), allConversationsStorage.Values);
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelConversationId.Visible = visible;
      SelectConversation(null); //this will also hide panelMetadata
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\L3STinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listConversations.SelectedValue);
        UpdateRepeater(repeaterL3STinstances, l3STinstanceStorage.Keys.Select(x=> new { filmId=listFilms.SelectedValue, conversationId=listConversations.SelectedValue, L3STinstanceId = x }) );
      }
    }

    protected void btnAddConversation_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("Conversation")) return;

      AddConversation();
    }

    protected void btnRename_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToRename("Conversation")) return;

      Rename();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("Conversation")) return;

      Save();
      SaveCollection();
      DisplayMetadata(listConversations.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
    }

    #endregion

  }
}