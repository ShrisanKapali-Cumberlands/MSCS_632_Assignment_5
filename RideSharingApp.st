"=====================================================
 RIDE SHARING SYSTEM - SMALLTALK IMPLEMENTATION
 Author: Claude AI
 Date: July 2025
 
 This system implements a complete ride sharing platform with:
 - Base Ride class with polymorphic fare calculation
 - Multiple ride types (Standard, Premium, Luxury, Pool)
 - Driver and Rider management
 - Advanced features like surge pricing and ride matching
=====================================================

 BASE RIDE CLASS
====================================================="
Object subclass: #Ride
    instanceVariableNames: 'rideID pickupLocation dropoffLocation distance fare status timestamp'
    classVariableNames: 'RideCounter'
    poolDictionaries: ''
    category: 'RideSharing-Core'!

!Ride class methodsFor: 'initialization'!
initialize
    "Initialize the ride counter"
    RideCounter := 0.
! !

!Ride class methodsFor: 'instance creation'!
from: aPickupLocation to: aDropoffLocation distance: aDistance
    "Create a new ride with pickup, dropoff, and distance"
    | newRide |
    RideCounter := RideCounter + 1.
    newRide := self new.
    newRide initializeWithID: RideCounter 
             pickup: aPickupLocation 
             dropoff: aDropoffLocation 
             distance: aDistance.
    ^newRide
! !

!Ride methodsFor: 'initialization'!
initializeWithID: anID pickup: aPickup dropoff: aDropoff distance: aDistance
    "Initialize a ride with all required parameters"
    rideID := anID.
    pickupLocation := aPickup.
    dropoffLocation := aDropoff.
    distance := aDistance.
    status := 'Requested'.
    timestamp := DateAndTime now.
    fare := self calculateFare.
! !

!Ride methodsFor: 'accessing'!
rideID
    "Return the ride ID"
    ^rideID
!

pickupLocation
    "Return the pickup location"
    ^pickupLocation
!

dropoffLocation
    "Return the dropoff location"
    ^dropoffLocation
!

distance
    "Return the distance"
    ^distance
!

fare
    "Return the calculated fare"
    ^fare
!

status
    "Return the current ride status"
    ^status
!

timestamp
    "Return the ride timestamp"
    ^timestamp
! !

!Ride methodsFor: 'operations'!
calculateFare
    "Base fare calculation - $2 base + $1.50 per mile"
    ^2.0 + (distance * 1.5)
!

updateStatus: newStatus
    "Update the ride status"
    status := newStatus.
!

rideDetails
    "Display detailed ride information"
    ^String streamContents: [:stream |
        stream nextPutAll: '=== RIDE DETAILS ==='; cr.
        stream nextPutAll: 'Ride ID: ', rideID printString; cr.
        stream nextPutAll: 'Type: ', self class name; cr.
        stream nextPutAll: 'From: ', pickupLocation; cr.
        stream nextPutAll: 'To: ', dropoffLocation; cr.
        stream nextPutAll: 'Distance: ', distance printString, ' miles'; cr.
        stream nextPutAll: 'Fare: $', fare printString; cr.
        stream nextPutAll: 'Status: ', status; cr.
        stream nextPutAll: 'Requested: ', timestamp printString; cr.
        stream nextPutAll: '==================='
    ]
! !

"=====================================================
 RIDE SUBCLASSES
====================================================="

Ride subclass: #StandardRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing-RideTypes'!

!StandardRide methodsFor: 'operations'!
calculateFare
    "Standard fare: $2 base + $1.50 per mile"
    ^2.0 + (distance * 1.5)
! !

Ride subclass: #PremiumRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing-RideTypes'!

!PremiumRide methodsFor: 'operations'!
calculateFare
    "Premium fare: $3 base + $2.25 per mile (50% markup)"
    ^3.0 + (distance * 2.25)
! !

Ride subclass: #LuxuryRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing-RideTypes'!

!LuxuryRide methodsFor: 'operations'!
calculateFare
    "Luxury fare: $5 base + $3.50 per mile (premium vehicles)"
    ^5.0 + (distance * 3.5)
! !

Ride subclass: #PoolRide
    instanceVariableNames: 'maxPassengers currentPassengers'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing-RideTypes'!

