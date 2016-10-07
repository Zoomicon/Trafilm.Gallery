//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: CXMLFileStorage.cs
//Version: 20151007

using System;
using System.Collections;
using System.Collections.Generic;
using Metadata.CXML;
using System.Xml;
using System.IO;
using System.Linq;

namespace Trafilm.Gallery
{

  public class CXMLFragmentStorage<I, T> : ICXMLMetadataStorage<I> where I: ICXMLMetadata where T : ICXMLMetadata, new()
  {

    #region --- Constants ---

    public static XmlWriterSettings DEFAULT_XML_WRITER_SETTINGS = new XmlWriterSettings() { Indent = true, IndentChars = "  " };

    #endregion

    #region --- Initialization ---

    public CXMLFragmentStorage(string collectionFile, string fragmentsFolder, string fragmentsFilter)
    {
      this.CollectionFile = collectionFile;
      this.FragmentsFolder = fragmentsFolder;
      this.FragmentsFilter = fragmentsFilter;
    }

    #endregion

    #region --- Properties ---

    public string CollectionFile { get; set; } = "../collection.cxml";
    public string FragmentsFolder { get; set; } = ".";

    public string FragmentsFilter { get; set; } = "*.cxml"; //can be used to select hierarchically named fragments, e.g. "BigBuckBunny.*.cxml" to filter for conversations of film "BigBuckBunny" and "BigBuckBunny.15.*.cxml" to filter for L3STinstances of conversation "15" in "BigBuckBunny" film

    public XmlWriterSettings XmlWritterSettings { get; set; } = DEFAULT_XML_WRITER_SETTINGS;

    public string FragmentFile(string key) {
      return Path.Combine(FragmentsFolder, key + ".cxml");
    }

    public I this[string key]
    {
      get
      {
        using (XmlReader cxml = CreateXmlReader(FragmentFile(key)))
          using (XmlReader cxmlFallback = CreateXmlReader(CollectionFile))
            return (I)new T().Load(key, cxml, cxmlFallback);
      }
      set
      {
        using (XmlWriter cxml = CreateXmlWriter(FragmentFile(key))) //will create any folder path if needed and replace existing file fragment
          value.Save(cxml);
      }
    }

    public int Count
    {
      get
      {
        return Directory.GetFiles(FragmentsFolder, FragmentsFilter).Length;
      }
    }

    public bool IsReadOnly
    {
      get
      {
        return false;
      }
    }

    public ICollection<string> Keys
    {
      get
      {
        return Directory.GetFiles(FragmentsFolder, FragmentsFilter).Select(file => Path.GetFileNameWithoutExtension(file)).ToList<string>();
      }
    }

    public ICollection<I> Values
    {
      get
      {
        return Keys.Select(key => this[key]).ToList<I>();
      }
    }

    #endregion

    #region --- Methods ---

    public void Add(KeyValuePair<string, I> item)
    {
      this[item.Key] = item.Value;
    }

    public void Add(string key, I value)
    {
      this[key] = value;
    }

    public void Clear()
    {
      foreach (string file in Directory.GetFiles(FragmentsFolder, FragmentsFilter))
        File.Delete(file);
    }

    public bool Contains(KeyValuePair<string, I> item)
    {
      return File.Exists(FragmentFile(item.Key)); //TODO: to implement this could load CXML and compare somehow item values
    }

    public bool ContainsKey(string key)
    {
      return File.Exists(FragmentFile(key));
    }

    public void CopyTo(KeyValuePair<string, I>[] array, int arrayIndex)
    {
      throw new NotImplementedException();
    }

    public IEnumerator<KeyValuePair<string, I>> GetEnumerator()
    {
      throw new NotImplementedException();
    }

    public bool Remove(KeyValuePair<string, I> item)
    {
      bool result = File.Exists(FragmentFile(item.Key));
      if (result)
        File.Delete(FragmentFile(item.Key)); //ignoring what the value is, just removing by key
      return result;
    }

    public bool Remove(string key)
    {
      try
      {
        File.Delete(FragmentFile(key));
        return true;
      }
      catch
      {
        return false;
      }
    }

    public bool TryGetValue(string key, out I value)
    {
      if (ContainsKey(key))
      {
        value = this[key];
        return true;
      }
      else
      {
        value = default(I);
        return false;
      }
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
      throw new NotImplementedException();
    }

    #endregion

    #region --- Helpers ---

    public static XmlReader CreateXmlReader(string inputUri)
    {
      try { return XmlReader.Create(inputUri); }
      catch { return null; }
    }

    public static XmlWriter CreateXmlWriter(string outputFile, XmlWriterSettings settings = null)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(outputFile))); //create any parent directories needed
      return XmlWriter.Create(outputFile, settings ?? DEFAULT_XML_WRITER_SETTINGS);
    }

    #endregion
  }

}