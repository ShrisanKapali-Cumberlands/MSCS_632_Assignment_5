// ****************************************** //
// ****************************************** //
// ******    MSCS 632 Assignment 5    ******* //
// ******    Ride Sharing Application ******* //
// ******    Shrisan kapali           ******* //
// ******    Student ID : 005032249   ******* //
// ****************************************** //
// ****************************************** //

#include <iostream>
#include <vector>
#include <string>
#include <iomanip>

// Forward declaration for Ride class
// This is necessary because Driver and Rider classes reference Ride pointers.
class Ride;

//======================================================================
// ## Initializing Driver Class
// ## Driver class manages driver information and their assigned rides.
//======================================================================
class Driver
{
    // Private members to encapsulate driver details and ride history
private:
    int driverID;                      // Unique identifier for the driver
    std::string name;                  // Name of the driver
    double rating;                     // Driver's average rating
    std::vector<Ride *> assignedRides; // An encapsulated list of completed rides by the driver

    // Access specifier for public methods
public:
    Driver(int id, const std::string &name, double rating)
        : driverID(id), name(name), rating(rating) {}

    // Push New Ride to Driver's assigned rides
    // This method adds a ride to the driver's list of assigned rides.
    void addRide(Ride *ride)
    {
        assignedRides.push_back(ride);
    }

    // Custom Method to display driver's details and ride history
    void getDriversDetails() const;
};

//======================================================================
// ## Initializing Rider Class
// ## Riders class are people who request rides.
// ## Riders can request rides and view their ride history.
//======================================================================
class Rider
{
private:
    int riderID;
    std::string name;
    std::vector<Ride *> requestedRides; // Encapsulated list of requested rides

public:
    Rider(int id, const std::string &name) : riderID(id), name(name) {}

    // Method to request a new ride
    void requestRide(Ride *ride)
    {
        requestedRides.push_back(ride);
    }

    // Custom Method to display the rider's ride history
    void viewRides() const;
};

//======================================================================
// ## Ride Class (Base)
// ## Functionality such as calculating fare and displaying ride details.
//======================================================================
class Ride
{
protected:
    int rideID;
    std::string pickupLocation;
    std::string dropoffLocation;
    double distance;
    double fare;
    static int nextRideID; // Static member to generate unique IDs

public:
    Ride(const std::string &pickup, const std::string &dropoff, double dist)
        : pickupLocation(pickup), dropoffLocation(dropoff), distance(dist), fare(0.0)
    {
        rideID = nextRideID++;
    }

    // Virtual destructor to ensure proper cleanup of derived objects
    virtual ~Ride() {}

    // Pure virtual function for calculating fare
    // This needs to be overridden in derived classes.
    virtual void calculateFare() = 0;

    // Virtual function to display ride details
    virtual void rideDetails() const
    {
        std::cout << "Ride ID: " << rideID << "\n"
                  << "  From: " << pickupLocation << "\n"
                  << "  To: " << dropoffLocation << "\n"
                  << "  Distance: " << distance << " miles\n"
                  << "  Fare: $" << std::fixed << std::setprecision(2) << fare << "\n";
    }

    // Getter for the fare
    double getFare() const { return fare; }
};

// Initialize static member
int Ride::nextRideID = 001;

//======================================================================
// ## Standard Rides that override base Ride class
// ## and implement specific fare calculation logic.
//======================================================================

// StandardRide Class
class StandardRide : public Ride
{
public:
    StandardRide(const std::string &pickup, const std::string &dropoff, double dist)
        : Ride(pickup, dropoff, dist) {}

    // Static Base Fares and rates for Standard rides
    void calculateFare() override
    {
        const double baseFare = 4.50;    // Base fare for standard rides
        const double ratePerMile = 2.25; // Rate per mile for standard rides
        fare = baseFare + (distance * ratePerMile);
    }

    // Override rideDetails to add type information
    void rideDetails() const override
    {
        std::cout << "\n--- Ride Details (Standard) ---\n";
        Ride::rideDetails(); // Call base class method
    }
};

// Premium Ride Class
class PremiumRide : public Ride
{
public:
    PremiumRide(const std::string &pickup, const std::string &dropoff, double dist)
        : Ride(pickup, dropoff, dist) {}