!PoolRide methodsFor: 'initialization'!
initializeWithID: anID pickup: aPickup dropoff: aDropoff distance: aDistance
    "Initialize pool ride with passenger tracking"
    super initializeWithID: anID pickup: aPickup dropoff: aDropoff distance: aDistance.
    maxPassengers := 4.
    currentPassengers := 1.
! !

!PoolRide methodsFor: 'operations'!
calculateFare
    "Pool fare: Discounted rate $1.50 base + $0.75 per mile"
    ^1.5 + (distance * 0.75)
!

addPassenger
    "Add a passenger to the pool"
    currentPassengers < maxPassengers
        ifTrue: [currentPassengers := currentPassengers + 1]
        ifFalse: [self error: 'Pool is full']
!

canAcceptPassenger
    "Check if pool can accept more passengers"
    ^currentPassengers < maxPassengers
! !

"=====================================================
 DRIVER CLASS
====================================================="
Object subclass: #Driver
    instanceVariableNames: 'driverID name rating assignedRides vehicleType earnings'
    classVariableNames: 'DriverCounter'
    poolDictionaries: ''
    category: 'RideSharing-People'!

!Driver class methodsFor: 'initialization'!
initialize
    "Initialize the driver counter"
    DriverCounter := 0.
! !

!Driver class methodsFor: 'instance creation'!
named: aName vehicleType: aVehicleType
    "Create a new driver"
    | newDriver |
    DriverCounter := DriverCounter + 1.
    newDriver := self new.
    newDriver initializeWithID: DriverCounter name: aName vehicleType: aVehicleType.
    ^newDriver
! !

!Driver methodsFor: 'initialization'!
initializeWithID: anID name: aName vehicleType: aVehicleType
    "Initialize driver with ID, name, and vehicle type"
    driverID := anID.
    name := aName.
    vehicleType := aVehicleType.
    rating := 5.0.
    assignedRides := OrderedCollection new.
    earnings := 0.0.
! !

!Driver methodsFor: 'accessing'!
driverID
    "Return the driver ID"
    ^driverID
!

name
    "Return the driver name"
    ^name
!

rating
    "Return the driver rating"
    ^rating
!

vehicleType
    "Return the vehicle type"
    ^vehicleType
!

earnings
    "Return total earnings"
    ^earnings
!

assignedRides
    "Return a copy of assigned rides (encapsulation)"
    ^assignedRides copy
! !

!Driver methodsFor: 'operations'!
addRide: aRide
    "Add a ride to the driver's assigned rides"
    assignedRides add: aRide.
    earnings := earnings + aRide fare.
    aRide updateStatus: 'Assigned to Driver'.
!

updateRating: newRating
    "Update driver rating (1-5 scale)"
    (newRating between: 1 and: 5)
        ifTrue: [rating := newRating]
        ifFalse: [self error: 'Rating must be between 1 and 5']
!

completeRide: aRide
    "Mark a ride as completed"
    (assignedRides includes: aRide)
        ifTrue: [aRide updateStatus: 'Completed']
        ifFalse: [self error: 'Ride not assigned to this driver']
!

getDriverInfo
    "Return detailed driver information"
    ^String streamContents: [:stream |
        stream nextPutAll: '=== DRIVER INFO ==='; cr.
        stream nextPutAll: 'Driver ID: ', driverID printString; cr.
        stream nextPutAll: 'Name: ', name; cr.
        stream nextPutAll: 'Vehicle: ', vehicleType; cr.
        stream nextPutAll: 'Rating: ', rating printString, '/5.0'; cr.
        stream nextPutAll: 'Total Rides: ', assignedRides size printString; cr.
        stream nextPutAll: 'Earnings: $', earnings printString; cr.
        stream nextPutAll: '==================='
    ]
! !

"=====================================================
 RIDER CLASS
====================================================="
Object subclass: #Rider
    instanceVariableNames: 'riderID name requestedRides paymentMethod'
    classVariableNames: 'RiderCounter'
    poolDictionaries: ''
    category: 'RideSharing-People'!

!Rider class methodsFor: 'initialization'!
initialize
    "Initialize the rider counter"
    RiderCounter := 0.
! !

