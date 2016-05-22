//import Dict, List, Maybe, Native.Scheduler //

var _iamfromspace$elm_hash$Native_Hash = function() {
  function hash(encoding, alg, output, msg) {
    return _elm_lang$core$Native_Scheduler.nativeBinding(function(cb) {
      var e, a, o;
      switch (encoding.ctor) {
        case 'Utf8': e = 'utf-8'; break;
        case 'Utf16be': e = 'utf-16be'; break;
        case 'Utf16le': e = 'utf-16le'; break;
      }
      switch (alg.ctor) {
        case 'Sha1': a = 'SHA-1'; break;
        case 'Sha256': a = 'SHA-256'; break;
        case 'Sha384': a = 'SHA-384'; break;
        case 'Sha512': a = 'SHA-512'; break;
      }
      switch (output.ctor) {
        case 'Hex': o = hex; break;
        case 'Bin': o = bin; break;
        case 'Base64': o = b64; break;
      }

      var buffer = new TextEncoder(e).encode(msg);
      return crypto.subtle.digest(a, buffer).then(function(hash) {
        var s = o(hash);
        cb(_elm_lang$core$Native_Scheduler.succeed(s));
      });
    })
  }

  function hex(buffer) {
    var hexCodes = [];
    var view = new DataView(buffer);
    for (var i = 0; i < view.byteLength; i += 4) {
      // Using getUint32 reduces the number of iterations needed (we process 4 bytes each time)
      var value = view.getUint32(i)
      // toString(16) will give the hex representation of the number without padding
      var stringValue = value.toString(16)
      // We use concatenation and slice for padding
      var padding = '00000000'
      var paddedValue = (padding + stringValue).slice(-padding.length)
      hexCodes.push(paddedValue);
    }

    // Join all the hex strings into one
    return hexCodes.join("");
  }

  function b64(buffer) {
    var b64Codes = [];
    var view = new DataView(buffer);
    for (var i = 0; i < view.byteLength; i += 1) {
      var value = view.getUint8(i)
      var stringValue = String.fromCharCode(value);
      b64Codes.push(stringValue);
    }
    return btoa(b64Codes.join(""));
  }

  // TODO: This is just a rehash of 'hex', so they can be combined into a generic function
  function bin(buffer) {
    var binCodes = [];
    var view = new DataView(buffer);
    for (var i = 0; i < view.byteLength; i += 4) {
      var value = view.getUint32(i)
      var stringValue = value.toString(2)
      var padding = '00000000000000000000000000000000'
      var paddedValue = (padding + stringValue).slice(-padding.length)
      binCodes.push(paddedValue);
    }
    return binCodes.join("");
  }

  return { hash: F4(hash) };
}();
