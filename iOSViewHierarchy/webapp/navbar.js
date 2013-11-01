function Navbar(options) {
  
  var o = options;
  
  var dom = $('<div class="navbar"></div>');
  var title  = $('<div class="navbar_title">iOS Hierarchy Viewer</div>');
  var loading = $('<div class="navbar_loading">Loading....</div>');
  
  dom.append(title);
  dom.append(loading);
  o.parentDom.append(dom);
  
  var showLoadingFunc = function() { loading.show(); }
  var hideLoadingFunc = function() { loading.hide(); }
  
  var versionFunc = function(ver) {
    title.text('iOS Hierarchy Viewer (' + ver + ')');
  };
  
  hideLoadingFunc();
  
  return {
    domElement: dom,
    version: versionFunc,
    showLoading: showLoadingFunc,
    hideLoading: hideLoadingFunc
  };
}
