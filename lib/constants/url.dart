/*
 * File: url.dart
 * Project: Marie ERP
 * Created Date: 2024
 * 
 * Copyright (c) 2024 Group 17
 * 
 * Authors:
 * - All Group 17 Members
 * 
 * Description:
 * Constants file that defines all API endpoints for the Marie ERP system.
 * Contains base URL configurations for different environments and a comprehensive
 * mapping of all available API endpoints. Centralizes URL management for
 * consistent API communication across the application.
 * 
 * Features:
 * - Configurable base URL for different environments
 * - Complete API endpoint mapping
 * - Environment-specific URL switching
 * - Structured endpoint organization by feature
 * 
 * API Endpoints Categories:
 * - Authentication (login, register)
 * - Stock Management (create, edit, delete, list)
 * - Ingredient Management (list, create, edit, delete)
 * - Storage Location Management
 * - Barcode Operations
 * - File Downloads
 * 
 * Environment URLs:
 * - Production: https://app.gomarie.com/Marie-ERP/api/
 * - Development: Various local IP configurations
 * - Testing: localhost configurations
 * 
 * Usage:
 * - Import this file to access API endpoints
 * - Use endPoint map to get full URLs
 * - Switch baseUrl for different environments
 * 
 * Security Notes:
 * - HTTPS required for production
 * - Local development supports HTTP
 * - API versioning handled in base URL
 * 
 * Modified/Adapted From:
 * - Flutter URL configuration patterns
 *   Source: https://docs.flutter.dev/development/data-and-backend/networking
 */

// var baseUrl = "https://app.gomarie.com/Marie-ERP/api/";
// var baseUrl = "http://172.20.10.2:8000/api/";
// var baseUrl = "http://10.163.5.3:8000/api/";
// var baseUrl = "https://www.karbudz.online/api/";
// var baseUrl = "http://172.18.144.151:8000/api/";
// var baseUrl = "http://192.168.79.117:8000/api/"; // qi shean
// var baseUrl = "http://10.163.10.141:8000/api/";
// var baseUrl = "http://192.168.205.117:8000/api/"; // univ
// var baseUrl = "http://10.163.4.166:8000/api/"; // try and error campus wifi
// var baseUrl = "http://192.168.205.117:8000/api/"; // hotspot
// var baseUrl = "http://192.168.0.7:8000/api/"; // code black cafe
var baseUrl = "http://192.168.0.197:8000/api/"; // home

Map endPoint = {
  "login": "${baseUrl}login",
  "register": "${baseUrl}register",
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
