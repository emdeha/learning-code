var xhrSuccess = function () {
  this.callback.apply(this, this.arguments)
}

var xhrError = function () {
  console.error(this.statusText)
}

var loadFile = function (sURL, timeout, fCallback /*, args to callback */) {
  var oReq = new XMLHttpRequest()
  oReq.callback = fCallback
  oReq.arguments = Array.prototype.slice.call(arguments, 2)
  oReq.ontimeout = function () {
    console.error('request timed out')
  }
  oReq.onload = xhrSuccess
  oReq.onerror = xhrError
  oReq.open('GET', sURL, true)
  oReq.timeout = timeout
  oReq.send(null)
}

var showMsg = function (sMsg) {
  alert(sMsg + this.responseText)
}

loadFile('https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Synchronous_and_Asynchronous_Requests', 500, showMsg, 'New message\n\n')
