var oReq = new XMLHttpRequest()

oReq.onprogress = function (e) {
  if (e.lengthComputable) {
    var percent = e.loaded / e.total

    var percentEl = document.getElementById('percent')
    percentEl.innerHTML = percent + '%'
  }
}

oReq.onload = function (e) {
  var percentEl = document.getElementById('percent')
  percentEl.innerHTML = 'done'
}

oReq.onerror = function (e) {
  var percentEl = document.getElementById('percent')
  percentEl.innerHTML = 'error'
}

oReq.onabort = function (e) {
  var percentEl = document.getElementById('percent')
  percentEl.innerHTML = 'aborted'
}

oReq.open('GET', 'https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Synchronous_and_Asynchronous_Requests')
oReq.send(null)
