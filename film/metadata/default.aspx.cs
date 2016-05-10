//Project: Trafilm.Gallery (http://trafilm.net)
//Filename: film\metadata\default.aspx.cs
//Version: 20160510

using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Metadata.CXML;

using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Globalization;
using System.Collections.Generic;

namespace Trafilm.Gallery
{
  public partial class FilmMetadataPage : BaseMetadataPage
  {

    private string path = HttpContext.Current.Server.MapPath("~/film/metadata");

    protected void Page_Load(object sender, EventArgs e)
    {
      _listItems = listFilms; //allow the ancestor class to access our listFilms UI object 
      
      if (!IsPostBack)
      {
        var itemPleaseSelect = new[] { new { Filename = "* Please select..." } };

        var items = Directory.EnumerateFiles(path, "*.cxml") //Available in .NET4, more efficient than GetFiles
                             .Select(f => new { Filename = Path.GetFileName(f) });

        listFilms.DataSource = itemPleaseSelect.Concat(items);

        listFilms.DataBind(); //must call this

        if (Request.QueryString["item"] != null)
          listFilms.SelectedValue = Request.QueryString["item"]; //must do after listFilms.DataBind
      }
    }
  
    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      UpdateSelection();
    }

    #region UI

    public override void ShowMetadataUI(bool visible)
    {
      if (uiMetadata != null)
        uiMetadata.Visible = visible;

      linkUrl.Visible = visible;
    }

    #endregion

    #region --- Load ---

    public override void DisplayMetadata(string key)
    {
       DisplayMetadata(key, LoadFilm(key));
    }

    CXMLFragmentStorage<IFilm, Film> filmStorage = new CXMLFragmentStorage<IFilm, Film>("../films.cxml", ".", "*.cxml");
    CXMLFragmentStorage<IScene, Scene> sceneStorage = new CXMLFragmentStorage<IScene, Scene>("../scenes.cxml", "../../scene/metadata", "");

    private IFilm LoadFilm(string key)
    {
      sceneStorage.FragmentsFilter = key + ".*.cxml";
      return (IFilm)filmStorage[key];
    }

    public void DisplayMetadata(string key, IFilm film)
    {
      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, film.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://trafilm.net/gallery/?film=" + key));
      UI.Load(txtDescription, film.Description);

      //ITrafilmMetadata//

      //No need to show film.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, film.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, film.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, film.Keywords);

      //IFilm//

      UI.Load(txtTitle_es, film.Title_es);
      UI.Load(txtTitle_ca, film.Title_ca);
      //...

      UI.Load(txtDuration, film.Duration.ToString("HH:MM:SS"));

      UI.Load(txtDirectors, film.Directors);
      UI.Load(txtScriptwriters, film.Scriptwriters);

      UI.Load(clistProductionCountries, film.ProductionCountries);
      UI.Load(txtProductionCompanies, film.ProductionCompanies);

      UI.Load(txtBoxOffice, film.BoxOffice);
      UI.Load(txtYear, film.Year.ToString());

      UI.Load(clistSourceLanguages, film.SourceLanguages);

      UI.Load(txtYearTranslated, film.YearTranslated.ToString());
      UI.Load(clistDubbedLanguages, film.DubbedLanguages);
      UI.Load(clistSubtitledLanguages, film.SubtitledLanguages);

      //Calculatable from Scenes//

      UI.Load(lblSceneCount, CalculateSceneCount(key).ToString());
      UI.Load(lblScenesDuration, CalculateScenesDuration(key).ToString("HH:MM:SS"));
    }

    #endregion

    #region --- Save ---

    public override ICXMLMetadata ExtractMetadata(string key)
    {
      IFilm film = new Film();

      //ICXMLMetadata//

      film.Title = txtTitle.Text;
      film.Image = "../film/" + key + "/" + key + "_thumb.jpg"; //TODO
      film.Url = new Uri("http://gallery.trafilm.net/?film=" + key);
      film.Description = txtDescription.Text;

      //ITrafilmMetadata//

      film.ReferenceId = key;
      string folderPath = Path.Combine(path, key); //TODO
      film.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      film.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      film.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IFilm//

      film.Title_es = txtTitle_es.Text;
      film.Title_ca = txtTitle_ca.Text;
      //...

      film.Duration = txtDuration.Text.ToNullableTimeSpan("HH:MM:SS");

      film.Directors = UI.GetCommaSeparated(txtDirectors);
      film.Scriptwriters = UI.GetCommaSeparated(txtScriptwriters);

      film.ProductionCountries = UI.GetSelected(clistProductionCountries);
      film.ProductionCompanies = UI.GetCommaSeparated(txtProductionCompanies);

      film.BoxOffice = txtBoxOffice.Text;
      film.Year = txtYear.Text.ToNullableInt();

      film.SourceLanguages = UI.GetSelected(clistSourceLanguages);

      film.YearTranslated = txtYearTranslated.Text.ToNullableInt();
      film.DubbedLanguages = UI.GetSelected(clistDubbedLanguages);
      film.SubtitledLanguages = UI.GetSelected(clistSubtitledLanguages);

      //Calculatable from Scenes//

      film.SceneCount = CalculateSceneCount(key);
      film.ScenesDuration = CalculateScenesDuration(key);

      return film;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      lblInfoUpdated.Text = DateTime.Now.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      DoSave();
    }

    public override void Report()
    {
      Report("../films.cxml", "Trafilm Gallery Films", Film.MakeFilmFacetCategories(), LoadFilms());
    }

    private IEnumerable<ICXMLMetadata> LoadFilms()
    {
      throw new NotImplementedException(); //TODO
    }

    #endregion

    #region --- Calculated from Scenes ---

    private int CalculateSceneCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private TimeSpan CalculateScenesDuration(string key) //TODO
    {
      throw new NotImplementedException();
    }

    #endregion

  }

}