!Rider class methodsFor: 'instance creation'!
named: aName paymentMethod: aPaymentMethod
    "Create a new rider"
    | newRider |
    RiderCounter := RiderCounter + 1.
    newRider := self new.
    newRider initializeWithID: RiderCounter name: aName paymentMethod: aPaymentMethod.
    ^newRider
! !

!Rider methodsFor: 'initialization'!
initializeWithID: anID name: aName paymentMethod: aPaymentMethod
    "Initialize rider with ID, name, and payment method"
    riderID := anID.
    name := aName.
    paymentMethod := aPaymentMethod.
    requestedRides := OrderedCollection new.
! !

!Rider methodsFor: 'accessing'!
riderID
    "Return the rider ID"
    ^riderID
!

name
    "Return the rider name"
    ^name
!

paymentMethod
    "Return the payment method"
    ^paymentMethod
!

requestedRides
    "Return a copy of requested rides (encapsulation)"
    ^requestedRides copy
! !

!Rider methodsFor: 'operations'!
requestRide: aRide
    "Request a new ride"
    requestedRides add: aRide.
    Transcript show: 'Ride requested by ', name, ' (ID: ', riderID printString, ')'; cr.
!

viewRides
    "Display ride history"
    | ridesInfo |
    ridesInfo := String streamContents: [:stream |
        stream nextPutAll: '=== RIDE HISTORY for ', name, ' ==='; cr.
        stream nextPutAll: 'Rider ID: ', riderID printString; cr.
        stream nextPutAll: 'Total Rides: ', requestedRides size printString; cr.
        stream nextPutAll: 'Payment Method: ', paymentMethod; cr; cr.
        requestedRides do: [:ride |
            stream nextPutAll: 'Ride #', ride rideID printString, ': ';
            nextPutAll: ride pickupLocation, ' → ', ride dropoffLocation;
            nextPutAll: ' ($', ride fare printString, ')'; cr
        ].
        stream nextPutAll: '================================='
    ].
    ^ridesInfo
!

cancelRide: aRide
    "Cancel a requested ride"
    (requestedRides includes: aRide)
        ifTrue: [
            aRide updateStatus: 'Cancelled'.
            Transcript show: 'Ride cancelled by ', name; cr
        ]
        ifFalse: [self error: 'Ride not found in requested rides']
! !

"=====================================================
 RIDE SHARING SYSTEM - MAIN CONTROLLER
====================================================="
Object subclass: #RideSharingSystem
    instanceVariableNames: 'drivers riders rides surgeMultiplier'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing-System'!

!RideSharingSystem methodsFor: 'initialization'!
initialize
    "Initialize the ride sharing system"
    drivers := OrderedCollection new.
    riders := OrderedCollection new.
    rides := OrderedCollection new.
    surgeMultiplier := 1.0.
! !

!RideSharingSystem methodsFor: 'management'!
addDriver: aDriver
    "Add a driver to the system"
    drivers add: aDriver.
    Transcript show: 'Driver ', aDriver name, ' added to system'; cr.
!

addRider: aRider
    "Add a rider to the system"
    riders add: aRider.
    Transcript show: 'Rider ', aRider name, ' added to system'; cr.
!

createRide: rideClass from: pickup to: dropoff distance: distance
    "Create a new ride of specified type"
    | newRide |
    newRide := rideClass from: pickup to: dropoff distance: distance.
    rides add: newRide.
    ^newRide
!

setSurgeMultiplier: multiplier
    "Set surge pricing multiplier"
    surgeMultiplier := multiplier.
    Transcript show: 'Surge multiplier set to ', multiplier printString; cr.
! !

!RideSharingSystem methodsFor: 'operations'!
matchRideWithDriver: aRide
    "Simple driver matching - find available driver"
    | availableDriver |
    availableDriver := drivers detect: [:driver | driver assignedRides isEmpty] ifNone: [nil].
    availableDriver ifNotNil: [
        availableDriver addRide: aRide.
        Transcript show: 'Ride ', aRide rideID printString, ' matched with driver ', availableDriver name; cr.
        ^availableDriver
    ].
    Transcript show: 'No available drivers for ride ', aRide rideID printString; cr.
    ^nil
!

