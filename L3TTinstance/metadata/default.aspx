﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3TTinstanceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3TTTTinstance\metadata\default.aspx
Version: 20160606
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - L3TT-instance Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL2language" runat="server" DataFile="~/metadata/L2language.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL2mode" runat="server" DataFile="~/metadata/L2mode.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlYesNo" runat="server" DataFile="~/metadata/YesNo.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlL3TTlanguageType" runat="server" DataFile="~/metadata/L3TTlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmeaningDeciphered" runat="server" DataFile="~/metadata/L3meaningDeciphered.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmodeChange" runat="server" DataFile="~/metadata/L3STmodeChange.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsOral" runat="server" DataFile="~/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3STinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3STinstance=<%=listL3STinstances.SelectedValue%>">L3ST-instance Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../L3TTinstance/metadata/">L3TT-instance Metadata</a>
    </div>

    <%-- INSTRUCTIONS BOX --%>

    <div class="instructions">
      Please fill in the following information for the L3TT-instance of your choice. Select the L3TT-instance from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3TT-instances.<br />
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- LOGIN STATUS --%>

      <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]

      <%-- INFO BOX --%>

      <div class="bar">

        <div>
        <div class="label">Select a Film</div>
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listFilms_SelectedIndexChanged" />
        </div>
        
        <asp:Panel runat="server" ID="panelConversationId" Visible="false">
          <div>
            <div class="label">Select a Conversation</div> 
            <asp:DropDownList ID="listConversations" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listConversations_SelectedIndexChanged" />
          </div>

          <asp:Panel runat="server" ID="panelL3STinstanceId" Visible="false">
            <div>
              <div class="label">Select an L3ST-instance</div> 
              <asp:DropDownList ID="listL3STinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3STinstances_SelectedIndexChanged" />
            </div>

            <asp:Panel runat="server" ID="panelL3TTinstanceId" Visible="false">
              <div class="label">Select an L3TT-instance</div> 
              <asp:DropDownList ID="listL3TTinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3TTinstances_SelectedIndexChanged" />

              <div>
                <div class="label">or add new L3TT-instance Id (e.g. <i>SpanishDub</i> or <i>SpanishSub</i> - do not include the Film Id, Conversation Id and L3ST-instance Id prefixes)</div>
                <asp:TextBox ID="txtL3TTinstance" runat="server" />
                <asp:Button ID="btnAddL3TTinstance" runat="server" Text="Add" OnClick="btnAddL3TTinstance_Click" />
                &nbsp;
                <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
              </div>
            </asp:Panel>

          </asp:Panel>
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. L3TT-instance Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. L3TT-instance Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">L3TT-instance URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <%-- TODO: maybe add image control and upload image action here? %>    


        <%-- ITrafilmMetadata --%>

        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div class="question">
          <div class="label">3. Transcription </div>
          <div class="tip">Transcription for the specific L3TT-instance (OPTIONAL)</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="question">
          <div class="label">4. Keywords</div>
          <div class="tip">Comma-separated list of keywords to help identify this item (OPTIONAL)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">5. Remarks </div>
          <div class="tip">Remarks on the metadata itself (OPTIONAL)</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>


        <%-- IL3TTinstanceMetadata --%>

        <div class="question">
          <div class="label">6. L2 language</div>
          <div class="tip">What language is L2 in?</div>
          <asp:DropDownList 
            ID="listL2language" runat="server"
            DataSourceID="xmlL2language" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">7. L2 mode</div>
          <div class="tip">Mode of L2?</div>
          <asp:DropDownList 
            ID="listL2mode" runat="server"
            DataSourceID="xmlL2mode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">8. L2 same as L3ST</div>
          <div class="tip">Is L2 same language as L3ST?</div>
          <asp:DropDownList 
            ID="listL2sameAsL3ST" runat="server"
            DataSourceID="xmlYesNo" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">9. L3ST conveyed as L3TT</div>
          <div class="tip">Has L3ST been conveyed as some sort of L3TT in the TT?</div>
          <asp:DropDownList 
            ID="listL3STconveyedAsL3TT" runat="server"
            DataSourceID="xmlYesNo" DataTextField="Title" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">10. L3TT language type</div>
          <div class="tip">With L2 as main language (L-main), what type of language is L3TT?</div>
          <asp:DropDownList 
            ID="listL3TTlanguageType" runat="server"
            DataSourceID="xmlL3TTlanguageType" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">11. L3TT language</div>
          <div class="tip">Which language is L3TT?</div>
          <asp:TextBox ID="txtL3TTlanguage" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">12. L3TT constructed based on</div>
          <div class="tip">If L3TT is “constructed”, then is based on:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3TTconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">13. L3TT meant to be understood</div>
          <div class="tip">Is L3TT meant to be understood by most of the audience?</div>
          <asp:DropDownList 
            ID="listL3TTaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3TTaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">14. L3TT required for understanding</div>
          <div class="tip">Does L3TT carry a meaningful message or one that requires it to be understood?</div>
          <asp:DropDownList 
            ID="listL3TTmessageUnderstanding" runat="server"
            DataSourceID="xmlL3TTmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">15. L3TT meaning decipherable</div>
          <div class="tip">Can the (pragmatic) meaning of L3TT be deciphered by other means? </div>
          <asp:DropDownList 
            ID="listL3TTmeaningDecipherable" runat="server"
            DataSourceID="xmlL3TTmeaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">16. L3TT speaker performance</div>
          <div class="tip">Select speaker’s L3TT proficiency and performance:</div>
          <asp:DropDownList 
            ID="listL3TTspeakerPerformance" runat="server"
            DataSourceID="xmlL3TTspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">17. L3TT mode</div>
          <div class="tip">Mode of L3TT?</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTmode" runat="server" 
              DataSourceID="xmlL3TTmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">18. L3TT represented</div>
          <div class="tip">There is no L3TT as such, strictly speaking, but rather, it is hinted at through certain "clues" verbally (in the L2) or non-verbally (visually or otherwise)</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresented" runat="server" 
              DataSourceID="xmlL3TTrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">19. L3TT represented: oral</div>
          <div class="tip">If “oral” selected for question on “L3TT represented”, specify how:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresentationsOral" runat="server" 
              DataSourceID="xmlL3TTrepresentationsOral" DataTextField="Title" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">20. L3TT represented: visual</div>
          <div class="tip">If “visual” selected for question on “L3TT represented”, specify how:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3TTrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">21. L3TT functions</div>
          <%-- <div class="tip"></div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTfunctions" runat="server"
              DataSourceID="xmlL3TTfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <%-- Calculated from L3STinstance --%>
        
        <div>
          <div class="label">L3ST language type change (Calculated from L3ST and L3TT language type)</div>
          <div class="tip">L3ST language type change in TT</div>
          <asp:ListBox ID="listL3STlanguageTypeChange" runat="server" Enabled="false" />
        </div>
        
        
        <div>
          <div class="label">L3ST mode change (Calculated from L3ST and L3TT mode)</div>
          <div class="tip">L3ST mode change in TT</div>
          <asp:ListBox ID="listL3STmodeChange" runat="server" Enabled="false" />
        </div>


        <div>
          <div class="label">L3ST functions change (Calculated from L3ST and L3TT functions)</div>
          <div class="tip">L3ST functions change in TT</div>
          <asp:ListBox ID="listL3STfunctionsChange" runat="server" Enabled="false" />
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