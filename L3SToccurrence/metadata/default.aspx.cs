//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3SToccurrence\metadata\default.aspx.cs
//Version: 20160525

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Trafilm.Metadata.Utils;

using System;
using System.Globalization;
using System.IO;

namespace Trafilm.Gallery
{
  public partial class L3SToccurrenceMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), listConversations.SelectedValue + ".*.cxml");

      UpdateFilmsList(listFilms, (IsPostBack) ? listFilms.SelectedValue : "film", !IsPostBack);
      if (!IsPostBack)
        listFilms_SelectedIndexChanged(listFilms, null);

      if (!IsPostBack)
      {
        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);

        UpdateL3SToccurrencesList(listL3SToccurrences, "L3SToccurrence", !IsPostBack);
        listL3SToccurrences_SelectedIndexChanged(listL3SToccurrences, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddL3SToccurrence()
    {
      string filmId = listFilms.SelectedValue;
      string conversationId = listConversations.SelectedValue;
      string L3SToccurrenceId = conversationId + "." + txtL3SToccurrence.Text; //that conversationId already contains the filmId in it
      txtL3SToccurrence.Text = "";

      CreateL3SToccurrence(filmId, conversationId, L3SToccurrenceId, ((listL3SToccurrences.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectL3SToccurrence(L3SToccurrenceId);
    }

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    public void SelectL3SToccurrence(string L3SToccurrenceId)
    {
      UpdateL3SToccurrencesList(listL3SToccurrences, L3SToccurrenceId); //update list since it may not be up-to-date
      listL3SToccurrences_SelectedIndexChanged(listL3SToccurrences, null);
    }

    #region Load

    public void DisplayMetadata(string L3SToccurrenceId)
    {
      IL3SToccurrence metadata = l3SToccurrenceStorage[L3SToccurrenceId];
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IL3SToccurrence metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?L3SToccurrence=" + key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show L3SToccurrence.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, metadata.Keywords);

      //IL3SToccurrence//

      UI.Load(listFilms, metadata.FilmReferenceId);
      UI.Load(listConversations, metadata.ConversationReferenceId);

      UI.Load(txtStartTime, metadata.StartTime.ToString(L3SToccurrenceMetadata.DEFAULT_POSITION_FORMAT));
      UI.Load(txtDuration, metadata.Duration.ToString(L3SToccurrenceMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(listL3STlanguageType, metadata.L3STlanguageType);
      UI.Load(txtL3STlanguage, metadata.L3STlanguage);

      UI.Load(clistL3STconstructedBasedOn, metadata.L3STconstructedBasedOn);

      UI.Load(listL3STaudienceUnderstanding, metadata.L3STaudienceUnderstanding);
      UI.Load(listL3STmessageUnderstanding, metadata.L3STmessageUnderstanding);
      UI.Load(listL3STmeaningDecipherable, metadata.L3STmeaningDecipherable);

      UI.Load(listL3STspeakerPerformance, metadata.L3STspeakerPerformance);

      UI.Load(clistL3STmode, metadata.L3STmode);

      UI.Load(clistL3STrepresented, metadata.L3STrepresented);
      UI.Load(clistL3STrepresentationsOral, metadata.L3STrepresentationsOral);
      UI.Load(clistL3STrepresentationsVisual, metadata.L3STrepresentationsVisual);

      UI.Load(clistL3STfunctions, metadata.L3STfunctions);
    }

    #endregion

    #region Save

    public IL3SToccurrence GetMetadataFromUI()
    {
      IL3SToccurrence metadata = new L3SToccurrence();
      string key = listL3SToccurrences.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = "../L3SToccurence/image/" + key + ".png";
      metadata.Url = new Uri("http://gallery.trafilm.net/?L3SToccurrence=" + key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;
      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      //Imetadata//

      metadata.ConversationReferenceId = listConversations.SelectedValue;

      metadata.FilmReferenceId = listFilms.SelectedValue;
      metadata.ConversationReferenceId = listConversations.SelectedValue;

      metadata.StartTime = txtStartTime.Text.ToNullableTimeSpan(L3SToccurrenceMetadata.DEFAULT_POSITION_FORMAT);
      metadata.Duration = txtDuration.Text.ToNullableTimeSpan(L3SToccurrenceMetadata.DEFAULT_DURATION_FORMAT);

      metadata.L3STlanguageType = listL3STlanguageType.SelectedValue;
      metadata.L3STlanguage = txtL3STlanguage.Text;

      metadata.L3STconstructedBasedOn = UI.GetSelected(clistL3STconstructedBasedOn);

      metadata.L3STaudienceUnderstanding = listL3STaudienceUnderstanding.SelectedValue;
      metadata.L3STmessageUnderstanding = listL3STmessageUnderstanding.SelectedValue;
      metadata.L3STmeaningDecipherable = listL3STmeaningDecipherable.SelectedValue;

      metadata.L3STspeakerPerformance = listL3STspeakerPerformance.SelectedValue;

      metadata.L3STmode = UI.GetSelected(clistL3STmode);

      metadata.L3STrepresented = UI.GetSelected(clistL3STrepresented);
      metadata.L3STrepresentationsOral = UI.GetSelected(clistL3STrepresentationsOral);
      metadata.L3STrepresentationsVisual = UI.GetSelected(clistL3STrepresentationsVisual);

      metadata.L3STfunctions = UI.GetSelected(clistL3STfunctions);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      l3SToccurrenceStorage[listL3SToccurrences.SelectedValue] = (IL3SToccurrence)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "L3SToccurrence/L3SToccurrences.cxml"), "Trafilm Gallery L3SToccurrences", L3SToccurrenceMetadataFacets.GetCXMLFacetCategories(), l3SToccurrenceStorage.Values);
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelConversationId.Visible = visible;
      SelectConversation(null);
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelL3SToccurrenceId.Visible = visible;
      SelectL3SToccurrence(null); //this will also hide panelMetadata
    }

    protected void listL3SToccurrences_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listL3SToccurrences.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
        DisplayMetadata(listL3SToccurrences.SelectedValue);
    }

    protected void btnAddL3SToccurrence_Click(object sender, EventArgs e)
    {
      AddL3SToccurrence();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
    }

    #endregion

  }

}