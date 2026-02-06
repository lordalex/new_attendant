# Implementation Guide - Ticket Display

## ✅ COMPLETED FUNCTIONS

All these functions are in `lib/flutter_flow/custom_functions.dart`:

### 1. Time Functions (WORKING)
```dart
getTimeDifferenceFromTicket(ticketJson)
→ Returns: "02d 10h 04m 14s"
```

### 2. Vehicle Functions
```dart
getVehicleIdFromTicket(ticketJson)
→ Returns: "fpjSMNhudv4rUEWarsGp"

formatVehicleDisplay(vehicleJson)
→ Returns: "2023 Toyota Camry - Silver (CA-ABC123)"
```

### 3. Custom Action (NEW)
```dart
fetchVehicleDetails(vehicleId, apiUrl, idToken)
→ Returns: VehicleData JSON with model, color, plate, etc.
```
File: `lib/custom_code/actions/fetch_vehicle_details.dart`

### 4. Image Functions
```dart
getClientPhotoFromTicket(ticketJson)
→ Returns: Photo URL or ""

hasValidClientPhoto(ticketJson)
→ Returns: true/false
```

---

## 🔧 FLUTTERFLOW SETUP STEPS

### STEP 1: Add Page Variables
Go to your ticket detail page and add these App/Page Variables:

1. **vehicleId** (String)
2. **vehicleData** (String) - will store JSON
3. **timeDifference** (String)

### STEP 2: On Page Load Actions

**Action 1: Set Time Difference**
- Action: Update Page State
- Variable: timeDifference
- Value: `getTimeDifferenceFromTicket(widget.ticketItem)`

**Action 2: Get Vehicle ID**
- Action: Update Page State
- Variable: vehicleId
- Value: `getVehicleIdFromTicket(widget.ticketItem)`

**Action 3: Fetch Vehicle Details (CONDITIONAL)**
- Action: Run Custom Action
- Action: `fetchVehicleDetails`
- Parameters:
  - vehicleId: `vehicleId` (from page state)
  - apiUrl: `"https://api.knex-app.xyz/api"` (your API URL)
  - idToken: `currentUserToken` (or however you get the auth token)
- Save Result To: `vehicleData`

**Condition for Action 3:**
Only run if: `vehicleId != null && vehicleId != ""`

### STEP 3: Display Widgets

**Time Difference Text:**
- Text Widget
- Value: `timeDifference`
- Fallback: "Calculating..."

**Vehicle Info Text:**
- Text Widget
- Value: `formatVehicleDisplay(vehicleData)`
- Fallback: "Loading vehicle..."

**OR Individual Fields:**
- Make: `getkeyfromjsonstring(vehicleData, "vehicle_make")`
- Model: `getkeyfromjsonstring(vehicleData, "vehicle_model")`
- Color: `getkeyfromjsonstring(vehicleData, "color")`
- Plate: `getkeyfromjsonstring(vehicleData, "license_plate")`

### STEP 4: Image Widget

**Image Visibility:**
- Wrap Image widget with Conditional Builder
- Condition: `hasValidClientPhoto(widget.ticketItem)`
- If TRUE: Show Image
  - Image Source: `getClientPhotoFromTicket(widget.ticketItem)`
- If FALSE: Show Placeholder Icon or Empty Container

**Alternative: Use Visibility Widget**
- Set Image visibility to: `hasValidClientPhoto(widget.ticketItem)`

---

## 📱 EXAMPLE WIDGET TREE

```
Column
├── Text: "Ticket #" + getkeyfromjsonstring(widget.ticketItem, "ticket_number")
├── Text: timeDifference
├── Text: formatVehicleDisplay(vehicleData)
│   OR
├── Row
│   ├── Text: getkeyfromjsonstring(vehicleData, "vehicle_make")
│   ├── Text: getkeyfromjsonstring(vehicleData, "vehicle_model")
│   └── Text: "(" + getkeyfromjsonstring(vehicleData, "color") + ")"
└── ConditionalBuilder
    ├── Condition: hasValidClientPhoto(widget.ticketItem)
    ├── True: Image.network(getClientPhotoFromTicket(widget.ticketItem))
    └── False: Icon(Icons.person)
```

---

## 🎯 COMPLETE EXAMPLE IN CODE

If you were writing this in Dart:

```dart
class TicketDetailPage extends StatefulWidget {
  final String ticketJson;
  
  @override
  Widget build(BuildContext context) {
    // These happen automatically in FlutterFlow OnPageLoad:
    
    // 1. Get time difference
    String timeDiff = getTimeDifferenceFromTicket(widget.ticketJson);
    // → "02d 10h 04m 14s"
    
    // 2. Get vehicle ID
    String vehicleId = getVehicleIdFromTicket(widget.ticketJson);
    // → "fpjSMNhudv4rUEWarsGp"
    
    // 3. Fetch vehicle details from API
    // This is the custom action:
    String vehicleJson = await fetchVehicleDetails(
      vehicleId, 
      "https://api.knex-app.xyz/api",
      currentUserToken
    );
    // → {"vehicle_make":"Toyota","vehicle_model":"Camry","color":"Silver"...}
    
    // 4. Format for display
    String displayText = formatVehicleDisplay(vehicleJson);
    // → "2023 Toyota Camry - Silver (CA-ABC123)"
    
    // 5. Check for photo
    bool hasPhoto = hasValidClientPhoto(widget.ticketJson);
    String photoUrl = getClientPhotoFromTicket(widget.ticketJson);
    
    return Column(
      children: [
        Text(timeDiff),  // "02d 10h 04m 14s"
        Text(displayText), // "2023 Toyota Camry - Silver"
        if (hasPhoto) Image.network(photoUrl),
      ],
    );
  }
}
```

---

## ⚠️ IMPORTANT NOTES

1. **Time Difference**: ✅ Works automatically - just call the function

2. **Vehicle Info**: Requires the API call action - cannot be done in a single function call because it needs to make an async HTTP request

3. **Images**: Use `hasValidClientPhoto()` to check before displaying to avoid errors

4. **Field Names**: The API uses snake_case:
   - `vehicle_make` not `make`
   - `vehicle_model` not `model`
   - `license_plate` not `plate`

---

## 🐛 TROUBLESHOOTING

**If vehicle data is empty:**
- Check that `vehicleId` is not empty
- Verify the API URL is correct
- Check that the user is authenticated (idToken)

**If images throw errors:**
- Always use `hasValidClientPhoto()` to check first
- The base64 action now returns safe placeholders

**If time shows empty:**
- Check that ticket has `createdAt` field
- The function handles both `created_at` and `createdAt`

---

All functions are ready to use! Just follow the FlutterFlow setup steps above.
