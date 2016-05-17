<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3occurenceMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3occurence\metadata\default.aspx
Version: 20160516
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - L3-occurence Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL3kind" runat="server" DataFile="~/L3occurence/metadata/L3kind.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLmainLanguage" runat="server" DataFile="~/L3occurence/metadata/LmainLanguage.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLmainMode" runat="server" DataFile="~/L3occurence/metadata/LmainMode.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlL3languageType" runat="server" DataFile="~/L3occurence/metadata/L3languageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3constructedBasedOn" runat="server" DataFile="~/L3occurence/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3audienceUnderstanding" runat="server" DataFile="~/L3occurence/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3messageUnderstanding" runat="server" DataFile="~/L3occurence/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3meaningDeciphered" runat="server" DataFile="~/L3occurence/metadata/L3meaningDeciphered.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3speakerPerformance" runat="server" DataFile="~/L3occurence/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3mode" runat="server" DataFile="~/L3occurence/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmodeChange" runat="server" DataFile="~/L3occurence/metadata/L3STmodeChange.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3represented" runat="server" DataFile="~/L3occurence/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3representationsOral" runat="server" DataFile="~/L3occurence/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3representationsVisual" runat="server" DataFile="~/L3occurence/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3functions" runat="server" DataFile="~/L3occurence/metadata/L3functions.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../L3occurence/metadata/">L3-occurence Metadata</a>
    </div>

    <%-- INSTRUCTIONS BOX --%>

    <div class="instructions">
      Please fill in the following information for the L3-occurence of your choice. Select the L3-occurence from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3-occurences.<br />
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

          <asp:Panel runat="server" ID="panelL3occurenceId" Visible="false">
            <div class="label">Select an L3-occurence</div> 
            <asp:DropDownList ID="listL3occurences" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3occurences_SelectedIndexChanged" />

            <div>
              <div class="label">or add new L3-occurence Id (do not include the Film Id and Conversation Id prefixes)</div>
              <asp:TextBox ID="txtL3occurence" runat="server" />
              <asp:Button ID="btnAddL3occurence" runat="server" Text="Add" OnClick="btnAddL3occurence_Click" />
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
          <div class="label">L3-occurence Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">L3-occurence Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">L3-occurence URL</div>
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

        <%-- IL3occurenceMetadata --%>


        <div class="question">
          <div class="label">L3-occurence Start Time (h:m:s)</div>
          <div class="tip">What part of the film is L3-ST in? (i.e. how many minutes and seconds from the start)</div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="25"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">L3-occurence Duration (h:m:s)</div>
          <div class="tip">How long does L3 last? (if the L3 is interrupted by other speech, count total seconds from onset to end of final L3-occurence)</div>
          <asp:TextBox ID="txtDuration" runat="server" Columns="25"></asp:TextBox>
        </div>
        

        <div class="question">
          <div class="label">L3 kind</div>
          <div class="tip">Is this an L3ST or L3TT occurence?</div>
          <asp:DropDownList 
            ID="listL3kind" runat="server"
            DataSourceID="xmlL3kind" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L1/L2 language (for ST/TT respectively)</div>
          <div class="tip">What language is L1/L2 (for an L3ST/L3TT occurence respectively) in?</div>
          <asp:DropDownList 
            ID="listLmainLanguage" runat="server"
            DataSourceID="xmlLmainLanguage" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L1/L2 mode (for ST/TT respectively)</div>
          <div class="tip">Mode of L1/L2 (for an L3ST/L3TT occurence respectively)?</div>
          <asp:DropDownList 
            ID="listLmainMode" runat="server"
            DataSourceID="xmlLmainMode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L2 same as L3ST</div>
          <asp:CheckBox ID="cbL2sameAsL3ST" runat="server" Text="Is L2 same language as L3ST?" CssClass="label" />
        </div>

        <div class="question">
          <div class="label">L3ST conveyed as L3TT</div>
          <asp:CheckBox ID="cbL3STconveyedAsL3TT" runat="server" Text="Has L3ST been conveyed as some sort of L3 in the TT?" CssClass="label" />
        </div>


        <div class="question">
          <div class="label">L3 language type</div>
          <div class="tip">What type of language is L3?</div>
          <asp:DropDownList 
            ID="listL3languageType" runat="server"
            DataSourceID="xmlL3languageType" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 language</div>
          <div class="tip">Which language is L3?</div>
          <asp:TextBox ID="txtL3language" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">L3 constructed based on</div>
          <div class="tip">If L3 is “constructed”, then is based on:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3constructedBasedOn" runat="server" 
              DataSourceID="xmlL3constructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">L3 meant to be understood</div>
          <div class="tip">Is L3 meant to be understood by most of the audience?</div>
          <asp:DropDownList 
            ID="listL3audienceUnderstanding" runat="server"
            DataSourceID="xmlL3audienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 required for understanding</div>
          <div class="tip">Does L3 carry a meaningful message or one that requires it to be understood?</div>
          <asp:DropDownList 
            ID="listL3messageUnderstanding" runat="server"
            DataSourceID="xmlL3messageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question">
          <div class="label">L3 meaning decipherable</div>
          <div class="tip">Can the meaning (pragmatic) of L3 be deciphered by other means? </div>
          <asp:DropDownList 
            ID="listL3meaningDecipherable" runat="server"
            DataSourceID="xmlL3meaningDeciphered" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L3 speaker performance</div>
          <div class="tip">Select speaker’s L3-TT proficiency and performance:</div>
          <asp:DropDownList 
            ID="listL3speakerPerformance" runat="server"
            DataSourceID="xmlL3speakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L3 mode</div>
          <div class="tip">Mode of L3?</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3mode" runat="server" 
              DataSourceID="xmlL3mode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">L3ST mode change</div>
          <div class="tip">L3ST mode change in TT (oral to written, written to oral) - applies only to L3TT occurence kind (leave empty if “L3 kind” is L3ST):</div>
          <asp:DropDownList 
            ID="listL3STmodeChange" runat="server"
            DataSourceID="xmlL3STmodeChange" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question">
          <div class="label">L3 represented</div>
          <%-- <div class="tip">L3 is represented:</div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3represented" runat="server" 
              DataSourceID="xmlL3represented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">L3 oral representations</div>
          <div class="tip">If “oral” selected for L3 representations, which:</div>
          <div class="tip"></div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3representationsOral" runat="server" 
              DataSourceID="xmlL3representationsOral" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">L3 visual representations</div>
          <div class="tip">If “visual” selected for L3 representations, which:</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3representationsVisual" runat="server" 
              DataSourceID="xmlL3representationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">L3 functions</div>
          <%-- <div class="tip"></div> --%>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3functions" runat="server" 
              DataSourceID="xmlL3functions" DataTextField="Value" DataValueField="Value"
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
