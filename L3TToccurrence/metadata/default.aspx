<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3TToccurrenceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3TTTToccurrence\metadata\default.aspx
Version: 20160527
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - L3TT-occurrence Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL2language" runat="server" DataFile="~/metadata/L2language.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL2mode" runat="server" DataFile="~/metadata/L2mode.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlL3TTlanguageType" runat="server" DataFile="~/metadata/L3TTlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmeaningDeciphered" runat="server" DataFile="~/metadata/L3meaningDeciphered.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmodeChange" runat="server" DataFile="~/metadata/L3STmodeChange.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsOral" runat="server" DataFile="~/metadata/L3TTrepresentationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3SToccurrence/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3SToccurrence=<%=listL3SToccurrences.SelectedValue%>">L3ST-occurrence Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../L3TToccurrence/metadata/">L3TT-occurrence Metadata</a>
    </div>

    <%-- INSTRUCTIONS BOX --%>

    <div class="instructions">
      Please fill in the following information for the L3TT-occurrence of your choice. Select the L3TT-occurrence from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3TT-occurrences.<br />
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
            <div>
              <div class="label">Select an L3ST-occurrence</div> 
              <asp:DropDownList ID="listL3SToccurrences" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3SToccurrences_SelectedIndexChanged" />
            </div>

            <asp:Panel runat="server" ID="panelL3TToccurrenceId" Visible="false">
              <div class="label">Select an L3TT-occurrence</div> 
              <asp:DropDownList ID="listL3TToccurrences" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3TToccurrences_SelectedIndexChanged" />

              <div>
                <div class="label">or add new L3TT-occurrence Id (e.g. <i>SpanishDub</i> or <i>SpanishSub</i> - do not include the Film Id, Conversation Id and L3ST-occurrence Id prefixes)</div>
                <asp:TextBox ID="txtL3TToccurrence" runat="server" />
                <asp:Button ID="btnAddL3TToccurrence" runat="server" Text="Add" OnClick="btnAddL3TToccurrence_Click" />
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
          <div class="label">1. L3TT-occurrence Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. L3TT-occurrence Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">L3TT-occurrence URL</div>
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

        <%-- IL3TToccurrenceMetadata --%>

        <div class="question">
          <div class="label">4. L2 language</div>
          <div class="tip">What language is L2 in?</div>
          <asp:DropDownList 
            ID="listL2language" runat="server"
            DataSourceID="xmlL2language" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">5. L2 mode</div>
          <div class="tip">Mode of L2?</div>
          <asp:DropDownList 
            ID="listL2mode" runat="server"
            DataSourceID="xmlL2mode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">6. L2 same as L3ST</div>
          <asp:CheckBox ID="cbL2sameAsL3ST" runat="server" Text="Is L2 same language as L3ST?" CssClass="label" />
        </div>

        <div class="question">
          <div class="label">7. L3ST conveyed as L3TT</div>
          <asp:CheckBox ID="cbL3STconveyedAsL3TT" runat="server" Text="Has L3ST been conveyed as some sort of L3TT in the TT?" CssClass="label" />
        </div>


        <div class="question">
          <div class="label">8. L3TT language type</div>
          <div class="tip">What type of language is L3TT?</div>
          <asp:DropDownList 
            ID="listL3TTlanguageType" runat="server"
            DataSourceID="xmlL3TTlanguageType" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">9. L3TT language</div>
          <div class="tip">Which language is L3TT?</div>
          <asp:TextBox ID="txtL3TTlanguage" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">10. L3TT constructed based on</div>
          <div class="tip">If L3TT is “constructed”, then is based on:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3TTconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">11. L3TT meant to be understood</div>
          <div class="tip">Is L3TT meant to be understood by most of the audience?</div>
          <asp:DropDownList 
            ID="listL3TTaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3TTaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">12. L3TT required for understanding</div>
          <div class="tip">Does L3TT carry a meaningful message or one that requires it to be understood?</div>
          <asp:DropDownList 
            ID="listL3TTmessageUnderstanding" runat="server"
            DataSourceID="xmlL3TTmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">13. L3TT meaning decipherable</div>
          <div class="tip">Can the meaning (pragmatic) of L3TT be deciphered by other means? </div>
          <asp:DropDownList 
            ID="listL3TTmeaningDecipherable" runat="server"
            DataSourceID="xmlL3TTmeaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">14. L3TT speaker performance</div>
          <div class="tip">Select speaker’s L3TT proficiency and performance:</div>
          <asp:DropDownList 
            ID="listL3TTspeakerPerformance" runat="server"
            DataSourceID="xmlL3TTspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">15. L3TT mode</div>
          <div class="tip">Mode of L3TT?</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTmode" runat="server" 
              DataSourceID="xmlL3TTmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">16. L3TT represented</div>
          <%-- <div class="tip">L3TT is represented:</div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresented" runat="server" 
              DataSourceID="xmlL3TTrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">17. L3TT oral representations</div>
          <div class="tip">If “oral” selected for L3TT representations, which:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresentationsOral" runat="server" 
              DataSourceID="xmlL3TTrepresentationsOral" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">18. L3TT visual representations</div>
          <div class="tip">If “visual” selected for L3TT representations, which:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3TTrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">19. L3TT functions</div>
          <%-- <div class="tip"></div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTfunctions" runat="server"
              DataSourceID="xmlL3TTfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <%-- Calculated from L3SToccurrence --%>
        
        <div>
          <div class="label">L3ST mode change (Calculated from L3ST mode and L3TT mode)</div>
          <div class="tip">L3ST mode change in TT</div>
          <asp:ListBox ID="listL3STmodeChange" runat="server" Enabled="false" />
        </div>


        <div>
          <div class="label">L3ST functions change (Calculated from L3ST functions and L3TT functions)</div>
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
