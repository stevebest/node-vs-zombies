var __slice = Array.prototype.slice;

var Hashtable = function(object) {

  var table = {};

  if ("undefined" !== typeof object) {
    table = object; // clone?
  }

  this.put = function(key, value) {
    table[key] = value;
  };

  this.get = function(key) {
    return table[key];
  };

  this.forEach = function(fn) {
    for (var key in table) {
      fn(key, table[key]);
    }
  };

  this.find = function(fn) {
    for (var key in table) {
      if (fn(table[key])) {
        return table[key];
      }
    }
    return null;
  }

  this.invoke = function() {
    var methodName = arguments[0];
    var a = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    var result = {};
    this.forEach(function(k, v) {
      return result[k] = v[methodName].apply(v, a);
    });
    return result;
  };

  this.all = function() {
    return table;
  }

  this.delete = function(key) {
    var deleted = table[key];
    delete table[key];
    return deleted;
  }

  this.isEmpty = function() {
    for (key in table) {
      return false;
    }
    return true;
  }

};

module.exports = Hashtable;
