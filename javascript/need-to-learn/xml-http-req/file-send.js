var xhr = new XMLHttpRequest()
xhr.open("GET", "https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Synchronous_and_Asynchronous_Requests", true)
xhr.onload = function (e) {
  if (xhr.readyState === 4) {
    if (xhr.status === 200) {
      console.log(xhr.responseText)
    } else {
      console.error(xhr.statusText)
    }
  }
}
xhr.onerror = function (resp) {
  console.log(xhr.statusText)
}

xhr.send(null)
