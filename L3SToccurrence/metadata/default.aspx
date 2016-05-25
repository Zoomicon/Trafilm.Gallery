<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3SToccurrenceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3SToccurrence\metadata\default.aspx
Version: 20160525
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - L3ST-occurrence Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL3STlanguageType" runat="server" DataFile="~/metadata/L3languageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmeaningDeciphered" runat="server" DataFile="~/metadata/L3meaningDeciphered.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsOral" runat="server" DataFile="~/metadata/L3STrepresentationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../L3SToccurrence/metadata/">L3ST-occurrence Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3TToccurrence/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3SToccurrence=<%=listL3SToccurrences.SelectedValue%>">L3TT-occurrence Metadata</a>
    </div>

    <%-- INSTRUCTIONS BOX --%>

    <div class="instructions">
      Please fill in the following information for the L3ST-occurrence of your choice. Select the L3ST-occurrence from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3ST-occurrences.<br />
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

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

          <asp:Panel runat="server" ID="panelL3SToccurrenceId" Visible="false">
            <div class="label">Select an L3ST-occurrence</div> 
            <asp:DropDownList ID="listL3SToccurrences" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3SToccurrences_SelectedIndexChanged" />

            <div>
              <div class="label">or add new L3ST-occurrence Id (do not include the Film Id and Conversation Id prefixes)</div>
              <asp:TextBox ID="txtL3SToccurrence" runat="server" />
              <asp:Button ID="btnAddL3SToccurrence" runat="server" Text="Add" OnClick="btnAddL3SToccurrence_Click" />
              &nbsp;
              <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
            </div>
          </asp:Panel>

        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. L3ST-occurrence Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. L3ST-occurrence Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">L3ST-occurrence URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <%-- ITrafilmMetadata --%>

        <div class="question">
          <div class="label">3. Keywords (comma-separated)</div>
          <div class="tip">Enter OPTIONAL list of keywords to help identify this item</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- IL3SToccurrenceMetadata --%>


        <div class="question">
          <div class="label">4. L3ST-occurrence Start Time (h:m:s)</div>
          <div class="tip">What part of the film is L3ST in? (i.e. how many minutes and seconds from the start)</div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="25"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">5. L3ST-occurrence Duration (h:m:s)</div>
          <div class="tip">How long does L3ST last? (if the L3ST is interrupted by other speech, count total seconds from onset to end of final L3ST-occurrence)</div>
          <asp:TextBox ID="txtDuration" runat="server" Columns="25"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">6. L3ST language type</div>
          <div class="tip">What type of language is L3ST?</div>
          <asp:DropDownList 
            ID="listL3STlanguageType" runat="server"
            DataSourceID="xmlL3STlanguageType" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">7. L3ST language</div>
          <div class="tip">Which language is L3ST?</div>
          <asp:TextBox ID="txtL3STlanguage" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">8. L3ST constructed based on</div>
          <div class="tip">If L3ST is “constructed”, then is based on:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3STconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">9. L3ST meant to be understood</div>
          <div class="tip">Is L3ST meant to be understood by most of the audience?</div>
          <asp:DropDownList 
            ID="listL3STaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3STaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">10. L3ST required for understanding</div>
          <div class="tip">Does L3ST carry a meaningful message or one that requires it to be understood?</div>
          <asp:DropDownList 
            ID="listL3STmessageUnderstanding" runat="server"
            DataSourceID="xmlL3STmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">11. L3ST meaning decipherable</div>
          <div class="tip">Can the meaning (pragmatic) of L3ST be deciphered by other means? </div>
          <asp:DropDownList 
            ID="listL3STmeaningDecipherable" runat="server"
            DataSourceID="xmlL3STmeaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">12. L3ST speaker performance</div>
          <div class="tip">Select speaker’s L3ST proficiency and performance:</div>
          <asp:DropDownList 
            ID="listL3STspeakerPerformance" runat="server"
            DataSourceID="xmlL3STspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">13. L3ST mode</div>
          <div class="tip">Mode of L3ST?</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STmode" runat="server" 
              DataSourceID="xmlL3STmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">14. L3ST represented</div>
          <%-- <div class="tip">L3ST is represented:</div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresented" runat="server" 
              DataSourceID="xmlL3STrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">15. L3ST oral representations</div>
          <div class="tip">If “oral” selected for L3ST representations, which:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsOral" runat="server" 
              DataSourceID="xmlL3STrepresentationsOral" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">16. L3ST visual representations</div>
          <div class="tip">If “visual” selected for L3ST representations, which:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3STrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">17. L3ST functions</div>
          <%-- <div class="tip"></div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STfunctions" runat="server" 
              DataSourceID="xmlL3STfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
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
