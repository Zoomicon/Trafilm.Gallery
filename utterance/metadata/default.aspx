﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UtteranceMetadataPage.aspx.cs" Inherits="Trafilm.Gallery.UtteranceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: utterance\metadata\default.aspx
Version: 20160513
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Utterance Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL3kind" runat="server" DataFile="~/utterance/metadata/L3kind.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLmainLanguage" runat="server" DataFile="~/utterance/metadata/LmainLanguage.xml" XPath="Facet/String" />
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
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../scene/metadata/?film=<%=listFilms.SelectedValue%>&scene=<%=listScenes.SelectedValue%>">Scene Metadata</a>
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

        <div>
        <div class="label">Select a Film</div>
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listFilms_SelectedIndexChanged" />
        </div>
        
        <asp:Panel runat="server" ID="panelSceneId" Visible="false">
          <div>
            <div class="label">Select a Scene</div> 
            <asp:DropDownList ID="listScenes" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listScenes_SelectedIndexChanged" />
          </div>

          <asp:Panel runat="server" ID="panelUtteranceId" Visible="false">
            <div class="label">Select an Utterance</div> 
            <asp:DropDownList ID="listUtterances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listUtterances_SelectedIndexChanged" />

            <div>
              <div class="label">or add new Utterance (partial) Id</div>
              <asp:TextBox ID="txtUtterance" runat="server" />
              <asp:Button ID="btnAddUtterance" runat="server" Text="Add" OnClick="btnAddUtterance_Click" />
            </div>
          </asp:Panel>

        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">Utterance Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Utterance Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">Utterance URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <%-- ITrafilmMetadata --%>

        <div class="question">
          <div class="label">Keywords (comma-separated)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- IUtteranceMetadata --%>

        <div class="question">
          <div class="label">L3 kind (L3ST or L3TT)</div>
          <asp:DropDownList 
            ID="listL3kind" runat="server"
            DataSourceID="xmlL3kind" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L1ST/L2TT language (for L3ST/L3TT kind respectively)</div>
          <asp:DropDownList 
            ID="listLmainLanguage" runat="server"
            DataSourceID="xmlLmainLanguage" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L1ST/L2TT mode (for L3ST/L3TT kind respectively)</div>
          <asp:DropDownList 
            ID="listLmainMode" runat="server"
            DataSourceID="xmlLmainMode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L2 language same as L3ST</div>
          <asp:CheckBox ID="cbL2sameAsL3ST" runat="server" />
        </div>

        <div class="question">
          <div class="label">L3ST conveyed as L3TT</div>
          <asp:CheckBox ID="cbL3STconveyedAsL3TT" runat="server" />
        </div>


        <div class="question">
          <div class="label">L3 language type</div>
          <asp:DropDownList 
            ID="listL3languageType" runat="server"
            DataSourceID="xmlL3languageType" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 language</div>
          <asp:TextBox ID="txtL3language" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">L3 constructed based on</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3constructedBasedOn" runat="server" 
              DataSourceID="xmlL3constructedBasedOn" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">L3 audience understanding</div>
          <asp:DropDownList 
            ID="listL3audienceUnderstanding" runat="server"
            DataSourceID="xmlL3audienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 message understanding</div>
          <asp:DropDownList 
            ID="listL3messageUnderstanding" runat="server"
            DataSourceID="xmlL3messageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 meaning can be deciphered via other means</div>
          <asp:DropDownList 
            ID="listL3meaningDeciphered" runat="server"
            DataSourceID="xmlL3meaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L3 speaker's performance</div>
          <asp:DropDownList 
            ID="listL3speakerPerformance" runat="server"
            DataSourceID="xmlL3speakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L3 mode</div>
          <asp:Panel runat="server" 
            Height="80" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3mode" runat="server" 
              DataSourceID="xmlL3mode" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">L3ST mode change (applicable only to L3TT kind)</div>
          <asp:DropDownList 
            ID="listL3STmodeChange" runat="server"
            DataSourceID="xmlL3STmodeChange" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L3 is represented</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3represented" runat="server" 
              DataSourceID="xmlL3represented" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">L3 oral representations (if any)</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3representationsOral" runat="server" 
              DataSourceID="xmlL3representationsOral" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">L3 visual representations (if any)</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistL3representationsVisual" runat="server" 
              DataSourceID="xmlL3representationsVisual" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">L3 functions</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
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
