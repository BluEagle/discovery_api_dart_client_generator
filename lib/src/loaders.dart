part of discovery_api_client_generator;

// Workaround for Cloud Endpoints because they don't respond to requests from HttpClient
Future<String> loadCustomUrl(String url) {
  var completer = new Completer();
  Process.run("curl", ["-k", url]).then((p) {
    completer.complete(p.stdout);    
  });

  return completer.future;
}

Future<String> loadDocumentFromUrl(String url) {
  var completer = new Completer();
  var client = new HttpClient();
  
  // @damondouglas replacing 16 var connection:
  Future<HttpClientRequest> connection = client.getUrl(Uri.parse(url));
  var result = new StringBuffer();

  // @damondouglas replacing 21 connection.onRequest = (HttpClientRequest request):
  connection.then((request){
    
    // @damondouglas replacing 25 connection.onResponse = (HttpClientResponse response):
    request.response.then((response){
      
      // @damondouglas replacing 26 response.inputStream.onData:
      response.listen((data){
        
        // @damondouglas replacing 27 result.add(new String.fromCharCodes(response.inputStream.read())):
        result.write(new String.fromCharCodes(data));
       
        // @damondouglas replacing 29 response.inputStream.onClosed:
      }, onDone:(){
        client.close();
        completer.complete(result.toString());
      });
    });
    
    // @damondouglas replacing 22 request.outputStream.close():
    request.close();
    
    //@damondouglas replacing 19 connection.onError:
  }, onError:(error)=> completer.complete("Unexpected error: $error"));

  return completer.future;
}

Future<String> loadDocumentFromGoogle(String api, String version) {
  final url = "https://www.googleapis.com/discovery/v1/apis/${encodeUriComponent(api)}/${encodeUriComponent(version)}/rest";
  return loadDocumentFromUrl(url);
}

Future<String> loadDocumentFromFile(String fileName) {
  final file = new File(fileName);
  return file.readAsString();
}

Future<Map> loadGoogleAPIList() {
  var completer = new Completer();
  final url = "https://www.googleapis.com/discovery/v1/apis";
  loadDocumentFromUrl(url)
    .then((data) {
      var apis = JSON.parse(data);
      completer.complete(apis);
    })
    .catchError((e) => completer.completeError(e));
  return completer.future;
}