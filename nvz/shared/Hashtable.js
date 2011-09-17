var Hashtable = function() {

  var table = {};

  this.put = function(key, value) {
    table[key] = value;
  };

  this.get = function(key) {
    return table[key];
  };

  this.forEach = function(fn) {
    for (key in table) {
      fn(key, table[key]);
    }
  };

  this.delete = function(key) {
    var deleted = table[key];
    delete table[key];
    return deleted;
  }

};

module.exports = Hashtable;