    // Premium rides fare calculation
    // Premium rides have a higher base fare and rate per mile.
    void calculateFare() override
    {
        const double baseFare = 8.00;
        const double ratePerMile = 3.75;
        fare = baseFare + (distance * ratePerMile);
    }

    // Override rideDetails to add type information
    void rideDetails() const override
    {
        std::cout << "\n---  *** Ride Details (Premium) *** ---\n";
        Ride::rideDetails(); // Call base class method
    }
};

//======================================================================
// ## Method Implementations for Driver and Rider
// These methods depend on the Ride class definition.
//======================================================================

void Driver::getDriversDetails() const
{
    std::cout << "\n========================================\n"
              << "Driver Info:\n"
              << "ID: " << driverID << ", Name: " << name << ", Rating: " << rating << "\n"
              << "--- Completed Rides ---\n";
    if (assignedRides.empty())
    {
        std::cout << "No rides completed yet.\n";
    }
    else
    {
        for (const auto &ride : assignedRides)
        {
            ride->rideDetails();
        }
    }
    std::cout << "========================================\n";
}

void Rider::viewRides() const
{
    std::cout << "\n========================================\n"
              << "Rider Info:\n"
              << "ID: " << riderID << ", Name: " << name << "\n"
              << "--- Requested Ride History ---\n";
    if (requestedRides.empty())
    {
        std::cout << "No rides requested yet.\n";
    }
    else
    {
        for (const auto &ride : requestedRides)
        {
            ride->rideDetails();
        }
    }
    std::cout << "========================================\n";
}

//======================================================================
// ## Main Function
// ## Demonstrates the functionality of the ride-sharing application.
// ## Showcases polymorphism, encapsulation, and dynamic memory management.
//======================================================================
int main()
{
    //  Creating Riders
    Rider rider1(1, "Tom");
    Rider rider2(2, "Henry");
    Rider rider3(3, "Nicole");

    // Creating Drivers
    Driver driver1(1, "Ben", 4.9);
    Driver driver2(2, "Paulo", 4.4);
    Driver driver3(3, "Samantha", 4.0);

    // Creating collections of rides
    // Demonstrating polymorphism.
    std::vector<Ride *> allRides;
    // Standard Rides
    allRides.push_back(new StandardRide("5 BroadWay St", "100 Highway Rd", 12.5));
    allRides.push_back(new StandardRide("12 Henry Rd", "5th & Brodway", 5.0));
    // Premium Rides
    allRides.push_back(new PremiumRide("9 Stacy Rd", "12 Park Center", 6.0));
    allRides.push_back(new PremiumRide("Hamilton Rd", "Jefferson St", 25.0));

    //  Processing and assigning rides
    std::cout << "Processing rides...\n";
    for (Ride *ride : allRides)
    {
        // Polymorphic call to calculateFare(). The correct overridden method is invoked.
        ride->calculateFare();

        // Requesting and accepting rides
        // For simplicity, we assign all rides to rider1 and driver1.
        rider1.requestRide(ride);
        driver1.addRide(ride);
    }

    // Adding Only 1 ride to rider2 and driver2
    allRides[1]->calculateFare(); // Ensure fare is calculated
    rider2.requestRide(allRides[1]);
    driver2.addRide(allRides[1]); // Assigning the same ride to driver2

    // 4. Demonstrate Polymorphism by displaying ride details
    std::cout << "\n--- All Rides (Demonstrating Polymorphism) ---\n";
    for (const Ride *ride : allRides)
    {
        // Polymorphic call to rideDetails(). The correct overridden method is invoked.
        ride->rideDetails();
        std::cout << std::endl;
    }

    // 5. Display Rider and Driver histories
    driver1.getDriversDetails(); // All Rides
    driver2.getDriversDetails(); // Only 1 ride
    driver3.getDriversDetails(); // No rides

    rider1.viewRides(); // All Rides
    rider2.viewRides(); // Only 1 ride
    rider3.viewRides(); // No rides

    // 6. Clean up dynamically allocated memory
    for (Ride *ride : allRides)
    {
        delete ride;
    }
    allRides.clear();

    return 0;
}