﻿//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: conversation\metadata\default.aspx.cs
//Version: 20160527

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
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), listConversations.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddConversation()
    {
      string filmId = listFilms.SelectedValue;
      string conversationId = filmId + "." + txtConversation.Text;
      txtConversation.Text = "";

      CreateConversation(filmId, conversationId, ((listConversations.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectConversation(conversationId);
    }

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    #region Load

    public void DisplayMetadata(string conversationId)
    {
      IConversation metadata = conversationStorage[conversationId];
      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), conversationId + ".*.cxml");
      metadata.L3SToccurrences = l3SToccurrenceStorage.Values; //this updates calculated properties //assumes "l3SToccurrenceStorage" has been updated
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IConversation metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?conversation=" + key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show conversation.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, metadata.Keywords);

      //IConversation//

      UI.Load(listFilms, metadata.FilmReferenceId);

      UI.Load(txtStartTime, metadata.StartTime.ToString(ConversationMetadata.DEFAULT_POSITION_FORMAT));
      UI.Load(txtDuration, metadata.Duration.ToString(ConversationMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(cbL1languagePresent, metadata.L1languagePresent);
      UI.Load(cbL2languagePresent, metadata.L2languagePresent);

      UI.Load(listSpeakingCharactersCount, metadata.SpeakingCharactersCount);
      UI.Load(listL3speakingCharactersCount, metadata.L3STspeakingCharactersCount);

      //Calculated properties//

      UI.Load(lblL3languagesCount, metadata.L3STlanguagesCount.ToString());
      UI.LoadContent(clistL3languages, metadata.L3STlanguages); //do not use Load, use LoadContent to add values, not select them

      UI.Load(lblL3languageTypesCount, metadata.L3STlanguageTypesCount.ToString());
      UI.LoadContent(clistL3languageTypes, metadata.L3STlanguageTypes); //do not use Load, use LoadContent to add values, not select them

      UI.Load(lblL3SToccurrenceCount, metadata.L3SToccurrenceCount.ToString());
    }

    #endregion

    #region Save

    public IConversation GetMetadataFromUI()
    {
      IConversation metadata = new Conversation();
      string key = listConversations.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = "../conversation/image/" + key + ".png";
      metadata.Url = new Uri("http://gallery.trafilm.net/?conversation=" + key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;
      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IConversation//

      metadata.FilmReferenceId = listFilms.SelectedValue;

      metadata.StartTime = txtStartTime.Text.ToNullableTimeSpan(ConversationMetadata.DEFAULT_POSITION_FORMAT);
      metadata.Duration = txtDuration.Text.ToNullableTimeSpan(ConversationMetadata.DEFAULT_DURATION_FORMAT);

      metadata.L1languagePresent = cbL1languagePresent.Checked;
      metadata.L2languagePresent = cbL2languagePresent.Checked;

      metadata.SpeakingCharactersCount = listSpeakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3
      metadata.L3STspeakingCharactersCount = listL3speakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3

      //Calculated properties//

      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), key + ".*.cxml");
      metadata.L3SToccurrences = l3SToccurrenceStorage.Values; //this updates calculated properties //assumes "l3SToccurrenceStorage" has been updated

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      conversationStorage[listConversations.SelectedValue] = GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "conversation/conversations.cxml"), "Trafilm Gallery Conversations", ConversationMetadataFacets.GetCXMLFacetCategories(), conversationStorage.Values);
    }

    #endregion

    #region Calculated from L3SToccurrences

    private int CalculateL3languagesCount(string key) //TODO
    {
      return 0;
    }

    private string[] CalculateL3languages(string key) //TODO
    {
      return new string[] { };
    }

    private int CalculateL3languageTypesCount(string key) //TODO
    {
      return 0;
    }

    private string[] CalculateL3languageTypes(string key) //TODO
    {
      return new string[] { };
    }

    private int CalculateL3SToccurrenceCount(string key)
    {
      return l3SToccurrenceStorage.Count;
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
      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listConversations.SelectedValue);
        UpdateRepeater(repeaterL3SToccurrences, l3SToccurrenceStorage.Keys.Select(x=> new { filmId=listFilms.SelectedValue, conversationId=listConversations.SelectedValue, L3SToccurrenceId = x }) );
      }
    }

    protected void btnAddConversation_Click(object sender, EventArgs e)
    {
      AddConversation();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
      DisplayMetadata(listConversations.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
    }

    #endregion

  }
}