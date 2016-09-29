<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3TTinstanceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3TTinstance\metadata\default.aspx
Version: 20160929
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | L3TT-instances</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL2language" runat="server" DataFile="~/metadata/L2language.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL2mode" runat="server" DataFile="~/metadata/L2mode.xml" XPath="Facet/String" />  
    <asp:XmlDataSource ID="xmlBlockbuster" runat="server" DataFile="~/metadata/Blockbuster.xml" XPath="Facet/String" />      
    <asp:XmlDataSource ID="xmlYesNo" runat="server" DataFile="~/metadata/YesNo.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlL3TTlanguageType" runat="server" DataFile="~/metadata/L3TTlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmeaningDecipherable" runat="server" DataFile="~/metadata/L3meaningDecipherable.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmodeChange" runat="server" DataFile="~/metadata/L3STmodeChange.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsOral" runat="server" DataFile="~/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTconversationFeatures" runat="server" DataFile="~/metadata/L3conversationFeatures.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTsources" runat="server" DataFile="~/metadata/L3sources.xml" XPath="Facet/String" />


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

              <asp:Panel ID="panelAdd" runat="server">
                <div class="label">or add new L3TT-instance Id (e.g. <i>SpanishDub</i> or <i>SpanishSub</i> - do not include the Film Id, Conversation Id and L3ST-instance Id prefixes)</div>
                <asp:TextBox ID="txtL3TTinstance" runat="server" />
                <asp:Button ID="btnAddL3TTinstance" runat="server" Text="Add" OnClick="btnAddL3TTinstance_Click" />
                &nbsp;
                <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
                &nbsp;
                <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
              </asp:Panel>
            </asp:Panel>

          </asp:Panel>
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. L3TT-instance Title</div>
          <div class="tip">Free text descriptive title (&lt;50 characters)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150" />
        </div>

        <div class="label">
          <div class="label">Description (Calculated from L3ST-instance)</div>
          <div class="tip">Free text brief description (<200 characters)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" ReadOnly="true" />
        </div>

        <div class="label">L3TT-instance URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div class="label">
          <div class="label">Image URL (Calculated from L3ST-instance)</div>
          <asp:Label ID="lblImageUrl" runat="server" />
        </div>   


        <%-- IL3TTinstanceMetadata --%>

        <div class="question">
          <div class="label">2. Film Title TT</div>
          <asp:TextBox ID="txtFilmTitleTT" runat="server" Columns="150" />
        </div>


        <div class="question">
          <div class="label">3. L2 language</div>
          <div class="tip">What language is L2 in?</div>
          <asp:DropDownList 
            ID="listL2language" runat="server"
            DataSourceID="xmlL2language" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">4. L2 mode</div>
          <div class="tip">Mode of L2?</div>
          <asp:DropDownList 
            ID="listL2mode" runat="server"
            DataSourceID="xmlL2mode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">5. Distribution countries (TT)</div>
          <div class="tip">Full name(s), insert a comma (,) between different countries</div>
          <asp:TextBox ID="txtDistributionCountriesTT" runat="server" Columns="150" />
        </div>

        <div class="question">
          <div class="label">6. Year TT released</div>
          <asp:TextBox ID="txtYearTTreleased" runat="server" />
        </div>


        <div class="question">
          <div class="label">7. Film TT Blockbuster</div>
          <div class="tip">Is the TT version ranked in the top 20 where distributed?</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listBlockbusterTT" runat="server"
              DataSourceID="xmlBlockbuster" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="label">
          <div class="label">Conversation Start Time (min) (Calculated from Conversation)</div>
          <div class="tip">What part of the film is the Conversation in? (i.e. how many minutes and seconds from the start)</div>
          <asp:Label ID="lblStartTime" runat="server" />
        </div>

        <div class="label">
          <div class="label">Conversation Duration (min) (Calculated from Conversation)</div>
          <div class="tip">How long does the Conversation last? (if L3ST insances are interrupted by other speech, count total seconds from onset to end of final L3ST-instance)</div>
          <asp:Label ID="lblDuration" runat="server" />
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
          <asp:TextBox ID="txtL3TTlanguage" runat="server" Columns="150" />
        </div>


        <div class="question">
          <div class="label">12. L3TT constructed based on</div>
          <div class="tip">If L3TT is “constructed”, is it based on any of the following options?</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
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
          <div class="label">14. L3TT message required for understanding</div>
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
            DataSourceID="xmlL3TTmeaningDecipherable" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">16. Quality of L3TT speaker performance</div>
          <div class="tip">How well is the L3TT spoken?</div>
          <asp:DropDownList 
            ID="listL3TTspeakerPerformance" runat="server"
            DataSourceID="xmlL3TTspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">17. L3TT mode, written/spoken, diegetic</div>
          <div class="tip">Mode of L3TT?</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:CheckBoxList ID="clistL3TTmode" runat="server" 
              DataSourceID="xmlL3TTmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">18. L3TT merely represented</div>
          <div class="tip">There is no actual L3TT, but there are clues</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:CheckBoxList ID="clistL3TTrepresented" runat="server" 
              DataSourceID="xmlL3TTrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">19. L3TT merely represented orally</div>
          <div class="tip">If “oral” selected for question on “L3TT represented”, specify how:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:CheckBoxList ID="clistL3TTrepresentationsOral" runat="server" 
              DataSourceID="xmlL3TTrepresentationsOral" DataTextField="Title" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">20. L3TT represented: visual</div>
          <div class="tip">If “visual” selected for question on “L3TT represented”, specify how:</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:CheckBoxList ID="clistL3TTrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3TTrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">21. L3TT functions</div>
          <div class="tip">What are the functions for this particular instance of L3TT?</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:CheckBoxList ID="clistL3TTfunctions" runat="server"
              DataSourceID="xmlL3TTfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">22. Conversation features for L3TT-instance</div>
          <div class="tip">Conversation types or features (functional or otherwise) related to L3TT presence</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:CheckBoxList ID="clistL3TTconversationFeatures" runat="server"
              DataSourceID="xmlL3TTconversationFeatures" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">23. L3TT sources <i>(with or without main language mix)</i></div>
          <div class="tip">Choose the description that best explains the number of sources (on or off screen, oral or written) and whether the main language is mixed with L3 (Main language, or “main”, is L2 for L3TT-instances)</div>
          <asp:DropDownList
            ID="listL3TTsources" runat="server"
            DataSourceID="xmlL3TTsources" DataTextField="Title" DataValueField="Value"
            />
        </div>


        <%-- Calculated from L3STinstance --%>
        
        <div>
          <div class="label">L3 language type change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST language type: change in TT</div>
          <asp:ListBox ID="listL3languageTypeChange" runat="server" Enabled="false" />
        </div>
                
        <div>
          <div class="label">L3 mode change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST mode: change in TT</div>
          <asp:ListBox ID="listL3modeChange" runat="server" Enabled="false" />
        </div>

        <div>
          <div class="label">L3 functions change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST functions: change in TT</div>
          <asp:ListBox ID="listL3functionsChange" runat="server" Enabled="false" />
        </div>

        <div>
          <div class="label">Conversation features for L3-instance change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">Conversation features for L3ST-instance: change in TT</div>
          <asp:ListBox ID="listL3conversationFeaturesChange" runat="server" Enabled="false" />
        </div>
        
        <div>
          <div class="label">L3 sources change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST sources: change in TT</div>
          <asp:ListBox ID="listL3sourcesChange" runat="server" Enabled="false" />
        </div>


        <%-- ITrafilmMetadata --%>

        <div class="question">
          <div class="label">24. Transcription </div>
          <div class="tip">Transcription for the specific L3TT-instance</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="question">
          <div class="label">25. Tags</div>
          <div class="tip">Keywords or other labels for filtering purposes , insert a comma (,) between different ones</div>
          <asp:TextBox ID="txtTags" runat="server" Columns="150" />
        </div>

        <div class="question">
          <div class="label">26. Remarks </div>
          <div class="tip">Issues concerning the analysis or the metadata form design</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>


        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div>
          <div class="label">Metadata Editors</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
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
          <br /><br />
        </asp:Panel>


        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>
