//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: film\metadata\default.aspx.cs
//Version: 20160529

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
    }

    #endregion

    #region --- Methods ---

    public void AddFilm()
    {
      string filmId = txtFilm.Text;
      txtFilm.Text = "";

      CreateFilm(filmId, ((listFilms.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectFilm(filmId);
    }

    public void SelectFilm(string filmId)
    {
      UpdateFilmsList(listFilms, filmId); //update list since it may not be up-to-date
      listFilms_SelectedIndexChanged(listFilms, null);
    }

    #region Linked Data

    public void LinkData(IFilm metadata)
    {
      string key = metadata.ReferenceId;

      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), key + ".*.cxml");
      var values = conversationStorage.Values; //assumes "conversationStorage" has been updated
      foreach (IConversation conversation in values)
      {
        ICXMLMetadataStorage<IL3SToccurrence> l3SToccs = new CXMLFragmentStorage<IL3SToccurrence, L3SToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\L3SToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3SToccurrence\metadata"), conversation.ReferenceId + ".*.cxml");
        conversation.L3SToccurrences = l3SToccs.Values;
        foreach (IL3SToccurrence l3SToccurrence in conversation.L3SToccurrences)
        {
          ICXMLMetadataStorage<IL3TToccurrence> l3TToccs = new CXMLFragmentStorage<IL3TToccurrence, L3TToccurrence>(Path.Combine(Request.PhysicalApplicationPath, @"L3TToccurrence\L3TToccurrences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3TToccurrence\metadata"), l3SToccurrence.ReferenceId + ".*.cxml");
          l3SToccurrence.L3TToccurrences = l3TToccs.Values;
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
      //Not showing any Image field
      UI.Load(linkUrl, GetFilmUri(key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show film.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, metadata.Keywords);

      //IFilm//

      UI.Load(txtTitle_es, metadata.Title_es);
      UI.Load(txtTitle_ca, metadata.Title_ca);
      //...

      UI.Load(txtDuration, metadata.Duration.ToString(FilmMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(txtDirectors, metadata.Directors);
      UI.Load(txtScriptwriters, metadata.Scriptwriters);

      UI.Load(clistProductionCountries, metadata.ProductionCountries);
      UI.Load(txtProductionCompanies, metadata.ProductionCompanies);

      UI.Load(txtBoxOffice, metadata.BoxOffice);
      UI.Load(txtYear, metadata.YearSTreleased.ToString());

      UI.Load(listL1language, metadata.L1language);

      UI.Load(txtYearTranslated, metadata.YearTTreleased_Spain.ToString());

      //Calculated properties//

      UI.LoadContent(listL2dubbedLanguages, metadata.L2dubbedLanguages);
      UI.LoadContent(listL2subtitledLanguages, metadata.L2subtitledLanguages);

      UI.Load(lblConversationCount, metadata.ConversationCount.ToString());
      UI.Load(lblConversationsDuration, metadata.ConversationsDuration.ToString(ConversationMetadata.DEFAULT_DURATION_FORMAT));
    }
 
    #endregion

    #region Save

    public IFilm GetMetadataFromUI()
    {
      IFilm metadata = new Film();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = "../film/image/" + key + ".png";
      metadata.Url = GetFilmUri(key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;

      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IFilm//

      metadata.Title_es = txtTitle_es.Text;
      metadata.Title_ca = txtTitle_ca.Text;
      //...

      metadata.Duration = txtDuration.Text.ToNullableTimeSpan(FilmMetadata.DEFAULT_DURATION_FORMAT);

      metadata.Directors = UI.GetCommaSeparated(txtDirectors);
      metadata.Scriptwriters = UI.GetCommaSeparated(txtScriptwriters);

      metadata.ProductionCountries = UI.GetSelected(clistProductionCountries);
      metadata.ProductionCompanies = UI.GetCommaSeparated(txtProductionCompanies);

      metadata.BoxOffice = txtBoxOffice.Text;
      metadata.YearSTreleased = txtYear.Text.ToNullableInt();

      metadata.L1language = listL1language.SelectedValue;

      metadata.YearTTreleased_Spain = txtYearTranslated.Text.ToNullableInt();

      //Calculated properties//

      LinkData(metadata);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      filmStorage[listFilms.SelectedValue] = (IFilm)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), "Trafilm Gallery Films", FilmMetadataFacets.GetCXMLFacetCategories(), filmStorage.Values);
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
      AddFilm();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
      DisplayMetadata(listFilms.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
    }

    #endregion

  }

}