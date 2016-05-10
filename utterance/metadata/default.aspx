<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UtteranceMetadataPage.aspx.cs" Inherits="Trafilm.Gallery.UtteranceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://trafilm.net)
Filename: utterance\metadata\default.aspx
Version: 20160510
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Utterance Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>
    <asp:XmlDataSource ID="xmlL3type" runat="server" DataFile="~/utterance/metadata/L3type.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLmainLanguage" runat="server" DataFile="~/metadata/Languages.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLmainMode" runat="server" DataFile="~/utterance/metadata/LmainMode.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlL3languageType" runat="server" DataFile="~/utterance/metadata/L3languageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3constructedBasedOn" runat="server" DataFile="~/utterance/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3audienceUnderstanding" runat="server" DataFile="~/utterance/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3messageUnderstanding" runat="server" DataFile="~/utterance/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3meaningDeciphered" runat="server" DataFile="~/utterance/metadata/L3meaningDeciphered.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3speakerPerformance" runat="server" DataFile="~/utterance/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3mode" runat="server" DataFile="~/utterance/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmodeChange" runat="server" DataFile="~/utterance/metadata/L3STmodeChange.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3represented" runat="server" DataFile="~/utterance/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3representationsOral" runat="server" DataFile="~/utterance/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3representationsVisual" runat="server" DataFile="~/utterance/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3functions" runat="server" DataFile="~/utterance/metadata/L3functions.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>
    <div class="navigation">
       <a href="../../film/metadata/">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../scene/metadata/">Scene Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../utterance/metadata/">Utterance Metadata</a>
    </div>

    <%-- INSTRUCTIONS BOX --%>
    <div class="instructions">
    Please fill in the following information for the Utterance of your choice. Select the Utterance from the dropdown list.<br />
    Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering Utterances.<br />
    Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- INFO BOX --%>
      <div class="bar">

        <div class="label">Utterance</div> 
        <asp:DropDownList ID="listUtterances" runat="server" AutoPostBack="True" 
          DataTextField="Filename" DataValueField="Filename" 
          OnSelectedIndexChanged="listUtterances_SelectedIndexChanged"
          />

        <br />

        <div class="label">Url</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div>
          <span class="label"><%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_INFO_CREATED%>: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />
          <span class="label"> - <%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_INFO_UPDATED%>: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

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

        <%-- ITrafilmMetadata --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_KEYWORDS%> (comma-separated)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- IUtteranceMetadata --%>

        <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_FILM_REFERENCE_ID%></div> 
        <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" 
          DataTextField="Filename" DataValueField="Filename"
          OnSelectedIndexChanged="listFilms_SelectedIndexChanged"
          />
        
        <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_SCENE_REFERENCE_ID%></div> 
        <asp:DropDownList ID="listScenes" runat="server" AutoPostBack="True" 
          DataTextField="Filename" DataValueField="Filename"
          OnSelectedIndexChanged="listScenes_SelectedIndexChanged"
          />


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_TYPE%></div>
          <asp:DropDownList 
            ID="listL3type" runat="server"
            DataSourceID="xmlL3type" DataTextField="Value" DataValueField="Value" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L_MAIN_LANGUAGE%></div>
          <asp:DropDownList 
            ID="listLmainLanguage" runat="server"
            DataSourceID="xmlLmainLanguage" DataTextField="Value" DataValueField="Value" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L_MAIN_MODE%></div>
          <asp:DropDownList 
            ID="listLmainMode" runat="server"
            DataSourceID="xmlLmainMode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L2_SAME_AS_L3ST%></div>
          <asp:CheckBox ID="cbL2sameAsL3ST" runat="server" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3ST_CONVEYED_AS_L3TT%></div>
          <asp:CheckBox ID="cbL3STconveyedAsL3TT" runat="server" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_LANGUAGE_TYPE%></div>
          <asp:DropDownList 
            ID="listL3languageType" runat="server"
            DataSourceID="xmlL3languageType" DataTextField="Value" DataValueField="Value" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_LANGUAGE%></div>
          <asp:TextBox ID="txtL3language" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_CONSTRUCTED_BASED_ON%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3constructedBasedOn" runat="server" 
              DataSourceID="xmlL3constructedBasedOn" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_AUDIENCE_UNDERSTANDING%></div>
          <asp:DropDownList 
            ID="listL3audienceUnderstanding" runat="server"
            DataSourceID="xmlL3audienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_MESSAGE_UNDERSTANDING%></div>
          <asp:DropDownList 
            ID="listL3messageUnderstanding" runat="server"
            DataSourceID="xmlL3messageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_MEANING_DECIPHERED%></div>
          <asp:DropDownList 
            ID="listL3meaningDeciphered" runat="server"
            DataSourceID="xmlL3meaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_SPEAKER_PERFORMANCE%></div>
          <asp:DropDownList 
            ID="listL3speakerPerformance" runat="server"
            DataSourceID="xmlL3speakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_MODE%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3mode" runat="server" 
              DataSourceID="xmlL3mode" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3ST_MODE_CHANGE%></div>
          <asp:DropDownList 
            ID="listL3STmodeChange" runat="server"
            DataSourceID="xmlL3STmodeChange" DataTextField="Value" DataValueField="Value" />
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_REPRESENTED%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3represented" runat="server" 
              DataSourceID="xmlL3represented" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_REPRESENTATIONS_ORAL%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3representationsOral" runat="server" 
              DataSourceID="xmlL3representationsOral" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_REPRESENTATIONS_VISUAL%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3representationsVisual" runat="server" 
              DataSourceID="xmlL3representationsVisual" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.UtteranceMetadataFacets.FACET_L3_FUNCTIONS%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3functions" runat="server" 
              DataSourceID="xmlL3functions" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
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