demonstratePolymorphism
    "Demonstrate polymorphic behavior with different ride types"
    | testRides |
    Transcript show: '=== POLYMORPHISM DEMONSTRATION ==='; cr.
    
    testRides := OrderedCollection new.
    testRides add: (StandardRide from: 'Downtown' to: 'Airport' distance: 15).
    testRides add: (PremiumRide from: 'Hotel' to: 'Conference Center' distance: 8).
    testRides add: (LuxuryRide from: 'Mansion' to: 'Opera House' distance: 12).
    testRides add: (PoolRide from: 'University' to: 'Shopping Mall' distance: 6).
    
    "Polymorphic fare calculation and ride details"
    testRides do: [:ride |
        Transcript show: 'Ride Type: ', ride class name; cr.
        Transcript show: 'Fare: $', ride fare printString; cr.
        Transcript show: ride rideDetails; cr; cr.
    ].
    
    rides addAll: testRides.
    ^testRides
!

generateSystemReport
    "Generate a comprehensive system report"
    | totalRides totalEarnings avgRating |
    totalRides := rides size.
    totalEarnings := drivers inject: 0 into: [:sum :driver | sum + driver earnings].
    avgRating := drivers isEmpty 
        ifTrue: [0] 
        ifFalse: [(drivers inject: 0 into: [:sum :driver | sum + driver rating]) / drivers size].
    
    ^String streamContents: [:stream |
        stream nextPutAll: '=== RIDE SHARING SYSTEM REPORT ==='; cr.
        stream nextPutAll: 'Total Drivers: ', drivers size printString; cr.
        stream nextPutAll: 'Total Riders: ', riders size printString; cr.
        stream nextPutAll: 'Total Rides: ', totalRides printString; cr.
        stream nextPutAll: 'Total Earnings: $', totalEarnings printString; cr.
        stream nextPutAll: 'Average Driver Rating: ', avgRating printString; cr.
        stream nextPutAll: 'Current Surge Multiplier: ', surgeMultiplier printString; cr.
        stream nextPutAll: '==================================='
    ]
! !

"=====================================================
 DEMONSTRATION SCRIPT
====================================================="
"Initialize all classes"
Ride initialize.
Driver initialize.
Rider initialize.

"Create the ride sharing system"
| system driver1 driver2 rider1 rider2 ride1 ride2 ride3 |
system := RideSharingSystem new.

"Create drivers"
driver1 := Driver named: 'John Smith' vehicleType: 'Toyota Camry'.
driver2 := Driver named: 'Sarah Johnson' vehicleType: 'BMW X5'.

"Create riders"
rider1 := Rider named: 'Alice Brown' paymentMethod: 'Credit Card'.
rider2 := Rider named: 'Bob Wilson' paymentMethod: 'PayPal'.

"Add drivers and riders to system"
system addDriver: driver1.
system addDriver: driver2.
system addRider: rider1.
system addRider: rider2.

"Create and request rides"
ride1 := system createRide: StandardRide from: 'Home' to: 'Work' distance: 10.
ride2 := system createRide: PremiumRide from: 'Airport' to: 'Hotel' distance: 25.
ride3 := system createRide: LuxuryRide from: 'Restaurant' to: 'Theater' distance: 5.

"Riders request rides"
rider1 requestRide: ride1.
rider2 requestRide: ride2.
rider1 requestRide: ride3.

"Match rides with drivers"
system matchRideWithDriver: ride1.
system matchRideWithDriver: ride2.
system matchRideWithDriver: ride3.

"Complete some rides"
driver1 completeRide: ride1.
driver2 completeRide: ride2.

"Display information"
Transcript show: driver1 getDriverInfo; cr; cr.
Transcript show: driver2 getDriverInfo; cr; cr.
Transcript show: rider1 viewRides; cr; cr.
Transcript show: rider2 viewRides; cr; cr.

"Demonstrate polymorphism"
system demonstratePolymorphism.

"Generate system report"
Transcript show: system generateSystemReport; cr.

"Set surge pricing and create a new ride"
system setSurgeMultiplier: 2.5.
ride4 := system createRide: PoolRide from: 'Stadium' to: 'Parking Lot' distance: 3.
Transcript show: 'New ride with surge pricing: $', ride4 fare printString; cr.

Transcript show: 'Ride Sharing System demonstration completed!'; cr."