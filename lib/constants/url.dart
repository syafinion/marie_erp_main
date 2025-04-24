// var baseUrl = "https://app.gomarie.com/Marie-ERP/api/";
// var baseUrl = "http://172.20.10.2:8000/api/";
// var baseUrl = "http://10.163.5.3:8000/api/";
// var baseUrl = "https://www.karbudz.online/api/";
// var baseUrl = "http://172.18.144.151:8000/api/";
// var baseUrl = "http://192.168.79.117:8000/api/"; // qi shean
// var baseUrl = "http://10.163.10.141:8000/api/";
var baseUrl = "http://172.18.150.51:8000/api/"; // univ
// var baseUrl = "http://10.163.4.166:8000/api/"; // try and error campus wifi
// var baseUrl = "http://192.168.205.117:8000/api/"; // hotspot
// var baseUrl = "http://192.168.0.7:8000/api/"; // code black cafe
// var baseUrl = "http://192.168.0.197:8000/api/"; // home

Map endPoint = {
  "login": "${baseUrl}login",
  "selectingStock": "${baseUrl}stocks/selectingStock",
  "stockCreation": "${baseUrl}stocks/create",
  "stockEdit": "${baseUrl}stocks/edit",
  "stockDelete": "${baseUrl}stocks/delete",
  "common": "${baseUrl}common",
  "ingredientsList": "${baseUrl}ingredientsList",
  "createIngredient": "${baseUrl}createIngredient",
  "editIngredient": "${baseUrl}editIngredient",
  "deleteIngredientByBarcode": "${baseUrl}delete-by-barcode",
  "listLocations": "${baseUrl}storage-locations",
  "addLocation": "${baseUrl}storage-locations",
  "stockList": "${baseUrl}stocks/list",
  "updateIngredientBarcode": "${baseUrl}update-ingredient-barcode",
  "stockEdits": "${baseUrl}stocks/edit",
  "stockCreate": "${baseUrl}stocks/create",
  "storeIngredients": "${baseUrl}storeIngredients",
  "download": "${baseUrl}stocks/downloadApp",

  // New endpoint for managing stock
  "manageStock": "${baseUrl}stocks/manage",
  // New endpoint for finding ingredients by barcode
  "findIngredientByBarcode": "${baseUrl}ingredient/find-by-barcode",
};
