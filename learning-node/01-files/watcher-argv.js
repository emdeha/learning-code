const
  fs = require("fs"),
  filename = process.argv[2];
if (!filename) {
  throw Error("A file to watch must be specified!");
}
fs.watch(filename, function() {
  console.log("File " + filename + " modified!");
});
console.log("Starting to watch file " + filename + " for modifications!");
