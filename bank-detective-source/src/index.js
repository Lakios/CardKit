let bankInfo = require('./general-banks-info');

window.__bankInfo = bankInfo;

function _postMessage(op, data) {
  window.webkit.messageHandlers.interOp.postMessage({op, data});
}

_postMessage('ready', {});

var _lightTheme = false;
var _getBankInfo = __bankInfo.getBankInfo;

window.__showBank = function(number, lightTheme) {
  if (lightTheme != _lightTheme) {
    _lightTheme = lightTheme;
    _getBankInfo = b__bankInfo.bankInfoCatalog({lightTheme: _lightTheme});
  }
  let view = document.getElementById('view');

  let info = _getBankInfo(number);

  view.innerHTML = '<img src="./images/bank-logos/' + info.logo + '"/>';
};
