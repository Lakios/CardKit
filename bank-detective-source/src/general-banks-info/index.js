'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getBankInfo = exports.bankInfoCatalog = undefined;

var _getBankInfo2 = require('./js/getBankInfo');

var _getBankInfo = _interopRequireWildcard(_getBankInfo2);

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

var emptyBankInfo = {
  "name": 'Ваш банк',
  "nameEn": 'Your bank',
  "backgroundColor": '#d5d5d5',
  "textColor": '#000',
  "logo": 'color/ru-unknown.svg'
};

function applyTheme(bankInfo, config) {
  bankInfo = Object.assign({}, bankInfo);
  if (config.lightTheme && bankInfo.supportedInvertTheme) {
    bankInfo.logo = 'white/' + bankInfo.logo;
  } else if (config.bankSymbol) {
    bankInfo.logo = 'mini/' + bankInfo.logo;
  } else {
    bankInfo.logo = 'color/' + bankInfo.logo;
  }
  return bankInfo;
}

function bankInfoCatalog() {
  var config = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

  var defaultBankInfo = config.defaultBankInfo || emptyBankInfo;

  // Нужно больше для тестирования, чем для реального использования
  var customGetBankInfo = config.getBankInfo || _getBankInfo.default;

  // кэш
  var searchQuery = null,
      foundBankInfo = null,
      searchByEightCharacters = false;

  function getBankInfoWrapper(pan) {
    if (pan === undefined || pan === null) {
      return defaultBankInfo;
    }
    pan = String(pan);

    // Если попали в кэш, то возвращаем данные из кэша
    if (config.cache && searchQuery !== "" && pan.startsWith(searchQuery) && (searchByEightCharacters || pan.length < 8)) {
      return foundBankInfo;
    }

    var result = customGetBankInfo(pan);

    if (!result) {
      return defaultBankInfo;
    }

    var bankInfo = applyTheme(result.bankInfo, config);

    if (config.cache) {
      searchQuery = result.prefix;
      foundBankInfo = bankInfo;
      searchByEightCharacters = pan.length >= 8;
    }

    return bankInfo;
  }

  return getBankInfoWrapper;
}

function getBankInfoWrapper(pan) {
  var config = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

  var customGetBankInfo = config.getBankInfo || _getBankInfo.default;

  var result = customGetBankInfo(pan);
  if (!result) {
    return config.defaultBankInfo || emptyBankInfo;
  }

  return applyTheme(result.bankInfo, config);
}

exports.bankInfoCatalog = bankInfoCatalog;
exports.getBankInfo = getBankInfoWrapper;