'use strict';
const

  net = require('net'),

  server = net.createServer(function(connection) {
    console.log('Subscriber connected');

    connection.write(
      '{"type":"changed","file":"targ'
    );

    let timer = setTimeout(function() {
      connection.write('et.txt","timestamp":134543534}' + '\n');
      connection.end();
    }, 1000);

    connection.on('end', function() {
      clearTimeout(timer);
      console.log('Subscriber disconnected');
    });
  });

server.listen(8876, function() {
  console.log('Test server listening for subscribers...');
});
