//Project: Trafilm.Gallery (http://trafilm.net)
//Filename: scene\metadata\default.aspx.cs
//Version: 20160510

using Metadata.CXML;
using Trafilm.Metadata.Models;
using Trafilm.Metadata;

using System;
using System.Linq;
using System.IO;
using System.Web;
using System.Globalization;
using System.Collections.Generic;

namespace Trafilm.Gallery
{
  public partial class SceneMetadataPage : BaseMetadataPage
  {

    private string path = HttpContext.Current.Server.MapPath("~/scene/scene");

    protected void Page_Load(object sender, EventArgs e)
    {
      _listItems = listScenes; //allow the ancestor class to access our listScenes UI object
      
      if (!IsPostBack)
      {
        var itemPleaseSelect = new[] { new { Filename = "* Please select..." } };

        var items = Directory.EnumerateFiles(path, "*.cxml") //Available in .NET4, more efficient than GetFiles
                             .Select(f => new { Filename = Path.GetFileName(f) });

        listScenes.DataSource = itemPleaseSelect.Concat(items);

        listScenes.DataBind(); //must call this

        if (Request.QueryString["item"] != null)
          listScenes.SelectedValue = Request.QueryString["item"]; //must do after listScenes.DataBind
      }
    }

    protected void listScenes_SelectedIndexChanged(object sender, EventArgs e)
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

    #region Load

    public override void DisplayMetadata(string key)
    {
       DisplayMetadata(key, LoadScene(key));
    }

    private IScene LoadScene(string key)
    {
      throw new NotImplementedException(); //TODO
    }

    public void DisplayMetadata(string key, IScene scene)
    {
      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, scene.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://trafilm.net/gallery/?scene=" + key));
      UI.Load(txtDescription, scene.Description);

      //ITrafilmMetadata//

      //No need to show scene.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, scene.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, scene.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, scene.Keywords);

      //IScene//

      UI.Load(listFilms, scene.FilmReferenceId);

      UI.Load(txtStartTime, scene.StartTime.ToString("HH:MM:SS.FF")); //TODO: get from SceneFacets?
      UI.Load(txtDuration, scene.Duration.ToString("MM:SS.FF")); //TODO: get from Trafilm.Metadata

      UI.Load(cbL1sourceLanguagePresent, scene.L1sourceLanguagePresent);
      UI.Load(cbL2translatedLanguagePresent, scene.L2translatedLanguagePresent);

      UI.Load(listSpeakingCharactersCount, scene.SpeakingCharactersCount);
      UI.Load(listL3speakingCharactersCount, scene.L3speakingCharactersCount);

      //Calculatable from Utterances//

      UI.Load(lblL3otherLanguagesCount, CalculateL3otherLanguagesCount(key).ToString());
      UI.Load(clistL3otherLanguages, CalculateL3otherLanguages(key));

      UI.Load(lblL3otherTypesCount, CalculateL3otherTypesCount(key).ToString());
      UI.Load(clistL3otherTypes, CalculateL3otherTypes(key));

      UI.Load(lblUtteranceCount, CalculateUtteranceCount(key).ToString());
    }

    #endregion

    #region Save

    public override ICXMLMetadata ExtractMetadata(string key)
    {
      IScene scene = new Scene();

      //ICXMLMetadata//

      scene.Title = txtTitle.Text;
      scene.Image = "../scene/" + key + "/" + key + "_thumb.jpg"; //TODO
      scene.Url = new Uri("http://gallery.trafilm.net/?scene=" + key); //TODO: could set to jump to movie time
      scene.Description = txtDescription.Text;

      //ITrafilmMetadata//

      scene.ReferenceId = key;
      string folderPath = Path.Combine(path, key); //TODO
      scene.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      scene.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      scene.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IScene//

      scene.FilmReferenceId = listFilms.SelectedValue;

      scene.StartTime = TimeSpan.ParseExact(txtStartTime.Text, "HH:MM:SS.FF", CultureInfo.InvariantCulture); //TODO: get from Trafilm.Metadata
      scene.Duration = TimeSpan.ParseExact(txtDuration.Text, "MM:SS.FF", CultureInfo.InvariantCulture); //TODO: get from Trafilm.Metadata

      scene.L1sourceLanguagePresent = cbL1sourceLanguagePresent.Checked;
      scene.L2translatedLanguagePresent = cbL2translatedLanguagePresent.Checked;

      scene.SpeakingCharactersCount = listSpeakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3
      scene.L3speakingCharactersCount = listL3speakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3

      //Calculatable from Utterances//

      scene.L3otherLanguagesCount = CalculateL3otherLanguagesCount(key);
      scene.L3otherLanguages = CalculateL3otherLanguages(key);

      scene.L3otherTypesCount = CalculateL3otherTypesCount(key);
      scene.L3otherTypes = CalculateL3otherTypes(key);

      scene.UtteranceCount = CalculateUtteranceCount(key);

      return scene;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      lblInfoUpdated.Text = DateTime.Now.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      DoSave();
    }

    public override void Report()
    {
      Report("../scenes.cxml", "Trafilm Gallery Scenes", Scene.MakeSceneFacetCategories(), LoadScenes());
    }

    private IEnumerable<ICXMLMetadata> LoadScenes()
    {
      throw new NotImplementedException(); //TODO
    }

    #endregion

    #region --- Calculated from Utterances ---

    private int CalculateL3otherLanguagesCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private string[] CalculateL3otherLanguages(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private int CalculateL3otherTypesCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private string[] CalculateL3otherTypes(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private int CalculateUtteranceCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    #endregion

  }
}