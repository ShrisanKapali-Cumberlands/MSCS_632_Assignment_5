## Assignment Information

**Shrisan Kapali**

**Student ID:** 005032249

**Assignment 5:** Developing a Class-Based Ride Sharing System

---

## Overview

This repository contains two applications that manage a class-based ride sharing system. Both implementations are designed to strongly demonstrate the four core principles of Object-Oriented Programming (OOP): Encapsulation, Inheritance, Polymorphism, and Abstraction.

---

## Repository Contents

This repository contains two source files:

- **RideSharingApp.cpp** – A complete, command-line based C++ implementation of the ride sharing program.
- **Assignment5SmallTalk.image** – A Smalltalk image file containing the ride sharing program, intended to be run in a Smalltalk environment like Pharo.

---

## C++ Program: `RideSharingApp.cpp`

### Key Classes

- **`Ride`**: An abstract base class that holds core details common to all rides (ID, locations, distance). It defines the interface for all ride types.
- **`StandardRide` & `PremiumRide`**: Concrete classes that inherit from `Ride`. Each provides a specific implementation for calculating fares.
- **`Driver`**: Represents a driver, managing their personal information and a history of completed rides.
- **`Rider`**: Represents a rider, managing their information and a history of requested rides.

---

## Key Features

- Shift scheduling based on employee availability and preferences.
- Fallback logic for employees without preferences.
- Modular and extensible structure for testing different input configurations.
- Console output of assigned shifts and employee workload.

---

## Smalltalk Program: `Assignment5SmallTalk.image`

### Description

This is a Smalltalk implementation of the same ride-sharing system. It is designed to be run within an interactive, image-based Smalltalk environment like Pharo. The logic mirrors the C++ version, demonstrating the same OOP principles in a different language paradigm.

### Key Classes

- **`Ride`**: The abstract base class, defined as `Object subclass: #Ride ...`. It contains the shared instance variables and defines the common protocol for all rides.
- **`StandardRide` & `PremiumRide`**: Concrete subclasses of `Ride` that provide their own implementations of the `calculateFare` method.
- **`Driver`**: A class to manage driver details and their collection of `assignedRides`.
- **`Rider`**: A class to manage rider details and their collection of `requestedRides`.

### How to Run

1.  Download and install a Smalltalk environment, **Pharo Launcher**, from [https://pharo.org/download](https://pharo.org/download).
2.  Launch the environment.
3.  Open the image found on the GitHub.
4.  Under the Playground, copy the code from file `RideSharingAppTestCase.st` and hit `Do it all`
