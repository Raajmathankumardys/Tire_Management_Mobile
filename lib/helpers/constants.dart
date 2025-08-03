class constants {
  static const String save = "Save";
  static const String cancel = "Cancel";
  static const String update = "Update";
  static const String delete = "Delete";
  static const String confirmdelete = "Confirm Delete";
  static const String textfield = "text_field";
  static const String numberfield = "number_field";
  static const String datefield = "date_field";
  static const String dropdownfield = "dropdown_field";
  static const String required = "This field is required";
  static const String datevalidate = "Please select a date";
}

class vehicleconstants extends constants {
  static const String appbar = "Vehicles";
  static const String novehicle = "No vehicles available";
  static const String license = "License No";
  static const String year = "Year";
  static const String endpoint = "/vehicles";
  static const String addvehicle = "Add Vehicle";
  static const String editvehicle = "Edit Vehicle";
  static const String name = "Vehicle Name";
  static const String vname = "Name";
  static const String namehint = "Enter vehicle name";
  static const String namevalidation = "Name must have 3 atleast characters";
  static const String type = "Type";
  static const String typehint = "Enter Vehicle Type";
  static const String typevalidation =
      "Vehicle Type must have 2 atleast characters";
  static const String licenseplate = "License Plate";
  static const String licenseplatehint = "Enter license plate";
  static const licenseplateregex = r'^[A-Z0-9]{6,10}$';
  static const String licenseplatevalidation =
      "Invalid license plate format (6-10 alphanumeric characters)";
  static const String manufactureyear = "Manufacture Year";
  static const String manufactureyearhint = "Enter manufacture year";
  static const String manufactureyearvalidation = "Pls enter a Valid year";
  static const String axleno = "Axle No";
  static const String axlenohint = "Enter axle no";
  static const String axlenovalidation =
      "Vehicle must have atleast of 2 axles ";
  static const String modaldelete =
      "Are you sure you want to delete this vehicle? This action cannot be undone.";
  static String vehicleUpdated(String name, String type) =>
      'Vehicle $name $type updated successfully';

  static String vehicleCreated(String name, String type) =>
      'Vehicle $name $type created successfully';

  static String vehicleDeleted(String name, String type) =>
      'Vehicle $name $type deleted successfully';
}

class tireinventoryconstants extends constants {
  static const String appbar = "Tire Inventory";
  static const String addtire = "Add Tire Inventory";
  static const String edittire = "Edit Tire Inventory";
  static const String brand = "Brand";
  static const String brandhint = "Enter brand";
  static const String model = "Model";
  static const String modelhint = "Enter model";
  static const String size = "Size";
  static const String sizehint = "Enter size";
  static const String serialno = "Serial No";
  static const String serialnohint = "Enter serial no";
  static const String location = "Location";
  static const String locationhint = "Enter location";
  static const String category = "Category";
  static const String temperature = "Temperature";
  static const String temperaturehint = "Enter temperature in °C";
  static const String pressure = "Pressure";
  static const String pressurehint = "Enter pressure in PSI";
  static const String distance = "Distance Travelled";
  static const String distancehint = "Enter Distance Travelled in KM";
  static const String purchasecost = "Purchase Cost";
  static const String purchasecosthint = "Enter Purchase Cost";
  static const String purchasedate = "Purchase Date";
  static const String warrantyperiod = "Warranty Period(Months)";
  static const String warrantyperiodhint = "Enter warranty period";
  static const String warrantyexpiry = "Warranty Expiry Date";
  static const String endpoint = "/tires";
  static String createdtoast(String Serialno) =>
      "Tire $Serialno Created Sucessfully";
  static String updatedtoast(String Serialno) =>
      "Tire $Serialno Updated Sucessfully";
  static String deletedtoast(String Serialno) =>
      "Tire $Serialno Deleted Sucessfully";
  static const String modaldelete =
      "Are you sure you want to delete this tire inventory?";
  static const String notirefound = "No Tires Found";
  static const String tireicon = "assets/vectors/tire.svg";
  static const String notiresavailable = "No Tires Available";
}

class settingsconstants extends constants {
  static const String appbar = "Settings";
  static const String darkmode = "Dark Mode";
  static const toggletheme = "Toggle Theme";
  static const help = "Help & Support";
  static const faq = "Frequently Asked Questions";
  static const wear = "How do I track tire wear?";
  static const wearanswer =
      "Tire wear is tracked using sensors or manual inspections. The system records tire tread depth and alerts when replacement is needed.";
  static const damage = "What are the common causes of tire damage?";
  static const damageanswer =
      "Common causes include over/under-inflation, poor road conditions, misalignment, and excessive braking.";
  static const tpms = "Can I integrate TPMS with this system?";
  static const tpmsans =
      "Yes, the system supports Tire Pressure Monitoring Systems (TPMS) for real-time monitoring of pressure and temperature.";
  static const rotate = "How often should I rotate my tires?";
  static const rotateans =
      "It's recommended to rotate tires every 5,000 to 7,500 miles for even wear and extended lifespan.";
  static const email = "📧 Email: support@yaantrac.com";
  static const phone = "📞 Phone: +1-800-123-4567";
  static const close = "Close";
}

