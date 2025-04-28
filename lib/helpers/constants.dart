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
