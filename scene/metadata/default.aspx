<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SceneMetadataPage.aspx.cs" Inherits="Trafilm.Gallery.SceneMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: scene\metadata\default.aspx
Version: 20160514
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Scene Metadata</title>
    
    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlCount" runat="server" DataFile="~/metadata/Count.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLanguages" runat="server" DataFile="~/metadata/Languages.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3languageTypes" runat="server" DataFile="~/scene/metadata/L3languageTypes.xml" XPath="Facet/String" />
    
    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../scene/metadata/">Scene Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../utterance/metadata/?film=<%=listFilms.SelectedValue%>&scene=<%=listScenes.SelectedValue%>">Utterance Metadata</a>
    </div>

    <%-- INSTRUCTION BOX --%>

    <div class="instructions">
      Please fill in the following information for the Scene of your choice. Select the Scene from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering Scenes.<br />
      Move the mouse over a question to see tooltip for it.
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- INFO BOX --%>

      <div class="bar">

        <div>
          <div class="label">Select a Film</div> 
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged ="listFilms_SelectedIndexChanged" />
        </div>

        <asp:Panel runat="server" ID="panelSceneId" Visible="false">
          <div class="label">Select a Scene</div> 
          <asp:DropDownList ID="listScenes" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listScenes_SelectedIndexChanged" />

          <div>
            <div class="label">or add new Scene (partial) Id</div>
            <asp:TextBox ID="txtScene" runat="server" />
            <asp:Button ID="btnAddScene" runat="server" Text="Add" OnClick="btnAddScene_Click" />
          </div>
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">Scene Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Scene Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">Scene URL</div>
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

        <%-- ISceneMetadata --%>

        <div class="question">
          <div class="label">Scene Start Time (h:m:s.f) - CAN USE 0 FOR HOURS, BUT NOT SKIP THEM</div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="25"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Scene Duration (h:m:s.f) - CAN USE 0 FOR HOURS, BUT NOT SKIP THEM</div>
          <asp:TextBox ID="txtDuration" runat="server" Columns="25"></asp:TextBox>
        </div>
        

        <div class="question">
          <div class="label">L1 (source) language present</div>
          <asp:CheckBox ID="cbL1languagePresent" runat="server" />
        </div>

        <div class="question">
          <div class="label">L2 (translated) language present</div>
          <asp:CheckBox ID="cbL2languagePresent" runat="server" />
        </div>


        <div class="question">
          <div class="label">Speaking characters count</div>
          <asp:DropDownList 
            ID="listSpeakingCharactersCount" runat="server"
            DataSourceID="xmlCount" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 (other) language speaking characters count</div>
          <asp:DropDownList 
            ID="listL3speakingCharactersCount" runat="server"
            DataSourceID="xmlCount" DataTextField="Value" DataValueField="Value" />
        </div>
        

        <%-- Calculated from Utterances --%>

        <div>
          <div class="label">Count of L3 (other) languages in Scene (Calculated from Utterances)</div>
          <asp:Label ID="lblL3languagesCount" runat="server"></asp:Label>
        </div>  

        <div>
          <div class="label">L3 (other) languages in Scene (Calculated from Utterances)</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            Enabled="false"
            >
            <asp:CheckBoxList ID="clistL3languages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>    


        <div>
          <div class="label">Count of L3 language types in Scene (Calculated from Utterances)</div>
          <asp:Label ID="lblL3languageTypesCount" runat="server"></asp:Label>
        </div> 
        
        <div>
          <div class="label">L3 language types in Scene (Calculated from Utterances)</div>
          <asp:Panel runat="server" 
            Height="100" Width="250"
            ScrollBars="Auto"
            Enabled="false"
            >
            <asp:CheckBoxList ID="clistL3languageTypes" runat="server" 
              DataSourceID="xmlL3languageTypes" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>            


        <div>
          <div class="label">Count of Utterances (Calculated)</div>
          <asp:Label ID="lblUtteranceCount" runat="server"></asp:Label>
        </div>    
        
        
        <%-- Utterances list --%>                  

        <asp:Repeater ID="repeaterUtterances" runat="server">
          <HeaderTemplate>
            <div class="label">List of Utterances<div>
          </HeaderTemplate>
          <ItemTemplate>
            <a href="../../utterance/metadata/?film=<%#Eval("filmId")%>&scene=<%#Eval("sceneId")%>&utterance=<%#Eval("utteranceId")%>"><%#Eval("utteranceId")%></a>&nbsp;&nbsp;
          </ItemTemplate>
        </asp:Repeater>


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
