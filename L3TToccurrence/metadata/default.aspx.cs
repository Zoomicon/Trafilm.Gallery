//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3TToccurrence\metadata\default.aspx.cs
//Version: 20160525

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

using System;
using System.Globalization;
using System.IO;

namespace Trafilm.Gallery
{
  public partial class L3TToccurrenceMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      l3SToccurrenceStorage = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), listL3SToccurrences.SelectedValue + ".*.cxml");
      l3TToccurrenceStorage = new CXMLFragmentStorage<IL3TToccurrence, L3TToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3TToccurrence\L3TToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3TToccurrence\metadata"), listConversations.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);

        UpdateL3SToccurrencesList(listL3SToccurrences, "L3SToccurrence", !IsPostBack);
        listL3SToccurrences_SelectedIndexChanged(listL3SToccurrences, null);

        UpdateL3TToccurrencesList(listL3TToccurrences, "L3TToccurrence", !IsPostBack);
        listL3TToccurrences_SelectedIndexChanged(listL3TToccurrences, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddL3TToccurrence()
    {
      string filmId = listFilms.SelectedValue;
      string conversationId = listConversations.SelectedValue;
      string l3SToccurrenceId = listL3SToccurrences.SelectedValue;
      string l3TToccurrenceId = l3SToccurrenceId + "." + txtL3TToccurrence.Text; //that l3SToccurrenceId already contains the filmId and conversationId in it
      txtL3TToccurrence.Text = "";

      CreateL3TToccurrence(filmId, conversationId, l3SToccurrenceId, l3TToccurrenceId, ((listL3TToccurrences.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectL3TToccurrence(l3TToccurrenceId);
    }

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    public void SelectL3SToccurrence(string l3SToccurrenceId)
    {
      UpdateL3SToccurrencesList(listL3SToccurrences, l3SToccurrenceId); //update list since it may not be up-to-date
      listL3SToccurrences_SelectedIndexChanged(listL3SToccurrences, null);
    }

    public void SelectL3TToccurrence(string L3TToccurrenceId)
    {
      UpdateL3TToccurrencesList(listL3TToccurrences, L3TToccurrenceId); //update list since it may not be up-to-date
      listL3TToccurrences_SelectedIndexChanged(listL3TToccurrences, null);
    }

    #region Load

    public void DisplayMetadata(string L3TToccurrenceId)
    {
      IL3TToccurrence metadata = l3TToccurrenceStorage[L3TToccurrenceId];
      metadata.L3SToccurrence = l3SToccurrenceStorage[metadata.L3SToccurrenceReferenceId];
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IL3TToccurrence metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?L3TToccurrence=" + key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show L3TToccurrence.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, metadata.Keywords);

      //IL3TToccurrence//

      UI.Load(listFilms, metadata.FilmReferenceId);
      UI.Load(listConversations, metadata.ConversationReferenceId);
      UI.Load(listL3SToccurrences, metadata.L3SToccurrenceReferenceId);

      UI.Load(listL2language, metadata.L2language);
      UI.Load(listL2mode, metadata.L2mode);

      UI.Load(cbL2sameAsL3ST, metadata.L2sameAsL3ST);
      UI.Load(cbL3STconveyedAsL3TT, metadata.L3STconveyedAsL3TT);

      UI.Load(listL3TTlanguageType, metadata.L3TTlanguageType);
      UI.Load(txtL3TTlanguage, metadata.L3TTlanguage);

      UI.Load(clistL3TTconstructedBasedOn, metadata.L3TTconstructedBasedOn);

      UI.Load(listL3TTaudienceUnderstanding, metadata.L3TTaudienceUnderstanding);
      UI.Load(listL3TTmessageUnderstanding, metadata.L3TTmessageUnderstanding);
      UI.Load(listL3TTmeaningDecipherable, metadata.L3TTmeaningDecipherable);

      UI.Load(listL3TTspeakerPerformance, metadata.L3TTspeakerPerformance);

      UI.Load(clistL3TTmode, metadata.L3TTmode);

      UI.Load(clistL3TTrepresented, metadata.L3TTrepresented);
      UI.Load(clistL3TTrepresentationsOral, metadata.L3TTrepresentationsOral);
      UI.Load(clistL3TTrepresentationsVisual, metadata.L3TTrepresentationsVisual);

      UI.Load(clistL3TTfunctions, metadata.L3TTfunctions);

      //Caclculated properties//

      UI.LoadContent(listL3STmodeChange, metadata.L3STmodeChange);
      UI.LoadContent(listL3STfunctionsChange, metadata.L3STfunctionsChange);
    }

    #endregion

    #region Save

    public IL3TToccurrence GetMetadataFromUI()
    {
      IL3TToccurrence metadata = new L3TToccurrence();
      string key = listL3TToccurrences.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = "../L3TToccurence/image/" + key + ".png";
      metadata.Url = new Uri("http://gallery.trafilm.net/?L3TToccurrence=" + key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;
      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IL3TToccurenceMetadata//

      metadata.FilmReferenceId = listFilms.SelectedValue;
      metadata.ConversationReferenceId = listConversations.SelectedValue;
      metadata.L3SToccurrenceReferenceId = listL3SToccurrences.SelectedValue;

      metadata.L2language = listL2language.SelectedValue;
      metadata.L2mode = listL2mode.SelectedValue;

      metadata.L2sameAsL3ST = cbL2sameAsL3ST.Checked;
      metadata.L3STconveyedAsL3TT = cbL3STconveyedAsL3TT.Checked;

      metadata.L3TTlanguageType = listL3TTlanguageType.SelectedValue;
      metadata.L3TTlanguage = txtL3TTlanguage.Text;

      metadata.L3TTconstructedBasedOn = UI.GetSelected(clistL3TTconstructedBasedOn);

      metadata.L3TTaudienceUnderstanding = listL3TTaudienceUnderstanding.SelectedValue;
      metadata.L3TTmessageUnderstanding = listL3TTmessageUnderstanding.SelectedValue;
      metadata.L3TTmeaningDecipherable = listL3TTmeaningDecipherable.SelectedValue;

      metadata.L3TTspeakerPerformance = listL3TTspeakerPerformance.SelectedValue;

      metadata.L3TTmode = UI.GetSelected(clistL3TTmode);

      metadata.L3TTrepresented = UI.GetSelected(clistL3TTrepresented);
      metadata.L3TTrepresentationsOral = UI.GetSelected(clistL3TTrepresentationsOral);
      metadata.L3TTrepresentationsVisual = UI.GetSelected(clistL3TTrepresentationsVisual);

      metadata.L3TTfunctions = UI.GetSelected(clistL3TTfunctions);

      //Calculated properties//

      metadata.L3SToccurrence = l3SToccurrenceStorage[metadata.L3SToccurrenceReferenceId];

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      l3TToccurrenceStorage[listL3TToccurrences.SelectedValue] = (IL3TToccurrence)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "L3TToccurrence/L3TToccurrences.cxml"), "Trafilm Gallery L3TToccurrences", L3TToccurrenceMetadataFacets.GetCXMLFacetCategories(), l3TToccurrenceStorage.Values);
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
      SelectL3SToccurrence(null);
    }

    protected void listL3SToccurrences_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3TToccurrenceStorage = new CXMLFragmentStorage<IL3TToccurrence, L3TToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3TToccurrence\L3TToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3TToccurrence\metadata"), listL3SToccurrences.SelectedValue + ".*.cxml");

      bool visible = (listL3SToccurrences.SelectedIndex > 0);
      panelL3TToccurrenceId.Visible = visible;
      SelectL3TToccurrence(null); //this will also hide panelMetadata
    }

    protected void listL3TToccurrences_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listL3TToccurrences.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
        DisplayMetadata(listL3TToccurrences.SelectedValue);
    }

    protected void btnAddL3TToccurrence_Click(object sender, EventArgs e)
    {
      AddL3TToccurrence();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
    }

    #endregion

  }

}