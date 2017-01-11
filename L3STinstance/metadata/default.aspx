<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3STinstanceMetadataPage" %>
<%@ Import namespace="Trafilm.Gallery" %>

<!DOCTYPE html>

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3STinstance\metadata\default.aspx
Version: 20170112
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | L3ST-instances</title>

    <meta name="viewport" content="width=400, user-scalable=yes, initial-scale=1" />

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL3STlanguageType" runat="server" DataFile="~/metadata/L3STlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmeaningDecipherable" runat="server" DataFile="~/metadata/L3meaningDecipherable.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsOral" runat="server" DataFile="~/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STconversationFeatures" runat="server" DataFile="~/metadata/L3conversationFeatures.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STsources" runat="server" DataFile="~/metadata/L3sources.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlConversationDuration" runat="server" DataFile="~/metadata/ConversationDuration.xml" XPath="Facet/String" />


    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../L3STinstance/metadata/">L3ST-instance Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3STinstance=<%=listL3STinstances.SelectedValue%>">L3TT-instance Metadata</a>
    </div>


    <%-- INSTRUCTIONS BOX --%>

    <div class="instructions">
      Please fill in the following information for the L3ST-instance of your choice. Select it using the dropdown lists.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3ST-instances.<br />
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
            <div class="label">Select an L3ST-instance</div> 
            <asp:DropDownList ID="listL3STinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3STinstances_SelectedIndexChanged" />

            <asp:Panel ID="panelAdd" runat="server">
              <div class="label">or add new L3ST-instance Id (e.g. <i>Speaking Chinese</i> - do not include the Film Id and Conversation Id prefixes)</div>
              <asp:TextBox ID="txtL3STinstance" runat="server" MaxLength="50" />
              <br />
              <asp:Button ID="btnAddL3STinstance" runat="server" Text="Add" OnClick="btnAddL3STinstance_Click" />
              &nbsp;
              <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
              &nbsp;&nbsp;
              <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
            </asp:Panel>
          </asp:Panel>

        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question" id="Title">
          <div class="label">1. L3ST-instance Title</div>
          <div class="tip">Free text descriptive title (&lt;50 characters)</div>
          <asp:TextBox ID="txtTitle" runat="server" />
        </div>

        <div class="question" id="Description">
          <div class="label">2. L3ST-instance Description</div>
          <div class="tip">Free text brief description (<200 characters)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="calculated" id="URL">
          <div class="label">L3ST-instance URL</div>
          <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />
        </div>

        <div class="question" id="Image">
          <div class="label">3. Image URL</div>
          <asp:TextBox ID="txtImageUrl" runat="server" />
        </div>


        <%-- IL3STinstanceMetadata --%>

        <div class="calculated" id="ConversationStartTime">
          <div class="label">Conversation start time (min) (Calculated from Conversation)</div>
          <div class="tip">What part of the film is the Conversation in? (i.e. how many minutes from the start)</div>
          <asp:Label ID="lblConversationStartTime" runat="server" />
        </div>

        <div class="calculated" id="ConversationDuration">
          <div class="label">Conversation duration (sec) (Calculated from Conversation)</div>
          <div class="tip">How long does the Conversation last? (if L3ST instances are interrupted by other speech, count total seconds from onset to end of final L3ST-instance)</div>
          <asp:Label ID="lblConversationDuration" runat="server" />
        </div>


        <div class="calculated" id="L1 language">
          <div class="label">L1 language (Calculated from Film)</div>
          <div class="tip">What language is L1 in?</div>
          <asp:Label ID="lblL1language" runat="server" />
        </div>


        <div class="question" id="L3STlanguageType">
          <div class="label">4. L3ST language type</div>
          <div class="tip">With L1 as main language (L-main), what type of language is L3ST?</div>
          <asp:DropDownList 
            ID="listL3STlanguageType" runat="server"
            DataSourceID="xmlL3STlanguageType" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question" id="L3STlanguage">
          <div class="label">5. L3ST language</div>
          <div class="tip">Which language is L3ST?</div>
          <asp:TextBox ID="txtL3STlanguage" runat="server" />
        </div>


        <div class="question" id="L3STconstructedBasedOn">
          <div class="label">6. L3ST constructed based on</div>
          <div class="tip">If L3ST is “constructed”, is it based on any of the following options?</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3STconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STaudienceUnderstanding">
          <div class="label">7. L3ST meant to be understood</div>
          <div class="tip">Is L3ST meant to be understood by most of the audience?</div>
          <asp:DropDownList 
            ID="listL3STaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3STaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L3STmessageUnderstanding">
          <div class="label">8. L3ST message required for understanding</div>
          <div class="tip">Does L3ST carry a meaningful message or one that requires it to be understood?</div>
          <asp:DropDownList 
            ID="listL3STmessageUnderstanding" runat="server"
            DataSourceID="xmlL3STmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L3STmeaningDecipherable">
          <div class="label">9. L3ST meaning decipherable</div>
          <div class="tip">Can the (pragmatic) meaning of L3ST be deciphered by other means? </div>
          <asp:DropDownList 
            ID="listL3STmeaningDecipherable" runat="server"
            DataSourceID="xmlL3STmeaningDecipherable" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="L3STspeakerPerformance">
          <div class="label">10. Quality of L3ST speaker performance</div>
          <div class="tip">How well is the L3ST spoken?</div>
          <asp:DropDownList 
            ID="listL3STspeakerPerformance" runat="server"
            DataSourceID="xmlL3STspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="L3STmode">
          <div class="label">11. L3ST mode, written/spoken, diegetic</div>
          <div class="tip">Mode of L3ST?</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STmode" runat="server" 
              DataSourceID="xmlL3STmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STrepresented">
          <div class="label">12. L3ST merely represented</div>
          <div class="tip">There is no actual L3ST, but there are clues</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresented" runat="server" 
              DataSourceID="xmlL3STrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question" id="L3STrepresentedOrally">
          <div class="label">13. L3ST merely represented orally</div>
          <div class="tip">If “oral” selected for question on “L3ST represented”, specify how:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsOral" runat="server" 
              DataSourceID="xmlL3STrepresentationsOral" DataTextField="Title" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question" id="L3STrepresentedVisually">
          <div class="label">14. L3ST represented: visual</div>
          <div class="tip">If “visual” selected for question on “L3ST represented”, specify how:</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3STrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STfunctions">
          <div class="label">15. L3ST functions</div>
          <div class="tip">What are the functions for this particular instance of L3ST?</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STfunctions" runat="server" 
              DataSourceID="xmlL3STfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STconversationFeatures">
          <div class="label">16. Conversation features for L3ST-instance</div>
          <div class="tip">Conversation types or features (functional or otherwise) related to L3ST presence</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STconversationFeatures" runat="server"
              DataSourceID="xmlL3STconversationFeatures" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="8" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        
        <div class="question" id="L3STsources">
          <div class="label">17. L3ST sources <i>(with or without main language mix)</i></div>
          <div class="tip">Choose the description that best explains the number of sources (on or off screen, oral or written) and whether the main language is mixed with L3 (Main language, or “main”, is L1 for L3ST-instances)</div>
          <asp:DropDownList
            ID="listL3STsources" runat="server"
            DataSourceID="xmlL3STsources" DataTextField="Title" DataValueField="Value"
            />
        </div>


        <%-- Calculated from L3TTinstances --%>

        <%-- //Count shown in parentheses next to title of respective list
        <div class="calculated" id=L3TTinstanceCount">
          <div class="label">Count of L3TT-instances (Calculated)</div>
          <asp:Label ID="lblL3TTinstanceCount" runat="server" />
        </div>    
        --%>

        <%-- ITrafilmMetadata --%>

        <div class="question" id="Transcription">
          <div class="label">18. Transcription </div>
          <div class="tip">Transcription for the specific L3ST-instance</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="question" id="Tags">
          <div class="label">19. Tags</div>
          <div class="tip">Keywords or other labels for filtering purposes , insert a comma (,) between different ones</div>
          <asp:TextBox ID="txtTags" runat="server" />
        </div>

        <div class="question" id="Remarks">
          <div class="label">20. Remarks </div>
          <div class="tip">Issues concerning the analysis or the metadata form design</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" />
        </div>


        <div class="calculated" id="InfoDates">
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div class="calculated" id="MetadataEditors">
          <div class="label">Metadata Editors</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listMetadataEditors" runat="server" Enabled="false" />
           </asp:Panel>
        </div>


        <%-- SAVE BUTTON --%>
           
        <asp:Panel ID="panelSave" runat="server">
          <br />
          <asp:Button ID="btnSave" runat="server"
            Text="Save metadata"
            Font-Bold="true"
            height="50"
            OnClick="btnSave_Click"
            />
          &nbsp;
          &nbsp;
          <i>Gallery contents are updated periodically during the day from saved metadata</i>
          <br /><br />
        </asp:Panel>


        <%-- L3TTinstances list --%>                  

        <div class="calculated" id="L3TTinstances">
          <div class="label">L3TT-instances (#<asp:Label ID="lblL3TTinstanceCount" runat="server" />)</div>
          <asp:Repeater ID="repeaterL3TTinstances" runat="server">
            <ItemTemplate>
              <a href="../../L3TTinstance/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>&L3STinstance=<%#Eval("L3STinstanceId")%>&L3TTinstance=<%#Eval("L3TTinstanceId")%>"><%#Eval("L3TTinstanceId").ToString().TrimStart(Eval("L3STinstanceId").ToString() + ".")%></a>&nbsp;&nbsp;
            </ItemTemplate>
          </asp:Repeater>
        </div>

        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>
