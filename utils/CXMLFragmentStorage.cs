//Project: Trafilm.Gallery (http://trafilm.net)
//Filename: CXMLFileStorage.cs
//Version: 20150510

using System;
using System.Collections;
using System.Collections.Generic;
using Metadata.CXML;
using System.Xml;
using System.IO;
using System.Linq;

namespace Trafilm.Gallery
{

  public class CXMLFragmentStorage<T> : ICXMLMetadataStorage where T:ICXMLMetadata, new()
  {

    #region --- Properties ---

    public string CollectionFile { get; set; }
    public string FragmentsFolder { get; set; }

    public string FragmentsFilter { get; set; } = "*.cxml"; //can be used to select hierarchically named fragments, e.g. "BigBuckBunny.*.cxml" to filter for scenes of film "BigBuckBunny" and "BigBuckBunny.15.*.cxml" to filter for Utterances of scene "15" in "BigBuckBunny" film

    public string FragmentFile(string key) {
      return FragmentsFolder + "/" + key + ".cxml";
    }

    public ICXMLMetadata this[string key]
    {
      get
      {
        return new T().Load(key, CreateXmlReader(FragmentFile(key)), CreateXmlReader(CollectionFile));
      }
      set
      {
        string fragmentFile = FragmentFile(key);
        using (XmlWriter cxml = CreateXmlWriter(fragmentFile)) //will create any folder path if needed and replace existing file fragment
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

    public ICollection<ICXMLMetadata> Values
    {
      get
      {
        return Keys.Select(key => this[key]).ToList<ICXMLMetadata>();
      }
    }

    #endregion

    #region --- Methods ---

    public void Add(KeyValuePair<string, ICXMLMetadata> item)
    {
      this[item.Key] = item.Value;
    }

    public void Add(string key, ICXMLMetadata value)
    {
      this[key] = value;
    }

    public void Clear()
    {
      foreach (string file in Directory.GetFiles(FragmentsFolder, FragmentsFilter))
        File.Delete(file);
    }

    public bool Contains(KeyValuePair<string, ICXMLMetadata> item)
    {
      return File.Exists(FragmentFile(item.Key)); //TODO: should load CXML and compare somehow values?
    }

    public bool ContainsKey(string key)
    {
      return File.Exists(FragmentFile(key));
    }

    public void CopyTo(KeyValuePair<string, ICXMLMetadata>[] array, int arrayIndex)
    {
      throw new NotImplementedException();
    }

    public IEnumerator<KeyValuePair<string, ICXMLMetadata>> GetEnumerator()
    {
      throw new NotImplementedException();
    }

    public bool Remove(KeyValuePair<string, ICXMLMetadata> item)
    {
      File.Delete(FragmentFile(item.Key)); //ignoring what the value is, just removing by key
      return true; //TODO: check documentation
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

    public bool TryGetValue(string key, out ICXMLMetadata value)
    {
      if (ContainsKey(key))
      {
        value = this[key];
        return true;
      }
      else
      {
        value = null;
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

    public static XmlWriter CreateXmlWriter(string outputFile)
    {
      Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(outputFile))); //create any parent directories needed
      return XmlWriter.Create(outputFile);
    }

    #endregion
  }

}