class notifcationconstants extends constants {
  static const appbar = "Alerts & Notifications";
}

class vehicleaxleconstants extends constants {
  static String endpoint(String id) => '/vehicles/$id/axles';
}

class tirepositionconstants extends constants {
  static String endpoint = '/tire-positions';
}

class tireexpenseconstants extends constants {
  static const String appbar = "Tire Expenses";
  static const String addtireexpense = "Add Tire Expense";
  static const String edittireexpense = "Edit Tire Expense";
  static const String cost = "Cost";
  static const String costhint = "Enter cost";
  static const String expensetype = "Expense Type";
  static const String expensetypehint = "Enter expense type";
  static const String expensedate = "Expense Date";
  static const String notes = "Notes";
  static const String noteshint = "Enter notes";
  static const String tire = "Tire";
  static const String modaldelete =
      "Are you sure you want to delete this tire expense?";
  static const String notireexpense = "No Tires Expense available";
  static const String endpoint = "/tire-expenses";
  static const String createdtoast = "Tire Expense added successfully";
  static const String updatedtoast = "Tire Expense updated successfully";
  static const String deletedtoast = "Tire Expense deleted successfully";
}

class tireperformancesconstants extends constants {
  static const String appbar = "Tire Performance";
  static const String addtirep = "Add Tire Performance";
  static const String pressure = "Pressure";
  static const String pressurehint = "Enter pressure";
  static const String wear = "Wear";
  static const String wearhint = "Enter wear";
  static const String temperature = "Temperature";
  static const String temperaturehint = "Enter temperature";
  static const String distancet = "Distance";
  static const String distance = "Distance Travelled";
  static const String distancehint = "Enter distance travelled";
  static const String treaddepth = "Tread Depth";
  static const String treaddepthhint = "Enter tread depth";
  static const String average = "Average";
  static const String readings = "Readings";
  static const String graph = "Graph";
  static const String psi = "PSI";
  static const String km = "KM";
  static const String mm = "MM";
  static const String degreec = "°C";
  static const String noperformance = "No Performance Available";
  static const String fail = "Fail to Load Data";
  static String endpoint(id) => '/tires/$id/performances';
  static String addendpoint(id) => '/tires/$id/add-performance';
  static const String createdtoast = "Tire Performance Added Sucessfully";
}

class tirecategoryconstants extends constants {
  static const String appbar = "Tire Category";
  static const String addtirecategory = "Add Tire Category";
  static const String edittirecategory = "Edit Tire Category";
  static const String category = "Category";
  static const String categoryhint = "Enter category";
  static const String decsription = "Description";
  static const String descriptionhint = "Enter description";
  static const String endpoint = "/tire-categories";
  static String createdtoast(String cat) => "Category $cat Added Sucessfully";
  static String updatedtoast(String cat) => "Category $cat Updated Sucessfully";
  static String deletedtoast(String cat) => "Category $cat Deleted Sucessfully";
  static const String modaldelete =
      "Are you sure you want to delete this tire category?";
  static const String nottirecategory = "No Tire Categories Available";
}

class tiremappingconstants extends constants {
  static const tireperformanceappbar = 'Tire Performance';
  static const mappingappbar = "Mapping";
  static const vehicledetails = "Vehicle-Details";
  static const tiremappingtitle = "Tire-Mapping";
  static const vehicledetailslicense = "LICENSE PLATE";
  static const vehicledetailslicenseno = "License Plate Number";
  static const axlepath = 'assets/vectors/T_i.svg';
  static select(String pos) => "Select Tire for $pos";
  static const search = "Search by Serial No";
  static deletemodal(String pos) =>
      "Are you sure you want to delete tire in postion $pos?";
  static const String tap = "Tap to select";
  static const String submitted = "Submitted successfully!";
  static const String select4 = "Select tire for all 4 positions";
  static const String nomappingfound = "No Mapping Found";
  static const String performancepath = 'assets/vectors/tire_psi.svg';
  static const String frontaxle = "Front Axle";
  static const String rearaxle = "Rear Axle";
  static const String fl1 = "FL1";
  static const String fr1 = "FR1";
  static const String rl1 = "RL1";
  static const String rr1 = "RR1";
  static endpoint(id) => '/tire-mapping/$id';
  static const String endpointpost = '/tire-mapping/tire-mappings';
  static const String addedToast = "Tire Mapping Added Successfully";
  static const String updatedToast = "Tire Mapping Updated Successfully";
  static const String deletedToast = "Tire Mapping Deleted Successfully";
}

