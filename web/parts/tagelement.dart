part of firestylesite;

class TagElement {
  html.DivElement _contElm;
  html.InputElement _tagElm;
  List<String> _tags = [];

  html.DivElement get contElm => _contElm;
  html.InputElement get tagElm => _tagElm;
  List<String> get tagList => _tags;

  TagElement(List<String> tags) {
//    this._tags = new List.from(tags);
    this._contElm = new html.DivElement();
    this._tagElm = new html.InputElement();
    _tagElm.style.width ="100%";
    _contElm.children.add(_tagElm);
    for(String tag in tags) {
      addTag(tag);
    }
    _tagElm.onChange.listen((e){
      var newTag =_tagElm.value;
      _tagElm.value = "";
      addTag(newTag);
    });
  }
 addTag(String tag ) {
   if(_tags.contains(tag)){
     return;
   }
   var btn = new html.ButtonElement();
   btn.text = " ${tag} (x) ";
   _contElm.children.add(btn);
   _tags.add(tag);
   btn.onClick.listen((_){
     btn.remove();
     _tags.remove(tag);
   });
 }
}
