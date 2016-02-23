// Adds event-handling logic to any object
// Pass `my` if you want access to the object's private state
var eventuality = function (that) {
  var registry = {};

  that.fire = function (event) {
    var arr,
        func,
        handler,
        i,
        type = typeof event === 'string' ? event : event.type;

    if (registry.hasOwnProperty(type)) {
      arr = registry[type];
      for (i = 0; i < arr.length; i += 1) {
        handler = arr[i];

        func = handler.method;
        if (typeof func === 'string') {
          func = this[func];
        }

        func.apply(this, handler.parameters || [event]);
      }
    }

    return this;
  };

  that.on = function (type, method, parameters) {
    var handler = {
      method: method,
      parameters: parameters
    };

    if (registry.hasOwnProperty(type)) {
      registry[type].push(handler);
    } else {
      registry[type] = [handler];
    }

    return this;
  };

  return that;
};
