class AppPermissions {
  static const String dashboard = 'dashboard';
  static const String loadingDetails = 'loading_details';
  static const String trips = 'trips';
  static const String expensesView = 'expenses_view';
  static const String vehicles = 'vehicles';
  static const String oilFilterDetails = 'oil_filter_details';
  static const String maintenanceToolDetails = 'maintenance_tool_details';
  static const String drivers = 'drivers';
  static const String bankAccounts = 'bank_accounts';
  static const String clients = 'clients';
  static const String clientFreightRates = 'client_freight_rates';
  static const String routes = 'routes';
  static const String pumps = 'pumps';
  static const String tools = 'tools';
  static const String maintenance = 'maintenance';
  static const String employeeAttendance = 'employee_attendance';
  static const String inventory = 'inventory';
  static const String dieselPricing = 'diesel_pricing';
  static const String employeeSalary = 'employee_salary';
  static const String vendors = 'vendors';
  static const String companySettings = 'company_settings';

  // Kept for old employee records. There is no standalone Documents screen in
  // the current drawer, so it is not assigned to newly created employees.
  static const String documents = 'documents';

  static const List<String> all = [
    dashboard,
    loadingDetails,
    trips,
    expensesView,
    vehicles,
    oilFilterDetails,
    maintenanceToolDetails,
    drivers,
    bankAccounts,
    clients,
    clientFreightRates,
    routes,
    pumps,
    tools,
    maintenance,
    employeeAttendance,
    inventory,
    dieselPricing,
    employeeSalary,
    vendors,
    companySettings,
  ];

  static String label(String permission) {
    switch (permission) {
      case dashboard:
        return 'Dashboard';

      case loadingDetails:
        return 'Loading Details';

      case trips:
        return 'Trips';

      case expensesView:
        return 'Expenses View';

      case vehicles:
        return 'Vehicles';

      case oilFilterDetails:
        return 'Oil & Filter Details';

      case maintenanceToolDetails:
        return 'Maintenance Tool Details';

      case drivers:
        return 'Drivers';

      case documents:
        return 'Documents';

      case bankAccounts:
        return 'Bank Accounts';

      case clients:
        return 'Clients';

      case clientFreightRates:
        return 'Client Freight Rates';

      case routes:
        return 'MTAG Tool';

      case pumps:
        return 'Petrol Pumps';

      case tools:
        return 'Tools';

      case maintenance:
        return 'Maintenance';

      case employeeAttendance:
        return 'Employee Attendance';

      case inventory:
        return 'Inventory';

      case dieselPricing:
        return 'Diesel Pricing';

      case employeeSalary:
        return 'Employees Salary';

      case vendors:
        return 'Vendors';

      case companySettings:
        return 'Company Settings';

      default:
        return permission;
    }
  }
}
