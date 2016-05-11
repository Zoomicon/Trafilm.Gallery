<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SceneMetadataPage.aspx.cs" Inherits="Trafilm.Gallery.SceneMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: scene\metadata\default.aspx
Version: 20160511
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Scene Metadata</title>
    
    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlCount" runat="server" DataFile="~/metadata/Count.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLanguages" runat="server" DataFile="~/metadata/Language.xml" XPath="Facet/String" />
    
    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../scene/metadata/">Scene Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../utterance/metadata/">Utterance Metadata</a>
    </div>

    <%-- INSTRUCTION BOX --%>

    <div class="instructions">
      Please fill in the following information for the Scene of your choice. Select the Scene from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering Scenes.<br />
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- INFO BOX --%>

      <div class="bar">

        <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_FILM_REFERENCE_ID%></div> 
        <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True"
          OnSelectedIndexChanged="listFilms_SelectedIndexChanged"
          />

        <asp:Panel runat="server" ID="panelSceneId" Visible="false">
          <div class="label">Select a Scene Id</div> 
          <asp:DropDownList ID="listScenes" runat="server" AutoPostBack="True" 
            OnSelectedIndexChanged="listScenes_SelectedIndexChanged"
            />

          <div>
            <div class="label">or add new Scene Id</div>
            <asp:TextBox ID="txtScene" runat="server" />
            <asp:Button ID="btnAddScene" runat="server" Text="Add" OnClick="btnAddScene_Click" />
          </div>
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="uiMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div>
          <div class="label">Title</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div>
          <div class="label">Description</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">Url</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div>
          <span class="label"><%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_INFO_CREATED%>: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />
          <span class="label"> - <%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_INFO_UPDATED%>: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <%-- ITrafilmMetadata --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_KEYWORDS%> (comma-separated)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- ISceneMetadata --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_START_TIME%></div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_DURATION%></div>
          <asp:TextBox ID="txtDuration" runat="server" Columns="150"></asp:TextBox>
        </div>
        

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L1_SOURCE_LANGUAGE_PRESENT%></div>
          <asp:CheckBox ID="cbL1sourceLanguagePresent" runat="server" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L2_TRANSLATED_LANGUAGE_PRESENT%></div>
          <asp:CheckBox ID="cbL2translatedLanguagePresent" runat="server" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_SPEAKING_CHARACTERS_COUNT%></div>
          <asp:DropDownList 
            ID="listSpeakingCharactersCount" runat="server"
            DataSourceID="xmlCount" DataTextField="Value" DataValueField="Value" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L3_SPEAKING_CHARACTERS_COUNT%></div>
          <asp:DropDownList 
            ID="listL3speakingCharactersCount" runat="server"
            DataSourceID="xmlCount" DataTextField="Value" DataValueField="Value" />
        </div>
        

        <%-- Calculatable from Utterances --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L3_OTHER_LANGUAGES_COUNT%></div>
          <asp:Label ID="lblL3otherLanguagesCount" runat="server"></asp:Label>
        </div>  

        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L3_OTHER_LANGUAGES%></div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            Enabled="false"
            >
            <asp:CheckBoxList ID="clistL3otherLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>    


        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L3_OTHER_TYPES_COUNT%></div>
          <asp:Label ID="lblL3otherTypesCount" runat="server"></asp:Label>
        </div> 
        
        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_L3_OTHER_TYPES%></div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            Enabled="false"
            >
            <asp:CheckBoxList ID="clistL3otherTypes" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>            


        <div>
          <div class="label"><%=Trafilm.Metadata.SceneMetadataFacets.FACET_UTTERANCE_COUNT%></div>
          <asp:Label ID="lblUtteranceCount" runat="server"></asp:Label>
        </div>                      


        <%-- SAVE BUTTON --%>
           
        <div>
          <asp:Button ID="btnSave" runat="server"
            Text="Save metadata"
            Font-Bold="true"
            height="50"
            OnClick="btnSave_Click"
            />
        </div>

        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>
