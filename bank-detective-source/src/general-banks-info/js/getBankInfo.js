'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getInfo = undefined;

var _banks = require('./banks');

var _banks2 = _interopRequireDefault(_banks);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var getInfo = exports.getInfo = function getInfo(bank) {
  return Object.assign({}, bank, {
    textColor: bank.text,
    logo: bank.logoSvg ? bank.logoSvg : bank.logoPng
  });
};

var isNumber = function isNumber(val) {
  return (/^\d+$/.test(val)
  );
};
var removeSpaces = function removeSpaces(val) {
  return val.replace(/\s/g, '');
};

function getBankInfo(pan) {

  pan = removeSpaces(String(pan));

  if (!isNumber(pan)) {
    return null;
  }

  // Определяем имя банка
  var prefix = pan.slice(0, 6),
      bankName = _banks2.default.prefixes[prefix];

  // Даже если по 6-и символам банк найден, то все равно проверяем по 8-и символам
  if (pan.length >= 8) {
    var tempPrefix = pan.slice(0, 8);
    var tempBankName = _banks2.default.prefixes[tempPrefix];
    if (tempBankName) {
      prefix = tempPrefix;
      bankName = tempBankName;
    }
  }

  // Неизвестный банк
  if (!bankName) {
    return null;
  }

  var bank = _banks2.default.banks[bankName];
  var bankInfo = getInfo(bank);

  return { bankInfo: bankInfo, prefix: prefix };
}

exports.default = getBankInfo;