<%@ Page Language="C#" 
         AutoEventWireup="true"
         Title="Trafilm Metadata"
%>

<%--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: Default.aspx
Version: 20160608
--%>

<html>

<head>

<title>Trafilm Gallery | The Translation of Multilingual Films in Spain</title>
<link rel="shortcut icon" type="image/ico" href='/favicon.ico' />

<style type="text/css">
body
{
  margin:0;
  padding:0;
  overflow-y:auto;
}

iframe 
{
  width:100%;
  height:100%;
  border:0;
  margin:0;
  padding:0;
}
</style>

</head>

<body>
  <iframe src="http://gallery.trafilm.net/film">
    <a href="http://gallery.trafilm.net/film">Trafilm Gallery | Films</a>
  </iframe>

  <iframe src="http://gallery.trafilm.net/conversation">
    <a href="http://gallery.trafilm.net/conversation">Trafilm Gallery | Conversations</a>
  </iframe>

  <iframe src="http://gallery.trafilm.net/L3STinstance">
    <a href="http://gallery.trafilm.net/L3STinstance">Trafilm Gallery | L3ST-instances</a>
  </iframe>

  <iframe src="http://gallery.trafilm.net/L3TTinstance">
    <a href="http://gallery.trafilm.net/L3TTinstance">Trafilm Gallery | L3TT-instances</a>
  </iframe>

</body>

</html>