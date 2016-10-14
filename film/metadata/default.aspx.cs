//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: film\metadata\default.aspx.cs
//Version: 20161014

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
  public partial class FilmMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);
      }

      bool canSave = IsUserAllowedToSave("Film");
      panelMetadata.Enabled = canSave;
      panelSave.Visible = canSave;
      panelAdd.Visible = canSave;

      btnRename.Visible = IsUserAllowedToRename("Film") && (listFilms.SelectedIndex > 0);

      //this.ClientScript.RegisterStartupScript(this.GetType(),
      //                                        "navigate",
      //                                        "window.onload = function() {window.location.hash='" + GetFilmUriHash(listFilms.SelectedValue) + "';}",
      //                                         true);
    }

    #endregion

    #region --- Methods ---

    public void AddFilm()
    {
      string filmId = txtFilm.Text.Trim();
      if (filmId.Length == 0) return;

      txtFilm.Text = "";

      CreateFilm(filmId, ((listFilms.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectFilm(filmId);
    }

    public void Rename()
    {
      //TODO
    }

    #region Selection

    public void SelectFilm(string filmId)
    {
      UpdateFilmsList(listFilms, filmId); //update list since it may not be up-to-date
      listFilms_SelectedIndexChanged(listFilms, null);
    }

    #endregion

    #region Linked Data

    public void LinkData(IFilm metadata)
    {
      string key = metadata.ReferenceId;

      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), key + ".*.cxml");
      var values = conversationStorage.Values; //assumes "conversationStorage" has been updated
      foreach (IConversation conversation in values)
      {
        ICXMLMetadataStorage<IL3STinstance> l3SToccs = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\L3STinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\metadata"), conversation.ReferenceId + ".*.cxml");
        conversation.L3STinstances = l3SToccs.Values;
        foreach (IL3STinstance l3STinstance in conversation.L3STinstances)
        {
          ICXMLMetadataStorage<IL3TTinstance> l3TToccs = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3TTinstance\L3TTinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3TTinstance\metadata"), l3STinstance.ReferenceId + ".*.cxml");
          l3STinstance.L3TTinstances = l3TToccs.Values;
        }
      }
      metadata.Conversations = values; //this updates calculated properties (must be set after the above nested calculations)
    }

    #endregion

    #region Load

    public void DisplayMetadata(string filmId)
    {
      IFilm metadata = filmStorage[filmId];
      LinkData(metadata);
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IFilm metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      UI.Load(txtImageUrl, metadata.Image);
      UI.Load(linkUrl, GetFilmUri(key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show film.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list

      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));

      UI.LoadContent(listMetadataEditors, metadata.MetadataEditors);

      //UI.Load(txtTranscription, metadata.Transcription);

      UI.Load(txtTags, metadata.Tags);

      UI.Load(txtRemarks, metadata.Remarks);

      //IFilm//

      UI.Load(listType, metadata.Type);

      UI.Load(txtDuration, metadata.Duration.ToString());

      UI.Load(txtSeries, metadata.Series);

      UI.Load(txtDirectors, metadata.Directors);
      UI.Load(txtScriptwriters, metadata.Scriptwriters);

      UI.Load(txtProductionCountries, metadata.ProductionCountries);
      UI.Load(txtProductionCompanies, metadata.ProductionCompanies);

      UI.Load(listBlockbuster, metadata.Blockbuster);
      UI.Load(txtYear, metadata.YearSTreleased.ToString());

      UI.Load(listL1language, metadata.L1language);

      //Calculated properties//

      UI.LoadContent(listL2dubbedLanguages, metadata.L2dubbedLanguages);
      UI.LoadContent(listL2subtitledLanguages, metadata.L2subtitledLanguages);

      UI.Load(lblConversationCount, metadata.ConversationCount.ToString());
    }
 
    #endregion

    #region Save

    public IFilm GetMetadataFromUI()
    {
      IFilm metadata = new Film();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = txtImageUrl.Text;
      metadata.Url = GetFilmUri(key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;

      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.MetadataEditors = UI.GetContent(listMetadataEditors);

      //metadata.Transcription = txtTranscription.Text;

      metadata.Tags = UI.GetCommaSeparated(txtTags);

      metadata.Remarks = txtRemarks.Text;

      //IFilm//

      metadata.Type = listType.SelectedValue;

      metadata.Duration = txtDuration.Text.ToNullableInt();

      metadata.Series = txtSeries.Text;

      metadata.Directors = UI.GetCommaSeparated(txtDirectors);
      metadata.Scriptwriters = UI.GetCommaSeparated(txtScriptwriters);

      metadata.ProductionCountries = UI.GetCommaSeparated(txtProductionCountries);
      metadata.ProductionCompanies = UI.GetCommaSeparated(txtProductionCompanies);

      metadata.Blockbuster = listBlockbuster.SelectedValue;
      metadata.YearSTreleased = txtYear.Text.ToNullableInt();

      metadata.L1language = listL1language.SelectedValue;

      //Calculated properties//

      LinkData(metadata);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      UI.AppendUserName(listMetadataEditors);
      filmStorage[listFilms.SelectedValue] = (IFilm)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), "Trafilm Gallery: Films", FilmMetadataFacets.GetCXMLFacetCategories(), filmStorage.Values);
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listFilms.SelectedValue); //assumes "conversationStorage" has been updated
        UpdateRepeater(repeaterConversations, conversationStorage.Keys.Select(x => new { filmId = listFilms.SelectedValue, conversationId = x }) );
      }
    }

    protected void btnAddFilm_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("Film")) return;

      AddFilm();
    }

    protected void btnRename_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToRename("Film")) return;

      Rename();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("Film")) return;

      Save();
      SaveCollection();
      DisplayMetadata(listFilms.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
    }

    #endregion

  }

}