class tripconstants extends constants {
  static const String appbar = "Trips";
  static const String startDate = "Start Date";
  static const String endDate = "End Date";
  static const String source = "Source";
  static const String sourcehint = "Enter Source";
  static const String destination = "Destination";
  static const String destinationhint = "Enter Destination";
  static const String addtrip = "Add Trip";
  static const String edittrip = "Edit Trip";
  static const String deletemodal = "Are you sure want to delete this trip?";
  static const String endpoint = '/trips';
  static const String notrip = "No Trips Available";
  static String addedtoast(String src, String dest) =>
      "Trip $src-$dest added sucessfully";
  static String updatedtoast(String src, String dest) =>
      "Trip $src-$dest updated sucessfully";
  static String deletedtoast(String src, String dest) =>
      "Trip $src-$dest deleted sucessfully";
}

class incomeconstants extends constants {
  static const String appbar = "Income";
  static const String amount = "Amount";
  static const String amounthint = "Enter Amount";
  static const String incomedate = "Income Date";
  static const String description = "Description";
  static const String descriptionhint = "Enter description";
  static const String all = "All";
  static const String week = "Week";
  static const String month = "Month";
  static const String year = "Year";
  static const String custom = "Custom";
  static const String deletemodal =
      "Are you sure you want to delete this income?";
  static const String addincome = "Add Income";
  static const String editincome = "Edit Income";
  static const String noincome = "No Incomes Found";
  static const String rupees = "\₹";
  static String endpointget(id) => '/trips/$id/incomes';
  static String endpoint(id, tripId) => '/trips/$tripId/incomes/$id';
  static const String addedtoast = "Income Added Successfully";
  static const String updatedtoast = "Income Updated Successfully";
  static const String deletetoast = "Income Deleted Sucessfully";
}

class expenseconstants extends constants {
  static const String appbar = "Expense";
  static const String amount = "Amount";
  static const String amounthint = "Enter Amount";
  static const String expensedate = "Expense Date";
  static const String description = "Description";
  static const String descriptionhint = "Enter description";
  static const String expensetype = "Expense Type";
  static const String all = "All";
  static const String week = "Week";
  static const String month = "Month";
  static const String year = "Year";
  static const String custom = "Custom";
  static const String fuelcosts = "Fuel Costs";
  static const String driverallowances = "Driver Allowances";
  static const String tollcharges = "Toll Charges";
  static const String maintenance = "Maintenance";
  static const String miscellaneous = "Miscellanous";
  static const String fuelcostsvalue = "FUEL";
  static const String driverallowancesvalue = "DRIVER_ALLOWANCE";
  static const String tollchargesvalue = "TOLL";
  static const String maintenancevalue = "MAINTENANCE";
  static const String miscellaneousvalue = "MISCELLANEOUS";
  static const String deletemodal =
      "Are you sure you want to delete this expense";
  static const String addexpense = "Add Expense";
  static const String editexpense = "Edit Expense";
  static const String noexpense = "No Expense Found";
  static const String rupees = "\₹";
  static String endpointget(id) => '/trips/$id/expenses';
  static String endpoint(id, tripId) => '/trips/$tripId/expenses/$id';
  static const String addedtoast = "Expense Added Successfully";
  static const String updatedtoast = "Expense Updated Successfully";
  static const String deletetoast = "Expense Deleted Sucessfully";
}

class tripprofitsummary extends constants {
  //Trip Overview
  static const String appbar = "Trip Overview";
  //Transaction
  static const String transaction = "Transactions";
  static const String notranscation = 'No Transactions Yet';
  static const String tripsummary = "Trip Summary";
  static const String addtransaction = "Add Transaction";
  static const String addtransactiontitle =
      "What type of transaction would you like to add?";
  static const String nooftrans = "Number of Transactions";
  static const String averageexpense = "Average Expense";
  static const String averageincome = "Average Income";
  static const String pertransaction = "Per Transaction";
  static const String stats = "Stats";
  static const String rupees = "\₹";
  static const String expense = "Expense";
  static const String income = "Income";
  static const String profit = "Profit";
  static const String loss = "Loss";
  //Trip Summary
  static const String category = "Category";
  static const String percentage = "Percentage";
  static const String amount = "Amount";
  static const String percentsymbol = "%";
  static const String total = "TOTAL";
  static const String percent100 = "100%";
  static const String tripdetails = "Trip Details";
  static const String totalexpenses = "TOTAL EXPENSE";
  static const String totalincome = "TOTAL INCOME";
  static const String profitu = 'PROFIT';
  static const String expensebreakdown = 'Expense Breakdown';
  static const String expensedistribution = "Expense Distribution";
  static const String notrips = "No Trip Summary Available";
}
