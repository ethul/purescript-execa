'use strict';

// module Node.Execa

var execa = require('execa');

function execaFn(file, args, opts, errorback, callback) {
  return function(){
    var promise = execa(file, args, opts);

    promise.then(function(result){
      callback(result)();
    });

    promise.catch(function(error){
      errorback(error)();
    });
  };
}
exports.execaFn = execaFn;
